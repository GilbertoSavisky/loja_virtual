import 'package:flutter/material.dart';
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
          return Column(
            children: carrinhoManger.itens.map((carrinhoProduto) => CarrinhoTile(carrinhoProduto)).toList(),
          );
        },
      ),
    );
  }
}
