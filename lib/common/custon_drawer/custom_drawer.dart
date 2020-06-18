import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/common/custon_drawer/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerTile(iconData: Icons.home, titulo: 'Início', page: 0,),
          DrawerTile(iconData: Icons.list, titulo: 'Produtos', page: 1,),
          DrawerTile(iconData: Icons.playlist_add_check, titulo: 'Meus Pedidos', page: 2,),
          DrawerTile(iconData: Icons.location_on, titulo: 'Lojas', page: 3,),
        ],
      ),
    );
  }
}
