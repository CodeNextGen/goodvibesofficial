import 'dart:io' hide ProcessException;

import 'package:grinder/grinder.dart';

const dartFmtLineLength = 80;

main(List<String> args) {
  grind(args);
}

@Task('Runs flutter analyze')
analyze() async {
  run('flutter', arguments: ['analyze']);
}

@Task()
checkFormat() {
  if (DartFmt.dryRun('.', lineLength: dartFmtLineLength))
    fail('Code is not properly formatted. Run `grind format`');
}

@Task()
clean() => defaultClean();

@Task()
format() => DartFmt.format('.', lineLength: dartFmtLineLength);

@Task()
@Depends(checkFormat, analyze)
test() => true;

@Task('Builds the docker image from ./docker/Docker')
buildDockerImage() async {
  final pubFileNames = ['pubspec.yaml', 'pubspec.lock'];
  pubFileNames
      .forEach((fileName) => copyFile(new File(fileName), new Directory('ci')));
  try {
    await runAsync('docker', arguments: [
      'build',
      '-t',
      'registry.gitlab.com/exitlive/music-player',
      'ci'
    ]);
    log('Now you have to tag the docker image and push it to gitlab. Lets say the version is 1.5, then:');
    log('docker tag ID_OF_BUILD registry.gitlab.com/exitlive/music-player:1.5\n'
        'docker push registry.gitlab.com/exitlive/music-player:1.5');
  } finally {
    pubFileNames.forEach((fileName) => delete(new File('ci/$fileName')));
  }
}
