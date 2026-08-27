// Pins the profile fields added for signup: the picture and the city have to
// survive the round trip to the document, or the drawer has nothing to show.
import 'package:flutter_test/flutter_test.dart';

import 'package:jiyan_learning/model/user_model.dart';

UserModel _user({
  String? location,
  String? photoBase64,
  String? photoUrl,
}) {
  final now = DateTime(2026, 8, 26);
  return UserModel(
    uid: 'abc123',
    childName: 'Jiyan',
    childAge: 7,
    parentEmail: 'parent@example.com',
    parentPhone: '+919876543210',
    location: location,
    photoBase64: photoBase64,
    photoUrl: photoUrl,
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  test('the photo and city are written to the document', () {
    final data = _user(
      location: 'Bhopal, Madhya Pradesh',
      photoBase64: 'aGVsbG8=',
      photoUrl: 'https://example.com/me.jpg',
    ).toFirestore();

    expect(data['location'], 'Bhopal, Madhya Pradesh');
    expect(data['photoBase64'], 'aGVsbG8=');
    expect(data['photoUrl'], 'https://example.com/me.jpg');
    expect(data['childName'], 'Jiyan');
    expect(data['parentEmail'], 'parent@example.com');
  });

  test('a profile with no photo writes nulls, not missing keys', () {
    final data = _user().toFirestore();

    // The drawer reads these straight off the document, so they must exist
    // and simply be null rather than be absent.
    expect(data.containsKey('photoBase64'), isTrue);
    expect(data.containsKey('photoUrl'), isTrue);
    expect(data.containsKey('location'), isTrue);
    expect(data['photoBase64'], isNull);
  });

  test('copyWith carries the new fields', () {
    final updated = _user().copyWith(
      location: 'Indore',
      photoBase64: 'bmV3',
      photoUrl: 'https://example.com/new.jpg',
    );

    expect(updated.location, 'Indore');
    expect(updated.photoBase64, 'bmV3');
    expect(updated.photoUrl, 'https://example.com/new.jpg');
    // Everything else is untouched.
    expect(updated.uid, 'abc123');
    expect(updated.childName, 'Jiyan');
    expect(updated.childAge, 7);
  });

  test('copyWith with nothing given changes nothing', () {
    final original = _user(location: 'Bhopal', photoBase64: 'aGk=');
    final same = original.copyWith();

    expect(same.location, 'Bhopal');
    expect(same.photoBase64, 'aGk=');
    expect(same.parentPhone, '+919876543210');
  });
}
