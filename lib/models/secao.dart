import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtualgigabyte/models/secao_item.dart';
import 'package:uuid/uuid.dart';

class Secao extends ChangeNotifier {
  Secao.fromDocumento (DocumentSnapshot documento){
    id = documento.documentID;
    nome = documento.data['nome'] as String;
    tipo = documento.data['tipo'] as String;
    itens = (documento.data['items'] as List).map((item) {
      return SecaoItem.fromMap(item as Map<String, dynamic>);
    }).toList();
  }

  Secao({this.id, this.nome, this.itens, this.tipo}){
    nome = nome ?? '';
    itens = itens ?? [];
    itensOriginais = List.from(itens);
  }

  final Firestore firestore = Firestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  DocumentReference get firestoreRef => firestore.document('home/$id');
  StorageReference get storageRef => storage.ref().child('home/$id');

  String id;
  String nome;
  String tipo;
  List<SecaoItem> itens;
  List<SecaoItem> itensOriginais;

  String _error;
  String get error => _error;
  set error(String valor){
    _error = valor;
    notifyListeners();
  }

  void addItem(SecaoItem item){
    itens.add(item);
    notifyListeners();
  }

  void removerItem(SecaoItem item){
    itens.remove(item);
    notifyListeners();
  }

  Secao clone(){
    return Secao(
      id: id,
      nome: nome,
      itens: itens.map((e) => e.clone()).toList(),
      tipo: tipo
    );
  }

  Future<void> salvar(int pos) async {
    final Map<String, dynamic> data = {
      'nome': nome,
      'tipo': tipo,
      'pos': pos
    };
    if(id == null){
      final doc = await firestore.collection('home').add(data);
      id = doc.documentID;
    }
    else {
      await firestoreRef.updateData(data);
    }

    for(final item in itens){
      if(item.image is File){
        final StorageUploadTask task = storageRef.child(Uuid().v1()).putFile(item.image);
        final StorageTaskSnapshot snapshot = await task.onComplete;
        final String url = await snapshot.ref.getDownloadURL() as String;
        item.image = url;
      }
    }

    for(final original in itensOriginais){
      if(!itens.contains(original) && (original.image as String).contains('firebase')){
        try {
          final ref = await storage.getReferenceFromUrl(
              original.image as String);
          await ref.delete();
        }catch(e){}
      }
    }
    final Map<String, dynamic> itensData = {
      'items': itens.map((e) => e.toMap()).toList()
    };

    await firestoreRef.updateData(itensData);
  }

  bool valid(){
    if(nome == null || nome.isEmpty){
      error = 'Título inválido';
    }
    else if(itens.isEmpty){
      error = 'Insira ao menos uma imagem';
    }
    else
      error = null;
    return error == null;
  }

  Future<void> delete() async {
    await firestoreRef.delete();
    for(final item in itens){
      if((item.image as String).contains('firebase')){
        try {
          final ref = await storage.getReferenceFromUrl(item.image as String);
          await ref.delete();
        } catch (e){}

      }
    }
  }

  @override
  String toString() {
    return '\nSecao{nome: $nome, tipo: $tipo, itens: $itens}';
  }
}