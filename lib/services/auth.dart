import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Authservice {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInAnon() async {
    try {
      UserCredential result = await  _auth.signInAnonymously();
      User user = result.user!;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  Future signInGmail() async {

  }
  Future signOutAnon() async {
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
    }
  }
}