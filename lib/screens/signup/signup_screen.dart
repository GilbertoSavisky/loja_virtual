import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/helpers/validadores.dart';
import 'package:lojavirtualgigabyte/models/user.dart';
import 'package:lojavirtualgigabyte/models/user_manager.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final User user = User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Criar Conta'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Nome Completo'),
                  validator: (nome){
                    if(nome.isEmpty) return 'Campo obrigatório';
                    else if(nome.trim().split(' ').length <= 1) return 'Preencha seu nome completo';
                    return null;
                  },
                  onSaved: (nome) => user.nome = nome,
                ),
                const SizedBox(height: 16,),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (email){
                    if(email.isEmpty){
                      return 'Campo obrigatório!';
                    } else if(!emailValid(email)){
                      return 'E-mail inválido';
                    }
                    return null;
                  },
                  onSaved: (email) => user.email = email,
                ),
                const SizedBox(height: 16,),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Senha'),
                  obscureText: true,
                  validator: (pass){
                    if(pass.isEmpty) return 'Campo obrigatório';
                    else if(pass.isEmpty || pass.length < 6)
                      return 'Senha inválida';
                    return null;
                  },
                  onSaved: (senha) => user.senha = senha,
                ),
                const SizedBox(height: 16,),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Repita a Senha'),
                  obscureText: true,
                  onSaved: (confirmeSenha) => user.confirmSenha = confirmeSenha,
                ),
                const SizedBox(height: 16,),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    disabledColor: Theme.of(context).primaryColor
                        .withAlpha(100),
                    textColor: Colors.white,
                    onPressed: (){
                      if(formKey.currentState.validate()){
                        formKey.currentState.save();
                        if(user.senha != user.confirmSenha){
                          scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: const Text('Senhas não coincidem!'),
                                backgroundColor: Colors.red,
                              )
                          );
                          return;
                        }
                        context.read<UserManager>().signUp(
                          user: user,
                          onFail: (e){
                            scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text('Falha ao cadastrar: $e'),
                                  backgroundColor: Colors.red,
                                )
                            );

                          },
                          onSuccess: (){
                            print('..........Sucesso');
                            }
                        );
                      }
                    },
                    child: const Text(
                      'Criar Conta',
                      style: TextStyle(
                          fontSize: 18
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}