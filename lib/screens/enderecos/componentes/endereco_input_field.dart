import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lojavirtualgigabyte/models/carrinho_manager.dart';
import 'package:lojavirtualgigabyte/models/endereco.dart';
import 'package:provider/provider.dart';

class EnderecoInputField extends StatelessWidget {

  final Endereco endereco;

  const EnderecoInputField({Key key, this.endereco}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    String emptyValidator(String texto) => texto.isEmpty ? 'Campo obrigatório' : null;
    final primaryColor = Theme.of(context).primaryColor;
    final carrinhoManager = context.watch<CarrinhoManager>();

    if(endereco.CEP != null && carrinhoManager.precoEntraga == null)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            enabled: !carrinhoManager.loading,
            initialValue: endereco.rua,
            decoration: InputDecoration(
              isDense: true,
              labelText: 'Rua/Avenida',
              hintText: 'Av. Brasil'
            ),
            onSaved: (t) => endereco.rua = t,
            validator: emptyValidator,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  enabled: !carrinhoManager.loading,
                  initialValue: endereco.numero,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Número',
                    hintText: '123'
                  ),
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  onSaved: (t) => endereco.numero = t,
                  validator: emptyValidator,
                ),
              ),
              SizedBox(width: 16,),
              Expanded(
                child: TextFormField(
                  enabled: !carrinhoManager.loading,
                  initialValue: endereco.complemento,
                  decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Complemento',
                      hintText: 'Opcional'
                  ),
                  onSaved: (t) => endereco.complemento = t,
                ),
              ),
            ],
          ),
          TextFormField(
            enabled: !carrinhoManager.loading,
            initialValue: endereco.bairro,
            decoration: InputDecoration(
                isDense: true,
                labelText: 'Bairro',
                hintText: 'Centro'
            ),
            validator: emptyValidator,
            onSaved: (t) => endereco.bairro = t,
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  enabled: false,
                  initialValue: endereco.cidade,
                  decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Cidade',
                      hintText: 'Curitiba'
                  ),
                  onSaved: (t) => endereco.cidade = t,
                  validator: emptyValidator,
                ),
              ),
              SizedBox(width: 16,),
              Expanded(
                child: TextFormField(
                  enabled: false,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.characters,
                  initialValue: endereco.estado,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'UF',
                    hintText: 'PR',
                    counterText: ''
                  ),
                  maxLength: 2,
                  onSaved: (t) => endereco.estado = t,
                  validator: (t){
                    if(t.isEmpty){
                      return 'Campo obrigatório';
                    }
                    else if(t.length != 2){
                      return 'Inválido';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 8,),
          if(carrinhoManager.loading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
              backgroundColor: Colors.white,
            ),

          RaisedButton(
            color: primaryColor,
            disabledColor: primaryColor.withAlpha(100),
            textColor: Colors.white,
            onPressed: !carrinhoManager.loading ? () async {
              if(Form.of(context).validate()){
                Form.of(context).save();
                try {
                  await context.read<CarrinhoManager>().setEndereco(endereco);
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
            child: const Text('Calcular Frete'),
          ),
        ],
      );
    else if(endereco.CEP != null)
      return                     Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Text('${endereco.rua}, ${endereco.numero}\n${endereco.bairro}, ${endereco.cidade} - ${endereco.estado}'),
      );
    else return Container();
  }
}
