import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lojavirtualgigabyte/models/cartao_credito.dart';
import 'package:lojavirtualgigabyte/screens/checkout/componentes/card_text_field.dart';

class CardBack extends StatelessWidget {

  final FocusNode cvvFocus;
  final CartaoCredito cartaoCredito;

  const CardBack({Key key, this.cvvFocus, this.cartaoCredito}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 16,
      child: Container(
        height: 200,
        color: Colors.pink[900],
        child: Column(
          children: [
            Container(
              color: Colors.black,
              margin: EdgeInsets.symmetric(vertical: 16),
              height: 40,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 70,
                  child: Container(
                    margin: EdgeInsets.only(left: 12),
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    color: Colors.grey[500],
                    child: CardTextField(
                        valorInicial: cartaoCredito.codigoSeguranca,
                      hint: '123',
                      bold: false,
                      tipoInput: TextInputType.number,
                      textAlign: TextAlign.end,
                      maxLength: 3,
                      focusNode: cvvFocus,
                      inputFormaters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                      ],
                      onSaved: cartaoCredito.setCodigoSeguranca,
                      validator: (cvv){
                        if(cvv.isEmpty || cvv.length != 3)
                          return 'Inválido';
                        return null;
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 30,
                  child: Container(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
