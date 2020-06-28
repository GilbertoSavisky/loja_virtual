import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:lojavirtualgigabyte/common/custon_drawer/custom_icon_button.dart';
import 'package:lojavirtualgigabyte/models/item_tamanho.dart';
import 'package:lojavirtualgigabyte/models/produto.dart';
import 'package:lojavirtualgigabyte/screens/editar_produto/componentes/edit_item_tamanho.dart';

class TamanhosForm extends StatelessWidget {

  final Produto produto;

  const TamanhosForm(this.produto);

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemTamanho>>(
      initialValue: produto.tamanhos,
      validator: (tamanhos){
        if(tamanhos.isEmpty){
          return 'Insira um tamanho';
        }
        else
          return null;
      },
      builder: (state){
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tamanhos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                CustomIconButton(
                  iconData: FontAwesome5.plus_square,
                  onTap: (){
                    state.value.add(ItemTamanho());
                    state.didChange(state.value);
                  },
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
            Column(
              children: state.value.map((tam) {
                return EditItemTamanho(
                  key: ObjectKey(tam),
                  tamanho: tam,
                  onRemove: (){
                    state.value.remove(tam);
                    state.didChange(state.value);
                  },
                  onMoveDown: tam != state.value.last ?(){
                    final index = state.value.indexOf(tam);
                    state.value.remove(tam);
                    state.value.insert(index + 1, tam);
                    state.didChange(state.value);
                  } : null,
                  onMoveUp: tam != state.value.first ? (){
                    final index = state.value.indexOf(tam);
                    state.value.remove(tam);
                    state.value.insert(index - 1, tam);
                    state.didChange(state.value);
                  } : null,
                );
              }).toList(),
            ),
            if(state.hasError)
              Container(
                alignment: Alignment.centerLeft,
                child: Text(state.errorText, style: TextStyle(color: Colors.red, fontSize: 12),),
              ),
          ],
        );
      },
    );
  }
}
