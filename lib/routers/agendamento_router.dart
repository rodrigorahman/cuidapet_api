import 'package:cuidapet_api/config/jwt_authentication_middleware.dart';
import 'package:cuidapet_api/controllers/agendamento/agendamento_controller.dart';
import 'package:cuidapet_api/core/i_routers_config.dart';
import 'package:cuidapet_api/models/usuario_model.dart';

import '../cuidapet_api.dart';

class AgendamentoRouter implements IRoutersConfig {
  @override
  void configure(Router router) {
    router.route('/agendamento/agendar')
      .link(() => JwtAuthenticationMiddleware())
      .link(() => AgendamentoController());

    router.route('/agendamentos')
      .link(() => JwtAuthenticationMiddleware())
      .link(() => AgendamentoController());

      router.route('/agendamentos/fornecedor')
      .link(() => JwtAuthenticationMiddleware())
      .linkFunction((request) {
        return AgendamentoController()
          .buscarAgendamentoDoFornecedor(request.attachments['user'] as UsuarioModel);
      });

      router.route('/agendamento/:id/status/:status')
      .link(() => JwtAuthenticationMiddleware())
      .linkFunction((request) async {
        print(request.path.variables);
        final v = request.path.variables;
        await AgendamentoController().alteraStatus(int.parse(v['id']) , v['status']);
        return Response.ok({});
      });

  }
}
