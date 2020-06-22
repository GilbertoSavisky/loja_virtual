import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/common/custon_drawer/custom_drawer_header.dart';
import 'package:lojavirtualgigabyte/common/custon_drawer/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 203, 236, 241),
                  Colors.white
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
              ),
            ),
          ),
          ListView(
            children: [
              CustomDrawerHeader(),
              const Divider(),
              DrawerTile(iconData: Icons.home, titulo: 'Início', page: 0,),
              DrawerTile(iconData: Icons.list, titulo: 'Produtos', page: 1,),
              DrawerTile(iconData: Icons.playlist_add_check, titulo: 'Meus Pedidos', page: 2,),
              DrawerTile(iconData: Icons.location_on, titulo: 'Lojas', page: 3,),
            ],
          ),
        ],
      ),
    );
  }
}
