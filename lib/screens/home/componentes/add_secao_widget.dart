import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/models/home_manager.dart';
import 'package:lojavirtualgigabyte/models/secao.dart';
import 'package:provider/provider.dart';

class AddSecaoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    return Row(
      children: [
        Expanded(
          child: FlatButton(
            onPressed: (){
              homeManager.addSecao(Secao(tipo: 'Lista'));
            },
            child: Text('Adicionar Lista'),
            textColor: Theme.of(context).primaryColor,
          ),
        ),
        Expanded(
          child: FlatButton(
            onPressed: (){
              homeManager.addSecao(Secao(tipo: 'Staggered'));
            },
            child: Text('Adicionar Grid'),
            textColor: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
