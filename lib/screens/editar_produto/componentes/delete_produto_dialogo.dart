import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/models/produto.dart';
import 'package:lojavirtualgigabyte/models/produto_manager.dart';
import 'package:screenshot/screenshot.dart';
import 'package:provider/provider.dart';

class DeleteProdutoDialogo extends StatelessWidget {

  final Produto produto;

  final ScreenshotController screenshotController = ScreenshotController();

  DeleteProdutoDialogo({Key key, this.produto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Excluir ${produto.nome}?'),
      content: Text('Esta ação não poderá ser desfeita!'),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlatButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text('cancelar', style: TextStyle(color: Theme.of(context).primaryColor),),
              ),
              Container(
                width: 80,
              ),
              FlatButton(
                onPressed: (){
                  context.read<ProdutoManager>().delete(produto);
                  Navigator.of(context).pop();
                },
                color: Colors.red[800],
                child: Text('Excluir Produto'),
              ),

            ],
          ),
        ),
      ],
    );
  }
}
