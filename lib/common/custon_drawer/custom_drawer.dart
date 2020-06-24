import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:lojavirtualgigabyte/common/custon_drawer/custom_drawer_header.dart';
import 'package:lojavirtualgigabyte/common/custon_drawer/drawer_tile.dart';
import 'package:lojavirtualgigabyte/models/user_manager.dart';
import 'package:provider/provider.dart';

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
              DrawerTile(iconData: FontAwesome5.store, titulo: 'Início', page: 0,),
              DrawerTile(iconData: FontAwesome5.cart_arrow_down, titulo: 'Produtos', page: 1,),
              DrawerTile(iconData: FontAwesome5.clipboard_check, titulo: 'Meus Pedidos', page: 2,),
              DrawerTile(iconData: FontAwesome5.map_marked_alt, titulo: 'Lojas', page: 3,),
              Consumer<UserManager>(
                builder: (_, userManager, __){
                  if(userManager.adminHabilitado){
                    return Column(
                      children: [
                        Divider(),
                        DrawerTile(iconData: FontAwesome5.users_cog, titulo: 'Usuários', page: 4,),
                        DrawerTile(iconData:  FontAwesome5.dolly, titulo: 'Pedidos', page: 5,),
                      ],
                    );
                  } else return Container();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
