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

using System;
using System.Collections.Immutable;
using System.Text;
using OpenRA.FileSystem;

namespace OpenRA
{
	public static class FluentProvider
	{
		// Ensure thread-safety.
		static readonly object SyncObject = new();
		static FluentBundle modFluentBundle;
		static FluentBundle localizedFluentBundle;
		static FluentBundle localizedMapFluentBundle;
		static FluentBundle mapFluentBundle;

		public static void Initialize(Manifest manifest, IReadOnlyFileSystem fileSystem, string culture = null)
		{
			lock (SyncObject)
			{
				// Always build the English base bundle.
				modFluentBundle = new FluentBundle(manifest.FluentCulture, manifest.FluentMessages, fileSystem);

				// Build localized override bundle if a non-English culture is selected.
				localizedFluentBundle = null;
				if (!string.IsNullOrEmpty(culture) && culture != "en"
					&& manifest.FluentTranslations.TryGetValue(culture, out var translationPaths)
					&& translationPaths.Length > 0)
				{
					localizedFluentBundle = new FluentBundle(culture, translationPaths, fileSystem);
					Log.Write("debug", $"Localization: loaded {translationPaths.Length} files for culture '{culture}'");
				}

				localizedMapFluentBundle = null;
				if (fileSystem is Map map && map.FluentMessageDefinitions != null)
				{
					var files = ImmutableArray<string>.Empty;
					if (map.FluentMessageDefinitions.Value != null)
						files = FieldLoader.GetValue<ImmutableArray<string>>("value", map.FluentMessageDefinitions.Value);

					string text = null;
					if (map.FluentMessageDefinitions.Nodes.Length > 0)
					{
						var builder = new StringBuilder();
						foreach (var node in map.FluentMessageDefinitions.Nodes)
							if (node.Key == "base64")
								builder.Append(Encoding.UTF8.GetString(Convert.FromBase64String(node.Value.Value)));

						text = builder.ToString();
					}

					mapFluentBundle = new FluentBundle(manifest.FluentCulture, files, fileSystem, text);

					if (!string.IsNullOrEmpty(culture) && culture != "en")
					{
						var localizedMapFiles = ImmutableArray.CreateBuilder<string>();
						foreach (var file in files)
						{
							// Transform "pkg|fluent/name.ftl" -> "pkg|fluent/<culture>/name.ftl".
							// Skip paths without a package prefix (e.g. embedded "map.ftl").
							var separatorIdx = file.IndexOf("|fluent/", StringComparison.Ordinal);
							if (separatorIdx < 0)
								continue;

							var localizedPath = file[..(separatorIdx + "|fluent/".Length)] + culture + "/" + file[(separatorIdx + "|fluent/".Length)..];
							if (fileSystem.Exists(localizedPath))
								localizedMapFiles.Add(localizedPath);
						}

						if (localizedMapFiles.Count > 0)
							localizedMapFluentBundle = new FluentBundle(culture, localizedMapFiles.ToImmutable(), fileSystem);
					}
				}
			}
		}

		public static string GetMessage(string key, params object[] args)
		{
			lock (SyncObject)
			{
				// Try localized bundle first for translated messages.
				if (localizedFluentBundle != null && localizedFluentBundle.TryGetMessage(key, out var localizedMessage, args))
					return localizedMessage;

				// By prioritizing mod-level fluent bundles we prevent maps from overwriting string keys. We do not want to
				// allow maps to change the UI nor any other strings not exposed to the map.
				if (modFluentBundle.TryGetMessage(key, out var message, args))
					return message;

				if (localizedMapFluentBundle != null && localizedMapFluentBundle.TryGetMessage(key, out var localizedMapMessage, args))
					return localizedMapMessage;

				if (mapFluentBundle != null)
					return mapFluentBundle.GetMessage(key, args);

				return key;
			}
		}

		public static bool TryGetMessage(string key, out string message, params object[] args)
		{
			lock (SyncObject)
			{
				// Try localized bundle first.
				if (localizedFluentBundle != null && localizedFluentBundle.TryGetMessage(key, out message, args))
					return true;

				// By prioritizing mod-level bundle we prevent maps from overwriting string keys. We do not want to
				// allow maps to change the UI nor any other strings not exposed to the map.
				if (modFluentBundle.TryGetMessage(key, out message, args))
					return true;

				if (localizedMapFluentBundle != null && localizedMapFluentBundle.TryGetMessage(key, out message, args))
					return true;

				if (mapFluentBundle != null && mapFluentBundle.TryGetMessage(key, out message, args))
					return true;

				return false;
			}
		}

		/// <summary>Should only be used by <see cref="MapPreview"/>.</summary>
		internal static bool TryGetModMessage(string key, out string message, params object[] args)
		{
			lock (SyncObject)
			{
				if (localizedFluentBundle != null && localizedFluentBundle.TryGetMessage(key, out message, args))
					return true;

				return modFluentBundle.TryGetMessage(key, out message, args);
			}
		}
	}
}
