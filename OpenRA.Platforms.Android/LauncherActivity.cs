using System;
using System.Collections.Generic;
using System.IO;
using Android.App;
using Android.Content;
using Android.Content.PM;
using Android.Graphics.Drawables;
using Android.OS;
using Android.Views;
using Android.Widget;
using OpenRA;
using OpenRA.FileSystem;

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
		static readonly string[] PreferredModOrder = { "cnc", "ra", "d2k", "ts" };
		string internalPath;
		string engineDir;
		List<ModInfo> mods;

		protected override void OnCreate(Bundle savedInstanceState)
		{
			SetTheme(Resource.Style.LauncherTheme);
			base.OnCreate(savedInstanceState);

			var paths = EngineAssets.Prepare(this);
			internalPath = paths.InternalPath;
			engineDir = paths.EngineDir;

			SetContentView(Resource.Layout.activity_launcher);

			mods = LoadMods();
			PopulateModIcons();

		}

		List<ModInfo> LoadMods()
		{
			var modsRoot = Path.Combine(engineDir, "mods");
			if (!Directory.Exists(modsRoot))
				return new List<ModInfo>();

			var list = new List<ModInfo>();
			foreach (var directory in Directory.GetDirectories(modsRoot))
			{
				var modId = Path.GetFileName(directory);
				if (string.IsNullOrEmpty(modId))
					continue;

				var modInfo = TryLoadMod(directory, modId);
				if (modInfo != null)
					list.Add(modInfo);
			}

			list.Sort(CompareMods);
			return list;
		}

		static int CompareMods(ModInfo a, ModInfo b)
		{
			var aIndex = Array.IndexOf(PreferredModOrder, a.Id);
			var bIndex = Array.IndexOf(PreferredModOrder, b.Id);

			if (aIndex >= 0 || bIndex >= 0)
			{
				if (aIndex < 0)
					return 1;

				if (bIndex < 0)
					return -1;

				if (aIndex != bIndex)
					return aIndex.CompareTo(bIndex);
			}

			return string.Compare(a.Title, b.Title, StringComparison.OrdinalIgnoreCase);
		}

		ModInfo TryLoadMod(string modDir, string modId)
		{
			var modYaml = Path.Combine(modDir, "mod.yaml");
			if (!File.Exists(modYaml))
				return null;

			try
			{
				using var package = new Folder(modDir);
				var manifest = new Manifest(modId, package);
				if (manifest.Metadata.Hidden)
					return null;

				var title = manifest.Metadata.Title;
				if (!TryResolveFluentTitle(modDir, title, out var resolved))
					resolved = title;

				if (string.IsNullOrWhiteSpace(resolved))
					resolved = modId;

				var iconPath = GetModIconPath(modDir);
				return new ModInfo(modId, resolved, manifest.Metadata.Version, iconPath);
			}
			catch (Exception ex)
			{
				global::Android.Util.Log.Warn("OpenRA", $"Skipping mod '{modId}': {ex.Message}");
				return null;
			}
		}

		string GetModIconPath(string modDir)
		{
			var iconFile = Path.Combine(modDir, "icon-3x.png");
			return File.Exists(iconFile) ? iconFile : null;
		}

		bool TryResolveFluentTitle(string modDir, string key, out string title)
		{
			title = null;
			if (string.IsNullOrWhiteSpace(key))
				return false;

			var fluentDir = Path.Combine(modDir, "fluent");
			if (!Directory.Exists(fluentDir))
				return false;

			var assignment = key + " =";
			foreach (var file in Directory.EnumerateFiles(fluentDir, "*.ftl"))
			{
				foreach (var line in File.ReadLines(file))
				{
					var trimmed = line.Trim();
					if (!trimmed.StartsWith(assignment, StringComparison.Ordinal))
						continue;

					title = trimmed.Substring(assignment.Length).Trim();
					if (!string.IsNullOrEmpty(title))
						return true;
				}
			}

			return false;
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
			var intent = new Intent(this, typeof(MainActivity));
			intent.PutExtra(MainActivity.ModIntentKey, mod.Id);
			StartActivity(intent);
			Finish();
		}

		void SetIconDrawable(ImageView icon, string path)
		{
			if (!string.IsNullOrEmpty(path) && File.Exists(path))
			{
				var drawable = Drawable.CreateFromPath(path);
				if (drawable != null)
				{
					icon.SetImageDrawable(drawable);
					return;
				}
			}

			icon.SetImageResource(Resource.Mipmap.ic_launcher);
		}

		sealed class ModInfo
		{
			public ModInfo(string id, string title, string version, string iconPath)
			{
				Id = id;
				Title = title;
				Version = version;
				IconPath = iconPath;
			}

			public string Id { get; }
			public string Title { get; }
			public string Version { get; }
			public string IconPath { get; }
		}
	}
}
