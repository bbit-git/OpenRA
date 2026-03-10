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

using System.Collections.Generic;
using System.IO;
using System.Linq;
using OpenRA.FileSystem;
using OpenRA.Widgets;

namespace OpenRA
{
	public class WidgetLoader
	{
		readonly Dictionary<string, MiniYamlNode> widgets = [];

		public WidgetLoader(Manifest manifest, IReadOnlyFileSystem fileSystem)
		{
			var stringPool = new HashSet<string>(); // Reuse common strings in YAML

			// Load base widgets (duplicates within base ChromeLayout are errors)
			foreach (var file in manifest.ChromeLayout.Select(
				a => MiniYaml.FromStream(fileSystem.Open(a), a, stringPool: stringPool)))
				foreach (var w in file)
				{
					var key = w.Key[(w.Key.IndexOf('@') + 1)..];
					if (widgets.ContainsKey(key))
						throw new InvalidDataException($"Widget has duplicate Key `{w.Key}` at {w.Location}");
					widgets.Add(key, w);
				}

			// Apply overrides from ChromeLayoutOverrides: merge into existing
			// widget definitions or add new ones. This allows mods to patch
			// individual widget properties without replacing entire layout files.
			ApplyOverrides(manifest.ChromeLayoutOverrides, fileSystem, stringPool);

#if ANDROID
			// Android-specific workaround: auto-discover override files from
			// chrome-touch/ directories matching base chrome/ layout files.
			// This keeps upstream mod.yaml and chrome/*.yaml files unmodified.
			var androidOverrides = new List<string>();
			foreach (var basePath in manifest.ChromeLayout)
			{
				var androidPath = basePath.Replace("|chrome/", "|chrome-touch/");
				if (androidPath != basePath && fileSystem.Exists(androidPath))
					androidOverrides.Add(androidPath);
			}

			ApplyOverrides(androidOverrides, fileSystem, stringPool);
#endif
		}

		void ApplyOverrides(IEnumerable<string> overrideFiles, IReadOnlyFileSystem fileSystem, HashSet<string> stringPool)
		{
			foreach (var file in overrideFiles.Select(
				a => MiniYaml.FromStream(fileSystem.Open(a), a, stringPool: stringPool)))
				foreach (var w in file)
				{
					// Support MiniYaml removal syntax: -Widget@KEY removes the
					// base widget so a subsequent node can fully replace it.
					if (w.Key.StartsWith('-'))
					{
						var removeKey = w.Key[1..];
						removeKey = removeKey[(removeKey.IndexOf('@') + 1)..];
						widgets.Remove(removeKey);
						continue;
					}

					var key = w.Key[(w.Key.IndexOf('@') + 1)..];
					if (widgets.TryGetValue(key, out var existing))
						widgets[key] = MiniYaml.MergeOverlay(existing, w);
					else
						widgets.Add(key, w);
				}
		}

		public Widget LoadWidget(WidgetArgs args, Widget parent, string w)
		{
			if (!widgets.TryGetValue(w, out var ret))
				throw new InvalidDataException($"Cannot find widget with Id `{w}`");

			return LoadWidget(args, parent, ret);
		}

		public Widget LoadWidget(WidgetArgs args, Widget parent, MiniYamlNode node)
		{
			var widget = NewWidget(node.Key, args);

			parent?.AddChild(widget);

			if (node.Key.Contains('@'))
				FieldLoader.LoadFieldOrProperty(widget, "Id", node.Key.Split('@')[1]);

			foreach (var child in node.Value.Nodes)
				if (child.Key != "Children")
					FieldLoader.LoadFieldOrProperty(widget, child.Key, child.Value.Value);

			widget.Initialize(args);

			foreach (var child in node.Value.Nodes)
				if (child.Key == "Children")
					foreach (var c in child.Value.Nodes)
						LoadWidget(args, widget, c);

			var logicNode = node.Value.NodeWithKeyOrDefault("Logic");
			var logic = logicNode?.Value.ToDictionary();
			args.Add("logicArgs", logic);

			widget.PostInit(args);

			args.Remove("logicArgs");

			return widget;
		}

		static Widget NewWidget(string widgetType, WidgetArgs args)
		{
			widgetType = widgetType.Split('@')[0];
			return Game.ModData.ObjectCreator.CreateObject<Widget>(widgetType + "Widget", args);
		}
	}
}
