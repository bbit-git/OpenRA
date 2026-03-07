using System.IO;
using Android.Content;
using Android.Content.Res;

namespace OpenRA.Platforms.Android
{
    static class EngineAssets
    {
        public static (string InternalPath, string EngineDir) Prepare(Context context)
        {
            var internalPath = context.FilesDir!.AbsolutePath;
            var engineDir = Path.Combine(internalPath, "engine");

            EnsureExtracted(context.Assets, "engine", engineDir);

            return (internalPath, engineDir);
        }

        static void EnsureExtracted(AssetManager assets, string assetPath, string destPath)
        {
            if (DestinationLooksExtracted(destPath))
                return;

            ExtractAssets(assets, assetPath, destPath);
        }

        static bool DestinationLooksExtracted(string destPath)
        {
            return Directory.Exists(destPath) && File.Exists(Path.Combine(destPath, "VERSION"));
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
