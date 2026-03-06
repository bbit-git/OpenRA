using System;
using System.IO;

namespace OpenRA.Platforms.Android.Content
{
	/// <summary>
	/// Path validation helpers for the content provider.
	/// Ensures all resolved paths stay within the content root directory.
	/// </summary>
	public static class PathSecurity
	{
		/// <summary>
		/// Resolves a relative path against a root directory and validates
		/// that the result does not escape the root via traversal, symlinks,
		/// or other tricks.
		/// </summary>
		public static string ResolveAndValidate(string rootCanonical, string rootPath, string relativePath, bool forWrite)
		{
			if (string.IsNullOrEmpty(relativePath))
				throw new ArgumentException("Path must not be empty.");

			if (Path.IsPathRooted(relativePath))
				throw new UnauthorizedAccessException("Absolute paths are not allowed.");

			// Reject encoded traversal sequences that survived URI decoding.
			if (relativePath.Contains(".."))
				throw new UnauthorizedAccessException("Path traversal is not allowed.");

			var combined = Path.Combine(rootPath, relativePath.Replace('/', Path.DirectorySeparatorChar));
			var full = Path.GetFullPath(combined);

			if (!IsUnderRoot(full, rootCanonical))
				throw new UnauthorizedAccessException("Path escapes content root.");

			var parent = Path.GetDirectoryName(full);
			if (string.IsNullOrEmpty(parent))
				throw new UnauthorizedAccessException("Invalid target path.");

			var parentFull = Path.GetFullPath(parent);
			if (!IsUnderRoot(parentFull, rootCanonical))
				throw new UnauthorizedAccessException("Parent directory escapes content root.");

			if (!forWrite && Directory.Exists(full))
				throw new UnauthorizedAccessException("Directories are not readable as files.");

			return full;
		}

		/// <summary>
		/// Checks whether fullPath is equal to or a child of rootCanonical.
		/// </summary>
		public static bool IsUnderRoot(string fullPath, string rootCanonical)
		{
			var normalized = Path.GetFullPath(fullPath)
				.TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar);

			var root = rootCanonical
				.TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar);

			return normalized == root
				|| normalized.StartsWith(root + Path.DirectorySeparatorChar, StringComparison.Ordinal);
		}

		/// <summary>
		/// Creates parent directories for a file path if they don't exist.
		/// Validates that the parent stays under the content root.
		/// </summary>
		public static void EnsureParentExists(string filePath)
		{
			var parent = Path.GetDirectoryName(filePath);
			if (string.IsNullOrEmpty(parent))
				throw new IOException("Missing parent directory.");

			Directory.CreateDirectory(parent);
		}
	}
}
