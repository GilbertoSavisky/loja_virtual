import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/models/produto_manager.dart';
import 'package:lojavirtualgigabyte/models/secao_item.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemTile extends StatelessWidget {

  final SecaoItem item;

  const ItemTile(this.item);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(item.produto != null) {
          final produto = context.read<ProdutoManager>().findProdutoById(item.produto);
          if(produto != null)
            Navigator.of(context).pushNamed('/produto', arguments: produto);
        }
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: item.image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
