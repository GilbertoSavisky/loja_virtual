import 'package:cloud_firestore/cloud_firestore.dart';

class Produto{

  Produto.fromDocumento(DocumentSnapshot documento){
    id = documento.documentID;
    nome = documento['nome'] as String;
    descricao = documento['descricao'] as String;
    imagens =  List<String>.from(documento.data['imagens'] as List<dynamic>);
  }

  String id;
  String nome;
  String descricao;
  List<String> imagens;

}