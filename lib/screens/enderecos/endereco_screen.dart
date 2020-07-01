import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/common/custon_drawer/preco_card.dart';
import 'package:lojavirtualgigabyte/models/carrinho_manager.dart';
import 'package:lojavirtualgigabyte/screens/enderecos/componentes/endereco_card.dart';
import 'package:provider/provider.dart';

class EnderecoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entrega'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        children: [
          EnderecoCard(),
          Consumer<CarrinhoManager>(
            builder: (_, carrinhoMamager, __){
              return PrecoCard(
                textoBotao: 'Continuar para o Pagamento',
                onPressed: carrinhoMamager.isEnderecoValido ? (){
                  Navigator.of(context).pushNamed('/checkout');
                } : null,
              );
            },
          ),
        ],
      ),
    );
  }
}
