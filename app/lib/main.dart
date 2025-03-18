import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('http://LOCALHOST:3000/login'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _showAlert('Login bem-sucedido', 'O usuário existe no banco.');
      } else if (response.statusCode == 401) {
        _showAlert('Falha no login', 'Email ou senha inválidos.');
      } else {
        _showAlert('Erro', 'Erro desconhecido ao conectar ao servidor.');
      }
    } catch (e) {
      _showAlert('Erro', 'Não foi possível conectar ao servidor.');
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Página de Login')),
      body: SizedBox(
        width: 390, // Largura fixa da tela
        height: 844, // Altura fixa da tela
        child: Stack(
          children: [
            // Imagem de fundo com tamanho original
            Image.asset(
              'assets/img/bg.png', // Caminho da imagem
              width: 390, // Largura da imagem
              height: 844, // Altura da imagem
              fit: BoxFit.cover, // Cobrir o espaço disponível
            ),
            // Div centralizada com o formulário
            Positioned(
              bottom: 50, // Ajuste para mover a div um pouco para cima
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white, // Fundo branco
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      20,
                    ), // Bordas arredondadas apenas no topo
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Sombra cinza
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // Deslocamento da sombra
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        hintText: 'Seu e-mail',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey[200]!,
                          ), // Borda cinza mais claro
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        hintText: 'Sua senha',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey[200]!,
                          ), // Borda cinza mais claro
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _login,
                      child: Text('Entrar'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 20), // Espaço extra na parte inferior
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
