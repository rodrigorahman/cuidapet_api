import 'package:cuidapet_api/controllers/agendamento/dto/agendar_servico_rq.dart';
import 'package:cuidapet_api/models/agendamento_model.dart';
import 'package:cuidapet_api/models/usuario_model.dart';
import 'package:cuidapet_api/repositories/agendamento_repository.dart';
import 'package:cuidapet_api/repositories/chat_repository.dart';

import '../../cuidapet_api.dart';

class AgendamentoController extends ResourceController {
  final _repository = AgendamentoRepository();
  final _chatRepository = ChatRepository();

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

  @Operation.get('usuario')
  Future<Response> buscarChatsUsuario() async {
    final user = request.attachments['user'] as UsuarioModel;
    final chats = await _chatRepository.buscarChatsUsuario(user.id);
    return Response.ok(chats.map((a) => {
      'id': a.id,
      'usuario': a.usuario,
      'nome': a.nome,
      'nome_pet': a.nomePet,
      'fornecedor': {
        'id': a.fornecedor.id,
        'nome': a.fornecedor.nome,
        'logo': a.fornecedor.logo
      }
    }).toList());
  }

  @Operation.get('fornecedor')
  Future<Response> buscarChatsFornecedor(@Bind.path('fornecedor') int fornecedor) async {
    final chats = await _chatRepository.buscarChatsFornecedor(fornecedor);
    return Response.ok(chats.map((a) => {
      'id': a.id,
      'usuario': a.usuario,
      'nome': a.nome,
      'nome_pet': a.nomePet,
      'fornecedor': {
        'id': a.fornecedor.id,
        'nome': a.fornecedor.nome,
        'logo': a.fornecedor.logo
      }
    }).toList());
  }
  
  @Operation.put('id')
  Future<Response> closeChat(@Bind.path('id') int id) async {
    await _chatRepository.closeChat(id);
    return Response.ok({});
  }

  Future<Response> buscarAgendamentoDoFornecedor(UsuarioModel user) async {
    final agendamentos = await _repository.buscarTodosAgendamentosFornecedor(user.fornecedorId);
    return Response.ok(agendamentos.map((a) => a.toMap()).toList());
  }
  
}
