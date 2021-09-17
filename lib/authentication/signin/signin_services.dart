import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void signInAnonymously() async {
  await Firebase.initializeApp();

  final userRes = await FirebaseAuth.instance.signInAnonymously();
  print("${userRes.user.uid}");
}
