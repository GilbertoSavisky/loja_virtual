import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/models/carrinho_manager.dart';
import 'package:lojavirtualgigabyte/models/produto.dart';
import 'package:lojavirtualgigabyte/models/produto_manager.dart';
import 'package:lojavirtualgigabyte/models/user_manager.dart';
import 'package:lojavirtualgigabyte/screens/base/base_screen.dart';
import 'package:lojavirtualgigabyte/screens/carrinho/carrinho_screen.dart';
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
        ProxyProvider<UserManager, CarrinhoManager>(
          create: (_) => CarrinhoManager(),
          lazy: false,
          update: (_, userManager, carrinhoManager) =>
            carrinhoManager..updateUser(userManager),
        ),
      ],
      child: MaterialApp(
        title: 'Loja do Daniel',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 4, 125, 141),
          scaffoldBackgroundColor: const Color.fromARGB(255, 4, 125, 141),
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