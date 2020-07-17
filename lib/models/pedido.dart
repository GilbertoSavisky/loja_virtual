import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtualgigabyte/models/carrinho_manager.dart';
import 'package:lojavirtualgigabyte/models/carrinho_produto.dart';
import 'package:lojavirtualgigabyte/models/endereco.dart';
import 'package:lojavirtualgigabyte/services/cielo_pagamento.dart';

enum Status {CANCELADO, PREPARANDO, TRANSPORTANDO, ENTREGUE}

class Pedido {

  Pedido.fromCarrinhoManager(CarrinhoManager carrinhoManager){
    items = List.from(carrinhoManager.itens);
    preco = carrinhoManager.totalPreco;
    userId = carrinhoManager.user.id;
    endereco = carrinhoManager.endereco;
    status = Status.PREPARANDO;
  }

  Pedido.fromDocumento(DocumentSnapshot documento){
    orderId = documento.documentID;
    preco = documento.data['preco'] as num;
    userId = documento.data['user'] as String;
    payId = documento.data['payId'] as String;
    data = documento.data['data'] as Timestamp;
    status = Status.values[documento.data['status'] as int];
    endereco = Endereco.fromMap(documento.data['endereco'] as Map<String, dynamic>);
    items = (documento.data['items'] as List<dynamic>).map((e) {
      return CarrinhoProduto.fromMap(e as Map<String, dynamic>);
    }).toList();
  }

  final Firestore firestore = Firestore.instance;

  DocumentReference get firestoreRef => firestore.collection('pedidos').document(orderId);

  void updateFromDocumento(DocumentSnapshot documento){
    status = Status.values[documento.data['status'] as int];
  }
  // ignore: missing_return
  Future<void> save(){
    firestore.collection('pedidos').document(orderId).setData(
      {
        'items': items.map((e) => e.toPedidoItemMap()).toList(),
        'preco': preco,
        'user': userId,
        'endereco': endereco.toMap(),
        'status': status.index,
        'data': Timestamp.now(),
        'payId': payId
      }
    );
  }

  Function() get recuar {
    return status.index >= Status.TRANSPORTANDO.index ?
        (){
      status = Status.values[status.index - 1];
      firestoreRef.updateData({'status': status.index});
    } : null;
  }

  Function() get avancar {
    return status.index <= Status.TRANSPORTANDO.index ?
        (){
      status = Status.values[status.index + 1];
      firestoreRef.updateData({'status': status.index});
    } : null;
  }

  Future<void> cancelar() async {
    try {
      await CieloPagamento().cancelar(payId);
      status = Status.CANCELADO;
      firestoreRef.updateData({'status': status.index});
    } catch(e){
      debugPrint('Erro ao Cancelar');
      return Future.error('Falha ao cancelar');
    }
  }

  List<CarrinhoProduto> items;
  num preco;
  String orderId;
  String userId;
  Endereco endereco;
  Timestamp data;
  Status status;
  String payId;

  String get formattedId => '#${orderId.padLeft(6, '0')}';

  String get statusText => getStatusText(status);

  static String getStatusText(Status status) {
    switch(status){
      case Status.CANCELADO:
        return 'Cancelado';
      case Status.PREPARANDO:
        return 'Em preparação';
      case Status.TRANSPORTANDO:
        return 'Em transporte';
      case Status.ENTREGUE:
        return 'Entregue';
      default:
        return '';
    }
  }

  @override
  String toString() {
    return 'Pedido{firestore: $firestore, items: $items, preco: $preco, orderId: $orderId, userId: $userId, endereco: $endereco, data: $data}';
  }
}