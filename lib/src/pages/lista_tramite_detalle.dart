import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:tdocumenterio/src/api/api.dart';
import 'package:tdocumenterio/src/models/lista_tramite.dart';

import 'package:http/http.dart' as http;

Future<List<TramiteDetalle>> fetchDetalles(
    http.Client client, String idTramiteDetalle) async {
  final _body = "IdTramiteDetalle=" + idTramiteDetalle;
  final response = await client.post(
      'http://URL/TramiteDocumentario2019/tramites/listar_historial',
      body: _body,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      encoding: Encoding.getByName("utf-8"));

  final results = json.decode(response.body);
  print("===>2 ${results}");

  // Use the compute function to run parsePhotos in a separate isolate
  return compute(parseDetalles, response.body);
}

// A function that converts a response body into a List<Photo>
List<TramiteDetalle> parseDetalles(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<TramiteDetalle>((json) => TramiteDetalle.fromJson(json))
      .toList();
}

class ListaTramiteDetallePage extends StatefulWidget {
  final String _idTramiteDetalle;

  ListaTramiteDetallePage(this._idTramiteDetalle);

  @override
  _ListaTramiteDetalle createState() => _ListaTramiteDetalle();
}

class _ListaTramiteDetalle extends State<ListaTramiteDetallePage> {
  static const String _baseDetalleTramite =
      "http://URL/TramiteDocumentario2019/tramites/listar_historial";
  @override
  void initState() {
    super.initState();
    //_get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: FutureBuilder<List<TramiteDetalle>>(
        future: fetchDetalles(http.Client(), widget._idTramiteDetalle),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? DetalleList(detalles: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class DetalleList extends StatelessWidget {
  final List<TramiteDetalle> detalles;

  DetalleList({Key key, this.detalles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: detalles.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(detalles[index].oficinaOrigen),
          subtitle: Text(detalles[index].oficinaDestino),
        );
      },
    );
    
  }
}
