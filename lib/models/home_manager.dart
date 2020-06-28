import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtualgigabyte/models/secao.dart';

class HomeManager extends ChangeNotifier {
  HomeManager(){
    _carregarSecaoes();
  }

  List<Secao> _secoes = [];
  List<Secao> _secoesEditando = [];

  bool editando = false;
  final Firestore firestore = Firestore.instance;

  Future<void> _carregarSecaoes() async {
    await firestore.collection('home').snapshots().listen((event) {
      _secoes.clear();
      for(final DocumentSnapshot documento in event.documents){
        _secoes.add(Secao.fromDocumento(documento));
      }
      notifyListeners();
    });
  }

  List<Secao> get secoes{
    if(editando){
      return _secoesEditando;
    }
    else
      return _secoes;
  }

  void removeSecao(Secao secao){
    _secoesEditando.remove(secao);
    notifyListeners();
  }

  void entrarEdicao(){
    editando = true;
    _secoesEditando = _secoes.map((s) => s.clone()).toList();
    notifyListeners();
  }

  void salvarEdicao(){
    editando = false;
    notifyListeners();
  }
  void descartarEdicao(){
    editando = false;
    notifyListeners();
  }

  void addSecao(Secao secao){
    _secoesEditando.add(secao);
    notifyListeners();
  }
}