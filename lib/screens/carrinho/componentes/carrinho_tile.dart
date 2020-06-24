import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/models/carrinho_produto.dart';

class CarrinhoTile extends StatelessWidget {

  final CarrinhoProduto carrinhoProduto;

  const CarrinhoTile(this.carrinhoProduto);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: Image.network(carrinhoProduto.produto.imagens.first),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  children: [
                    Text(carrinhoProduto.produto.nome,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text('Tamanho', style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    Text('R\$ ${carrinhoProduto.precoUnico.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
