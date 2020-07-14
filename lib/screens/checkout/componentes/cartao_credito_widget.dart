import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/screens/checkout/componentes/card_back.dart';
import 'package:lojavirtualgigabyte/screens/checkout/componentes/card_front.dart';

class CartaoCreditoWidget extends StatelessWidget {

  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  final FocusNode numFocus = FocusNode();
  final FocusNode dataFocus = FocusNode();
  final FocusNode nomeFocus = FocusNode();
  final FocusNode cvvFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FlipCard(
            key: cardKey,
            direction: FlipDirection.HORIZONTAL,
            speed: 700,
            flipOnTouch: false,
            front: CardFront(
                numFocus: numFocus,
                dataFocus: dataFocus,
                nomeFocus: nomeFocus,
              finish: (){
                cardKey.currentState.toggleCard();
                cvvFocus.requestFocus();
              },
            ),
            back: CardBack(
              cvvFocus: cvvFocus
            ),
          ),
          FlatButton(
            padding: EdgeInsets.zero,
            child: Text('Virar Cartão'),
            onPressed: (){
              cardKey.currentState.toggleCard();
            },
          ),
        ],
      ),
    );
  }
}
