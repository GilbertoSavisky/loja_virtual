import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/models/produto.dart';

class ProdutoListTile extends StatelessWidget {

  final Produto produto;

  const ProdutoListTile({this.produto});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed('/produto', arguments: produto);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Container(
          height: 100,
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.network(produto.imagens.first),
              ),
              const SizedBox(width: 16,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(produto.nome, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800), overflow: TextOverflow.ellipsis, maxLines: 2,),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text('A partir de', style: TextStyle(fontSize: 12, color: Colors.grey[400]),),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('R\$ ${produto.precoBase}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Theme.of(context).primaryColor),),
                        if(!produto.temEstoque)
                          Text('Sem estoque', style: TextStyle(color: Colors.red[800], fontSize: 11),)
                      ],
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
