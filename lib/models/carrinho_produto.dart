import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtualgigabyte/models/item_tamanho.dart';
import 'package:lojavirtualgigabyte/models/produto.dart';

class CarrinhoProduto{
  CarrinhoProduto.fromProduto(this.produto){
    produtoId = produto.id;
    quantidade = 1;
    tamanho = produto.tamanhoSelecionado.nome;
  }

  CarrinhoProduto.fromDocumento(DocumentSnapshot documento){
    produtoId = documento.data['produtoId'] as String;
    quantidade = documento.data['quantidade'] as int;
    tamanho = documento.data['tamanho'] as String;
    
    firestore.document('produtos/$produtoId').get().then((value) =>
      produto = Produto.fromDocumento(value)
    );
  }

  final Firestore firestore = Firestore.instance;

  String produtoId;
  int quantidade;
  String tamanho;

  Produto produto;

  ItemTamanho get itemTamanho {
    if(produto == null) return null;
    return produto.findTamanho(tamanho);
  }

  num get precoUnico {
    if(produto == null) return 0;
    return itemTamanho?.preco ?? 0;
  }

  Map<String, dynamic> carrinhoItemMap(){
    return{
      'produtoId': produtoId,
      'quantidade': quantidade,
      'tamanho': tamanho
    };
  }
}