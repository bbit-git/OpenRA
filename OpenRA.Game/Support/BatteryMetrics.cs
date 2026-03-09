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
using System.Diagnostics;

namespace OpenRA.Support
{
	/// <summary>
	/// Provides battery current and estimated power readings.
	/// Values are battery-side estimates, not per-app power measurements.
	/// Accuracy is device/vendor dependent.
	/// </summary>
	public interface IBatteryMetricsProvider
	{
		/// <summary>Whether the device supports battery current readings.</summary>
		bool IsSupported { get; }

		/// <summary>Whether the device is currently charging.</summary>
		bool IsCharging { get; }

		/// <summary>Instantaneous battery current in mA (always positive).</summary>
		double CurrentNowMA { get; }

		/// <summary>Average battery current in mA, if available. NaN if unsupported.</summary>
		double CurrentAvgMA { get; }

		/// <summary>Battery voltage in volts.</summary>
		double VoltageV { get; }

		/// <summary>Read fresh values from the hardware. Called at a throttled rate.</summary>
		void Update();
	}

	/// <summary>
	/// Manages battery power metrics collection and feeds them into PerfHistory.
	/// Readings are throttled to avoid excessive system service calls.
	/// </summary>
	public static class BatteryMetrics
	{
		const string CurrentNowKey = "battery_mA";
		const string PowerKey = "battery_mW";
		const long UpdateIntervalMs = 500;

		static IBatteryMetricsProvider provider;
		static readonly Stopwatch throttleTimer = new();
		static bool initialized;
		static bool logged;

		/// <summary>Whether battery metrics are available and supported.</summary>
		public static bool IsAvailable => provider != null && provider.IsSupported;

		/// <summary>Whether the device is currently charging.</summary>
		public static bool IsCharging => provider?.IsCharging ?? false;

		/// <summary>
		/// Register a platform-specific battery metrics provider.
		/// Call once during startup; only the first registration is accepted.
		/// </summary>
		public static void SetProvider(IBatteryMetricsProvider p)
		{
			if (initialized)
				return;

			provider = p;
			initialized = true;

			// Do an initial read to determine support.
			p.Update();

			throttleTimer.Start();
		}

		/// <summary>
		/// Collect a battery sample and push it into PerfHistory.
		/// Call once per game tick, before PerfHistory.Tick().
		/// </summary>
		public static void CollectSample()
		{
			if (provider == null || !provider.IsSupported)
				return;

			// Throttle hardware reads.
			if (throttleTimer.ElapsedMilliseconds >= UpdateIntervalMs)
			{
				provider.Update();
				throttleTimer.Restart();
			}

			if (!logged)
			{
				logged = true;
				Log.Write("perf", $"BatteryMetrics: supported={provider.IsSupported}, " +
					$"current={provider.CurrentNowMA:F1} mA, voltage={provider.VoltageV:F3} V, " +
					$"charging={provider.IsCharging}");
			}

			var currentMA = provider.CurrentNowMA;
			var voltageV = provider.VoltageV;
			var powerMW = currentMA * voltageV;

			// Set values directly. PerfHistory.Tick() will move Val into the sample buffer.
			PerfHistory.Items[CurrentNowKey].Val = currentMA;
			PerfHistory.Items[PowerKey].Val = powerMW;
		}

		/// <summary>Reset state for a fresh session (e.g. process reuse on Android).</summary>
		public static void Reset()
		{
			provider = null;
			initialized = false;
			logged = false;
			throttleTimer.Reset();
		}
	}
}
