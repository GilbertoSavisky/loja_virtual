import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtualgigabyte/models/item_tamanho.dart';

class Produto extends ChangeNotifier {

  Produto.fromDocumento(DocumentSnapshot documento){
    id = documento.documentID;
    nome = documento['nome'] as String;
    descricao = documento['descricao'] as String;
    imagens =  List<String>.from(documento.data['imagens'] as List<dynamic> ?? []);
    tamanhos =  (documento.data['tamanhos'] as List<dynamic>).map((t) => ItemTamanho.fromMap(t as Map<String, dynamic>)).toList();
  }

  String id;
  String nome;
  String descricao;
  List<String> imagens;
  List<ItemTamanho> tamanhos;

  ItemTamanho _tamanhoSelecionado;

  ItemTamanho get tamanhoSelecionado => _tamanhoSelecionado;
  set tamanhoSelecionado(ItemTamanho item){
    _tamanhoSelecionado = item;
    notifyListeners();
  }

}