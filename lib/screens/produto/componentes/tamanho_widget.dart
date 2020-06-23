import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/models/item_tamanho.dart';
import 'package:lojavirtualgigabyte/models/produto.dart';
import 'package:provider/provider.dart';

class TamanhoWidget extends StatelessWidget {

  final ItemTamanho tamanho;

  const TamanhoWidget({this.tamanho});

  @override
  Widget build(BuildContext context) {
    final produto = context.watch<Produto>();
    final selecionado = tamanho == produto.tamanhoSelecionado;

    Color color;
    if(!tamanho.temEstoque)
      color = Colors.red.withAlpha(50);
    else if(selecionado)
      color = Theme.of(context).primaryColor;
    else
      color = Colors.grey;

    return GestureDetector(
      onTap: (){
        if(tamanho.temEstoque)
          produto.tamanhoSelecionado = tamanho;
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: color
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                color: color,
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(tamanho.nome, style: TextStyle(color: Colors.white),),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('R\$ ${tamanho.preco.toStringAsFixed(2)}',
                style: TextStyle(
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
