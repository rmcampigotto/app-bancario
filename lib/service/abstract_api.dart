import 'package:http/http.dart' as http;

abstract class AbstractApi {

  static const String _urlLocalHost = 'http://localhost:3000';
  String _recurso;

  AbstractApi(this._recurso);

  Future<String> getAll() async {
    var response = await http.get(Uri.parse('$_urlLocalHost/$_recurso'));
    return response.body;
  }

  Future<String> getOne(int id) async {
    var response = await http.get(Uri.parse('$_urlLocalHost/$_recurso/$id'));
    return response.body;
  }

  Future<String> post(Object? body) async {
    var response = await http.post(Uri.parse('$_urlLocalHost/$_recurso'), body: body);
    return response.body;
  }

  Future<String> put(Object? body, int id) async {
    var response = await http.put(Uri.parse('$_urlLocalHost/$_recurso/$id'), body: body);
    return response.body;
  }

  Future<String> delete(int id) async {
    var response = await http.delete(Uri.parse('$_urlLocalHost/$_recurso/$id'));
    return response.body;
  }
}