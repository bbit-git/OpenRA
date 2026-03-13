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

using NUnit.Framework;
using OpenRA.Platforms.SDL2;
using OpenRA.Primitives;

namespace OpenRA.Test.OpenRA.Platforms.SDL2
{
	[TestFixture]
	sealed class Sdl2PlatformWindowTest
	{
		[Test]
		public void AndroidScaleClampUsesHeightFloor()
		{
			var scale = Sdl2PlatformWindow.ClampAndroidWindowScale(4f, new Size(2560, 1440));

			Assert.That(scale, Is.EqualTo(1440f / Sdl2PlatformWindow.AndroidMinLogicalHeight).Within(0.0001f));
		}

		[Test]
		public void AndroidScaleClampUsesWidthFloor()
		{
			var scale = Sdl2PlatformWindow.ClampAndroidWindowScale(4f, new Size(1920, 1440));

			Assert.That(scale, Is.EqualTo(1920f / Sdl2PlatformWindow.AndroidMinLogicalWidth).Within(0.0001f));
		}

		[Test]
		public void AndroidScaleClampLeavesAlreadySafeScaleUnchanged()
		{
			var scale = Sdl2PlatformWindow.ClampAndroidWindowScale(1.5f, new Size(2560, 1600));

			Assert.That(scale, Is.EqualTo(1.5f));
		}

		[Test]
		public void AndroidLogicalSizeIsRoundedDownToEvenDimensions()
		{
			var size = Sdl2PlatformWindow.CalculateAndroidLogicalSize(new Size(2081, 1027), 2f);

			Assert.That(size.Width, Is.EqualTo(1040));
			Assert.That(size.Height, Is.EqualTo(512));
		}
	}
}
