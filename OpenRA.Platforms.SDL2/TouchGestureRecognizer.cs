#region Copyright & License Information
/*
 * Copyright (c) The OpenRA Developers and Contributors
 * This file is part of OpenRA, which is free software. It is made
 * available to you under the terms of the GNU General Public License
 * as published by the Free Software Foundation, either version 3 of
 * the License, or (at your option) any later version. For more
 * information, see COPYING.
 */
#endregion

using System;
using SDL2;

namespace OpenRA.Platforms.SDL2
{
	sealed class TouchGestureRecognizer
	{
		enum State { Idle, WaitingForGesture, LongPressDrag, TwoFingerActive, Cancelled }

		const int LongPressMs = 400;
		const int TapMaxMovePx = 15;
		const int DragThresholdPx = 15;
		const float PinchZoomScale = 0.04f;

		State state = State.Idle;
		int fingerCount;

		// First finger tracking
		long finger1Id;
		int2 finger1Start;
		int2 finger1Pos;

		// Second finger tracking
		long finger2Id;
		int2 finger2Pos;

		// Two-finger state
		int2 prevMidpoint;
		float prevDistance;

		// Long-press timer
		long fingerDownTicks;

		static int2 FingerToScreen(SDL.SDL_TouchFingerEvent tfinger, Sdl2PlatformWindow device)
		{
			var x = (int)(tfinger.x * device.SurfaceSize.Width);
			var y = (int)(tfinger.y * device.SurfaceSize.Height);
			return EventPosition(device, x, y);
		}

		static int2 EventPosition(Sdl2PlatformWindow device, int x, int y)
		{
			if (Platform.CurrentPlatform != PlatformType.OSX && device.EffectiveWindowSize != device.SurfaceSize)
			{
				var s = 1 / device.EffectiveWindowScale;
				return new int2((int)(Math.Sign(x) / 2f + x * s), (int)(Math.Sign(y) / 2f + y * s));
			}

			return new int2(x, y);
		}

		static void Emit(IInputHandler inputHandler, MouseInputEvent evt, MouseButton button, int2 pos, int2 delta, Modifiers mods, int tapCount = 0)
		{
			inputHandler.OnMouseInput(new MouseInput(evt, button, pos, delta, mods, tapCount));
		}

		static float Distance(int2 a, int2 b)
		{
			var dx = a.X - b.X;
			var dy = a.Y - b.Y;
			return (float)Math.Sqrt(dx * dx + dy * dy);
		}

		static int2 Midpoint(int2 a, int2 b)
		{
			return new int2((a.X + b.X) / 2, (a.Y + b.Y) / 2);
		}

		public void HandleFingerEvent(SDL.SDL_Event e, Sdl2PlatformWindow device, IInputHandler inputHandler, Modifiers mods)
		{
			var pos = FingerToScreen(e.tfinger, device);
			var fingerId = e.tfinger.fingerId;

			switch (e.type)
			{
				case SDL.SDL_EventType.SDL_FINGERDOWN:
					HandleFingerDown(fingerId, pos, inputHandler, mods);
					break;
				case SDL.SDL_EventType.SDL_FINGERUP:
					HandleFingerUp(fingerId, pos, inputHandler, mods);
					break;
				case SDL.SDL_EventType.SDL_FINGERMOTION:
					HandleFingerMotion(fingerId, pos, inputHandler, mods);
					break;
			}
		}

		void HandleFingerDown(long fingerId, int2 pos, IInputHandler inputHandler, Modifiers mods)
		{
			fingerCount++;

			switch (state)
			{
				case State.Idle:
					finger1Id = fingerId;
					finger1Start = pos;
					finger1Pos = pos;
					fingerDownTicks = DateTime.Now.Ticks;
					state = State.WaitingForGesture;
					break;

				case State.WaitingForGesture:
					// Second finger arrived - transition to two-finger mode
					finger2Id = fingerId;
					finger2Pos = pos;
					EnterTwoFingerMode(inputHandler, mods);
					break;

				case State.LongPressDrag:
					// Second finger arrived during long-press drag - cancel box select, enter two-finger
					finger2Id = fingerId;
					finger2Pos = pos;
					Emit(inputHandler, MouseInputEvent.Up, MouseButton.Left, finger1Pos, int2.Zero, mods);
					EnterTwoFingerMode(inputHandler, mods);
					break;

				default:
					// Additional fingers in TwoFingerActive or Cancelled: ignore
					break;
			}
		}

