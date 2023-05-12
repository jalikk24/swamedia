import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:swamedia/api/Client.dart';

class GetRespController {

  getResp(user, Function(String) res) async {
    Response resp = await Client().initDio(user).then((dio) => dio.get(
        "connections",
        queryParameters: {
          "requestMask.includeField": "person.names"
        },));
    if(resp.statusCode == 200) {
      final Map<String, dynamic> data =
      json.decode(resp.data) as Map<String, dynamic>;
      final String? namedContact = _pickFirstNamedContact(data);
      if(namedContact != null) {
        res(namedContact);
      } else {
        res("Failed");
      }
    }
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
          (dynamic contact) => (contact as Map<Object?, dynamic>)['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final List<dynamic> names = contact['names'] as List<dynamic>;
      final Map<String, dynamic>? name = names.firstWhere(
            (dynamic name) =>
        (name as Map<Object?, dynamic>)['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

}