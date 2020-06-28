import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
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
      initialValue: List.from(produto.imagens),
      validator: (imagem){
        if(imagem.isEmpty){
          return 'Insira pelo menos uma imagem';
        }
        return null;
      },
      onSaved: (imagens) => produto.novasImagens = imagens,
      builder: (state){
        void onImageSelected(File file){
          state.value.add(file);
          state.didChange(state.value);
          Navigator.of(context).pop();
        }

        return Column(
          children: [
            AspectRatio(
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
                      icon: Icon(Icons.add_photo_alternate),
                      color: primaryColor,
                      iconSize: 50,
                      onPressed: (){
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
                    ),
                  ),
                ),
                dotSize: 4,
                dotBgColor: Colors.transparent,
                dotColor: primaryColor,
                autoplay: false,
                dotSpacing: 15,
              ),
            ),
            if(state.hasError)
              Container(
                margin: EdgeInsets.only(top: 16, left: 16),
                  alignment: Alignment.centerLeft,
                  child: Text(state.errorText, style: TextStyle(color: Colors.red, fontSize: 12),)),
          ],
        );
      },
    );
  }
}
