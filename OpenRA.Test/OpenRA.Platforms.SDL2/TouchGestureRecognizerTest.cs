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
using System.Collections.Generic;
using System.Reflection;
using NUnit.Framework;
using OpenRA.Platforms.SDL2;
using OpenRA.Primitives;
using OpenRA.Widgets;

namespace OpenRA.Test.OpenRA.Platforms.SDL2
{
	[TestFixture]
	public sealed class TouchGestureRecognizerTest
	{
		sealed class RecordingInputHandler : IInputHandler
		{
			public readonly List<MouseInput> MouseInputs = [];

			public void ModifierKeys(Modifiers mods) { }
			public void OnKeyInput(KeyInput input) { }
			public void OnTextInput(string text) { }

			public void OnMouseInput(MouseInput input)
			{
				MouseInputs.Add(input);
			}
		}

		static readonly MethodInfo HandleFingerDown = typeof(TouchGestureRecognizer)
			.GetMethod("HandleFingerDown", BindingFlags.Instance | BindingFlags.NonPublic);
		static readonly MethodInfo HandleFingerUp = typeof(TouchGestureRecognizer)
			.GetMethod("HandleFingerUp", BindingFlags.Instance | BindingFlags.NonPublic);
		static readonly MethodInfo HandleFingerMotion = typeof(TouchGestureRecognizer)
			.GetMethod("HandleFingerMotion", BindingFlags.Instance | BindingFlags.NonPublic);
		static readonly FieldInfo FingerDownTicks = typeof(TouchGestureRecognizer)
			.GetField("fingerDownTicks", BindingFlags.Instance | BindingFlags.NonPublic);

		static void InvokeFingerDown(TouchGestureRecognizer recognizer, long fingerId, int2 pos, IInputHandler input, Modifiers mods)
		{
			HandleFingerDown.Invoke(recognizer, [fingerId, pos, input, mods]);
		}

		static void InvokeFingerUp(TouchGestureRecognizer recognizer, long fingerId, int2 pos, IInputHandler input, Modifiers mods)
		{
			HandleFingerUp.Invoke(recognizer, [fingerId, pos, input, mods]);
		}

		static void InvokeFingerMotion(TouchGestureRecognizer recognizer, long fingerId, int2 pos, IInputHandler input, Modifiers mods)
		{
			HandleFingerMotion.Invoke(recognizer, [fingerId, pos, input, mods]);
		}

		[Test]
		public void ShortTapEmitsPlainLeftClick()
		{
			var recognizer = new TouchGestureRecognizer { LongPressMs = 1000, LongTapIsRightClick = _ => false };
			var input = new RecordingInputHandler();
			var pos = new int2(100, 100);

			InvokeFingerDown(recognizer, 1, pos, input, Modifiers.None);
			InvokeFingerUp(recognizer, 1, pos, input, Modifiers.None);

			Assert.That(input.MouseInputs, Has.Count.EqualTo(2));
			Assert.That(input.MouseInputs[0].Event, Is.EqualTo(MouseInputEvent.Down));
			Assert.That(input.MouseInputs[0].Button, Is.EqualTo(MouseButton.Left));
			Assert.That(input.MouseInputs[0].Modifiers, Is.EqualTo(Modifiers.None));
			Assert.That(input.MouseInputs[1].Event, Is.EqualTo(MouseInputEvent.Up));
			Assert.That(input.MouseInputs[1].Button, Is.EqualTo(MouseButton.Left));
			Assert.That(input.MouseInputs[1].Modifiers, Is.EqualTo(Modifiers.None));
		}

		[Test]
		public void LongTapReleaseEmitsAltLeftClick()
		{
			var recognizer = new TouchGestureRecognizer
			{
				LongPressMs = 10,
				LongTapIsRightClick = _ => false,
				LongTapShouldForceMove = _ => true,
			};
			var input = new RecordingInputHandler();
			var pos = new int2(100, 100);

			InvokeFingerDown(recognizer, 1, pos, input, Modifiers.None);
			FingerDownTicks.SetValue(recognizer, DateTime.Now.Ticks - TimeSpan.FromMilliseconds(50).Ticks);

			recognizer.ProcessTimers(null, input, Modifiers.None);
			InvokeFingerUp(recognizer, 1, pos, input, Modifiers.None);

			Assert.That(input.MouseInputs, Has.Count.EqualTo(2));
			Assert.That(input.MouseInputs[0].Event, Is.EqualTo(MouseInputEvent.Down));
			Assert.That(input.MouseInputs[0].Button, Is.EqualTo(MouseButton.Left));
			Assert.That(input.MouseInputs[0].Modifiers.HasModifier(Modifiers.Alt), Is.True);
			Assert.That(input.MouseInputs[1].Event, Is.EqualTo(MouseInputEvent.Up));
			Assert.That(input.MouseInputs[1].Button, Is.EqualTo(MouseButton.Left));
			Assert.That(input.MouseInputs[1].Modifiers.HasModifier(Modifiers.Alt), Is.True);
		}

