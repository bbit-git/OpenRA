using System.IO;
using Android.Content;
using Android.Content.Res;
using Android.Content.PM;

namespace OpenRA.Platforms.Android
{
    static class EngineAssets
    {
        static readonly object Sync = new();
        static string preparedStamp;

        public static (string InternalPath, string EngineDir) Prepare(Context context)
        {
            var internalPath = context.FilesDir!.AbsolutePath;
            var engineDir = Path.Combine(internalPath, "engine");
            var versionFile = Path.Combine(engineDir, "VERSION");
            var stampFile = Path.Combine(engineDir, ".assetstamp");
            var currentStamp = GetCurrentAssetStamp(context);

            lock (Sync)
            {
                // Android-specific workaround:
                // returning from the game to the launcher keeps the process alive,
                // and some extracted asset files can still be open. Reusing the
                // already-prepared engine directory avoids recopying locked files.
                if (preparedStamp == currentStamp && File.Exists(versionFile))
                    return (internalPath, engineDir);

                if (File.Exists(versionFile) &&
                    File.Exists(stampFile) &&
                    File.ReadAllText(stampFile) == currentStamp)
                {
                    preparedStamp = currentStamp;
                    return (internalPath, engineDir);
                }

                ExtractAssets(context.Assets, "engine", engineDir);
                File.WriteAllText(stampFile, currentStamp);
                preparedStamp = currentStamp;
            }

            return (internalPath, engineDir);
        }

        static string GetCurrentAssetStamp(Context context)
        {
            var packageInfo = context.PackageManager?.GetPackageInfo(
                context.PackageName!,
                (PackageInfoFlags)0);

            return packageInfo == null
                ? "unknown"
                : $"{packageInfo.LongVersionCode}:{packageInfo.LastUpdateTime}";
        }

        static void ExtractAssets(AssetManager assets, string assetPath, string destPath)
        {
            var children = assets.List(assetPath);
            if (children == null || children.Length == 0)
            {
                CopyAssetFile(assets, assetPath, destPath);
                return;
            }

            Directory.CreateDirectory(destPath);

            foreach (var child in children)
                ExtractAssets(assets, assetPath + "/" + child, destPath + "/" + child);
        }

        static void CopyAssetFile(AssetManager assets, string assetPath, string destPath)
        {
            var destDir = Path.GetDirectoryName(destPath);
            if (destDir != null)
                Directory.CreateDirectory(destDir);

            using var input = assets.Open(assetPath);
            using var output = File.Create(destPath);
            input.CopyTo(output);
        }
    }
}
