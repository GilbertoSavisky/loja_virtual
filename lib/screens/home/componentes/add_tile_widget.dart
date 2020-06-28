import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:lojavirtualgigabyte/models/secao.dart';
import 'package:lojavirtualgigabyte/models/secao_item.dart';
import 'package:lojavirtualgigabyte/screens/editar_produto/componentes/image_source_sheet.dart';

class AddTileWidget extends StatelessWidget {

  final Secao secao;

  AddTileWidget({this.secao});

  @override
  Widget build(BuildContext context) {

    void onImageSelected(File file){
      secao.addItem(SecaoItem(image: file));
      Navigator.of(context).pop();
    }

    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: (){
          if(Platform.isAndroid){
            showModalBottomSheet(
              context: context,
              builder: (_) => ImageSourceSheet(
                onImageSelected: onImageSelected,
              ),
            );
          } else {
            showCupertinoModalPopup(
              context: context,
              builder: (_) => ImageSourceSheet(
                onImageSelected: onImageSelected,
              ),
            );
          }
        },
        child: Container(
          color: Colors.white.withAlpha(30),
          child: Icon(
            FontAwesome5.plus,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
