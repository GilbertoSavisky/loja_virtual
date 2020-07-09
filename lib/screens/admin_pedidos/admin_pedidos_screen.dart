import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/common/custom_icon_button.dart';
import 'package:lojavirtualgigabyte/common/custon_drawer/custom_drawer.dart';
import 'package:lojavirtualgigabyte/common/empty_card.dart';
import 'package:lojavirtualgigabyte/common/pedidos_tile.dart';
import 'package:lojavirtualgigabyte/models/admin_pedidos_manager.dart';
import 'package:lojavirtualgigabyte/models/pedido.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AdminPedidosScreen extends StatefulWidget {

  @override
  _AdminPedidosScreenState createState() => _AdminPedidosScreenState();
}

class _AdminPedidosScreenState extends State<AdminPedidosScreen> {
  final PanelController panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Todos os Pedidos'),
        centerTitle: true,
      ),
      body: Consumer<AdminPedidosManager>(
        builder: (_, ordersManager, __){
          final filteredOrders = ordersManager.pedidosFiltrados;

          return SlidingUpPanel(
            controller: panelController,
            body: Column(
              children: <Widget>[
                if(ordersManager.userFilter != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Pedidos de ${ordersManager.userFilter.nome}',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        CustomIconButton(
                          iconData: Icons.close,
                          color: Colors.white,
                          onTap: (){
                            ordersManager.setUserFilter(null);
                          },
                        )
                      ],
                    ),
                  ),
                if(filteredOrders.isEmpty)
                  Expanded(
                    child: EmptyCard(
                      title: 'Nenhuma venda realizada!',
                      iconData: Icons.border_clear,
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                        itemCount: filteredOrders.length,
                        itemBuilder: (_, index){
                          return PedidosTile(
                            filteredOrders[index],
                            showControls: true,
                          );
                        }
                    ),
                  )
              ],
            ),
            minHeight: 40,
            maxHeight: 240,
            panel: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    if(panelController.isPanelClosed)
                      panelController.open();
                    else
                      panelController.close();
                  },
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    height: 40,
                    alignment: Alignment.center,
                    child: Text('Filtros',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: Status.values.map((e) {
                      return CheckboxListTile(
                        title: Text(Pedido.getStatusText(e)),
                        dense: true,
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (valor){
                          ordersManager.setStatusFiltro(
                            status: e,
                            enabled: valor
                          );
                        },
                        value: ordersManager.statusFiltro.contains(e),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}