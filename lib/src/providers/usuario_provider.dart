import 'dart:convert';

import 'package:http/http.dart' as http;

class UsuarioProvider {
  // url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY]';
  final String _firebaseToken = 'AIzaSyC93bFcfFIch4dkWNZEUz9Y8G24cz1EUb4';

  Future nuevoUsuario(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
        body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    if(decodedResp.containsKey('idToken')) {
      // TODO: Salvar el token en el storage
      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      // Hubo un error
      return {'ok': false, 'mensaje': decodedResp['error']['message']};
    }
  }
}