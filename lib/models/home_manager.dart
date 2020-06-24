import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtualgigabyte/models/secao.dart';

class HomeManager extends ChangeNotifier {
  HomeManager(){
    _carregarSecaoes();
  }

  List<Secao> secoes = [];
  final Firestore firestore = Firestore.instance;

  Future<void> _carregarSecaoes() async {
    await firestore.collection('home').snapshots().listen((event) {
      secoes.clear();
      for(final DocumentSnapshot documento in event.documents){
        secoes.add(Secao.fromDocumento(documento));
      }
      notifyListeners();
    });
  }
}