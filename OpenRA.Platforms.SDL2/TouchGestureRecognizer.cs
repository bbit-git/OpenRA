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
		enum State { Idle, WaitingForGesture, SingleFingerMove, LongPressArmed, LongPressDrag, TwoFingerPendingSelect, TwoFingerSelect, TwoFingerActive, Cancelled }

		public int LongPressMs = 400;
		public Func<int2, bool> LongTapIsRightClick;
		public Func<int2, bool> LongTapShouldForceMove;
		public Func<int2, bool> LongPressDragStartsLeftClick;
		public Func<int2, bool> SingleFingerDragMovesMouse;
		const int TapMaxMovePx = 15;
		const int DragThresholdPx = 15;
		const int LongPressDragStartThresholdPx = 2;
		const int TwoFingerSelectionMinDelayMs = 200;
		const int TwoFingerSelectionAnchorTolerancePx = 8;
		const int TwoFingerSelectionCommitThresholdPx = 12;
		const int TwoFingerSelectionCommittedAnchorTolerancePx = 24;
		const float PinchZoomScale = 0.04f;

		State state = State.Idle;
		int fingerCount;

		// First finger tracking
		long finger1Id;
		int2 finger1Start;
		int2 finger1Pos;

		// Second finger tracking
		long finger2Id;
		int2 finger2Start;
		int2 finger2Pos;
		long selectionAnchorFingerId;
		int2 selectionAnchorStart;
		int2 twoFingerSelectionPos;

		// Two-finger state
		int2 prevMidpoint;
		float prevDistance;
		float accumulatedScroll;

		// Long-press timer
		long fingerDownTicks;
		bool longPressCanForceMove;
		bool longPressCanStartLeftDrag;

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
					finger2Id = fingerId;
					finger2Start = pos;
					finger2Pos = pos;
					var elapsed = (DateTime.Now.Ticks - fingerDownTicks) / TimeSpan.TicksPerMillisecond;
					if (elapsed >= TwoFingerSelectionMinDelayMs &&
						Distance(finger1Start, finger1Pos) < TapMaxMovePx &&
						LongTapShouldForceMove?.Invoke(finger1Start) == true)
						state = State.TwoFingerPendingSelect;
					else
						EnterTwoFingerMode(inputHandler, mods);
					break;

				case State.SingleFingerMove:
					finger2Id = fingerId;
					finger2Start = pos;
					finger2Pos = pos;
					EnterTwoFingerMode(inputHandler, mods);
					break;

				case State.LongPressArmed:
					finger2Id = fingerId;
					finger2Start = pos;
					finger2Pos = pos;
					if (longPressCanForceMove && Distance(finger1Start, finger1Pos) < TapMaxMovePx)
						state = State.TwoFingerPendingSelect;
					else
						EnterTwoFingerMode(inputHandler, mods);
					break;

				case State.LongPressDrag:
					// Second finger arrived during long-press drag - cancel box select, enter two-finger
					finger2Id = fingerId;
					finger2Start = pos;
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

				case State.LongPressArmed:
					// Long press without drag: optionally issue force-move click.
					// Some modes (e.g. building placement) should swallow long-tap to avoid accidental deploy.
					if (longPressCanForceMove)
					{
						Emit(inputHandler, MouseInputEvent.Down, MouseButton.Left, finger1Start, int2.Zero, mods | Modifiers.Alt);
						Emit(inputHandler, MouseInputEvent.Up, MouseButton.Left, finger1Start, int2.Zero, mods | Modifiers.Alt,
							MultiTapDetection.InfoFromMouse((byte)SDL.SDL_BUTTON_LEFT));
					}

					state = State.Idle;
					break;

				case State.LongPressDrag:
					// Release completes box selection
					Emit(inputHandler, MouseInputEvent.Up, MouseButton.Left, finger1Pos, int2.Zero, mods);
					state = State.Idle;
					break;

				case State.SingleFingerMove:
					state = State.Idle;
					break;

				case State.TwoFingerPendingSelect:
					if (fingerCount == 0)
					{
						state = State.Idle;
						break;
					}

					// Recover the original one-finger gesture if the pending second touch was brief.
					if (fingerId == finger2Id)
					{
						finger2Id = 0;
						state = State.WaitingForGesture;
						break;
					}

					// If the original finger lifts first, promote the remaining finger to continue from a clean state.
					if (fingerId == finger1Id)
					{
						finger1Id = finger2Id;
						finger1Start = finger2Pos;
						finger1Pos = finger2Pos;
						finger2Id = 0;
						fingerDownTicks = DateTime.Now.Ticks;
						state = State.WaitingForGesture;
						break;
					}

					state = State.Cancelled;
					break;

				case State.TwoFingerSelect:
					// Releasing either finger completes the selection box.
					Emit(inputHandler, MouseInputEvent.Up, MouseButton.Left, twoFingerSelectionPos, int2.Zero, mods);
					state = fingerCount > 0 ? State.Cancelled : State.Idle;
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
			var prevFinger1Pos = finger1Pos;
			var prevFinger2Pos = finger2Pos;

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
					if (SingleFingerDragMovesMouse?.Invoke(finger1Start) == true)
					{
						if (moved > LongPressDragStartThresholdPx)
						{
							Emit(inputHandler, MouseInputEvent.Move, MouseButton.None, finger1Pos,
								new int2(finger1Pos.X - prevFinger1Pos.X, finger1Pos.Y - prevFinger1Pos.Y), mods);
							state = State.SingleFingerMove;
						}

						break;
					}

					if (moved > DragThresholdPx)
					{
						// Moved too far before long-press timer - cancel (1-finger swipe discarded)
						state = State.Cancelled;
					}

					break;
				}

				case State.LongPressArmed:
				{
					var moved = Distance(finger1Start, finger1Pos);
					if (moved > LongPressDragStartThresholdPx)
					{
						if (longPressCanForceMove || longPressCanStartLeftDrag)
						{
							// Long-press drag starts a held left-button drag with a tiny deadzone to keep selection responsive.
							Emit(inputHandler, MouseInputEvent.Down, MouseButton.Left, finger1Start, int2.Zero, mods);
							Emit(inputHandler, MouseInputEvent.Move, MouseButton.Left, finger1Pos,
								new int2(finger1Pos.X - finger1Start.X, finger1Pos.Y - finger1Start.Y), mods);
							state = State.LongPressDrag;
						}
						else if (SingleFingerDragMovesMouse?.Invoke(finger1Start) == true)
						{
							Emit(inputHandler, MouseInputEvent.Move, MouseButton.None, finger1Pos,
								new int2(finger1Pos.X - prevFinger1Pos.X, finger1Pos.Y - prevFinger1Pos.Y), mods);
							state = State.SingleFingerMove;
						}
						else
							state = State.Cancelled;
					}

					break;
				}

				case State.SingleFingerMove:
					Emit(inputHandler, MouseInputEvent.Move, MouseButton.None, finger1Pos,
						new int2(finger1Pos.X - prevFinger1Pos.X, finger1Pos.Y - prevFinger1Pos.Y), mods);
					break;

				case State.LongPressDrag:
					// Emit move for box selection
					Emit(inputHandler, MouseInputEvent.Move, MouseButton.Left, finger1Pos,
						new int2(finger1Pos.X - prevFinger1Pos.X, finger1Pos.Y - prevFinger1Pos.Y), mods);
					break;

				case State.TwoFingerPendingSelect:
				{
					var firstFingerMoved = Distance(finger1Start, finger1Pos);
					var secondFingerMoved = Distance(finger2Start, finger2Pos);
					var firstAnchorCandidate = firstFingerMoved <= TwoFingerSelectionAnchorTolerancePx &&
						secondFingerMoved >= TwoFingerSelectionCommitThresholdPx;
					var secondAnchorCandidate = secondFingerMoved <= TwoFingerSelectionAnchorTolerancePx &&
						firstFingerMoved >= TwoFingerSelectionCommitThresholdPx;

					if (firstAnchorCandidate)
					{
						BeginTwoFingerSelection(inputHandler, mods, finger1Id, finger1Start, finger2Pos);
						break;
					}

					if (secondAnchorCandidate)
					{
						BeginTwoFingerSelection(inputHandler, mods, finger2Id, finger2Start, finger1Pos);
						break;
					}

					if (firstFingerMoved > TwoFingerSelectionAnchorTolerancePx &&
						secondFingerMoved > TwoFingerSelectionAnchorTolerancePx)
						EnterTwoFingerMode(inputHandler, mods);

					break;
				}

				case State.TwoFingerSelect:
				{
					var anchorMoved = selectionAnchorFingerId == finger1Id
						? Distance(selectionAnchorStart, finger1Pos) > TwoFingerSelectionCommittedAnchorTolerancePx
						: Distance(selectionAnchorStart, finger2Pos) > TwoFingerSelectionCommittedAnchorTolerancePx;
					if (anchorMoved)
					{
						Emit(inputHandler, MouseInputEvent.Up, MouseButton.Left, twoFingerSelectionPos, int2.Zero, mods);
						EnterTwoFingerMode(inputHandler, mods);
						break;
					}

					var selectionPos = selectionAnchorFingerId == finger1Id ? finger2Pos : finger1Pos;
					var previousSelectionPos = twoFingerSelectionPos;
					twoFingerSelectionPos = selectionPos;

					var delta = new int2(twoFingerSelectionPos.X - previousSelectionPos.X, twoFingerSelectionPos.Y - previousSelectionPos.Y);
					Emit(inputHandler, MouseInputEvent.Move, MouseButton.Left, twoFingerSelectionPos, delta, mods);
					break;
				}

				case State.TwoFingerActive:
				{
					var newMidpoint = Midpoint(finger1Pos, finger2Pos);
					var newDistance = Distance(finger1Pos, finger2Pos);

					// Pan: emit Middle Move with delta
					var panDelta = new int2(newMidpoint.X - prevMidpoint.X, newMidpoint.Y - prevMidpoint.Y);
					if (panDelta.X != 0 || panDelta.Y != 0)
						Emit(inputHandler, MouseInputEvent.Move, MouseButton.Middle, newMidpoint, panDelta, mods);

					// Pinch zoom: accumulate fractional scroll delta to avoid losing small per-frame movements
					var distanceDelta = newDistance - prevDistance;
					if (Math.Abs(distanceDelta) > 1f)
						accumulatedScroll += distanceDelta * PinchZoomScale;
					var scrollDelta = (int)Math.Round(accumulatedScroll);
					if (scrollDelta != 0)
					{
						Emit(inputHandler, MouseInputEvent.Scroll, MouseButton.None, newMidpoint,
							new int2(0, scrollDelta), mods);
						accumulatedScroll -= scrollDelta;
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
			accumulatedScroll = 0f;

			// Emit a Move first to update Viewport.LastMousePos to the midpoint,
			// preventing a camera jump on the first pan frame.
			Emit(inputHandler, MouseInputEvent.Move, MouseButton.None, prevMidpoint, int2.Zero, mods);
			Emit(inputHandler, MouseInputEvent.Down, MouseButton.Middle, prevMidpoint, int2.Zero, mods);
			state = State.TwoFingerActive;
		}

		void EnterTwoFingerSelection(IInputHandler inputHandler, Modifiers mods)
		{
			BeginTwoFingerSelection(inputHandler, mods, finger1Id, finger1Start, finger2Pos);
		}

		void BeginTwoFingerSelection(IInputHandler inputHandler, Modifiers mods, long anchorFingerId, int2 anchorStart, int2 selectionPos)
		{
			selectionAnchorFingerId = anchorFingerId;
			selectionAnchorStart = anchorStart;
			twoFingerSelectionPos = selectionPos;
			Emit(inputHandler, MouseInputEvent.Down, MouseButton.Left, anchorStart, int2.Zero, mods);
			Emit(inputHandler, MouseInputEvent.Move, MouseButton.Left, selectionPos,
				new int2(selectionPos.X - anchorStart.X, selectionPos.Y - anchorStart.Y), mods);
			state = State.TwoFingerSelect;
		}

		public void ProcessTimers(Sdl2PlatformWindow device, IInputHandler inputHandler, Modifiers mods)
		{
			if (state != State.WaitingForGesture)
				return;

			var elapsed = (DateTime.Now.Ticks - fingerDownTicks) / TimeSpan.TicksPerMillisecond;
			var moved = Distance(finger1Start, finger1Pos);

			if (elapsed >= LongPressMs && moved < TapMaxMovePx)
			{
				if (LongTapIsRightClick?.Invoke(finger1Start) == true)
				{
					// Long-tap over a widget that wants right-click (e.g. production cancel)
					Emit(inputHandler, MouseInputEvent.Down, MouseButton.Right, finger1Start, int2.Zero, mods);
					Emit(inputHandler, MouseInputEvent.Up, MouseButton.Right, finger1Start, int2.Zero, mods);
					state = State.Cancelled;
				}
				else
				{
					// Long-press detected - arm either force-move tap (on release) or a held left-button drag (on move).
					longPressCanForceMove = LongTapShouldForceMove?.Invoke(finger1Start) == true;
					longPressCanStartLeftDrag = LongPressDragStartsLeftClick?.Invoke(finger1Start) == true;
					state = State.LongPressArmed;
				}
			}
		}
	}
}
