import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/common/preco_card.dart';
import 'package:lojavirtualgigabyte/models/carrinho_manager.dart';
import 'package:lojavirtualgigabyte/models/checkout_manager.dart';
import 'package:lojavirtualgigabyte/screens/checkout/componentes/cartao_credito_widget.dart';
import 'package:provider/provider.dart';

class CheckOutScreen extends StatelessWidget {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
            if(checkOutManager.loading){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text('Processando seu pagamento...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),)
                  ],
                ),
              );
            }
            return Form(
              key: formKey,
              child: ListView(
                children: [
                  CartaoCreditoWidget(),
                  PrecoCard(
                    onPressed: (){
                      if(formKey.currentState.validate()){
                        print('enviar');
//                        checkOutManager.checkout(
//                            onEstoqueFail: (e){
//                              scaffoldKey.currentState.showSnackBar(
//                                  SnackBar(
//                                    content: Text('Não há estoque suficiente'),
//                                    backgroundColor: Colors.red[800],
//                                    duration: Duration(seconds: 2),
//                                  )
//                              );
//                              Navigator.of(context).popUntil((route) => route.settings.name == '/carrinho');
//                            },
//                            onSuccess: (pedido){
//                              Navigator.of(context).popUntil((route) => route.settings.name == '/');
//                              Navigator.of(context).pushNamed('/confirmacao', arguments: pedido);
//                            }
//                        );
                      }

                    },
                    textoBotao: 'Finalizar Pedido',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
