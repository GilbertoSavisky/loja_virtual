import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lojavirtualgigabyte/models/endereco.dart';

class User{

  User({this.email, this.senha, this.nome, this.id});

  String id;
  String nome;
  String email;
  String senha;
  String cpf;
  String confirmSenha;
  bool admin = false;
  Endereco endereco;

  DocumentReference get firestoreRef => Firestore.instance.document('users/$id');
  CollectionReference get carrinhoRef => firestoreRef.collection('carrinho');
  CollectionReference get tokenRef => firestoreRef.collection('tokens');

  User.fromDocument(DocumentSnapshot doc){
    id = doc.documentID;
    nome = doc.data['nome'] as String;
    email = doc.data['email']as String;
    cpf = doc.data['cpf']as String;
    if(doc.data.containsKey('endereco')){
      endereco = Endereco.fromMap(doc.data['endereco'] as Map<String, dynamic>);
    }
  }
  Future<void> saveData()async{
    await firestoreRef.setData(toMap());
  }

  Map<String, dynamic> toMap(){
    return {
      'nome': nome,
      'email': email,
      if(endereco != null)
        'endereco': endereco.toMap(),
      if(cpf != null)
        'cpf': cpf
    };
  }

  void setEndereco(Endereco endereco){
    this.endereco = endereco;
    saveData();
  }

  void setCpf(String cpf){
    this.cpf = cpf;
    saveData();
  }

  Future<void> saveToken() async {
    final token = await FirebaseMessaging().getToken();
    tokenRef.document(token).setData({
      'token': token,
      'updateAt': FieldValue.serverTimestamp(),
      'plataforma': Platform.operatingSystem
    });
  }
}