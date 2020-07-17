import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lojavirtualgigabyte/models/page_manager.dart';
import 'package:lojavirtualgigabyte/models/user_manager.dart';
import 'package:lojavirtualgigabyte/screens/admin_pedidos/admin_pedidos_screen.dart';
import 'package:lojavirtualgigabyte/screens/admin_users/admin_users_screen.dart';
import 'package:lojavirtualgigabyte/screens/home/home_screen.dart';
import 'package:lojavirtualgigabyte/screens/lojas/loja_screen.dart';
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

    configFCM();
  }

  void configFCM(){
    final fcm = FirebaseMessaging();

    if(Platform.isIOS){
      fcm.requestNotificationPermissions(
        const IosNotificationSettings(provisional: true)
      );
    }
    fcm.configure(
      onLaunch: (Map<String, dynamic> mensagem) async {
        print('onLaunch: $mensagem');
      },
      onResume: (Map<String, dynamic> mensagem) async {
        print('onResume: $mensagem');
      },
      onMessage: (Map<String, dynamic> mensagem) async {
        showNotification(
          mensagem['notification']['title'] as String,
          mensagem['notification']['body'] as String
        );
      }
    );
  }
  
  void showNotification(String titulo, String mensagem) {
    Flushbar(
      title: titulo,
      message: mensagem,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      isDismissible: true,
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 5),
      icon: Icon(Icons.shopping_cart, color: Colors.white,),

    ).show(context);
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
              LojaScreen(),
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
