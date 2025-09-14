import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class ProfileRepository {
  Future<String> loadEmail();

  Future<String> loadText();

  Future<void> saveText(final String value);
}

final class FirebaseProfileRepository implements ProfileRepository {
  @override
  Future<String> loadEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    return user == null ? '' : user.email ?? '';
  }

  @override
  Future<String> loadText() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return '';

    final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (!docSnapshot.exists) return '';

    final data = docSnapshot.data();
    if (data == null || !data.containsKey('text')) return '';

    final text = data['text'] as String?;
    return text ?? '';
  }

  @override
  Future<void> saveText(final String value) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('No user is signed in to save data.');

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({'text': value}, SetOptions(merge: true));
  }
}