		[Test]
		public void LongTapReleaseIsSwallowedWhenForceMoveIsDisabled()
		{
			var recognizer = new TouchGestureRecognizer
			{
				LongPressMs = 10,
				LongTapIsRightClick = _ => false,
				LongTapShouldForceMove = _ => false,
			};
			var input = new RecordingInputHandler();
			var pos = new int2(100, 100);

			InvokeFingerDown(recognizer, 1, pos, input, Modifiers.None);
			FingerDownTicks.SetValue(recognizer, DateTime.Now.Ticks - TimeSpan.FromMilliseconds(50).Ticks);

			recognizer.ProcessTimers(null, input, Modifiers.None);
			InvokeFingerUp(recognizer, 1, pos, input, Modifiers.None);

			Assert.That(input.MouseInputs, Is.Empty);
		}

		[Test]
		public void LongPressThenSmallDragStartsSelectionInsteadOfForceMoveTap()
		{
			var recognizer = new TouchGestureRecognizer
			{
				LongPressMs = 10,
				LongTapIsRightClick = _ => false,
				LongTapShouldForceMove = _ => true,
			};

			var input = new RecordingInputHandler();
			var start = new int2(100, 100);
			var drag = new int2(103, 100);

			InvokeFingerDown(recognizer, 1, start, input, Modifiers.None);
			FingerDownTicks.SetValue(recognizer, DateTime.Now.Ticks - TimeSpan.FromMilliseconds(50).Ticks);
			recognizer.ProcessTimers(null, input, Modifiers.None);

			// Small movement after long-press should enter drag-select mode.
			InvokeFingerMotion(recognizer, 1, drag, input, Modifiers.None);
			InvokeFingerUp(recognizer, 1, drag, input, Modifiers.None);

			Assert.That(input.MouseInputs, Has.Count.EqualTo(3));
			Assert.That(input.MouseInputs[0].Event, Is.EqualTo(MouseInputEvent.Down));
			Assert.That(input.MouseInputs[0].Button, Is.EqualTo(MouseButton.Left));
			Assert.That(input.MouseInputs[0].Modifiers.HasModifier(Modifiers.Alt), Is.False);
			Assert.That(input.MouseInputs[1].Event, Is.EqualTo(MouseInputEvent.Move));
			Assert.That(input.MouseInputs[1].Button, Is.EqualTo(MouseButton.Left));
			Assert.That(input.MouseInputs[1].Location, Is.EqualTo(drag));
			Assert.That(input.MouseInputs[1].Delta, Is.EqualTo(new int2(3, 0)));
			Assert.That(input.MouseInputs[2].Event, Is.EqualTo(MouseInputEvent.Up));
			Assert.That(input.MouseInputs[2].Button, Is.EqualTo(MouseButton.Left));
			Assert.That(input.MouseInputs[2].Modifiers.HasModifier(Modifiers.Alt), Is.False);
		}

