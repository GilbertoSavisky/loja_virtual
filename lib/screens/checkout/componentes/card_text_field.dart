import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardTextField extends StatelessWidget {

  const CardTextField({
    Key key,
    this.titulo,
    this.bold,
    this.hint,
    this.tipoInput,
    this.inputFormaters,
    this.validator,
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.focusNode,
    this.onSubmitted,
    this.onSaved,
    this.valorInicial
  }) : textInputAction = onSubmitted == null ? TextInputAction.done : TextInputAction.next, super(key: key);

  final String titulo;
  final bool bold;
  final String hint;
  final TextInputType tipoInput;
  final List<TextInputFormatter> inputFormaters;
  final int maxLength;
  final TextAlign textAlign;
  final FocusNode focusNode;
  final Function(String) onSubmitted;
  final TextInputAction textInputAction;
  final FormFieldSetter<String> onSaved;
  final String valorInicial;

  final FormFieldValidator<String> validator;
  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: valorInicial,
      validator: validator,
      onSaved: onSaved,
      builder: (state){
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(titulo != null)
                Row(
                  children: [
                    Text(titulo, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.white),),
                    if(state.hasError)
                      Text(' Inválido', style: TextStyle(color: Colors.red, fontSize: 9),)
                  ],
                ),
              TextFormField(
                initialValue: valorInicial,
                style: TextStyle(
                  color: titulo == null && state.hasError ? Colors.red : Colors.white,
                  fontWeight: bold ? FontWeight.bold : FontWeight.w500,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: titulo == null && state.hasError ? Colors.red.withAlpha(200) : Colors.white.withAlpha(100)),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 2),
                    counterText: '',
                    border: InputBorder.none,
                ),
                textAlign: textAlign,
                keyboardType: tipoInput,
                inputFormatters:inputFormaters,
                onChanged: (texto){
                  state.didChange(texto);
                },
                maxLength: maxLength,
                focusNode: focusNode,
                onFieldSubmitted: onSubmitted,
                textInputAction: textInputAction,
              ),
            ],
          ),
        );
      },
    );
  }
}
