import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:lojavirtualgigabyte/common/custom_icon_button.dart';
import 'package:lojavirtualgigabyte/common/pedido_produto_tile.dart';
import 'package:lojavirtualgigabyte/models/pedido.dart';
import 'package:lojavirtualgigabyte/screens/pedidos/componentes/cancelar_pedido_dialogo.dart';
import 'package:lojavirtualgigabyte/screens/pedidos/componentes/export_endereco_dialogo.dart';

class PedidosTile extends StatelessWidget {

  const PedidosTile(this.order, {this.showControls = false});

  final Pedido order;
  final bool showControls;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  order.formattedId,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                Text(
                  'R\$ ${order.preco.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Text(
              order.statusText,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: order.status == Status.CANCELADO ?
                  Colors.red : primaryColor,
                  fontSize: 14
              ),
            )
          ],
        ),
        children: <Widget>[
          Column(
            children: order.items.map((e){
              return PedidoProdutoTile(carrinhoProduto: e,);
            }).toList(),
          ),
          if(showControls && order.status != Status.CANCELADO)
            Container(
              height: 60,
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: [
                      CustomIconButton(
                        onTap: (){
                          showDialog(context: context,
                              barrierDismissible: false,
                              builder: (_) => CancelarPedidoDialogo(pedido: order,)
                          );
                        },
                        iconData: FontAwesome5.handshake_slash,
                        color: Colors.red[800],
                      ),
                      Text('Cancelar')
                    ],
                  ),
                  Column(
                    children: [
                      CustomIconButton(
                        onTap: order.recuar,
                        iconData: FontAwesome5.reply,
                        color: Colors.purpleAccent,
                      ),
                      Text('Recuar')
                    ],
                  ),
                  Column(
                    children: [
                      CustomIconButton(
                        onTap: order.avancar,
                        iconData: FontAwesome5.share,
                        color: Colors.purpleAccent,
                      ),
                      Text('Avançar')
                    ],
                  ),
                  Column(
                    children: [
                      CustomIconButton(
                        onTap: (){
                          showDialog(context: context,
                              builder: (_) => ExportEnderecoDialogo(endereco: order.endereco,)
                          );
                        },
                        iconData: FontAwesome5.address_card,
                        color: Colors.purpleAccent,
                      ),
                      Text('Endereço')
                    ],
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}