import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/models/pedido.dart';

class CancelarPedidoDialogo extends StatefulWidget {

  final Pedido pedido;

  const CancelarPedidoDialogo({Key key, this.pedido}) : super(key: key);

  @override
  _CancelarPedidoDialogoState createState() => _CancelarPedidoDialogoState();
}

class _CancelarPedidoDialogoState extends State<CancelarPedidoDialogo> {

  bool loading = false;
  String error;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false) ,
      child: AlertDialog(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Cancelar ${widget.pedido.formattedId}?', style: TextStyle(color: loading ? Colors.grey : Colors.black),),
            loading ? LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                  Theme.of(context).primaryColor
              ),
              backgroundColor: Colors.grey[200],
            ) : Container()
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loading ? 'Cancelando...' : 'Esta ação não poderá ser desfeita!'),
            if(error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(error, style: TextStyle(color: Colors.red),),
              )
          ],
        ),
        actions: [
          Row(
            children: [
              FlatButton(
                onPressed: !loading ? (){
                  Navigator.of(context).pop();
                } : null,
                child: Text('Voltar'),
              ),

              FlatButton(
                onPressed: !loading ? () async {
                  setState(() {
                    loading = true;
                  });
                  try {
                    await widget.pedido.cancelar();
                    Navigator.of(context).pop();
                  } catch (e) {
                    setState(() {
                      loading = false;
                      error = e.toString();
                    });
                  }
                } : null,
                color: Colors.red[800],
                child: Text('Cancelar Pedido'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
