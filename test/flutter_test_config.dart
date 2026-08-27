// Applies to every test file in this directory.
//
// The screens here are drawn with GoogleFonts, which fetches its faces over
// the network. A test run has none, so every screen build raises a font error
// that has nothing to do with what is being tested -- and, in the probes,
// trips the harness's own error handling. The text still lays out in the
// default face, so those errors are dropped here, once, for all tests.
//
// Runtime fetching is deliberately left on: with it off google_fonts raises a
// different message, and the probes match on the fetching one.
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  final report = reportTestException;
  reportTestException = (details, description) {
    final text = details.exception.toString();
    if (text.contains('font') || text.contains('GoogleFonts')) return;
    report(details, description);
  };

  await testMain();
}
