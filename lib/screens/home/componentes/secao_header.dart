import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:lojavirtualgigabyte/common/custom_icon_button.dart';
import 'package:lojavirtualgigabyte/models/home_manager.dart';
import 'package:lojavirtualgigabyte/models/secao.dart';
import 'package:provider/provider.dart';

class SecaoHeader extends StatelessWidget {

  final Secao secao;

  const SecaoHeader({this.secao});
  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    if(homeManager.editando){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: secao.nome,
                  decoration: InputDecoration(
                    hintText: 'Título',
                    isDense: true,
                    border: InputBorder.none
                  ),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                  onChanged: (texto) => secao.nome = texto,
                ),
              ),
              CustomIconButton(
                iconData: FontAwesome5.trash_alt,
                color: Theme.of(context).primaryColor,
                onTap: (){
                  homeManager.removeSecao(secao);
                },
              ),
            ],
          ),
          if(secao.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(secao.error, style: TextStyle(color: Colors.red, fontWeight: FontWeight.w800),),
            ),
        ],
      );
    }
    else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(secao.nome, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),),
      );
    }
  }
}
