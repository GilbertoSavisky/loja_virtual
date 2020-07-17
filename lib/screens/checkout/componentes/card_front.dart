import 'package:brasil_fields/brasil_fields.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lojavirtualgigabyte/models/cartao_credito.dart';
import 'package:lojavirtualgigabyte/screens/checkout/componentes/card_text_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CardFront extends StatelessWidget {

  CardFront({Key key, this.numFocus, this.nomeFocus, this.dataFocus, this.finish, this.cartaoCredito}) : super(key: key);

  final FocusNode numFocus;
  final FocusNode dataFocus;
  final FocusNode nomeFocus;
  final VoidCallback finish;
  final CartaoCredito cartaoCredito;

  final dataFormatter = MaskTextInputFormatter(
    mask: '!#/-###', filter: {'#': RegExp('[0-9]'), '!': RegExp('[0-1]'), '-': RegExp('[2]')}
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 16,
      child: Container(
        padding: EdgeInsets.all(24),
        height: 200,
        color: Colors.pink[900],
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CardTextField(
                    valorInicial: cartaoCredito.numero,
                    titulo: 'Número',
                    hint: '0000-0000-0000-0000',
                    tipoInput: TextInputType.number,
                    bold: true,
                    inputFormaters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      CartaoBancarioInputFormatter()
                    ],
                    onSaved: cartaoCredito.setNumero,
                    focusNode: numFocus,
                    onSubmitted: (_){
                      dataFocus.requestFocus();
                    },
                    validator: (num) {
                      if(num.length != 19){
                        return 'Inválido';
                      }
                      else if(detectCCType(num) == CreditCardType.unknown)
                        return 'Inválido';
                      return null;
                    },
                  ),
                  CardTextField(
                    valorInicial: cartaoCredito.dataValidade,
                    titulo: 'Validade',
                    hint: '01/2020',
                    tipoInput: TextInputType.number,
                    bold: false,
                    onSubmitted: (_){
                      nomeFocus.requestFocus();
                    },
                    focusNode: dataFocus,
                    onSaved: cartaoCredito.setDataValidade,
                    inputFormaters: [
                      dataFormatter
                    ],
                    validator: (data){
                      if(data.length != 7)
                        return 'Inválido';
                      return null;
                    },
                  ),
                  CardTextField(
                      valorInicial: cartaoCredito.titular,
                    titulo: 'Titular',
                    hint: 'Nome Completo',
                    tipoInput: TextInputType.text,
                    bold: true,
                    onSubmitted: (_){
                      finish();
                    },
                    focusNode: nomeFocus,
                    onSaved: cartaoCredito.setTitular,
                    validator: (nome){
                      if(nome.isEmpty)
                        return 'Inválido';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
