import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:lojavirtualgigabyte/helpers/firebase_errors.dart';
import 'package:lojavirtualgigabyte/models/user.dart';

class UserManager extends ChangeNotifier {

  UserManager(){
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  User user;
  Firestore firestore = Firestore.instance;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  bool _loadingFace = false;
  bool get loadingFace => _loadingFace;
  set loadingFace(bool value){
    _loadingFace = value;
    notifyListeners();
  }


  Future<void> signIn({User user, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final AuthResult result = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.senha);

      await _loadCurrentUser(firebaseUser: result.user);

      onSuccess();
    } on PlatformException catch (e){
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  Future<void> signUp({User user, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final AuthResult result = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.senha);

      user.id = result.user.uid;
      this.user = user;
      await user.saveData();
      user.saveToken();

      onSuccess();

    } on PlatformException catch (e){
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  void signOut(){
    auth.signOut();
    user = null;
    notifyListeners();
  }

  bool get isLoggedin => user != null;


  Future<void> _loadCurrentUser({FirebaseUser firebaseUser}) async {
    final FirebaseUser currentUser = firebaseUser ?? await auth.currentUser();
    if(currentUser != null){
      final DocumentSnapshot docUser = await firestore.collection('users').document(currentUser.uid).get();
      user = User.fromDocument(docUser);
      user.saveToken();

      final docAdmin = await Firestore.instance.collection('admins').document(user.id).get();
      if(docAdmin.exists){
        user.admin = true;
      }
      notifyListeners();
    }
  }

  Future<void> facebookLogin({Function onFail, Function onSuccess}) async {
    loadingFace = true;
    final result = await FacebookLogin().logIn(['email', 'public_profile']);
    switch(result.status) {
      case FacebookLoginStatus.loggedIn:
        final credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token
        );
        final authResult = await auth.signInWithCredential(credential);
        if(authResult.user != null){
          final firebaseUser = authResult.user;
          user = User(
            id: firebaseUser.uid,
            nome: firebaseUser.displayName,
            email: firebaseUser.email,
          );
          await user.saveData();
          user.saveToken();

          onSuccess();
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        onFail(result.errorMessage);
        break;
    }
    loadingFace = false;
  }

  bool get adminHabilitado => user != null && user.admin;
}