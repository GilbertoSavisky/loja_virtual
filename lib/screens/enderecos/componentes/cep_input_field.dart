import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:lojavirtualgigabyte/common/custon_drawer/custom_icon_button.dart';
import 'package:lojavirtualgigabyte/models/carrinho_manager.dart';
import 'package:lojavirtualgigabyte/models/endereco.dart';
import 'package:provider/provider.dart';

class CepInputField extends StatefulWidget {

  CepInputField({Key key, this.endereco}) : super(key: key);

  final Endereco endereco;

  @override
  _CepInputFieldState createState() => _CepInputFieldState();
}

class _CepInputFieldState extends State<CepInputField> {
  final TextEditingController cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final carrinhoManager = context.watch<CarrinhoManager>();

    if(widget.endereco.CEP == null)

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            enabled: !carrinhoManager.loading,
            controller: cepController,
            decoration: InputDecoration(
              isDense: true,
              labelText: 'Cep',
              hintText: '12.345-678'
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
              CepInputFormatter(),
            ],
            validator: (cep){
              if(cep.isEmpty){
                return 'Campo obrigatório';
              }
              else if(cep.length != 10){
                return 'Cep inválido';
              }
              return null;
            },

          ),

          if(carrinhoManager.loading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
              backgroundColor: Colors.white,
            ),
          RaisedButton(
            onPressed: !carrinhoManager.loading ? () async {
              if(Form.of(context).validate()){
                try {
                  await context.read<CarrinhoManager>().getEndereco(
                      cepController.text);
                } catch(e){
                  Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$e'),
                        backgroundColor: Colors.red[800],
                      )
                  );

                }
              }
            } : null,
            color: primaryColor,
            disabledColor: primaryColor.withAlpha(100),
            child: Text('Buscar CEP',),
            textColor: Colors.white,
          ),
        ],
      );
    else
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
                child: Text('CEP: ${widget.endereco.CEP}', style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),)),
            CustomIconButton(
              iconData: FontAwesome5.edit,
              color: primaryColor,
              tamanho: 20,
              onTap: (){
                context.read<CarrinhoManager>().removeEndereco();
              },
            ),
          ],
        ),
      );
  }
}
