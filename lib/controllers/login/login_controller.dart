import 'package:cuidapet_api/controllers/login/dto/change_password_rq.dart';
import 'package:cuidapet_api/controllers/login/dto/login_patch_rq.dart';
import 'package:cuidapet_api/cuidapet_api.dart';
import 'package:cuidapet_api/exceptions/user_notfound_exception.dart';
import 'package:cuidapet_api/models/usuario_model.dart';
import 'package:cuidapet_api/repositories/usuario_repository.dart';
import 'package:cuidapet_api/utils/jwt_utils.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

import 'dto/login_rq.dart';

class LoginController extends ResourceController {
  final _repository = UsuarioRepository();

  @Operation.post()
  Future<Response> login(@Bind.body() LoginRQ request) async {
    try {
      final user = await _repository.validateLogin(request.login, request.senha, facebook: request.facebookLogin);

      return Response.ok({
        'access_token': JwtUtils.generateJWT(user.id),
      });
    } on UserNotFoundException catch (e) {
      if (request.facebookLogin) {
        final user = await _repository.createFacebookUser(request.login, request.avatar);
        return Response.created('/login/register', body: {
          'access_token': JwtUtils.generateJWT(user.id),
        });
      } else {
        return Response.forbidden(body: {'message': e.message});
      }
    } catch (e) {
      print(e);
      return Response.serverError();
    }
  }

  @Operation('PATCH')
  Future<Response> pathLogin(@Bind.body() LoginPatchRq loginRQ) async {
    try {
      final String token = request.attachments['access_token'] as String;
      final UsuarioModel user = request.attachments['user'] as UsuarioModel;

      final refreshToken = await _repository.updateTokenUser(loginRQ, user.id, token);
      return Response.ok({
        'access_token': JwtUtils.generateJWT(user.id),
        'refresh_token': refreshToken,
      });
    } on UserNotFoundException catch (e) {
      return Response.forbidden(body: {'message': e.message});
    }
  }

  @Operation.put()
  Future<Response> updatePassword(@Bind.body() ChangePasswordRQ changePasswordRQ) async {
    try {
      
      final UsuarioModel user = request.attachments['user'] as UsuarioModel;
      await _repository.updatePassword(user.id, changePasswordRQ.password);
      return Response.ok({});

    } catch (e) {
      print(e);
      return Response.serverError(
        body: {'erro': 'Erro ao atualizar senha', 'exception': e.toString()},
      );
    }
  }
}