		void HandleFingerUp(long fingerId, int2 pos, IInputHandler inputHandler, Modifiers mods)
		{
			fingerCount = Math.Max(0, fingerCount - 1);

			// Update position for the finger being lifted
			if (fingerId == finger1Id)
				finger1Pos = pos;
			else if (fingerId == finger2Id)
				finger2Pos = pos;

			switch (state)
			{
				case State.WaitingForGesture:
				{
					var elapsed = (DateTime.Now.Ticks - fingerDownTicks) / TimeSpan.TicksPerMillisecond;
					var moved = Distance(finger1Start, pos);

					if (elapsed < LongPressMs && moved < TapMaxMovePx)
					{
						// Tap: emit atomic Left Down+Up at the tap position
						var tapCount = MultiTapDetection.DetectFromMouse((byte)SDL.SDL_BUTTON_LEFT, finger1Start);
						Emit(inputHandler, MouseInputEvent.Down, MouseButton.Left, finger1Start, int2.Zero, mods, tapCount);
						Emit(inputHandler, MouseInputEvent.Up, MouseButton.Left, finger1Start, int2.Zero, mods,
							MultiTapDetection.InfoFromMouse((byte)SDL.SDL_BUTTON_LEFT));
					}

					// Otherwise discard (moved too far without long-press)
					state = State.Idle;
					break;
				}

				case State.LongPressDrag:
					// Release completes box selection
					Emit(inputHandler, MouseInputEvent.Up, MouseButton.Left, finger1Pos, int2.Zero, mods);
					state = State.Idle;
					break;

				case State.TwoFingerActive:
					// One finger lifted - end pan
					Emit(inputHandler, MouseInputEvent.Up, MouseButton.Middle, prevMidpoint, int2.Zero, mods);
					state = fingerCount > 0 ? State.Cancelled : State.Idle;
					break;

				case State.Cancelled:
					if (fingerCount == 0)
						state = State.Idle;
					break;

				default:
					if (fingerCount == 0)
						state = State.Idle;
					break;
			}
		}

		void HandleFingerMotion(long fingerId, int2 pos, IInputHandler inputHandler, Modifiers mods)
		{
			// Update tracked positions
			if (fingerId == finger1Id)
				finger1Pos = pos;
			else if (fingerId == finger2Id)
				finger2Pos = pos;

			switch (state)
			{
				case State.WaitingForGesture:
				{
					var moved = Distance(finger1Start, finger1Pos);
					if (moved > DragThresholdPx)
					{
						// Moved too far before long-press timer - cancel (1-finger swipe discarded)
						state = State.Cancelled;
					}

					break;
				}

				case State.LongPressDrag:
					// Emit move for box selection
					Emit(inputHandler, MouseInputEvent.Move, MouseButton.Left, finger1Pos,
						new int2(pos.X - finger1Pos.X, pos.Y - finger1Pos.Y), mods);
					break;

				case State.TwoFingerActive:
				{
					var newMidpoint = Midpoint(finger1Pos, finger2Pos);
					var newDistance = Distance(finger1Pos, finger2Pos);

					// Pan: emit Middle Move with delta
					var panDelta = new int2(newMidpoint.X - prevMidpoint.X, newMidpoint.Y - prevMidpoint.Y);
					if (panDelta.X != 0 || panDelta.Y != 0)
						Emit(inputHandler, MouseInputEvent.Move, MouseButton.Middle, newMidpoint, panDelta, mods);

					// Pinch zoom: emit Scroll event
					var distanceDelta = newDistance - prevDistance;
					if (Math.Abs(distanceDelta) > 1f)
					{
						var scrollDelta = (int)Math.Round(distanceDelta * PinchZoomScale);
						if (scrollDelta != 0)
							Emit(inputHandler, MouseInputEvent.Scroll, MouseButton.None, newMidpoint,
								new int2(0, scrollDelta), mods);
					}

					prevMidpoint = newMidpoint;
					prevDistance = newDistance;
					break;
				}

				case State.Cancelled:
					// Swallow
					break;
			}
		}

		void EnterTwoFingerMode(IInputHandler inputHandler, Modifiers mods)
		{
			prevMidpoint = Midpoint(finger1Pos, finger2Pos);
			prevDistance = Distance(finger1Pos, finger2Pos);
			Emit(inputHandler, MouseInputEvent.Down, MouseButton.Middle, prevMidpoint, int2.Zero, mods);
			state = State.TwoFingerActive;
		}

		public void ProcessTimers(Sdl2PlatformWindow device, IInputHandler inputHandler, Modifiers mods)
		{
			if (state != State.WaitingForGesture)
				return;

			var elapsed = (DateTime.Now.Ticks - fingerDownTicks) / TimeSpan.TicksPerMillisecond;
			var moved = Distance(finger1Start, finger1Pos);

			if (elapsed >= LongPressMs && moved < TapMaxMovePx)
			{
				// Long-press detected - begin box selection drag
				Emit(inputHandler, MouseInputEvent.Down, MouseButton.Left, finger1Start, int2.Zero, mods);
				state = State.LongPressDrag;
			}
		}
	}
}
