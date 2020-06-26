import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/models/produto.dart';

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
            state.value.map((imagem){
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.remove),
                  ),
                ],
              );
            }).toList(),
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
