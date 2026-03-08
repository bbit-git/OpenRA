namespace OpenRA.Platforms.Android.Content
{
	/// <summary>
	/// URI contract constants for the OpenRA content provider.
	/// URI format: content://com.bigbangit.openra.android.content/file/{relative-path}
	/// </summary>
	public static class OpenRAContentContract
	{
		public const string Authority = "com.bigbangit.openra.android.content";
		public const string FilePrefix = "file";
		public const string Permission = "com.bigbangit.openra.android.permission.WRITE_CONTENT";
	}
}
