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

using System.Linq;
using OpenRA.Mods.Common.Traits;
using OpenRA.Mods.Common.Widgets;
using OpenRA.Widgets;

namespace OpenRA.Mods.Common.Widgets.Logic
{
	public class MenuButtonsChromeLogic : ChromeLogic
	{
		readonly World world;
		readonly Widget worldRoot;
		readonly Widget menuRoot;
		readonly MenuButtonWidget optionsButton;

		bool disableSystemButtons;
		Widget currentWidget;

		[ObjectCreator.UseCtor]
		public MenuButtonsChromeLogic(Widget widget, World world)
		{
			this.world = world;

			worldRoot = Ui.Root.Get("WORLD_ROOT");
			menuRoot = Ui.Root.Get("MENU_ROOT");

			// System buttons
			optionsButton = widget.GetOrNull<MenuButtonWidget>("OPTIONS_BUTTON");
			if (optionsButton != null)
			{
				var blinking = false;
				var lp = world.LocalPlayer;
				optionsButton.IsDisabled = () => disableSystemButtons;
				optionsButton.OnClick = () =>
				{
					blinking = false;
					OpenMenuPanel(optionsButton, new WidgetArgs()
					{
						{ "initialPanel", IngameInfoPanel.AutoSelect }
					});
				};
				optionsButton.IsHighlighted = () => blinking && Game.LocalTick % 50 < 25;

				if (lp != null)
				{
					void StartBlinking(Player player, bool inhibitAnnouncement)
					{
						if (!inhibitAnnouncement && player == world.LocalPlayer)
							blinking = true;
					}

					var mo = lp.PlayerActor.TraitOrDefault<MissionObjectives>();

					if (mo != null)
						mo.ObjectiveAdded += StartBlinking;
				}

				if (Platform.CurrentPlatform == PlatformType.Android)
					Game.OnApplicationEnteringBackground += OpenPauseMenuOnBackground;
			}

			var debug = widget.GetOrNull<MenuButtonWidget>("DEBUG_BUTTON");
			if (debug != null)
			{
				// Can't use DeveloperMode.Enabled because there is a hardcoded hack to *always*
				// enable developer mode for singleplayer games, but we only want to show the button
				// if it has been explicitly enabled
				var def = world.Map.Rules.Actors[SystemActors.Player].TraitInfo<DeveloperModeInfo>().CheckboxEnabled;
				var enabled = world.LobbyInfo.GlobalSettings.OptionOrDefault("cheats", def);
				debug.IsVisible = () => enabled;
				debug.IsDisabled = () => disableSystemButtons;
				debug.OnClick = () => OpenMenuPanel(debug, new WidgetArgs()
				{
					{ "initialPanel", IngameInfoPanel.Debug }
				});
			}
		}

		void OpenMenuPanel(MenuButtonWidget button, WidgetArgs widgetArgs = null)
		{
			disableSystemButtons = true;
			var cachedPause = world.PredictedPaused;

			if (button.HideIngameUI)
			{
				// Cancel custom input modes (guard, building placement, etc)
				world.CancelInputMode();

				worldRoot.IsVisible = () => false;
			}

			if (button.Pause && world.LobbyInfo.NonBotClients.Count() == 1)
				world.SetPauseState(true);

			var cachedDisableWorldSounds = Game.Sound.DisableWorldSounds;
			if (button.DisableWorldSounds)
				Game.Sound.DisableWorldSounds = true;

			widgetArgs ??= [];
			widgetArgs.Add("onExit", () =>
			{
				if (button.HideIngameUI)
					worldRoot.IsVisible = () => true;

				if (button.DisableWorldSounds)
					Game.Sound.DisableWorldSounds = cachedDisableWorldSounds;

				if (button.Pause && world.LobbyInfo.NonBotClients.Count() == 1)
					world.SetPauseState(cachedPause);

				menuRoot.RemoveChild(currentWidget);
				disableSystemButtons = false;
			});

			currentWidget = Game.LoadWidget(world, button.MenuContainer, menuRoot, widgetArgs);
			Game.RunAfterTick(Ui.ResetTooltips);
		}

		void OpenPauseMenuOnBackground()
		{
			Game.RunAfterTick(() =>
			{
				if (!CanOpenPauseMenuOnBackground())
					return;

				Sync.RunUnsynced(world, optionsButton.OnClick);
			});
		}

		bool CanOpenPauseMenuOnBackground()
		{
			return optionsButton != null
				&& Game.IsCurrentWorld(world)
				&& world.Type == WorldType.Regular
				&& !world.IsReplay
				&& !disableSystemButtons
				&& optionsButton.IsVisible()
				&& !optionsButton.IsDisabled()
				&& menuRoot.Children.Count == 0;
		}

		protected override void Dispose(bool disposing)
		{
			if (disposing && optionsButton != null && Platform.CurrentPlatform == PlatformType.Android)
				Game.OnApplicationEnteringBackground -= OpenPauseMenuOnBackground;

			base.Dispose(disposing);
		}
	}
}
