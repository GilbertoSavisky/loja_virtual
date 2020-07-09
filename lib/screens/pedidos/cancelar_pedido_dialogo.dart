import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/models/pedido.dart';

class CancelarPedidoDialogo extends StatelessWidget {

  final Pedido pedido;

  const CancelarPedidoDialogo({Key key, this.pedido}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cancelar ${pedido.formattedId}?'),
      content: Text('Esta ação não poderá ser desfeita!'),
      actions: [
        Row(
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
                pedido.cancelar();
                Navigator.of(context).pop();
              },
              color: Colors.red[800],
              child: Text('Cancelar Pedido'),
            ),

          ],
        ),
      ],
    );
  }
}
