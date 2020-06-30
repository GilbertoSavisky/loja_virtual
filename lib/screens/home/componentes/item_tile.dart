import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/models/home_manager.dart';
import 'package:lojavirtualgigabyte/models/produto.dart';
import 'package:lojavirtualgigabyte/models/produto_manager.dart';
import 'package:lojavirtualgigabyte/models/secao.dart';
import 'package:lojavirtualgigabyte/models/secao_item.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemTile extends StatelessWidget {

  final SecaoItem item;

  const ItemTile(this.item);

  @override
  Widget build(BuildContext context) {
    final homeManger = context.watch<HomeManager>();
    return GestureDetector(
      onTap: (){
        if(item.produto != null) {
          final produto = context.read<ProdutoManager>().findProdutoById(item.produto);
          if(produto != null)
            Navigator.of(context).pushNamed('/produto', arguments: produto);
        }
      },
      onLongPress: homeManger.editando ? (){
        showDialog(
          context: context,
          builder: (_){
            final produto  = context.read<ProdutoManager>().findProdutoById(item.produto);
            return AlertDialog(
              content: produto != null ? ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(produto.nome),
                subtitle: Text('R\$ ${produto.precoBase.toStringAsFixed(2)}'),
                leading: Image.network(produto.imagens.first),
              ): null,
              title: Text('Editar Item'),
              actions: [
                FlatButton(
                  onPressed: (){
                    context.read<Secao>().removerItem(item);
                    Navigator.of(context).pop();
                  },
                  child: Text('Excluir'),
                  textColor: Colors.red,
                ),
                FlatButton(
                  onPressed: () async {
                    if(produto != null){
                      item.produto = null;
                    }
                    else {
                      final Produto produto = await Navigator.of(context).pushNamed('/selecionar_produto') as Produto;
                      item.produto = produto?.id;
                    }
                    Navigator.of(context).pop();
                  },
                  child: produto != null ? Text('Desvincular') : Text('Vincular'),
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            );
          }
        );
      } : null,
      child: AspectRatio(
        aspectRatio: 1,
        child: item.image is String ?
          FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: item.image,
          fit: BoxFit.cover,
        ) : Image.file(item.image as File, fit: BoxFit.cover,),
      ),
    );
  }
}
