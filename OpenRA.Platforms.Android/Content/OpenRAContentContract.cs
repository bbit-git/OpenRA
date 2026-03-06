namespace OpenRA.Platforms.Android.Content
{
	/// <summary>
	/// URI contract constants for the OpenRA content provider.
	/// URI format: content://net.openra.android.content/file/{relative-path}
	/// </summary>
	public static class OpenRAContentContract
	{
		public const string Authority = "net.openra.android.content";
		public const string FilePrefix = "file";
		public const string Permission = "net.openra.android.permission.WRITE_CONTENT";
	}
}
