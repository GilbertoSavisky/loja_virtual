import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lojavirtualgigabyte/models/home_manager.dart';
import 'package:lojavirtualgigabyte/models/secao.dart';
import 'package:lojavirtualgigabyte/screens/home/componentes/add_tile_widget.dart';
import 'package:lojavirtualgigabyte/screens/home/componentes/item_tile.dart';
import 'package:lojavirtualgigabyte/screens/home/componentes/secao_header.dart';
import 'package:provider/provider.dart';

class SecaoStaggered extends StatelessWidget {

  final Secao secao;

  const SecaoStaggered({this.secao});

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return ChangeNotifierProvider.value(
      value: secao,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SecaoHeader(secao: secao),
            Consumer<Secao>(
              builder: (_, sec, __){
                return StaggeredGridView.countBuilder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  itemCount: homeManager.editando ? secao.itens.length + 1 : secao.itens.length,
                  itemBuilder: (_, index){
                    if(index < secao.itens.length)
                      return ItemTile(secao.itens[index]);
                    else
                      return AddTileWidget(secao: secao,);

                  },
                  staggeredTileBuilder: (index){
                    return StaggeredTile.count(2, index.isEven ? 2 : 1);
                  },
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
