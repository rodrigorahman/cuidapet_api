import 'package:cuidapet_api/config/database_connection.dart';
import 'package:cuidapet_api/models/chat_model.dart';
import 'package:cuidapet_api/models/fornecedor_model.dart';
import 'package:mysql1/mysql1.dart';

class ChatRepository {


  Future<List<ChatModel>> buscarChatsUsuario(int usuario) async {
    MySqlConnection conn;
    try {
      conn = await DatabaseConnection.openConnection();
      final result = await conn.query(''' 
        select c.id, c.data_criacao, c.status, a.nome, a.nome_pet, a.fornecedor_id, f.nome, f.logo, a.usuario_id
        from chats as c
          inner join agendamento a on c.agendamento_id = a.id
          inner join fornecedor f on a.fornecedor_id = f.id
        where a.usuario_id = ? 
        and c.status = 'A'
        order by c.data_criacao
      ''', [usuario]);
      
      return result.map((e){
        return ChatModel(
          id: e[0] as int,
          status: e[2] as String,
          nome: e[3] as String ,
          nomePet: e[4] as String,
          fornecedor: FornecedorModel(
            id: e[5] as int,
            nome: e[6] as String,
            logo: (e[7] as Blob).toString()
          ),
          usuario: e[8] as int
        );
      }).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
      
  }

   Future<List<ChatModel>> buscarChatsFornecedor(int fornecedor) async {
    MySqlConnection conn;
    try {
      conn = await DatabaseConnection.openConnection();
      final result = await conn.query(''' 
        select c.id, c.data_criacao, c.status, a.nome, a.nome_pet, a.fornecedor_id, f.nome, f.logo, a.usuario_id
        from chats as c
          inner join agendamento a on c.agendamento_id = a.id
          inner join fornecedor f on a.fornecedor_id = f.id
        where a.fornecedor_id = ?
        and c.status = 'A'
        order by c.data_criacao
      ''', [fornecedor]);
      return result.map((e){
        return ChatModel(
          id: e[0] as int,
          status: e[2] as String,
          nome: e[3] as String ,
          nomePet: e[4] as String,
          fornecedor: FornecedorModel(
            id: e[5] as int,
            nome: e[6] as String,
            logo: (e[7] as Blob).toString()
          ),
          usuario: e[8] as int
        );
      }).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> closeChat(int id) async {
    MySqlConnection conn;
    try {
      conn = await DatabaseConnection.openConnection();
      await conn.query(''' 
        update chats set status = 'F' where id = ?
      ''', [id]);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}