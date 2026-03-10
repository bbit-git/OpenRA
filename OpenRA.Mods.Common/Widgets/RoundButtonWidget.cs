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

using OpenRA.Primitives;
using OpenRA.Widgets;

namespace OpenRA.Mods.Common.Widgets
{
	public class RoundButtonWidget : ButtonWidget
	{
		public Color CircleColor = Color.FromArgb(160, 255, 255, 255);
		public Color BorderColor = Color.FromArgb(200, 180, 180, 180);
		public int BorderWidth = 2;

		[ObjectCreator.UseCtor]
		public RoundButtonWidget(ModData modData)
			: base(modData) { }

		protected RoundButtonWidget(RoundButtonWidget other)
			: base(other)
		{
			CircleColor = other.CircleColor;
			BorderColor = other.BorderColor;
			BorderWidth = other.BorderWidth;
		}

		public override void Draw()
		{
			var rb = RenderBounds;
			var disabled = IsDisabled();

			var borderColor = disabled ? Color.FromArgb(100, 120, 120, 120) : BorderColor;
			WidgetUtils.FillEllipseWithColor(rb, borderColor);

			var inner = new Rectangle(
				rb.X + BorderWidth, rb.Y + BorderWidth,
				rb.Width - BorderWidth * 2, rb.Height - BorderWidth * 2);
			var fillColor = disabled ? Color.FromArgb(80, 200, 200, 200) : CircleColor;
			WidgetUtils.FillEllipseWithColor(inner, fillColor);

			var font = Game.Renderer.Fonts[Font];
			var text = GetText();
			var textSize = font.Measure(text);
			var textPos = new int2(
				rb.X + (rb.Width - textSize.X) / 2,
				rb.Y + (rb.Height - textSize.Y - font.TopOffset) / 2);

			var textColor = disabled ? GetColorDisabled() : GetColor();
			font.DrawTextWithContrast(text, textPos, textColor,
				Color.FromArgb(180, 0, 0, 0), Color.FromArgb(80, 255, 255, 255), 1);
		}

		public override RoundButtonWidget Clone() { return new RoundButtonWidget(this); }
	}
}
