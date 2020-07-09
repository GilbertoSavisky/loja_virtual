import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/common/custon_drawer/custom_drawer.dart';
import 'package:lojavirtualgigabyte/common/empty_card.dart';
import 'package:lojavirtualgigabyte/common/login_card.dart';
import 'package:lojavirtualgigabyte/common/pedidos_tile.dart';
import 'package:lojavirtualgigabyte/models/pedidos_manager.dart';
import 'package:provider/provider.dart';

class PedidosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text("Meus Pedidos"),
        centerTitle: true,
      ),
      body: Consumer<PedidosManager>(
        builder: (_, pedidosManager, __){
          if(pedidosManager.user == null){
            return LoginCard();
          }
          if(pedidosManager.pedidos.isEmpty){
            return EmptyCard(
              title: 'Nenhuma compra encontrada',
              iconData: Icons.border_clear,
            );
          }
          return ListView.builder(
            itemCount: pedidosManager.pedidos.length,
            itemBuilder: (_, index){
              return PedidosTile(
                  pedidosManager.pedidos.reversed.toList()[index],
              );
            },

          );
        },
      ),
    );
  }
}
