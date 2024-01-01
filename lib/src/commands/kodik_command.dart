import 'package:args/command_runner.dart';
// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';
import 'package:libanime/libanime.dart';
import 'package:libanime/structures/video.dart';
import 'package:mason_logger/mason_logger.dart';

///
/// `maco kodik`
/// A kodik downloader [Command]

class KodikCommand extends Command<int> {
  /// {@macro kodik_command}
  KodikCommand({
    required Logger logger,
  }) : _logger = logger {
    argParser
      ..addOption(
        'url',
        abbr: 'u',
        help: 'Player Url',
      )
      ..addOption(
        'path',
        abbr: 'p',
        help: 'Path for downloading. (Default ./video.mp4)',
      )
      ..addFlag(
        'info',
        abbr: 'i',
        help: 'Log additional anime info',
      )
      ..addFlag(
        'download',
        abbr: 'd',
        help: 'Download video. Use path option for downloading path change.',
        negatable: false,
      )
      ..addOption(
        'token',
        abbr: 't',
        help: 'Token for interacting with Kodik API',
      );
  }

  @override
  String get description => 'Download video from Kodik player.';

  @override
  String get name => 'kodik';

  final Logger _logger;
  final dio = Dio();

  @override
  Future<int> run() async {
    final url = argResults!['url'].toString().startsWith('//')
        ? 'https:${argResults!['url']}'
        : argResults!['url'].toString();
    dynamic token = 'b7cc4293ed475c4ad1fd599d114f4435';
    if (argResults?.wasParsed('url') == false) {
      _logger.err(lightRed.wrap('Url option cannot be null.'));
      return ExitCode.noInput.code;
    }
    if (argResults?.wasParsed('token') == false) {
      _logger.info(cyan.wrap('Token not set using default.'));
    } else {
      token = argResults!['token'];
    }
    final kodik = Kodik(token.toString());
    Map<String, Video>? links = {};
    final progress = _logger.progress('Begging video extracing.');
    try {
      links = await kodik.parse(url, true);
    } on Exception {
      progress.fail('An error occurred');
      _logger.err(lightRed.wrap('Link decode error!'));
      return ExitCode.unavailable.code;
    }
    progress.complete('Fetching complete!');
    // ignore: use_if_null_to_convert_nulls_to_bools
    if (argResults?.wasParsed('info') == true) {
      dynamic info;
      try {
        // ignore: inference_failure_on_function_invocation
        final infoRq = await dio
            // ignore: inference_failure_on_function_invocation
            .get('https://kodikapi.com/search?token=$token&player_link=$url');
        // ignore: avoid_dynamic_calls
        info = infoRq.data['results'][0];
      } on DioException {
        progress.fail('An error occurred');
        _logger.err(lightRed.wrap('Info requesting error'));
        return ExitCode.unavailable.code;
      }

      // ignore: avoid_dynamic_calls, lines_longer_than_80_chars
      _logger.info(
          // ignore: avoid_dynamic_calls
          '\n${styleBold.wrap('Title Original')}: ${info!["title_orig"]}\n${styleBold.wrap('Title RU')}: ${info!["title"]}\n${styleBold.wrap('Release Year')}: ${info!["year"]}\n${styleBold.wrap('Translator Name')}: ${info!["translation"]["title"]}\n${styleBold.wrap('Shikimori')}: https://shikimori.one/animes/${info!["shikimori_id"]}\n',);
    }
    final quality = _logger.chooseOne(
      'Choose quality:',
      choices: ['360', '480', '720'],
      defaultValue: '480',
    );
    final mp4Url = links![quality]?.url;
    _logger.info(mp4Url);
    if (argResults?['download'] == true) {
      var path = './video.mp4';
      // ignore: use_if_null_to_convert_nulls_to_bools
      if (argResults?.wasParsed('path') == true) {
        path = argResults!['path'].toString();
      }
      final downloadProgress = _logger.progress('Downloading.');
      try {
        await dio.download(mp4Url!, path);
      } catch (e) {
        downloadProgress.fail('An error occurred while downloading');
        _logger.detail('Error: $e');
      }
      downloadProgress.complete('Downloaded at $path');
    }

    return ExitCode.success.code;
  }
}
