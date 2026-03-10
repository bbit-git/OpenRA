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
using System.Collections.Generic;
using NUnit.Framework;
using OpenRA.Graphics;
using OpenRA.Primitives;

namespace OpenRA.Test
{
	[TestFixture]
	sealed class FontsTest
	{
		sealed class FakePlatform : IPlatform
		{
			public IPlatformWindow CreateWindow(Size size, WindowMode windowMode, float scaleModifier, int vertexBatchSize, int indexBatchSize, int videoDisplay, GLProfile profile)
			{
				throw new NotSupportedException();
			}

			public ISoundEngine CreateSound(string device)
			{
				throw new NotSupportedException();
			}

			public IFont CreateFont(byte[] data)
			{
				return data[0] switch
				{
					0 => new FakeFont(new Dictionary<char, FontGlyph>
					{
						['A'] = Glyph(6),
					}),
					1 => new FakeFont(new Dictionary<char, FontGlyph>
					{
						['A'] = Glyph(4),
						['B'] = Glyph(8),
					}),
					_ => throw new ArgumentOutOfRangeException(nameof(data)),
				};
			}
		}

		sealed class FakeFont(Dictionary<char, FontGlyph> glyphs) : IFont
		{
			public FontGlyph CreateGlyph(char c, int size, float deviceScale)
			{
				return glyphs.TryGetValue(c, out var glyph) ? glyph : new FontGlyph { Data = null };
			}

			public void Dispose() { }
		}

		static FontGlyph Glyph(float advance)
		{
			return new FontGlyph
			{
				Advance = advance,
				Offset = int2.Zero,
				Size = new Size(1, 1),
				Data = [0xFF]
			};
		}

		[Test]
		public void Load_FontData_AllowsFallbackFont()
		{
			var yaml = new MiniYaml(
				null,
				[
					new MiniYamlNode(
						"Regular",
						new MiniYaml(
							null,
							[
								new MiniYamlNode(nameof(FontData.Font), "common|FreeSans.ttf"),
								new MiniYamlNode(nameof(FontData.FallbackFont), "common|DroidSansFallbackFull.ttf"),
								new MiniYamlNode(nameof(FontData.Size), "14"),
								new MiniYamlNode(nameof(FontData.Ascender), "11"),
							]))
				]);

			var fonts = FieldLoader.Load<Fonts>(yaml);

			Assert.That(fonts.FontList["Regular"].Font, Is.EqualTo("common|FreeSans.ttf"));
			Assert.That(fonts.FontList["Regular"].FallbackFont, Is.EqualTo("common|DroidSansFallbackFull.ttf"));
		}

		[Test]
		public void SpriteFont_UsesFallbackFontForMissingGlyphs()
		{
			using var builder = new SheetBuilder(SheetType.BGRA, 64);
			using var font = new SpriteFont(new FakePlatform(), "Test", [[0], [1]], 12, 9, 1f, builder);

			Assert.That(font.Measure("AB").X, Is.EqualTo(14));
		}
	}
}
