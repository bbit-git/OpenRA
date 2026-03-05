using Android.App;
using Android.Content.PM;
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
		ConfigurationChanges =
			ConfigChanges.Orientation |
			ConfigChanges.ScreenSize |
			ConfigChanges.KeyboardHidden)]
	public class MainActivity : global::Org.Libsdl.App.SDLActivity
	{
		string internalPath;

		protected override void OnCreate(Bundle savedInstanceState)
		{
			// Capture the files directory before SDL initialises; Game.InitializeAndRun
			// needs it as the Engine.SupportDir override.
			internalPath = FilesDir!.AbsolutePath;

			// SDLActivity.OnCreate() loads native libs, creates the SDLSurface,
			// and wires up all the SDL JNI callbacks. Must be called before any
			// SDL API usage.
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
					"Engine.SupportDir=" + internalPath
				};

				Game.InitializeAndRun(args);
			}
			catch (System.Exception ex)
			{
				global::Android.Util.Log.Error("OpenRA", "Fatal error in runGameLoop: " + ex.ToString());
			}
		}
	}
}
