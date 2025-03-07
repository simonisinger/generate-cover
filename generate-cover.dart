import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as p;

main(List<String> args) {
  ArgParser parser = ArgParser();
  ArgResults argResults = parser.parse(args);
  if (argResults.rest.length != 2) {
    print('invalid argument count');
    exit(1);
  }

  File imageFile = File(argResults.rest.first);
  File audioFile = File(argResults.rest[1]);

  ProcessResult result = Process.runSync('ffmpeg', [
    '-loop',
    '1',
    '-i',
    imageFile.path,
    '-y',
    '-loglevel',
    'warning',
    '-i',
    audioFile.path,
    '-c:v',
    'libx264',
    '-c:a',
    'copy',
    '-pix_fmt',
    'yuv420p',
    '-x264-params',
    'bluray_compat=1',
    '-map',
    '0:0',
    '-map',
    '1:0',
    '-shortest',
    '-vf',
    'scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2,setsar=1',
    p.basenameWithoutExtension(audioFile.path) + '.mkv'
  ]);
  print(result.stderr);
  print(result.stdout);
}