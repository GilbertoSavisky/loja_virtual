import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/models/admin_pedidos_manager.dart';
import 'package:lojavirtualgigabyte/models/admin_users_manager.dart';
import 'package:lojavirtualgigabyte/models/carrinho_manager.dart';
import 'package:lojavirtualgigabyte/models/home_manager.dart';
import 'package:lojavirtualgigabyte/models/lojas_manager.dart';
import 'package:lojavirtualgigabyte/models/pedido.dart';
import 'package:lojavirtualgigabyte/models/pedidos_manager.dart';
import 'package:lojavirtualgigabyte/models/produto.dart';
import 'package:lojavirtualgigabyte/models/produto_manager.dart';
import 'package:lojavirtualgigabyte/models/user_manager.dart';
import 'package:lojavirtualgigabyte/screens/base/base_screen.dart';
import 'package:lojavirtualgigabyte/screens/carrinho/carrinho_screen.dart';
import 'package:lojavirtualgigabyte/screens/checkout/checkout_screen.dart';
import 'package:lojavirtualgigabyte/screens/confirmacao/confirmacao_screen.dart';
import 'package:lojavirtualgigabyte/screens/editar_produto/editar_produto_screen.dart';
import 'package:lojavirtualgigabyte/screens/enderecos/endereco_screen.dart';
import 'package:lojavirtualgigabyte/screens/login/login_screen.dart';
import 'package:lojavirtualgigabyte/screens/produto/produto_screen.dart';
import 'package:lojavirtualgigabyte/screens/selecionar_produto/selecionar_produto_screen.dart';
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
          create: (_) => LojasManager(),
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
        ChangeNotifierProxyProvider<UserManager, PedidosManager>(
          create: (_) => PedidosManager(),
          lazy: false,
          update: (_, userManager, pedidosManager) =>
          pedidosManager..updateUser(userManager.user),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, adminUsersManager) => adminUsersManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminPedidosManager>(
          create: (_) => AdminPedidosManager(),
          lazy: false,
          update: (_, userManager, adminProdutosManager) => adminProdutosManager..updateAdmin(adminHabilitade: userManager.adminHabilitado),
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
                  builder: (_) => CarrinhoScreen(),
                  settings: settings
              );
            case '/endereco':
              return MaterialPageRoute(
                  builder: (_) => EnderecoScreen()
              );
            case '/confirmacao':
              return MaterialPageRoute(
                  builder: (_) => ConfirmacaoScreen(
                    settings.arguments as Pedido
                  )
              );
            case '/checkout':
              return MaterialPageRoute(
                  builder: (_) => CheckOutScreen()
              );
            case '/editar_produto':
              return MaterialPageRoute(
                  builder: (_) => EditarProdutoScreen(settings.arguments as Produto)
              );
            case '/selecionar_produto':
              return MaterialPageRoute(
                  builder: (_) => SelecionarProdutoScreen()
              );
            case '/produto':
              return MaterialPageRoute(
                  builder: (_) => ProdutoScreen(settings.arguments as Produto)
              );
            case '/':
            default:
              return MaterialPageRoute(
                builder: (_) => BaseScreen(),
                settings: settings
              );
          }
        },
      ),
    );
  }
}