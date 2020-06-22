import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtualgigabyte/models/produto.dart';

class ProdutoManager extends ChangeNotifier{

  ProdutoManager(){
    _carregarTodosProdutos();
  }

  final Firestore firestore = Firestore.instance;

  List<Produto> todosProdutos = [];

  Future<void> _carregarTodosProdutos() async{
    final QuerySnapshot snapProdutos = await firestore.collection('produtos').getDocuments();
    todosProdutos = snapProdutos.documents.map((d) => Produto.fromDocumento(d)).toList();
    notifyListeners();
  }
}

