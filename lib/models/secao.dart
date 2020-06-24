import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojavirtualgigabyte/models/secao_item.dart';

class Secao {
  Secao.fromDocumento (DocumentSnapshot documento){
    nome = documento.data['nome'] as String;
    tipo = documento.data['tipo'] as String;
    itens = (documento.data['items'] as List).map((item) {
      return SecaoItem.fromMap(item as Map<String, dynamic>);
    }).toList();
  }

  String nome;
  String tipo;
  List<SecaoItem> itens;

  @override
  String toString() {
    return '\nSecao{nome: $nome, tipo: $tipo, itens: $itens}';
  }
}