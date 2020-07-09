import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/models/produto.dart';
import 'package:lojavirtualgigabyte/models/produto_manager.dart';
import 'package:lojavirtualgigabyte/screens/editar_produto/componentes/delete_produto_dialogo.dart';
import 'package:lojavirtualgigabyte/screens/editar_produto/componentes/imagens_form.dart';
import 'package:lojavirtualgigabyte/screens/editar_produto/componentes/tamanho_form.dart';
import 'package:provider/provider.dart';

class EditarProdutoScreen extends StatelessWidget {

  final Produto produto;

  EditarProdutoScreen(Produto p) :
        editando = p != null,
        produto = p != null ? p.clone() : Produto();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final bool editando;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: produto,

      child: Scaffold(
        appBar: AppBar(
          title: Text(editando ? 'Editar Produto' : 'Criar Produto'),
          centerTitle: true,
          actions: [
            if(editando)
              IconButton(
                onPressed: () async {
                  await showDialog(context: context,
                      builder: (_) => DeleteProdutoDialogo(produto: produto,),
                  );
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.delete),
              ),
          ],
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: formKey,
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
                      // ignore: missing_return
                      validator: (nome){
                        if(nome.length < 6)
                          return 'Título muito curto';
                      },
                      onSaved: (nome) => produto.nome = nome,
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
                      onSaved: (descricao) => produto.descricao = descricao,
                    ),
                    TamanhosForm(produto),
                    SizedBox(height: 20,),
                    Consumer<Produto>(
                      builder: (_, produto, __){
                        return SizedBox(
                          height: 44,
                          child: RaisedButton(
                            onPressed: !produto.loading ? () async {
                              if(formKey.currentState.validate()) {
                                formKey.currentState.save();
                                await produto.salvar();
                                context.read<ProdutoManager>().update(produto);
                                Navigator.of(context).pop();
                              }
                            } : null,
                            child: produto.loading ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),) : Text('Salvar', style: TextStyle(fontSize: 18),),
                            color: Theme.of(context).primaryColor,
                            disabledColor: Theme.of(context).primaryColor.withAlpha(100),
                            textColor: Colors.white,
                          ),
                        );
                      },
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
