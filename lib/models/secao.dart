import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtualgigabyte/models/secao_item.dart';

class Secao extends ChangeNotifier {
  Secao.fromDocumento (DocumentSnapshot documento){
    nome = documento.data['nome'] as String;
    tipo = documento.data['tipo'] as String;
    itens = (documento.data['items'] as List).map((item) {
      return SecaoItem.fromMap(item as Map<String, dynamic>);
    }).toList();
  }

  Secao({this.nome, this.itens, this.tipo}){
    nome = nome ?? '';
    itens = itens ?? [];
  }

  String nome;
  String tipo;
  List<SecaoItem> itens;

  void addItem(SecaoItem item){
    itens.add(item);
    notifyListeners();
  }

  Secao clone(){
    return Secao(
      nome: nome,
      itens: itens.map((e) => e.clone()).toList(),
      tipo: tipo
    );
  }

  @override
  String toString() {
    return '\nSecao{nome: $nome, tipo: $tipo, itens: $itens}';
  }
}