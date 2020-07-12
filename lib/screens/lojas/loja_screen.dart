import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/common/custon_drawer/custom_drawer.dart';
import 'package:lojavirtualgigabyte/models/lojas_manager.dart';
import 'package:lojavirtualgigabyte/screens/lojas/componentes/loja_card.dart';
import 'package:provider/provider.dart';

class LojaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Lojas'),
        centerTitle: true,
      ),
      body: Consumer<LojasManager>(
        builder: (_, lojasManager, __){
          if(lojasManager.lojas.isEmpty){
            return LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
              backgroundColor: Colors.transparent,
            );
          }
          return ListView.builder(
            itemCount: lojasManager.lojas.length,
            itemBuilder: (_, index){
              return LojaCard(loja: lojasManager.lojas[index]);
            },
          );
        },
      ),
    );
  }
}
