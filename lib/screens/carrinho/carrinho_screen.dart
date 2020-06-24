import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/common/custon_drawer/preco_card.dart';
import 'package:lojavirtualgigabyte/models/carrinho_manager.dart';
import 'package:lojavirtualgigabyte/screens/carrinho/componentes/carrinho_tile.dart';
import 'package:provider/provider.dart';

class CarrinhoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        centerTitle: true,
      ),
      body: Consumer<CarrinhoManager>(
        builder: (_, carrinhoManger, __){
          return ListView(
            children: [
              Column(
                children: carrinhoManger.itens.map((carrinhoProduto) => CarrinhoTile(carrinhoProduto)).toList(),
              ),
              PrecoCard(
                onPressed: carrinhoManger.isCarrinhoValido ? (){} : null,
                textoBotao: 'Continuar para a Entrega',
              ),
            ],
          );
        },
      ),
    );
  }
}
