import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/common/custon_drawer/preco_card.dart';
import 'package:lojavirtualgigabyte/models/carrinho_manager.dart';
import 'package:lojavirtualgigabyte/models/checkout_manager.dart';
import 'package:provider/provider.dart';

class CheckOutScreen extends StatelessWidget {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
        key: scaffoldKey,
        body: Consumer<CheckoutManager>(
          builder: (_, checkOutManager, __){
            return ListView(
              children: [
                PrecoCard(
                  onPressed: (){
                    checkOutManager.checkout(
                      onEstoqueFail: (e){
                        scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text('Não há estoque suficiente'),
                            backgroundColor: Colors.red[800],
                            duration: Duration(seconds: 2),
                          )
                        );
                        Navigator.of(context).popUntil((route) => route.settings.name == '/carrinho');
                      }
                    );
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
