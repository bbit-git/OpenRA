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
using Android.Content;
using Android.OS;
using OpenRA.Support;

namespace OpenRA.Platforms.Android
{
	/// <summary>
	/// Reads battery current and voltage from Android BatteryManager.
	/// Values are battery-side estimates, not per-app power measurements.
	/// Accuracy is device/vendor dependent; some devices return zero or unsupported values.
	/// </summary>
	public sealed class AndroidBatteryMetrics : IBatteryMetricsProvider
	{
		readonly BatteryManager batteryManager;
		readonly Context context;

		double currentNowMA;
		double currentAvgMA = double.NaN;
		double voltageV;
		bool isCharging;
		bool isSupported;
		bool capabilityChecked;

		public bool IsSupported => isSupported;
		public bool IsCharging => isCharging;
		public double CurrentNowMA => currentNowMA;
		public double CurrentAvgMA => currentAvgMA;
		public double VoltageV => voltageV;

		public AndroidBatteryMetrics(Context context)
		{
			this.context = context;
			batteryManager = (BatteryManager)context.GetSystemService(Context.BatteryService);
			isSupported = batteryManager != null;
		}

		public void Update()
		{
			if (batteryManager == null)
				return;

			try
			{
				// BATTERY_PROPERTY_CURRENT_NOW returns microamps.
				// Sign convention varies by vendor, so we use absolute value.
				var currentNowUA = batteryManager.GetIntProperty((int)BatteryProperty.CurrentNow);

				if (!capabilityChecked)
				{
					capabilityChecked = true;

					// Int32.MinValue is the documented sentinel for unsupported properties.
					// 0 can be a valid reading (e.g. fully charged on AC), so don't reject it.
					if (currentNowUA == int.MinValue)
					{
						isSupported = false;
						global::Android.Util.Log.Info("OpenRA",
							"BatteryMetrics: unsupported (currentNow=MinValue)");
						return;
					}

					global::Android.Util.Log.Info("OpenRA",
						$"BatteryMetrics: supported, initial currentNow={currentNowUA} µA");
				}

				// Convert µA to mA, always positive.
				currentNowMA = Math.Abs(currentNowUA / 1000.0);

				// Average current (may be unsupported on some devices).
				var currentAvgUA = batteryManager.GetIntProperty((int)BatteryProperty.CurrentAverage);
				currentAvgMA = (currentAvgUA != int.MinValue)
					? Math.Abs(currentAvgUA / 1000.0)
					: double.NaN;

				// Read voltage from the battery status sticky broadcast (millivolts).
				// RegisterReceiver with a null receiver returns the sticky Intent
				// without registering a listener — this is thread-safe on Android.
				var batteryStatus = context.RegisterReceiver(null,
					new IntentFilter(Intent.ActionBatteryChanged));
				if (batteryStatus != null)
				{
					var voltMV = batteryStatus.GetIntExtra(BatteryManager.ExtraVoltage, 0);
					voltageV = voltMV / 1000.0;

					var status = (BatteryStatus)batteryStatus.GetIntExtra(
						BatteryManager.ExtraStatus, (int)BatteryStatus.Unknown);
					isCharging = status == BatteryStatus.Charging || status == BatteryStatus.Full;
				}
			}
			catch (Exception ex)
			{
				global::Android.Util.Log.Warn("OpenRA",
					$"BatteryMetrics: read failed: {ex.Message}");
				isSupported = false;
			}
		}
	}
}
