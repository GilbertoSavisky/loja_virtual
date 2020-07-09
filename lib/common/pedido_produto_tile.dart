import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/models/carrinho_produto.dart';

class PedidoProdutoTile extends StatelessWidget {

  final CarrinhoProduto carrinhoProduto;

  const PedidoProdutoTile({Key key, this.carrinhoProduto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed('/produto', arguments: carrinhoProduto.produto);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            SizedBox(height: 60, width: 60,
              child: Image.network(carrinhoProduto.produto.imagens.first),
            ),
            SizedBox(width: 8,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(carrinhoProduto.produto.nome,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),),
                  Text('Tamanho: ${carrinhoProduto.tamanho}',
                    style: TextStyle(fontWeight: FontWeight.w300),),
                  Text('Preço: ${carrinhoProduto.fixedPreco ?? carrinhoProduto.precoUnico.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).primaryColor),),
                ],
              ),
            ),
            Text('${carrinhoProduto.quantidade}', style: TextStyle(fontSize: 20),)
          ],
        ),
      ),
    );
  }
}
