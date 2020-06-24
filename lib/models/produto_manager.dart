import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtualgigabyte/models/produto.dart';
import 'package:lojavirtualgigabyte/models/secao_item.dart';

class ProdutoManager extends ChangeNotifier{

  ProdutoManager(){
    _carregarTodosProdutos();
  }

  final Firestore firestore = Firestore.instance;

  List<Produto> todosProdutos = [];
  String _pesquisa = '';

  String get pesquisa => _pesquisa;

  set pesquisa(String valor){
    _pesquisa = valor;
    notifyListeners();
  }

  List<Produto> produtosFiltrados(){
    final List<Produto> produtosFiltrados = [];

    if(pesquisa.isEmpty){
      produtosFiltrados.addAll(todosProdutos);
    } else {
      produtosFiltrados.addAll(todosProdutos.where((p) => p.nome.toLowerCase().contains(pesquisa.toLowerCase())));
    }
    return produtosFiltrados;
  }

  Future<void> _carregarTodosProdutos() async{
    final QuerySnapshot snapProdutos = await firestore.collection('produtos').getDocuments();
    todosProdutos = snapProdutos.documents.map((d) => Produto.fromDocumento(d)).toList();
    notifyListeners();
  }

  Produto findProdutoById(String id) {
    try {
      return todosProdutos.firstWhere((element) => element.id == id);
    } catch (e){
      return null;
    }
  }
}

