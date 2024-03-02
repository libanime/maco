import 'package:args/command_runner.dart';
// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';
import 'package:libanime/parsers/anime.dart';
import 'package:libanime/structures/video.dart';
import 'package:mason_logger/mason_logger.dart';

/// `maco sibnet`
/// A Sibnet downloader [Command]

class SibnetCommand extends Command<int> {
  /// {@macro sibnet_command}
  SibnetCommand({
    required Logger logger,
  }) : _logger = logger {
    argParser
        /*..addOption(
        'path',
        abbr: 'p',
        help: 'Path for downloading. (Default ./video.mp4)',
      )
      ..addFlag(
        'download',
        abbr: 'd',
        help: 'Download video. Use path option for downloading path change.',
        negatable: false,
      )*/
        .addOption(
      'url',
      abbr: 'u',
      help: 'Player Url',
    );
  }

  @override
  String get description => 'Download video from Sibnet player.';

  @override
  String get name => 'sibnet';

  final Logger _logger;
  final dio = Dio();

  @override
  Future<int> run() async {
    if (argResults?.wasParsed('url') == false) {
      _logger.err(lightRed.wrap('Url option cannot be null.'));
      return ExitCode.noInput.code;
    }
    final url = argResults!['url'].toString();
    final sibnet = Sibnet();
    Video link;
    final progress = _logger.progress('Begging video extraction.');
    try {
      link = await sibnet.parse(url);
    } on Exception {
      progress.fail('An error occurred');
      _logger.err(lightRed.wrap('Link decode error!'));
      return ExitCode.unavailable.code;
    }
    progress.complete('Fetching complete!');

    final mp4Url = link.url;
    _logger.info(mp4Url);
    /* Not working, ToDo: fix
    if (argResults?['download'] == true) {
      var path = './video.mp4';
      // ignore: use_if_null_to_convert_nulls_to_bools
      if (argResults?.wasParsed('path') == true) {
        path = argResults!['path'].toString();
      }
      final downloadProgress = _logger.progress('Downloading.');
      try {
        await dio.download(mp4Url, path, options: Options(
          headers: {
            'Referer': mp4Url
          },
        ),);
      } catch (e) {
        downloadProgress.fail('An error occurred while downloading');
        _logger.detail('Error: $e');
      }
      downloadProgress.complete('Downloaded at $path');
    }*/

    return ExitCode.success.code;
  }
}
