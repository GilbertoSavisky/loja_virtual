import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:lojavirtualgigabyte/models/produto.dart';
import 'package:lojavirtualgigabyte/screens/editar_produto/componentes/imagens_form.dart';

class EditarProduto extends StatelessWidget {

  final Produto produto;

  EditarProduto(this.produto);

  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Anúncio'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: fromKey,
        child: ListView(
          children: [
            ImagensForm(produto),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    initialValue: produto.nome,
                    decoration: InputDecoration(
                      hintText: 'Título',
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    validator: (nome){
                      if(nome.length < 6)
                        return 'Título muito curto';
                    },
                  ),
                  RaisedButton(
                    onPressed: (){
                      if(fromKey.currentState.validate())
                        print('valido');
                      else
                        print('invalido');
                    },
                    child: Text('Salvar'),
                    color: Theme.of(context).primaryColor,

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