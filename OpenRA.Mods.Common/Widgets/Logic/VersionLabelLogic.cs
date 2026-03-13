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

using OpenRA.Mods.Common.Widgets;
using OpenRA.Widgets;

namespace OpenRA.Mods.Common.Widgets.Logic
{
	public class VersionLabelLogic : ChromeLogic
	{
		[ObjectCreator.UseCtor]
		public VersionLabelLogic(LabelWidget widget, ModData modData)
		{
			var versionText = modData.Manifest.Metadata.Version;
#if ANDROID
			if (!string.IsNullOrEmpty(Platform.DisplayVersion))
			{
				// Android-specific workaround: show package metadata on a separate line
				// so the engine version remains the primary compatibility indicator.
				versionText += "\nAndroid " + Platform.DisplayVersion;
				widget.VAlign = TextVAlign.Top;
			}
#endif

			widget.GetText = () => versionText;
		}
	}
}