		[Test]
		public void LongPressThenSmallDragStartsHeldLeftDragWhenConfigured()
		{
			var recognizer = new TouchGestureRecognizer
			{
				LongPressMs = 10,
				LongTapIsRightClick = _ => false,
				LongTapShouldForceMove = _ => false,
				LongPressDragStartsLeftClick = _ => true,
			};

			var input = new RecordingInputHandler();
			var start = new int2(100, 100);
			var drag = new int2(104, 102);

			InvokeFingerDown(recognizer, 1, start, input, Modifiers.None);
			FingerDownTicks.SetValue(recognizer, DateTime.Now.Ticks - TimeSpan.FromMilliseconds(50).Ticks);
			recognizer.ProcessTimers(null, input, Modifiers.None);

			InvokeFingerMotion(recognizer, 1, drag, input, Modifiers.None);
			InvokeFingerUp(recognizer, 1, drag, input, Modifiers.None);

			Assert.That(input.MouseInputs, Has.Count.EqualTo(3));
			Assert.That(input.MouseInputs[0].Event, Is.EqualTo(MouseInputEvent.Down));
			Assert.That(input.MouseInputs[0].Button, Is.EqualTo(MouseButton.Left));
			Assert.That(input.MouseInputs[0].Location, Is.EqualTo(start));
			Assert.That(input.MouseInputs[0].Modifiers, Is.EqualTo(Modifiers.None));
			Assert.That(input.MouseInputs[1].Event, Is.EqualTo(MouseInputEvent.Move));
			Assert.That(input.MouseInputs[1].Button, Is.EqualTo(MouseButton.Left));
			Assert.That(input.MouseInputs[1].Location, Is.EqualTo(drag));
			Assert.That(input.MouseInputs[1].Delta, Is.EqualTo(new int2(4, 2)));
			Assert.That(input.MouseInputs[2].Event, Is.EqualTo(MouseInputEvent.Up));
			Assert.That(input.MouseInputs[2].Button, Is.EqualTo(MouseButton.Left));
			Assert.That(input.MouseInputs[2].Location, Is.EqualTo(drag));
		}

		[Test]
		public void SecondFingerOnStationaryFirstStartsGroupSelection()
		{
			var recognizer = new TouchGestureRecognizer
			{
				LongPressMs = 1000,
				LongTapIsRightClick = _ => false,
				LongTapShouldForceMove = _ => true,
			};

			var input = new RecordingInputHandler();
			var anchor = new int2(100, 100);
			var secondDown = new int2(120, 120);
			var secondDrag = new int2(136, 136);

			InvokeFingerDown(recognizer, 1, anchor, input, Modifiers.None);
			FingerDownTicks.SetValue(recognizer, DateTime.Now.Ticks - TimeSpan.FromMilliseconds(250).Ticks);
			InvokeFingerDown(recognizer, 2, secondDown, input, Modifiers.None);
			InvokeFingerMotion(recognizer, 2, secondDrag, input, Modifiers.None);
			InvokeFingerUp(recognizer, 2, secondDrag, input, Modifiers.None);

			Assert.That(input.MouseInputs, Has.Count.EqualTo(3));
			Assert.That(input.MouseInputs[0].Event, Is.EqualTo(MouseInputEvent.Down));
			Assert.That(input.MouseInputs[0].Button, Is.EqualTo(MouseButton.Left));
			Assert.That(input.MouseInputs[0].Location, Is.EqualTo(anchor));
			Assert.That(input.MouseInputs[1].Event, Is.EqualTo(MouseInputEvent.Move));
			Assert.That(input.MouseInputs[1].Button, Is.EqualTo(MouseButton.Left));
			Assert.That(input.MouseInputs[1].Location, Is.EqualTo(secondDrag));
			Assert.That(input.MouseInputs[2].Event, Is.EqualTo(MouseInputEvent.Up));
			Assert.That(input.MouseInputs[2].Button, Is.EqualTo(MouseButton.Left));
			Assert.That(input.MouseInputs[2].Location, Is.EqualTo(secondDrag));
		}

		[Test]
		public void FirstFingerCanBecomeDragFingerWhenSecondFingerStaysAnchored()
		{
			var recognizer = new TouchGestureRecognizer
			{
				LongPressMs = 1000,
				LongTapIsRightClick = _ => false,
				LongTapShouldForceMove = _ => true,
			};

			var input = new RecordingInputHandler();
			var firstDown = new int2(100, 100);
			var secondDown = new int2(120, 120);
			var firstDrag = new int2(136, 136);

			InvokeFingerDown(recognizer, 1, firstDown, input, Modifiers.None);
			FingerDownTicks.SetValue(recognizer, DateTime.Now.Ticks - TimeSpan.FromMilliseconds(250).Ticks);
			InvokeFingerDown(recognizer, 2, secondDown, input, Modifiers.None);
			InvokeFingerMotion(recognizer, 1, firstDrag, input, Modifiers.None);
			InvokeFingerUp(recognizer, 1, firstDrag, input, Modifiers.None);

			Assert.That(input.MouseInputs, Has.Count.EqualTo(3));
			Assert.That(input.MouseInputs[0].Event, Is.EqualTo(MouseInputEvent.Down));
			Assert.That(input.MouseInputs[0].Button, Is.EqualTo(MouseButton.Left));
			Assert.That(input.MouseInputs[0].Location, Is.EqualTo(secondDown));
			Assert.That(input.MouseInputs[1].Event, Is.EqualTo(MouseInputEvent.Move));
			Assert.That(input.MouseInputs[1].Button, Is.EqualTo(MouseButton.Left));
			Assert.That(input.MouseInputs[1].Location, Is.EqualTo(firstDrag));
			Assert.That(input.MouseInputs[2].Event, Is.EqualTo(MouseInputEvent.Up));
			Assert.That(input.MouseInputs[2].Button, Is.EqualTo(MouseButton.Left));
			Assert.That(input.MouseInputs[2].Location, Is.EqualTo(firstDrag));
		}

