import 'package:flutter/material.dart';

class DialogoPesquisa extends StatelessWidget {

  final String texto;

  DialogoPesquisa(this.texto);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 2, left: 4, right: 4,
          child: Card(
            child: TextFormField(
              initialValue: texto,
              textInputAction: TextInputAction.search,
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                prefixIcon: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
              ),
              onFieldSubmitted: (texto){
                Navigator.of(context).pop(texto);
              },
            ),
          ),
        ),
      ],
    );
  }
}
