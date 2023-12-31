import 'package:args/command_runner.dart';
import 'package:libanime/structures/video.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:libanime/libanime.dart';
import 'package:dio/dio.dart';


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
      help: 'Url to player for download',
    )
    ..addFlag(
      'download',
      abbr: 'd',
      help: 'Automaticly download into current directory.',
      negatable: false
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

  @override
  Future<int> run() async {
    final token = "b7cc4293ed475c4ad1fd599d114f4435";
    if (argResults?.wasParsed("url") == false) {
      _logger.err(lightRed.wrap("Url param cannot be null.")!);
      return ExitCode.noInput.code;
    }
    if (argResults?.wasParsed("token") == false) {
      _logger.info(cyan.wrap("Token not set using default.")!);
    }
    final kodik = Kodik(token);
    Map<String, Video>? links = {};
    final progress = _logger.progress("Begging video extracing.");
    try {
      links = await kodik.parse(argResults!['url'].toString(), true);
    } on Exception {
      progress.fail("An error occurred");
      _logger.err(lightRed.wrap("Link decode error!"));
      return ExitCode.unavailable.code;
    }

    progress.complete("Fetching complete!");
    final quality = _logger.chooseOne(
    'Choose quality:',
    choices: ['360', '480', '720'],
    defaultValue: '480',
  );
    final url = links![quality]?.url;
    _logger.info(url);
    if (argResults?["download"] == true) {
      final dio = Dio();
      final downloadProgress = _logger.progress("Starting downloading.");
      try {
        final path = "" + "video.mp4";
        await dio.download(url!, path);
      } catch (e) {
        downloadProgress.fail("An error occurred while downloading");
      } finally {
        downloadProgress.complete("Downloaded at ${path}")
      }
      
    }
    
    return ExitCode.success.code;
  }
}
