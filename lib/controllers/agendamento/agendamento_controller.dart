import 'package:cuidapet_api/controllers/agendamento/dto/agendar_servico_rq.dart';
import 'package:cuidapet_api/core/constants.dart';
import 'package:cuidapet_api/models/usuario_model.dart';
import 'package:cuidapet_api/repositories/agendamento_repository.dart';
import 'package:cuidapet_api/utils/push_notification_helper.dart';
import 'package:dio/dio.dart' as dio;

import '../../cuidapet_api.dart';

class AgendamentoController extends ResourceController {
  final _repository = AgendamentoRepository();

  @Operation.post()
  Future<Response> agendarServico(@Bind.body() AgendarServicoRQ agendaServicoRq) async {
    final UsuarioModel user = request.attachments['user'] as UsuarioModel;
    await _repository.agendar(user.id, agendaServicoRq);
    return Response.ok({});
  }

  @Operation.get()
  Future<Response> buscarAgendamentos() async {
    final user = request.attachments['user'] as UsuarioModel;
    final agendamentos = await _repository.buscarTodosAgendamentos(user.id);
    return Response.ok(agendamentos.map((a) => a.toMap()).toList());
  }

  Future<Response> buscarAgendamentoDoFornecedor(UsuarioModel user) async {
    final agendamentos = await _repository.buscarTodosAgendamentosFornecedor(user.fornecedorId);
    return Response.ok(agendamentos.map((a) => a.toMap()).toList());
  }

  Future<void> alteraStatus(int agenda, String status) async {
    await _repository.alterarStatus(agenda, status);
    final tokens = await _repository.getTokenUsuarioMensagem(agenda);
    final payload = {'type': 'AU'};
    PushNotificationHelper.sendMessage(
      [tokens['ios'], tokens['android']],
      "Agendamento Atualizado",
      "Agendamento atualizado para ${statusAgendamento(status)}",
      payload,
    );
  }
}
