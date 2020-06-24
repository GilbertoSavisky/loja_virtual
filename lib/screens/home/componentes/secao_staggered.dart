import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lojavirtualgigabyte/models/secao.dart';
import 'package:lojavirtualgigabyte/screens/home/componentes/item_tile.dart';
import 'package:lojavirtualgigabyte/screens/home/componentes/secao_header.dart';

class SecaoStaggered extends StatelessWidget {

  final Secao secao;

  const SecaoStaggered({this.secao});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SecaoHeader(secao: secao),
          StaggeredGridView.countBuilder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            crossAxisCount: 4,
            itemCount: secao.itens.length,
            itemBuilder: (_, index){
              return ItemTile(secao.itens[index]);
            },
            staggeredTileBuilder: (index){
              return StaggeredTile.count(2, index.isEven ? 2 : 1);
            },
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
        ],
      ),
    );
  }
}
