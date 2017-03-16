import 'package:dart_dev/dart_dev.dart' show dev, config;

main(List<String> args) async {
  const directories = const <String>[
    'lib/',
    'test/',
    'tool/',
  ];

  config.analyze.entryPoints = directories;

  config.test
    ..pubServe = true
    ..platforms = [
      'vm',
      'content-shell',
    ]
    // Prevent test load timeouts on Smithy.
    ..concurrency = 1
    ..unitTests = [
      'test/test_util_test.dart',
    ];

  config.coverage
    ..html = false
    ..pubServe = true
    ..reportOn = [
      'lib/'
    ];

  await dev(args);
}
