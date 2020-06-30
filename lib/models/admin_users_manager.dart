import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtualgigabyte/models/user.dart';
import 'package:lojavirtualgigabyte/models/user_manager.dart';

class AdminUsersManager extends ChangeNotifier {

  List<User> users = [];

  StreamSubscription _subscription;

  final Firestore firestore = Firestore.instance;
  void updateUser(UserManager userManager){
    _subscription?.cancel();
    if(userManager.adminHabilitado) {
      _listenToUsers();
    } else {
      users.clear();
      notifyListeners();
    }
  }

  void _listenToUsers(){

    _subscription = firestore.collection('users').snapshots().listen((event) {
      users = event.documents.map((e) =>
       User.fromDocument(e)).toList();
      users.sort((a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));
      notifyListeners();
    });
  }

  List<String> get nomes => users.map((e) => e.nome).toList();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}