import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lojavirtualgigabyte/common/custon_drawer/custom_drawer.dart';
import 'package:lojavirtualgigabyte/models/page_manager.dart';
import 'package:lojavirtualgigabyte/models/user_manager.dart';
import 'package:lojavirtualgigabyte/screens/admin_pedidos/admin_pedidos_screen.dart';
import 'package:lojavirtualgigabyte/screens/admin_users/admin_users_screen.dart';
import 'package:lojavirtualgigabyte/screens/home/home_screen.dart';
import 'package:lojavirtualgigabyte/screens/pedidos/pedidos_screen.dart';
import 'package:lojavirtualgigabyte/screens/produtos/produtos_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();


  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_)=> PageManager(pageController),
      child: Consumer<UserManager>(
        builder: (_, userManager, __){
          return PageView(
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              HomeScreen(),
              ProdutosScreen(),
              PedidosScreen(),
              Scaffold(
                drawer: CustomDrawer(),
                appBar: AppBar(title: Text('Lojas')),
              ),
              if(userManager.adminHabilitado)
                ...[
                  AdminUsersScreen(),
                  AdminPedidosScreen(),
                ],
            ],
          );
        },
      ),
    );
  }
}
