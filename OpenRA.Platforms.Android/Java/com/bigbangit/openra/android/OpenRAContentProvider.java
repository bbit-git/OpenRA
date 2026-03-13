package com.bigbangit.openra.android;

import android.content.ContentProvider;
import android.content.ContentValues;
import android.database.Cursor;
import android.database.MatrixCursor;
import android.net.Uri;
import android.os.ParcelFileDescriptor;
import android.util.Log;
import android.webkit.MimeTypeMap;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;

public final class OpenRAContentProvider extends ContentProvider {
    private static final String TAG = "OpenRAContentProvider";
    private static final String AUTHORITY = "com.bigbangit.openra.android.content";
    private static final String FILE_PREFIX = "file";

    private File rootPath;
    private String rootCanonical;

    @Override
    public boolean onCreate() {
        if (getContext() == null || getContext().getFilesDir() == null) {
            Log.e(TAG, "Assets: provider init failed because files dir is unavailable");
            return false;
        }

        rootPath = new File(getContext().getFilesDir(), "Content");
        if (!rootPath.exists() && !rootPath.mkdirs()) {
            Log.e(TAG, "Assets: failed to create content root " + rootPath.getAbsolutePath());
            return false;
        }

        try {
            rootCanonical = rootPath.getCanonicalPath();
        } catch (IOException e) {
            Log.e(TAG, "Assets: failed to resolve content root", e);
            return false;
        }

        Log.i(TAG, "Assets: content provider initialized root=" + rootCanonical);
        return true;
    }

    @Override
    public ParcelFileDescriptor openFile(Uri uri, String mode) throws FileNotFoundException {
        final boolean forWrite = !"r".equals(mode);
        final File target = resolvePath(uri, forWrite);

        switch (mode) {
            case "r":
                if (!target.isFile()) {
                    throw new FileNotFoundException("File not found: " + uri);
                }

                return ParcelFileDescriptor.open(target, ParcelFileDescriptor.MODE_READ_ONLY);

            case "w":
            case "wt":
                ensureParentExists(target);
                return ParcelFileDescriptor.open(
                    target,
                    ParcelFileDescriptor.MODE_WRITE_ONLY
                        | ParcelFileDescriptor.MODE_TRUNCATE
                        | ParcelFileDescriptor.MODE_CREATE);

            case "wa":
                ensureParentExists(target);
                return ParcelFileDescriptor.open(
                    target,
                    ParcelFileDescriptor.MODE_WRITE_ONLY
                        | ParcelFileDescriptor.MODE_APPEND
                        | ParcelFileDescriptor.MODE_CREATE);

            case "rw":
                ensureParentExists(target);
                return ParcelFileDescriptor.open(
                    target,
                    ParcelFileDescriptor.MODE_READ_WRITE
                        | ParcelFileDescriptor.MODE_CREATE);

            default:
                throw new IllegalArgumentException("Unsupported file mode: " + mode);
        }
    }

    @Override
    public String getType(Uri uri) {
        final File path = resolvePath(uri, false);
        final String name = path.getName();
        final int dot = name.lastIndexOf('.');
        if (dot < 0 || dot == name.length() - 1) {
            return "application/octet-stream";
        }

        final String ext = name.substring(dot + 1).toLowerCase();
        final String mime = MimeTypeMap.getSingleton().getMimeTypeFromExtension(ext);
        return mime != null ? mime : "application/octet-stream";
    }

    @Override
    public int delete(Uri uri, String selection, String[] selectionArgs) {
        final File path = resolvePath(uri, false);
        if (path.isDirectory()) {
            throw new UnsupportedOperationException("Cannot delete directories");
        }

        return path.exists() && path.delete() ? 1 : 0;
    }

    @Override
    public Uri insert(Uri uri, ContentValues values) {
        throw new UnsupportedOperationException("Insert is not supported. Use openFile.");
    }

    @Override
    public int update(Uri uri, ContentValues values, String selection, String[] selectionArgs) {
        throw new UnsupportedOperationException("Update is not supported. Use openFile.");
    }

    @Override
    public Cursor query(Uri uri, String[] projection, String selection, String[] selectionArgs, String sortOrder) {
        return new MatrixCursor(projection != null ? projection : new String[0]);
    }

    private File resolvePath(Uri uri, boolean forWrite) {
        if (!AUTHORITY.equals(uri.getAuthority())) {
            throw new IllegalArgumentException("Invalid authority: " + uri);
        }

        final java.util.List<String> segments = uri.getPathSegments();
        if (segments == null || segments.size() < 2 || !FILE_PREFIX.equals(segments.get(0))) {
            throw new IllegalArgumentException("Invalid URI format. Expected content://" + AUTHORITY + "/file/{path}");
        }

        final String encodedPath = uri.getEncodedPath();
        if (encodedPath == null) {
            throw new IllegalArgumentException("URI path is missing");
        }

        final String prefix = "/" + FILE_PREFIX + "/";
        if (!encodedPath.startsWith(prefix) || encodedPath.length() <= prefix.length()) {
            throw new IllegalArgumentException("URI file path is missing");
        }

        final String relativePath = Uri.decode(encodedPath.substring(prefix.length()));
        if (relativePath.isEmpty()) {
            throw new IllegalArgumentException("Path must not be empty");
        }

        if (relativePath.contains("..")) {
            throw new SecurityException("Path traversal is not allowed");
        }

        final File candidate = new File(rootPath, relativePath.replace('/', File.separatorChar));
        final File canonicalFile;
        try {
            canonicalFile = candidate.getCanonicalFile();
        } catch (IOException e) {
            throw new IllegalArgumentException("Failed to resolve target path", e);
        }

        final String fullPath = canonicalFile.getPath();
        if (!isUnderRoot(fullPath)) {
            throw new SecurityException("Path escapes content root");
        }

        final File parent = canonicalFile.getParentFile();
        if (parent == null || !isUnderRoot(parent.getPath())) {
            throw new SecurityException("Parent path escapes content root");
        }

        if (canonicalFile.isDirectory()) {
            throw new SecurityException("Directories are not readable or writable as files");
        }

        if (!forWrite && !canonicalFile.exists()) {
            return canonicalFile;
        }

        return canonicalFile;
    }

    private boolean isUnderRoot(String fullPath) {
        final String normalized = trimTrailingSeparators(fullPath);
        final String root = trimTrailingSeparators(rootCanonical);
        return normalized.equals(root) || normalized.startsWith(root + File.separator);
    }

    private static String trimTrailingSeparators(String path) {
        int end = path.length();
        while (end > 1) {
            final char c = path.charAt(end - 1);
            if (c != File.separatorChar && c != '/') {
                break;
            }

            end--;
        }

        return path.substring(0, end);
    }

    private static void ensureParentExists(File target) throws FileNotFoundException {
        final File parent = target.getParentFile();
        if (parent == null) {
            throw new FileNotFoundException("Missing parent directory for " + target.getPath());
        }

        if (!parent.exists() && !parent.mkdirs()) {
            throw new FileNotFoundException("Failed to create parent directory " + parent.getPath());
        }

        if (!parent.isDirectory()) {
            throw new FileNotFoundException("Parent is not a directory " + parent.getPath());
        }
    }
}
