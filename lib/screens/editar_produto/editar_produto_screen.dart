import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:lojavirtualgigabyte/models/produto.dart';
import 'package:lojavirtualgigabyte/screens/editar_produto/componentes/imagens_form.dart';
import 'package:lojavirtualgigabyte/screens/editar_produto/componentes/tamanho_form.dart';

class EditarProduto extends StatelessWidget {

  final Produto produto;

  EditarProduto(this.produto);

  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

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
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('A partir de', style: TextStyle(fontSize: 13, color: Colors.grey[600]),),
                  ),
                  Text('R\$ ...', style: TextStyle(fontSize: 22, color: primaryColor, fontWeight: FontWeight.bold),),
                  Padding(
                    padding: EdgeInsets.only(top: 16, ),
                    child: Text('Descrição', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  ),
                  TextFormField(
                    initialValue: produto.descricao,
                    style: TextStyle(
                      fontSize: 16
                    ),
                    decoration: InputDecoration(
                      hintText: 'Descrição',
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    validator: (desc){
                      if(desc.length < 10){
                        return 'Descrição muito curta!';
                      }
                      else
                        return null;
                    },
                  ),
                  TamanhosForm(produto),
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
