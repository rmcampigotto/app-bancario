import 'dart:convert';

import '../models/transacao_entitie.dart';
import 'abstract_api.dart';

class TransacaoService extends AbstractApi {
  TransacaoService() : super("transacoes");

  Future<List<TransacaoEntitie>> GetAllTransacoes() async {
    String body = await super.getAll();
    List<dynamic> jsonList = jsonDecode(body);
    return jsonList.map((json) => TransacaoEntitie.fromJson(json)).toList();
  }

  Future<TransacaoEntitie> GetTransacaoById(int id) async {
    String body = await super.getOne(id);
    Map<String, dynamic> json = jsonDecode(body);
    return TransacaoEntitie.fromJson(json);
  }

  Future<TransacaoEntitie> CreateTransacao(TransacaoEntitie transacao) async {
    String body = await super.post(transacao);
    Map<String, dynamic> json = jsonDecode(body);
    return TransacaoEntitie.fromJson(json);
  }

  Future<List<TransacaoEntitie>> UpdateTransacao(TransacaoEntitie transacao, int id) async {
    String body = await super.put(transacao, id);
    List<dynamic> jsonList = jsonDecode(body);
    return jsonList.map((json) => TransacaoEntitie.fromJson(json)).toList();
  }

  Future<List<TransacaoEntitie>> DeleteTransacao(int id) async {
    String body = await super.delete(id);
    List<dynamic> jsonList = jsonDecode(body);
    return jsonList.map((json) => TransacaoEntitie.fromJson(json)).toList();
  }
}