import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/models/carrinho_manager.dart';
import 'package:provider/provider.dart';

class PrecoCard extends StatelessWidget {

  final String textoBotao;
  final VoidCallback onPressed;

  const PrecoCard({this.onPressed, this.textoBotao});

  @override
  Widget build(BuildContext context) {
    final carrinhoManager = context.watch<CarrinhoManager>();
    final precoProdutos = carrinhoManager.precoProdutos;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Resumo do Pedido', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
            SizedBox(height: 12,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('SubTotal'),
                Text('R\$ ${precoProdutos.toStringAsFixed(2)}'),
              ],
            ),
            const Divider(),
            const SizedBox(height: 12,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: TextStyle(fontWeight: FontWeight.w500),),
                Text('R\$ ${precoProdutos.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),),
              ],
            ),
            const SizedBox(height: 8,),
            RaisedButton(
              disabledColor: Theme.of(context).primaryColor.withAlpha(100),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: onPressed,
              child: Text(textoBotao),
            ),
          ],
        ),
      ),
    );
  }
}
