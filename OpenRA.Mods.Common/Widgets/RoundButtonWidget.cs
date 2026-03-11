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
		public bool DrawSelectionOutlineIcon = false;
		public Color SelectionOutlineColor = Color.White;
		public int SelectionOutlinePadding = 16;
		public int SelectionOutlineStrokeWidth = 2;
		public int SelectionOutlineDashLength = 6;
		public int SelectionOutlineGapLength = 4;
		public float SelectionOutlineDisabledOpacity = 0.2f;
		public bool DrawCircularChrome = true;

		[ObjectCreator.UseCtor]
		public RoundButtonWidget(ModData modData)
			: base(modData) { }

		protected RoundButtonWidget(RoundButtonWidget other)
			: base(other)
		{
			CircleColor = other.CircleColor;
			BorderColor = other.BorderColor;
			BorderWidth = other.BorderWidth;
			DrawSelectionOutlineIcon = other.DrawSelectionOutlineIcon;
			SelectionOutlineColor = other.SelectionOutlineColor;
			SelectionOutlinePadding = other.SelectionOutlinePadding;
			SelectionOutlineStrokeWidth = other.SelectionOutlineStrokeWidth;
			SelectionOutlineDashLength = other.SelectionOutlineDashLength;
			SelectionOutlineGapLength = other.SelectionOutlineGapLength;
			SelectionOutlineDisabledOpacity = other.SelectionOutlineDisabledOpacity;
			DrawCircularChrome = other.DrawCircularChrome;
		}

		public override void Draw()
		{
			var rb = RenderBounds;
			var disabled = IsDisabled();

			if (DrawCircularChrome)
			{
				var borderColor = disabled ? Color.FromArgb(100, 120, 120, 120) : BorderColor;
				WidgetUtils.FillEllipseWithColor(rb, borderColor);

				var inner = new Rectangle(
					rb.X + BorderWidth, rb.Y + BorderWidth,
					rb.Width - BorderWidth * 2, rb.Height - BorderWidth * 2);
				var fillColor = disabled ? Color.FromArgb(80, 200, 200, 200) : CircleColor;
				WidgetUtils.FillEllipseWithColor(inner, fillColor);
			}

			if (DrawSelectionOutlineIcon)
			{
				var alpha = disabled ? (byte)(255 * SelectionOutlineDisabledOpacity) : byte.MaxValue;
				var iconColor = Color.FromArgb(alpha, SelectionOutlineColor);
				var outline = new Rectangle(
					rb.X + SelectionOutlinePadding,
					rb.Y + SelectionOutlinePadding,
					rb.Width - SelectionOutlinePadding * 2,
					rb.Height - SelectionOutlinePadding * 2);

				DrawDashedRectangle(outline, iconColor);
				return;
			}

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

		void DrawDashedRectangle(Rectangle rect, Color color)
		{
			if (rect.Width <= 0 || rect.Height <= 0)
				return;

			var left = rect.Left - 0.5f;
			var top = rect.Top - 0.5f;
			var right = rect.Right - 0.5f;
			var bottom = rect.Bottom - 0.5f;

			DrawDashedLine(new float2(left, top), new float2(right, top), color);
			DrawDashedLine(new float2(right, top), new float2(right, bottom), color);
			DrawDashedLine(new float2(right, bottom), new float2(left, bottom), color);
			DrawDashedLine(new float2(left, bottom), new float2(left, top), color);
		}

		void DrawDashedLine(float2 start, float2 end, Color color)
		{
			var horizontal = start.Y == end.Y;
			var step = SelectionOutlineDashLength + SelectionOutlineGapLength;
			var length = horizontal ? (int)(end.X - start.X) : (int)(end.Y - start.Y);
			var direction = length >= 0 ? 1 : -1;
			var remaining = direction * length;

			for (var offset = 0; offset < remaining; offset += step)
			{
				var dash = offset + SelectionOutlineDashLength > remaining ? remaining - offset : SelectionOutlineDashLength;
				if (dash <= 0)
					break;

				var dashStart = horizontal
					? new float2(start.X + direction * offset, start.Y)
					: new float2(start.X, start.Y + direction * offset);
				var dashEnd = horizontal
					? new float2(start.X + direction * (offset + dash), start.Y)
					: new float2(start.X, start.Y + direction * (offset + dash));

				Game.Renderer.RgbaColorRenderer.DrawLine(dashStart, dashEnd, SelectionOutlineStrokeWidth, color);
			}
		}

		public override RoundButtonWidget Clone() { return new RoundButtonWidget(this); }
	}
}
