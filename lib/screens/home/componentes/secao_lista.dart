import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lojavirtualgigabyte/models/home_manager.dart';
import 'package:lojavirtualgigabyte/models/secao.dart';
import 'package:lojavirtualgigabyte/screens/home/componentes/add_tile_widget.dart';
import 'package:lojavirtualgigabyte/screens/home/componentes/item_tile.dart';
import 'package:lojavirtualgigabyte/screens/home/componentes/secao_header.dart';
import 'package:provider/provider.dart';

class SecaoLista extends StatelessWidget {

  final Secao secao;

  const SecaoLista({this.secao});

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
            SizedBox(height: 150,
              child: Consumer<Secao>(
                builder: (_, secao, __){
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index){
                      if(index < secao.itens.length)
                        return ItemTile(secao.itens[index]);
                      else
                        return AddTileWidget(secao: secao,);
                    },
                    separatorBuilder: (_,__) => SizedBox(width: 4,),
                    itemCount: homeManager.editando ? secao.itens.length + 1 : secao.itens.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
