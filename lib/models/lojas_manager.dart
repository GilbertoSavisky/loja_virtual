import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtualgigabyte/models/loja.dart';

class LojasManager extends ChangeNotifier {

  Timer _timer;

  LojasManager(){
    _carregarLojas();
    _startTime();
  }

  List<Loja> lojas = [];
  final Firestore firestore = Firestore.instance;

  void _carregarLojas() async {
    final snapshot = await firestore.collection('lojas').getDocuments();
    lojas = snapshot.documents.map((e) => Loja.fromDocumento(e)).toList();
    notifyListeners();
  }

  void _startTime(){
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      _checkOpenning();
    });
  }
  void _checkOpenning(){
    for(final loja in lojas){
      loja.updateStatus();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}