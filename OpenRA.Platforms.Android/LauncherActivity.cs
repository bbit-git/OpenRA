using System;
using System.Collections.Generic;
using Android.App;
using Android.Content;
using Android.Content.PM;
using Android.Graphics.Drawables;
using Android.OS;
using Android.Views;
using Android.Widget;

namespace OpenRA.Platforms.Android
{
	[Activity(
		Label = "@string/app_name",
		MainLauncher = true,
		Icon = "@mipmap/ic_launcher",
		RoundIcon = "@mipmap/ic_launcher",
		Theme = "@style/LauncherTheme",
		ScreenOrientation = ScreenOrientation.SensorLandscape,
		ConfigurationChanges =
			ConfigChanges.Orientation |
			ConfigChanges.ScreenSize |
			ConfigChanges.KeyboardHidden,
		Exported = true)]
	public class LauncherActivity : Activity
	{
		static readonly ModTemplate[] PreferredMods =
		{
			new("cnc", "Tiberian Dawn"),
			new("ra", "Red Alert"),
			new("d2k", "Dune 2000"),
			new("ts", "Tiberian Sun")
		};

		List<ModInfo> mods;

		protected override void OnCreate(Bundle savedInstanceState)
		{
			SetTheme(Resource.Style.LauncherTheme);
			base.OnCreate(savedInstanceState);

			SetContentView(Resource.Layout.activity_launcher);
			SetLauncherLoadingState(false);

			mods = LoadMods();
			PopulateModIcons();
		}

		protected override void OnResume()
		{
			base.OnResume();
			SetLauncherLoadingState(false);
		}

		List<ModInfo> LoadMods()
		{
			var list = new List<ModInfo>();
			var bundledMods = GetBundledMods();

			foreach (var mod in PreferredMods)
			{
				if (bundledMods.Count > 0 && !bundledMods.Contains(mod.Id))
					continue;

				list.Add(new ModInfo(mod.Id, mod.Title, $"engine/mods/{mod.Id}/icon-3x.png"));
			}

			return list;
		}

		HashSet<string> GetBundledMods()
		{
			try
			{
				var modDirs = Assets.List("engine/mods");
				var result = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
				if (modDirs == null)
					return result;

				foreach (var modDir in modDirs)
				{
					if (string.IsNullOrWhiteSpace(modDir))
						continue;

					if (modDir == "common" || modDir == "common-content" || modDir == "common-touch")
						continue;

					if (modDir.EndsWith("-content", StringComparison.OrdinalIgnoreCase))
						continue;

					result.Add(modDir);
				}

				return result;
			}
			catch (Exception ex)
			{
				global::Android.Util.Log.Warn("OpenRA", $"Launcher asset scan failed: {ex.Message}");
				return new HashSet<string>(StringComparer.OrdinalIgnoreCase);
			}
		}

		void PopulateModIcons()
		{
			var iconRow = FindViewById<LinearLayout>(Resource.Id.mod_icon_row);
			var empty = FindViewById<TextView>(Resource.Id.launcher_empty);
			iconRow.RemoveAllViews();

			if (mods.Count == 0)
			{
				if (empty != null)
					empty.Visibility = ViewStates.Visible;
				return;
			}

			if (empty != null)
				empty.Visibility = ViewStates.Gone;

			var inflater = LayoutInflater.FromContext(this);
			var density = Resources.DisplayMetrics.Density;
			var gap = (int)(20 * density + 0.5f);

			foreach (var mod in mods)
			{
				var tile = inflater.Inflate(Resource.Layout.launcher_mod_item, iconRow, false);
				var selectedMod = mod;
				tile.Click += (_, _) => LaunchMod(selectedMod);
				tile.ContentDescription = mod.Title;

				var layoutParams = new LinearLayout.LayoutParams(
					ViewGroup.LayoutParams.WrapContent,
					ViewGroup.LayoutParams.WrapContent);
				layoutParams.MarginEnd = gap;
				tile.LayoutParameters = layoutParams;

				var icon = tile.FindViewById<ImageView>(Resource.Id.mod_item_icon);
				SetIconDrawable(icon, mod.IconPath);

				iconRow.AddView(tile);
			}
		}

		void LaunchMod(ModInfo mod)
		{
			SetLauncherLoadingState(true);

			var intent = new Intent(this, typeof(MainActivity));
			intent.PutExtra(MainActivity.ModIntentKey, mod.Id);
			StartActivity(intent);
			Finish();
		}

		void SetLauncherLoadingState(bool isLoading)
		{
			var tagline = FindViewById<TextView>(Resource.Id.launcher_tagline);
			if (tagline == null)
				return;

			tagline.Text = isLoading
				? GetString(Resource.String.launcher_loading)
				: GetString(Resource.String.launcher_tagline);
		}

		void SetIconDrawable(ImageView icon, string path)
		{
			if (!string.IsNullOrEmpty(path))
			{
				try
				{
					using var stream = Assets.Open(path);
					var drawable = Drawable.CreateFromStream(stream, path);
					if (drawable != null)
					{
						icon.SetImageDrawable(drawable);
						return;
					}
				}
				catch
				{
					// Fall back to generic launcher icon.
				}
			}

			icon.SetImageResource(Resource.Mipmap.ic_launcher);
		}

		readonly struct ModTemplate
		{
			public ModTemplate(string id, string title)
			{
				Id = id;
				Title = title;
			}

			public string Id { get; }
			public string Title { get; }
		}

		sealed class ModInfo
		{
			public ModInfo(string id, string title, string iconPath)
			{
				Id = id;
				Title = title;
				IconPath = iconPath;
			}

			public string Id { get; }
			public string Title { get; }
			public string IconPath { get; }
		}
	}
}
