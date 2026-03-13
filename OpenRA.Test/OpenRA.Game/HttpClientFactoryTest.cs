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
using OpenRA.Support;

namespace OpenRA.Test
{
	[TestFixture]
	sealed class HttpClientFactoryTest
	{
		[Test(Description = "Desktop test runs should keep using the managed handler.")]
		public void UsesManagedHandlerOnNonAndroidPlatforms()
		{
			Assert.That(OperatingSystem.IsAndroid(), Is.False);
			Assert.That(HttpClientFactory.UseManagedHandler, Is.True);
		}
	}
}
