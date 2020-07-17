import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtualgigabyte/models/carrinho_manager.dart';
import 'package:lojavirtualgigabyte/models/cartao_credito.dart';
import 'package:lojavirtualgigabyte/models/pedido.dart';
import 'package:lojavirtualgigabyte/models/produto.dart';
import 'package:lojavirtualgigabyte/services/cielo_pagamento.dart';

class CheckoutManager extends ChangeNotifier {

  CarrinhoManager cartManager;

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool valor){
    _loading = valor;
    notifyListeners();
  }

  final Firestore firestore = Firestore.instance;
  final CieloPagamento cieloPagamento = CieloPagamento();

  // ignore: use_setters_to_change_properties
  void updateCart(CarrinhoManager cartManager){
    this.cartManager = cartManager;
  }

  Future<void> checkout({CartaoCredito cartaoCredito, Function onEstoqueFail, Function onSuccess, Function onPayFail}) async {
    loading = true;
    final orderId = await _getOrderId();

    String payId;
    try {
      payId = await cieloPagamento.autorizacao(
          preco: cartManager.totalPreco,
          cartaoCredito: cartaoCredito,
          pedidoId: orderId.toString(),
          user: cartManager.user
      );
      debugPrint('sucesso = ${payId}');
    } catch(e){
      onPayFail(e);
      loading = false;
      return;
    }

    try {
      await _decrementStock();
    } catch (e){
      CieloPagamento().cancelar(payId);
      onEstoqueFail(e);
      loading = false;
      return;
    }

    try {
      await cieloPagamento.captura(payId);
    } catch(e) {
      onPayFail(e);
      loading = false;
      return;
    }


    final order = Pedido.fromCarrinhoManager(cartManager);
    order.orderId = orderId.toString();
    order.payId = payId;

    await order.save();

    cartManager.clear();
    onSuccess(order);
    loading = false;
  }

  Future<int> _getOrderId() async {
    final ref = firestore.document('aux/contpedido');

    try {
      final result = await firestore.runTransaction((tx) async {
        final doc = await tx.get(ref);
        final orderId = doc.data['corrente'] as int;
        await tx.update(ref, {'corrente': orderId + 1});
        return {'orderId': orderId};
      });
      return result['orderId'] as int;
    } catch (e){
      debugPrint(e.toString());
      return Future.error('Falha ao gerar número do pedido');
    }
  }

  Future<void> _decrementStock(){
    // 1. Ler todos os estoques 3xM
    // 2. Decremento localmente os estoques 2xM
    // 3. Salvar os estoques no firebase 2xM

    return firestore.runTransaction((tx) async {
      final List<Produto> productsToUpdate = [];
      final List<Produto> productsWithoutStock = [];

      for(final cartProduct in cartManager.itens){
        Produto product;

        if(productsToUpdate.any((p) => p.id == cartProduct.produtoId)){
          product = productsToUpdate.firstWhere(
                  (p) => p.id == cartProduct.produtoId);
        } else {
          final doc = await tx.get(
              firestore.document('produtos/${cartProduct.produtoId}')
          );
          product = Produto.fromDocumento(doc);
        }

        cartProduct.produto = product;

        final size = product.findTamanho(cartProduct.tamanho);
        if(size.estoque - cartProduct.quantidade < 0){
          productsWithoutStock.add(product);
        } else {
          size.estoque -= cartProduct.quantidade;
          productsToUpdate.add(product);
        }
      }

      if(productsWithoutStock.isNotEmpty){
        return Future.error(
            '${productsWithoutStock.length} produtos sem estoque');
      }

      for(final product in productsToUpdate){
        tx.update(firestore.document('produtos/${product.id}'),
            {'tamanhos': product.exportarListaTamanhos()});
      }
    });
  }

}