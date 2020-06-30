import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtualgigabyte/models/item_tamanho.dart';
import 'package:uuid/uuid.dart';

class Produto extends ChangeNotifier {

  Produto({this.id, this.nome, this.descricao, this.tamanhos, this.imagens}){
    imagens = imagens ?? [];
    tamanhos = tamanhos ?? [];
  }

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
  List<dynamic> novasImagens;
  ItemTamanho _tamanhoSelecionado;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool valor){
    _loading = valor;
    notifyListeners();
  }

  ItemTamanho get tamanhoSelecionado => _tamanhoSelecionado;
  set tamanhoSelecionado(ItemTamanho item){
    _tamanhoSelecionado = item;
    notifyListeners();
  }

  int get totalEstoque {
    int estoque = 0;
    for(final tamanho in tamanhos){
      estoque += tamanho.estoque;
    }
    return estoque;
  }

  ItemTamanho findTamanho(String nome){
    try {
      return tamanhos.firstWhere((t) => t.nome == nome);
    } catch(e){
      return null;
    }
  }

  final Firestore firestore = Firestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.document('produtos/$id');
  StorageReference get storageRef => firebaseStorage.ref().child('produtos').child(id);

  bool get temEstoque => totalEstoque > 0;

  num get precoBase {
    num menorPreco = double.infinity;
    for(final tamanho in tamanhos){
      if(tamanho.preco < menorPreco && tamanho.temEstoque){
        menorPreco = tamanho.preco;
      }
    }
    return menorPreco;
  }

  Produto clone(){
    return Produto(
      id: id,
      nome: nome,
      descricao: descricao,
      imagens: List.from(imagens),
      tamanhos: tamanhos.map((tamanho) => tamanho.clone()).toList()
    );
  }

  List<Map<String, dynamic>> exportarListaTamanhos(){
    return tamanhos.map((tam) => tam.toMap()).toList();
  }

  Future<void> salvar() async {
    loading = true;
    final Map<String, dynamic> data = {
      'nome': nome,
      'descricao': descricao,
      'tamanhos': exportarListaTamanhos(),
    };

    if(id == null){
      final doc = await firestore.collection('produtos').add(data);
      id = doc.documentID;
    }
    else{
      await firestoreRef.updateData(data);
    }

    final List<String> updateImagens = [];

    for(final newImage in novasImagens) {
      if(imagens.contains(newImage)){
        updateImagens.add(newImage as String);
      }
      else {
        final StorageUploadTask task = storageRef.child(Uuid().v1()).putFile(newImage as File);
        final StorageTaskSnapshot snapshot = await task.onComplete;
        final String url = await snapshot.ref.getDownloadURL() as String;
        updateImagens.add(url);
      }
    }

    for(final imagem in imagens){
      if(!novasImagens.contains(imagem)){
        try {
          final ref = await firebaseStorage.getReferenceFromUrl(imagem);
          await ref.delete();
        } catch (e){

        }
      }
    }

    await firestoreRef.updateData({'imagens': updateImagens});
    imagens = updateImagens;
    loading = false;
  }

}