		[Test]
		public void LongPressArmedThenSecondFingerCanStartGroupSelection()
		{
			var recognizer = new TouchGestureRecognizer
			{
				LongPressMs = 10,
				LongTapIsRightClick = _ => false,
				LongTapShouldForceMove = _ => true,
			};

			var input = new RecordingInputHandler();
			var firstDown = new int2(100, 100);
			var secondDown = new int2(120, 120);
			var secondDrag = new int2(136, 136);

			InvokeFingerDown(recognizer, 1, firstDown, input, Modifiers.None);
			FingerDownTicks.SetValue(recognizer, DateTime.Now.Ticks - TimeSpan.FromMilliseconds(50).Ticks);
			recognizer.ProcessTimers(null, input, Modifiers.None);
			InvokeFingerDown(recognizer, 2, secondDown, input, Modifiers.None);
			InvokeFingerMotion(recognizer, 2, secondDrag, input, Modifiers.None);
			InvokeFingerUp(recognizer, 2, secondDrag, input, Modifiers.None);

			Assert.That(input.MouseInputs, Has.Count.EqualTo(3));
			Assert.That(input.MouseInputs[0].Event, Is.EqualTo(MouseInputEvent.Down));
			Assert.That(input.MouseInputs[0].Button, Is.EqualTo(MouseButton.Left));
			Assert.That(input.MouseInputs[0].Location, Is.EqualTo(firstDown));
			Assert.That(input.MouseInputs[1].Event, Is.EqualTo(MouseInputEvent.Move));
			Assert.That(input.MouseInputs[1].Button, Is.EqualTo(MouseButton.Left));
			Assert.That(input.MouseInputs[1].Location, Is.EqualTo(secondDrag));
			Assert.That(input.MouseInputs[2].Event, Is.EqualTo(MouseInputEvent.Up));
			Assert.That(input.MouseInputs[2].Button, Is.EqualTo(MouseButton.Left));
		}

		[Test]
		public void NonUnitSingleFingerDragEmitsMouseMoveWithoutPlacementClick()
		{
			var recognizer = new TouchGestureRecognizer
			{
				LongPressMs = 1000,
				LongTapIsRightClick = _ => false,
				LongTapShouldForceMove = _ => false,
				SingleFingerDragMovesMouse = _ => true,
			};

			var input = new RecordingInputHandler();
			var start = new int2(100, 100);
			var drag = new int2(120, 110);

			InvokeFingerDown(recognizer, 1, start, input, Modifiers.None);
			InvokeFingerMotion(recognizer, 1, drag, input, Modifiers.None);
			InvokeFingerUp(recognizer, 1, drag, input, Modifiers.None);

			Assert.That(input.MouseInputs, Has.Count.EqualTo(1));
			Assert.That(input.MouseInputs[0].Event, Is.EqualTo(MouseInputEvent.Move));
			Assert.That(input.MouseInputs[0].Button, Is.EqualTo(MouseButton.None));
			Assert.That(input.MouseInputs[0].Location, Is.EqualTo(drag));
			Assert.That(input.MouseInputs[0].Delta, Is.EqualTo(new int2(20, 10)));
		}

