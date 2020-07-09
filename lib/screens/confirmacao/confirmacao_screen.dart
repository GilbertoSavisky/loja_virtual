import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/common/pedido_produto_tile.dart';
import 'package:lojavirtualgigabyte/models/pedido.dart';

class ConfirmacaoScreen extends StatelessWidget {

  const ConfirmacaoScreen(this.pedido);

  final Pedido pedido;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido ${pedido.formattedId} Confirmado'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      pedido.formattedId,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      'R\$ ${pedido.preco.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: pedido.items.map((e){
                  return PedidoProdutoTile(carrinhoProduto: e,);
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}