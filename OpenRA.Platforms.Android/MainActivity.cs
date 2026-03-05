using Android.App;
using Android.Content.PM;
using Android.Content.Res;
using Android.OS;

// Application-level icon/label attributes
[assembly: Application(Label = "@string/app_name", Icon = "@mipmap/ic_launcher", RoundIcon = "@mipmap/ic_launcher")]

namespace OpenRA.Platforms.Android
{
	/// <summary>
	/// Main activity that extends SDLActivity so the SDL surface lifecycle is
	/// managed correctly. SDLActivity creates the SurfaceView and starts the
	/// SDLMain thread once the surface is ready. SDLMain.run() (patched in
	/// SDLActivity.java) calls runGameLoop() on this class via reflection,
	/// which in turn calls Game.InitializeAndRun() on the SDL thread.
	/// </summary>
	[Activity(
		Label = "@string/app_name",
		MainLauncher = true,
		Icon = "@mipmap/ic_launcher",
		RoundIcon = "@mipmap/ic_launcher",
		ScreenOrientation = ScreenOrientation.SensorLandscape,
		ConfigurationChanges =
			ConfigChanges.Orientation |
			ConfigChanges.ScreenSize |
			ConfigChanges.KeyboardHidden)]
	public class MainActivity : global::Org.Libsdl.App.SDLActivity
	{
		string internalPath;
		string engineDir;

		// OpenRA does not use the stock SDL native-main entry point.
		// The patched SDLMain.run() calls runGameLoop() via reflection instead,
		// so there is no "libmain.so" to load.
		protected override string[] GetLibraries() => new[] { "SDL2" };

		protected override void OnCreate(Bundle savedInstanceState)
		{
			internalPath = FilesDir!.AbsolutePath;
			engineDir = System.IO.Path.Combine(internalPath, "engine");

			// Extract bundled engine data (mods, glsl, VERSION) from APK assets
			// to internal storage so the engine can access them via filesystem paths.
			ExtractAssets("engine", engineDir);

			// SDLActivity.OnCreate() loads native libs, creates the SDLSurface,
			// and wires up all the SDL JNI callbacks.
			base.OnCreate(savedInstanceState);
		}

		/// <summary>
		/// Called from Java SDLMain.run() via reflection once the SDL surface is
		/// ready and the SDLThread has been started by SDLActivity.
		/// Runs on the SDLThread, not the UI thread.
		/// </summary>
		[Java.Interop.Export("runGameLoop")]
		public void RunGameLoop()
		{
			try
			{
				var args = new[]
				{
					"Game.Mod=ra",
					"Engine.EngineDir=" + engineDir,
					"Engine.SupportDir=" + internalPath
				};

				Game.InitializeAndRun(args);
			}
			catch (System.Exception ex)
			{
				global::Android.Util.Log.Error("OpenRA", "Fatal error in runGameLoop: " + ex.ToString());
			}
		}

		/// <summary>
		/// Recursively copies an asset folder to a filesystem directory.
		/// Overwrites existing files every launch to keep assets in sync with the APK.
		/// </summary>
		void ExtractAssets(string assetPath, string destPath)
		{
			var assets = Assets;
			var children = assets.List(assetPath);

			if (children == null || children.Length == 0)
			{
				// It's a file, not a directory — copy it.
				CopyAssetFile(assets, assetPath, destPath);
				return;
			}

			System.IO.Directory.CreateDirectory(destPath);

			foreach (var child in children)
				ExtractAssets(assetPath + "/" + child, destPath + "/" + child);
		}

		static void CopyAssetFile(AssetManager assets, string assetPath, string destPath)
		{
			var destDir = System.IO.Path.GetDirectoryName(destPath);
			if (destDir != null)
				System.IO.Directory.CreateDirectory(destDir);

			using var input = assets.Open(assetPath);
			using var output = System.IO.File.Create(destPath);
			input.CopyTo(output);
		}
	}
}
