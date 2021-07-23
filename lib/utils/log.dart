import 'dart:io';
import 'dart:developer' as dev;
import 'package:path_provider/path_provider.dart' as pp;

class LoggerHelper {
  static Directory cacheDir;
  bool logConsole = true;
  bool logFile = true;

  void logInfo(Object msg, [String tag]) {
    if (logConsole) {
      dev.log(msg.toString(), name: tag);
    }
    if (logFile) {
      _writeLog(msg.toString() ?? "");
    }
  }

  void _writeLog(String msg) {
    outputFile.writeAsStringSync(
      '[$time] $msg\n',
      mode: FileMode.append,
      flush: true,
    );
  }

  File get outputFile {
    if (cacheDir == null) {
      return null;
    }
    return File('${cacheDir.absolute.path}/log-${dataString()}.log');
  }

  static String dataString() {
    final dt = DateTime.now();
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static String get time {
    final dt = DateTime.now();
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final s = dt.day.toString().padLeft(2, '0');
    final mil = dt.millisecond.toString().padLeft(3, '0');
    return '$h:$m:$s.$mil';
  }

  static void initLogDir() async {
    cacheDir = await pp.getTemporaryDirectory();
  }

  static Iterable<File> getLogFileList() sync* {
    if (cacheDir == null) {
      return;
    }
    final files = cacheDir.listSync();
    for (final file in files) {
      final path = file.uri.pathSegments.last;
      if (path.startsWith('log-')) {
        yield file;
      }
    }
  }
}