		[Test]
		public void ImmediateSecondFingerStartsPanInsteadOfGroupSelection()
		{
			var recognizer = new TouchGestureRecognizer
			{
				LongPressMs = 1000,
				LongTapIsRightClick = _ => false,
				LongTapShouldForceMove = _ => true,
			};

			var input = new RecordingInputHandler();
			var anchor = new int2(100, 100);
			var secondDown = new int2(120, 120);

			InvokeFingerDown(recognizer, 1, anchor, input, Modifiers.None);
			InvokeFingerDown(recognizer, 2, secondDown, input, Modifiers.None);

			Assert.That(input.MouseInputs, Has.Count.EqualTo(2));
			Assert.That(input.MouseInputs[0].Event, Is.EqualTo(MouseInputEvent.Move));
			Assert.That(input.MouseInputs[0].Button, Is.EqualTo(MouseButton.None));
			Assert.That(input.MouseInputs[1].Event, Is.EqualTo(MouseInputEvent.Down));
			Assert.That(input.MouseInputs[1].Button, Is.EqualTo(MouseButton.Middle));
		}

		[Test]
		public void TwoFingerSelectionCancelsToPanWhenBothFingersMove()
		{
			var recognizer = new TouchGestureRecognizer
			{
				LongPressMs = 1000,
				LongTapIsRightClick = _ => false,
				LongTapShouldForceMove = _ => true,
			};

			var input = new RecordingInputHandler();
			var firstDown = new int2(100, 100);
			var secondDown = new int2(120, 120);

			InvokeFingerDown(recognizer, 1, firstDown, input, Modifiers.None);
			FingerDownTicks.SetValue(recognizer, DateTime.Now.Ticks - TimeSpan.FromMilliseconds(250).Ticks);
			InvokeFingerDown(recognizer, 2, secondDown, input, Modifiers.None);

			// First movement commits selection with the second finger as anchor.
			InvokeFingerMotion(recognizer, 1, new int2(112, 112), input, Modifiers.None);
			// Then move the anchor far enough to cancel back to pan.
			InvokeFingerMotion(recognizer, 2, new int2(150, 150), input, Modifiers.None);

			Assert.That(input.MouseInputs.Count, Is.GreaterThanOrEqualTo(5));
			Assert.That(input.MouseInputs[0].Event, Is.EqualTo(MouseInputEvent.Down));
			Assert.That(input.MouseInputs[0].Button, Is.EqualTo(MouseButton.Left));
			Assert.That(input.MouseInputs[1].Event, Is.EqualTo(MouseInputEvent.Move));
			Assert.That(input.MouseInputs[1].Button, Is.EqualTo(MouseButton.Left));
			Assert.That(input.MouseInputs[2].Event, Is.EqualTo(MouseInputEvent.Up));
			Assert.That(input.MouseInputs[2].Button, Is.EqualTo(MouseButton.Left));
			Assert.That(input.MouseInputs[3].Event, Is.EqualTo(MouseInputEvent.Move));
			Assert.That(input.MouseInputs[3].Button, Is.EqualTo(MouseButton.None));
			Assert.That(input.MouseInputs[4].Event, Is.EqualTo(MouseInputEvent.Down));
			Assert.That(input.MouseInputs[4].Button, Is.EqualTo(MouseButton.Middle));
		}

		[Test]
		public void PendingSecondFingerLiftRecoversOriginalTap()
		{
			var recognizer = new TouchGestureRecognizer
			{
				LongPressMs = 1000,
				LongTapIsRightClick = _ => false,
				LongTapShouldForceMove = _ => true,
			};

			var input = new RecordingInputHandler();
			var firstDown = new int2(100, 100);
			var secondDown = new int2(120, 120);

			InvokeFingerDown(recognizer, 1, firstDown, input, Modifiers.None);
			FingerDownTicks.SetValue(recognizer, DateTime.Now.Ticks - TimeSpan.FromMilliseconds(250).Ticks);
			InvokeFingerDown(recognizer, 2, secondDown, input, Modifiers.None);
			InvokeFingerUp(recognizer, 2, secondDown, input, Modifiers.None);
			InvokeFingerUp(recognizer, 1, firstDown, input, Modifiers.None);

			Assert.That(input.MouseInputs, Has.Count.EqualTo(2));
			Assert.That(input.MouseInputs[0].Event, Is.EqualTo(MouseInputEvent.Down));
			Assert.That(input.MouseInputs[0].Button, Is.EqualTo(MouseButton.Left));
			Assert.That(input.MouseInputs[1].Event, Is.EqualTo(MouseInputEvent.Up));
			Assert.That(input.MouseInputs[1].Button, Is.EqualTo(MouseButton.Left));
		}
	}
}
