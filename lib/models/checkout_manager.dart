import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtualgigabyte/models/carrinho_manager.dart';
import 'package:lojavirtualgigabyte/models/produto.dart';

class CheckoutManager extends ChangeNotifier {

  CarrinhoManager cartManager;

  final Firestore firestore = Firestore.instance;

  // ignore: use_setters_to_change_properties
  void updateCart(CarrinhoManager cartManager){
    this.cartManager = cartManager;
  }

  Future<void> checkout() async {
    try {
      await _decrementStock();
    } catch (e){
      debugPrint(e.toString());
    }

    _getOrderId().then((value) => print(value));
  }

  Future<int> _getOrderId() async {
    final ref = firestore.document('aux/ordercounter');

    try {
      final result = await firestore.runTransaction((tx) async {
        final doc = await tx.get(ref);
        final orderId = doc.data['current'] as int;
        await tx.update(ref, {'current': orderId + 1});
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
              firestore.document('products/${cartProduct.produtoId}')
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
        tx.update(firestore.document('products/${product.id}'),
            {'sizes': product.exportarListaTamanhos()});
      }
    });
  }

}