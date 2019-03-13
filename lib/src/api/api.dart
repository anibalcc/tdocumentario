import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:dio/dio.dart';

import 'package:http/http.dart' as http;

import 'package:tdocumenterio/src/models/lista_tramite.dart';

class Api {
  Api();

  //Dio dio = Dio();
  Dio dio = new Dio(new BaseOptions(
      baseUrl: "http://190.108.89.83/TramiteDocumentario2019/tramites/",
      connectTimeout: 5000,
      receiveTimeout: 100000,
      // 5s
      headers: {"user-agent": "dio", "api": "1.0.0"},
      contentType: ContentType.JSON,
      // Transform the response data to a String encoded with UTF8.
      // The default value is [ResponseType.JSON].
      responseType: ResponseType.plain));

  static const String _baseBuscaTramiteDoc =
      "http://190.108.89.83/TramiteDocumentario2019/tramites/buscar_tramite_expediente/";
  static const String _baseBuscaTramiteDoc2 =
      "http://190.108.89.83/TramiteDocumentario2019/tramites/buscar_tramite/";
  static const String _baseDetalleTramite =
      "http://190.108.89.83/TramiteDocumentario2019/tramites/listar_historial";

  Uri uri = Uri(
      path:
          "http://190.108.89.83/TramiteDocumentario2019/tramites/listar_historial");

  Future fetchTramitePorExpediente(int expediente) async {
    //
  }

  Future fetchTramitePorDocumento(String idTramiteDetalle) async {}

  fetchDetalleTramite() async {

    final _body = "IdTramiteDetalle=" + "3064907";
    final response = await http.post(_baseDetalleTramite,
        body: _body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        encoding: Encoding.getByName("utf-8"));

    print("===>1 ${response.body}");
    final results = json.decode(response.body);
    print("===>2 ${results}");

    TramiteDetalleList tramiteList = TramiteDetalleList.fromJson(results);

    //return tramiteList.tramiteDetalles;
    final parsed = results.cast<Map<String, dynamic>>();

    //return parsed.map<TramiteDetalleList>((json) => TramiteDetalleList.fromJson(json) );

    return List<TramiteDetalle>.from(
        parsed.map<TramiteDetalle>((json) => TramiteDetalle.fromJson(json)));
  }
}
