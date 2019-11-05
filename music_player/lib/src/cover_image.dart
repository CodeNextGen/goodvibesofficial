import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

String _currentCoverUrl;

/// The temporary filename of the current cover.
/// This future resolves when the file has been downloaded and transferred to
/// the tmp directory.
Future<String> _currentCoverFilename;

Directory _tmpDirectory;

Future<Directory> _getTmpDirectory() async =>
    _tmpDirectory ??= await getTemporaryDirectory();

/// Saves a temporary image of the cover so our plugin can use it.
/// If the cover isn't saved this function might return `null`.
Future<String> transferImage(String coverUrl) async {
  if (coverUrl == _currentCoverUrl) return await _currentCoverFilename;
  final coverFilenameCompleter = Completer<String>();
  final previousCoverUrl = _currentCoverUrl;
  _currentCoverUrl = coverUrl;
  _currentCoverFilename = coverFilenameCompleter.future;

  final tmpDirectory = await _getTmpDirectory();

  if (previousCoverUrl != null) {
    // The previous cover image will not used anymore and can therefore be
    // deleted.
    final previousFile = getTmpCoverFile(tmpDirectory, previousCoverUrl);
    // ignore: unawaited_futures
    () async {
      try {
        await previousFile.delete();
      } catch (e) {
        print('Unable to delete ${previousFile.path}: $e');
      }
    }();
  }

  final cover = await DefaultCacheManager().getSingleFile(coverUrl);
  final coverBytes = await cover.readAsBytes();
  final tmpFile = getTmpCoverFile(tmpDirectory, coverUrl);

  if (_currentCoverUrl != coverUrl) {
    print('Not saving cover image $coverUrl. Another cover has been saved.');
    return null;
  }

  await tmpFile.writeAsBytes(coverBytes);
  if (_currentCoverUrl != coverUrl) {
    print('Deleting cover image $coverUrl. Another cover has been saved.');
    try {
      await tmpFile.delete();
    } catch (e) {
      print('Unable to delete ${tmpFile.path}: $e');
    }
    return null;
  }

  final filename = path.basename(tmpFile.path);

  coverFilenameCompleter.complete(filename);

  return filename;
}

File getTmpCoverFile(Directory tmpDirectory, String coverUrl) {
  final hash = base64UrlEncode(md5.convert(utf8.encode(coverUrl)).bytes);
  return File('${tmpDirectory.path}/$hash.jpg');
}
