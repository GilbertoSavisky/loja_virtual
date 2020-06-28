import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/models/admin_users_manager.dart';
import 'package:lojavirtualgigabyte/models/carrinho_manager.dart';
import 'package:lojavirtualgigabyte/models/home_manager.dart';
import 'package:lojavirtualgigabyte/models/produto.dart';
import 'package:lojavirtualgigabyte/models/produto_manager.dart';
import 'package:lojavirtualgigabyte/models/user_manager.dart';
import 'package:lojavirtualgigabyte/screens/base/base_screen.dart';
import 'package:lojavirtualgigabyte/screens/carrinho/carrinho_screen.dart';
import 'package:lojavirtualgigabyte/screens/editar_produto/editar_produto_screen.dart';
import 'package:lojavirtualgigabyte/screens/login/login_screen.dart';
import 'package:lojavirtualgigabyte/screens/produto/produto_screen.dart';
import 'package:lojavirtualgigabyte/screens/signup/signup_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProdutoManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CarrinhoManager>(
          create: (_) => CarrinhoManager(),
          lazy: false,
          update: (_, userManager, carrinhoManager) =>
            carrinhoManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userMamanger, adminUsersManager) => adminUsersManager..updateUser(userMamanger),
        ),
      ],
      child: MaterialApp(
        title: 'Loja de Peças Íntimas',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.pinkAccent[200],
          scaffoldBackgroundColor: Colors.pink[100],
          appBarTheme: const AppBarTheme(
              elevation: 0
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/base',
        onGenerateRoute: (settings){
          switch(settings.name){
            case '/login':
              return MaterialPageRoute(
                  builder: (_) => LoginScreen()
              );
            case '/signup':
              return MaterialPageRoute(
                  builder: (_) => SignUpScreen()
              );
            case '/carrinho':
              return MaterialPageRoute(
                  builder: (_) => CarrinhoScreen()
              );
            case '/editar_produto':
              return MaterialPageRoute(
                  builder: (_) => EditarProduto(settings.arguments as Produto)
              );
            case '/produto':
              return MaterialPageRoute(
                  builder: (_) => ProdutoScreen(settings.arguments as Produto)
              );
            case '/base':
            default:
              return MaterialPageRoute(
                  builder: (_) => BaseScreen()
              );
          }
        },
      ),
    );
  }
}