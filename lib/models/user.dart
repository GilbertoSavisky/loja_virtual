import 'package:cloud_firestore/cloud_firestore.dart';

class User{

  User({this.email, this.senha, this.nome, this.id});

  String id;
  String nome;
  String email;
  String senha;
  String confirmSenha;

  DocumentReference get firestoreRef => Firestore.instance.document('users/$id');
  CollectionReference get carrinhoRef => firestoreRef.collection('carrinho');

  User.FromDocument(DocumentSnapshot doc){
    id = doc.documentID;
    nome = doc.data['nome'] as String;
    email = doc.data['email']as String;
  }
  Future<void> saveData()async{
    await firestoreRef.setData(toMap());
  }

  Map<String, dynamic> toMap(){
    return {
      'nome': nome,
      'email': email,
    };
  }
}