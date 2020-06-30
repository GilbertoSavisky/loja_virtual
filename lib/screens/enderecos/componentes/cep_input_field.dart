import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lojavirtualgigabyte/models/carrinho_manager.dart';
import 'package:provider/provider.dart';

class CepInputField extends StatelessWidget {

  final TextEditingController cepController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
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
        RaisedButton(
          onPressed: (){
            if(Form.of(context).validate()){
              context.read<CarrinhoManager>().getEndereco(cepController.text);
            }
          },
          color: primaryColor,
          disabledColor: primaryColor.withAlpha(100),
          child: Text('Buscar CEP',),
          textColor: Colors.white,
        ),
      ],
    );
  }
}
