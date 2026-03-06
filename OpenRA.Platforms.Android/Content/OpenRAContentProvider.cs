using System.IO;
using Android.Content;
using Android.Database;
using Android.Database.Sqlite;
using Android.OS;
using Android.Webkit;
using Uri = Android.Net.Uri;

namespace OpenRA.Platforms.Android.Content
{
	/// <summary>
	/// Android ContentProvider that exposes the OpenRA Content directory
	/// via content:// URIs. Allows authorized apps (signed with the same
	/// key) to read and write game content files.
	///
	/// URI format: content://net.openra.android.content/file/{relative-path}
	///
	/// Android-specific integration layer for external content management.
	/// </summary>
	[ContentProvider(
		new[] { OpenRAContentContract.Authority },
		Exported = true,
		GrantUriPermissions = true,
		ReadPermission = OpenRAContentContract.Permission,
		WritePermission = OpenRAContentContract.Permission)]
	public class OpenRAContentProvider : ContentProvider
	{
		string rootPath = "";
		string rootCanonical = "";

		public override bool OnCreate()
		{
			rootPath = System.IO.Path.Combine(Context.FilesDir.AbsolutePath, "Content");
			Directory.CreateDirectory(rootPath);
			rootCanonical = System.IO.Path.GetFullPath(rootPath);

			global::Android.Util.Log.Info("OpenRA", "ContentProvider: initialized, root=" + rootCanonical);
			return true;
		}

		public override ParcelFileDescriptor OpenFile(Uri uri, string mode)
		{
			var target = ResolvePath(uri, forWrite: mode != "r");

			if (mode == "r")
			{
				if (!File.Exists(target))
					throw new FileNotFoundException("File not found: " + uri);

				return ParcelFileDescriptor.Open(
					new Java.IO.File(target),
					ParcelFileMode.ReadOnly);
			}

			if (mode == "w" || mode == "wt")
			{
				PathSecurity.EnsureParentExists(target);

				return ParcelFileDescriptor.Open(
					new Java.IO.File(target),
					ParcelFileMode.WriteOnly | ParcelFileMode.Truncate | ParcelFileMode.Create);
			}

			if (mode == "wa")
			{
				PathSecurity.EnsureParentExists(target);

				return ParcelFileDescriptor.Open(
					new Java.IO.File(target),
					ParcelFileMode.WriteOnly | ParcelFileMode.Append | ParcelFileMode.Create);
			}

			if (mode == "rw")
			{
				PathSecurity.EnsureParentExists(target);

				return ParcelFileDescriptor.Open(
					new Java.IO.File(target),
					ParcelFileMode.ReadWrite | ParcelFileMode.Create);
			}

			throw new System.NotSupportedException("Unsupported file mode: " + mode);
		}

		public override string GetType(Uri uri)
		{
			var path = ResolvePath(uri, forWrite: false);
			var ext = System.IO.Path.GetExtension(path)?.TrimStart('.').ToLowerInvariant();

			if (string.IsNullOrEmpty(ext))
				return "application/octet-stream";

			var mime = MimeTypeMap.Singleton.GetMimeTypeFromExtension(ext);
			return mime ?? "application/octet-stream";
		}

		public override int Delete(Uri uri, string selection, string[] selectionArgs)
		{
			var path = ResolvePath(uri, forWrite: false);

			// Reject directories explicitly — Delete is for files only.
			if (Directory.Exists(path))
				throw new System.NotSupportedException("Cannot delete directories.");

			if (!File.Exists(path))
				return 0;

			File.Delete(path);
			return 1;
		}

		public override Uri Insert(Uri uri, ContentValues values)
		{
			throw new System.NotSupportedException("Insert is not supported. Use OpenFile with write mode.");
		}

		public override int Update(Uri uri, ContentValues values, string selection, string[] selectionArgs)
		{
			throw new System.NotSupportedException("Update is not supported. Use OpenFile with write mode.");
		}

		public override ICursor Query(Uri uri, string[] projection, string selection, string[] selectionArgs, string sortOrder)
		{
			return new MatrixCursor(projection ?? System.Array.Empty<string>());
		}

		string ResolvePath(Uri uri, bool forWrite)
		{
			var segments = uri.PathSegments;
			if (segments == null || segments.Count < 2 || segments[0] != OpenRAContentContract.FilePrefix)
				throw new Java.Lang.IllegalArgumentException("Invalid URI format. Expected: content://.../file/{path}");

			var relativePath = string.Join("/", segments.Skip(1));
			relativePath = Uri.Decode(relativePath) ?? "";

			return PathSecurity.ResolveAndValidate(rootCanonical, rootPath, relativePath, forWrite);
		}
	}
}
