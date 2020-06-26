import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/fontelico_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:lojavirtualgigabyte/models/produto.dart';
import 'package:lojavirtualgigabyte/screens/editar_produto/componentes/image_source_sheet.dart';

class ImagensForm extends StatelessWidget {

  final Produto produto;

  const ImagensForm(this.produto);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return FormField<List<dynamic>>(
      initialValue: produto.imagens,
      builder: (state){
        return AspectRatio(
          aspectRatio: 1,
          child: Carousel(
            images:
            state.value.map<Widget>((imagem){
              return Stack(
                children: [
                  if(imagem is String)
                    Image.network(imagem)
                  else
                    Image.file(imagem as File),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(FontAwesome5.trash_alt ),
                      color: Colors.red,
                      onPressed: (){
                        state.value.remove(imagem);
                        state.didChange(state.value);
                      },
                    ),
                  ),
                ],
              );
            }).toList()..add(
              Material(
                color: Colors.grey[100],
                child: IconButton(
                  icon: Icon(Icons.add_a_photo),
                  color: primaryColor,
                  iconSize: 50,
                  onPressed: (){
                    showModalBottomSheet(
                        context: context,
                        builder: (_) => ImageSourceSheet(),
                    );
                  },
                ),
              ),
            ),
            dotSize: 4,
            dotBgColor: Colors.transparent,
            dotColor: primaryColor,
            autoplay: false,
            dotSpacing: 15,
          ),
        );
      },
    );
  }
}
