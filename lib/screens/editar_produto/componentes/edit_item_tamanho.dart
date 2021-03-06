
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:lojavirtualgigabyte/common/custom_icon_button.dart';
import 'package:lojavirtualgigabyte/models/item_tamanho.dart';

class EditItemTamanho extends StatelessWidget {

  final ItemTamanho tamanho;
  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;

  const EditItemTamanho({Key key, this.tamanho, this.onRemove, this.onMoveDown, this.onMoveUp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 25,
          child: TextFormField(
            initialValue: tamanho.nome,
            decoration: InputDecoration(
              labelText: 'Título',
              isDense: true,
            ),
            validator: (nome){
              if(nome.isEmpty)
                return 'inválido';
              else
                return null;
            },
            onChanged: (nome) => tamanho.nome = nome,
          ),
        ),
        SizedBox(width: 4,),
        Expanded(
          flex: 25,
          child: TextFormField(
            initialValue: tamanho.estoque?.toString(),
            decoration: InputDecoration(
              labelText: 'Estoque',
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            validator: (estoque){
              if(int.tryParse(estoque) == null)
                return 'Inválido';
              else
                return null;
            },
            onChanged: (estoque) => tamanho.estoque = int.tryParse(estoque),

          ),
        ),
        SizedBox(width: 4,),
        Expanded(
          flex: 50,
          child: TextFormField(
            initialValue: tamanho.preco?.toStringAsFixed(2),
            decoration: InputDecoration(
              labelText: 'Preço',
              isDense: true,
              prefix: Text ('R\$ '),
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (preco){
              if(num.tryParse(preco) == null)
                return 'Inválido';
              else
                return null;

            },
            onChanged: (preco) => tamanho.preco = num.tryParse(preco),

          ),
        ),
        CustomIconButton(
          color: Colors.red,
          onTap: onRemove,
          iconData: FontAwesome5.minus,

        ),
        CustomIconButton(
          color: Theme.of(context).primaryColor,
          onTap: onMoveUp,
          iconData: FontAwesome5.arrow_alt_circle_up,

        ),
        CustomIconButton(
          color: Theme.of(context).primaryColor,
          onTap: onMoveDown,
          iconData: FontAwesome5.arrow_alt_circle_down,

        ),
      ],
    );
  }
}
