using Android.App;
using Android.Content;
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
		Icon = "@mipmap/ic_launcher",
		RoundIcon = "@mipmap/ic_launcher",
		Theme = "@style/SplashTheme",
		ScreenOrientation = ScreenOrientation.SensorLandscape,
		ConfigurationChanges =
			ConfigChanges.Orientation |
			ConfigChanges.ScreenSize |
			ConfigChanges.KeyboardHidden,
		Exported = false)]
	public class MainActivity : global::Org.Libsdl.App.SDLActivity
	{
		public const string ModIntentKey = "com.bigbangit.openra.android.extra.MOD_ID";
		string internalPath;
		string engineDir;
		string selectedMod = "ra";

		// OpenRA does not use the stock SDL native-main entry point.
		// The patched SDLMain.run() calls runGameLoop() via reflection instead,
		// so there is no "libmain.so" to load.
		protected override string[] GetLibraries() => new[] { "SDL2" };

		protected override void OnCreate(Bundle savedInstanceState)
		{
			// Switch from the splash theme to the real fullscreen theme
			// once the activity is ready to render.
			SetTheme(global::Android.Resource.Style.ThemeNoTitleBarFullScreen);

			var paths = EngineAssets.Prepare(this);
			internalPath = paths.InternalPath;
			engineDir = paths.EngineDir;
			selectedMod = Intent?.GetStringExtra(ModIntentKey) ?? "ra";

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
			var runStatus = RunStatus.Error;

			try
			{
				var modToLaunch = string.IsNullOrWhiteSpace(selectedMod) ? "ra" : selectedMod;
				var args = new[]
				{
					"Game.Mod=" + modToLaunch,
					"Engine.EngineDir=" + engineDir,
					"Engine.SupportDir=" + internalPath
				};

				Game.CanExitToLauncher = true;
				runStatus = Game.InitializeAndRun(args);
			}
			catch (System.Exception ex)
			{
				global::Android.Util.Log.Error("OpenRA", "Fatal error in runGameLoop: " + ex.ToString());
			}
			finally
			{
				Game.CanExitToLauncher = false;

				if (runStatus == RunStatus.ExitToLauncher)
				{
					global::Android.Util.Log.Info("OpenRA", "ExitToLauncher: returning to launcher activity");
					RunOnUiThread(() =>
					{
						var launcherIntent = new Intent(this, typeof(LauncherActivity));
						launcherIntent.AddFlags(ActivityFlags.ClearTop | ActivityFlags.NewTask | ActivityFlags.SingleTop);
						StartActivity(launcherIntent);
						Finish();
					});
				}
				else
				{
					// Game loop has ended — finish the activity so the process exits cleanly.
					global::Android.Util.Log.Info("OpenRA", $"Game loop ended with status {runStatus}, terminating process");
					RunOnUiThread(() => FinishAndRemoveTask());

					// FinishAndRemoveTask only finishes the Activity; the process stays alive.
					// Force-exit so stale state doesn't linger.
					Java.Lang.Thread.Sleep(500);
					Java.Lang.JavaSystem.Exit(0);
				}
			}
		}
	}
}
