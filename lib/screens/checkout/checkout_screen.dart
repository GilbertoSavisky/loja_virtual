import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/common/custon_drawer/preco_card.dart';
import 'package:lojavirtualgigabyte/models/carrinho_manager.dart';
import 'package:lojavirtualgigabyte/models/checkout_manager.dart';
import 'package:provider/provider.dart';

class CheckOutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CarrinhoManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, carrinhoManager, checkOutManager) =>
        checkOutManager..updateCart(carrinhoManager),
      lazy: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pagamento'),
          centerTitle: true,
        ),
        body: Consumer<CheckoutManager>(
          builder: (_, checkOutManager, __){
            return ListView(
              children: [
                PrecoCard(
                  onPressed: (){
                    checkOutManager.checkout();
                  },
                  textoBotao: 'Finalizar Pedido',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
