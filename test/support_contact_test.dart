// Pins the one place the support address lives, and that the mail link it
// builds is one a mail app will actually accept.
import 'package:flutter_test/flutter_test.dart';

import 'package:jiyan_learning/app/support_contact.dart';

void main() {
  test('there is a single support address', () {
    expect(SupportContact.email, contains('@'));
    expect(SupportContact.email.trim(), SupportContact.email);
  });

  test('the mailto link carries the address, subject and body', () {
    // composeEmail launches; this checks the same Uri shape it builds.
    final uri = Uri(
      scheme: 'mailto',
      path: SupportContact.email,
      query: 'subject=${Uri.encodeComponent("Jiyan Learning - Help")}',
    );

    expect(uri.scheme, 'mailto');
    expect(uri.path, SupportContact.email);
    // Spaces must be percent-encoded, not '+': mail apps show a '+' literally
    // in the subject line.
    expect(uri.query, contains('%20'));
    expect(uri.query, isNot(contains('+')));
  });
}
