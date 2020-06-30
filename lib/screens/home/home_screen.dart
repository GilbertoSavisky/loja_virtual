import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:lojavirtualgigabyte/common/custon_drawer/custom_drawer.dart';
import 'package:lojavirtualgigabyte/models/home_manager.dart';
import 'package:lojavirtualgigabyte/models/user_manager.dart';
import 'package:lojavirtualgigabyte/screens/home/componentes/add_secao_widget.dart';
import 'package:lojavirtualgigabyte/screens/home/componentes/secao_lista.dart';
import 'package:lojavirtualgigabyte/screens/home/componentes/secao_staggered.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.pink[300],
                  Colors.white
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                snap: true,
                floating: true,
                backgroundColor: Colors.transparent,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text('Loja de Peças Íntimas'),
                  centerTitle: true,
                ),
                elevation: 0,
                actions: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    color: Colors.white,
                    onPressed: (){
                      Navigator.of(context).pushNamed('/carrinho');
                    },
                  ),
                  Consumer2<UserManager, HomeManager>(
                    builder: (_, userManager, homeManager, __){
                      if(userManager.adminHabilitado && !homeManager.loading){
                        if(homeManager.editando){
                          return PopupMenuButton(
                            itemBuilder: (_){
                              return ['Salvar', 'Descartar'].map((e) {
                                return PopupMenuItem(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(e == 'Salvar' ? FontAwesome5.check_circle : FontAwesome5.redo_alt, color: Theme.of(context).primaryColor,),
                                      Text(e),
                                    ],
                                  ),
                                  value: e,
                                );
                              }).toList();
                            },
                            onSelected: (e) {
                              if(e == 'Salvar'){
                                homeManager.salvarEdicao();
                              }
                              else {
                                homeManager.descartarEdicao();
                              }
                            },
                          );
                        } else {
                          return IconButton(
                            icon: Icon(FontAwesome5.edit),
                            onPressed: homeManager.entrarEdicao,
                          );
                        }
                      } else return Container();
                    },
                  ),
                ],
              ),
              Consumer<HomeManager>(
                builder: (_, homeManager, __){
                  if(homeManager.loading){
                    return SliverToBoxAdapter(
                      child: LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                        backgroundColor: Colors.transparent,
                      ),
                    );
                  }
                  final List<Widget> children = homeManager.secoes.map<Widget>((sec) {
                    switch(sec.tipo){
                      case 'Lista':
                        return SecaoLista(secao: sec);
                      case 'Staggered':
                        return SecaoStaggered(secao: sec);
                      default:
                        return Container();
                    }
                  }).toList();

                  if(homeManager.editando)
                    children.add(AddSecaoWidget());

                  return SliverList(
                    delegate: SliverChildListDelegate(children),
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
