import 'package:cuidapet_api/cuidapet_api.dart';

class LoginCadastroController extends ResourceController {

  @Operation.post()
  Future<Response> cadastro() async {
    return Response.ok({'message': 'cadastro'});
  }

}