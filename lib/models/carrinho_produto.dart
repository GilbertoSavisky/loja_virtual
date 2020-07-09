import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtualgigabyte/models/item_tamanho.dart';
import 'package:lojavirtualgigabyte/models/produto.dart';

class CarrinhoProduto extends ChangeNotifier{
  CarrinhoProduto.fromProduto(this._produto){
    produtoId = produto.id;
    quantidade = 1;
    tamanho = produto.tamanhoSelecionado.nome;
  }

  CarrinhoProduto.fromDocumento(DocumentSnapshot documento){
    id = documento.documentID;
    produtoId = documento.data['produtoId'] as String;
    quantidade = documento.data['quantidade'] as int;
    tamanho = documento.data['tamanho'] as String;
    
    firestore.document('produtos/$produtoId').get().then((value) {
      produto = Produto.fromDocumento(value);
    });
  }

  CarrinhoProduto.fromMap(Map<String, dynamic> map){
    produtoId = map['produtoId'] as String;
    quantidade = map['quantidade'] as int;
    tamanho = map['tamanho'] as String;
    fixedPreco = map['fixedPreco'] as num;

    firestore.document('produtos/$produtoId').get().then((value) {
      produto = Produto.fromDocumento(value);
    });
  }

  final Firestore firestore = Firestore.instance;
  String id;
  String produtoId;
  int quantidade;
  String tamanho;
  num fixedPreco;

  Produto _produto;

  Produto get produto => _produto;

  set produto(Produto produto){
    _produto = produto;
    notifyListeners();
  }

  ItemTamanho get itemTamanho {
    if(produto == null) return null;
    return produto.findTamanho(tamanho);
  }

  num get precoUnico {
    if(produto == null) return 0;
    return itemTamanho?.preco ?? 0;
  }

  num get precoTotal => precoUnico * quantidade;

  Map<String, dynamic> carrinhoItemMap(){
    return{
      'produtoId': produtoId,
      'quantidade': quantidade,
      'tamanho': tamanho
    };
  }

  Map<String, dynamic> toPedidoItemMap(){
    return{
      'produtoId': produtoId,
      'quantidade': quantidade,
      'tamanho': tamanho,
      'fixedPreco': fixedPreco ?? precoUnico
    };
  }

  bool podeJuntarItem(Produto produto){
    return produto.id == produtoId && produto.tamanhoSelecionado.nome == tamanho;
  }

  void incrementar(){
    quantidade++;
    notifyListeners();
  }
  void decrementar(){
    quantidade--;
    notifyListeners();
  }

  bool get temEstoque {
    if(produto != null && produto.deletado)
      return false;
    final tamanho = itemTamanho;
    if(tamanho == null) return false;
    return tamanho.estoque >= quantidade;
  }
}