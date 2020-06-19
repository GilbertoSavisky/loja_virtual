import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/common/custon_drawer/custom_drawer.dart';
import 'package:lojavirtualgigabyte/models/page_manager.dart';
import 'package:lojavirtualgigabyte/screens/login/login_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {

  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_)=> PageManager(pageController),
      child: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          LoginScreen(),
          Scaffold(
            drawer: CustomDrawer(),
            appBar: AppBar(title: Text('Produtos')),
          ),
          Scaffold(
            drawer: CustomDrawer(),
            appBar: AppBar(title: Text('Meus Pedidos')),
          ),
          Scaffold(
            drawer: CustomDrawer(),
            appBar: AppBar(title: Text('Lojas')),
          ),
        ],
      ),
    );
  }
}
