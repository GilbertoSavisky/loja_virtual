import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lojavirtualgigabyte/models/secao.dart';
import 'package:lojavirtualgigabyte/screens/home/componentes/item_tile.dart';
import 'package:lojavirtualgigabyte/screens/home/componentes/secao_header.dart';

class SecaoLista extends StatelessWidget {

  final Secao secao;

  const SecaoLista({this.secao});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SecaoHeader(secao: secao),
          SizedBox(height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index){
                return ItemTile(secao.itens[index]);
              },
              separatorBuilder: (_,__) => SizedBox(width: 4,),
              itemCount: secao.itens.length,
            ),
          ),
        ],
      ),
    );
  }
}
