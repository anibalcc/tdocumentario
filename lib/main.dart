import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:tdocumenterio/src/api/api.dart';

import 'package:tdocumenterio/src/models/lista_tramite.dart';
import 'package:tdocumenterio/src/pages/lista_tramite_detalle.dart';

import 'package:http/http.dart' as http;

import 'package:tdocumenterio/src/models/tramite.dart';

Future<List<Tramite>> fetchTramites(
    http.Client client, String nroExpediente) async {
  final _body = "Expediente=" + nroExpediente;
  final response = await client.post(
      "http://URL/TramiteDocumentario2019/tramites/buscar_tramite_expediente/",
      body: _body,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      encoding: Encoding.getByName("utf-8"));

  // Use the compute function to run parsePhotos in a separate isolate
  return compute(parseTramites, response.body);
}

// A function that converts a response body into a List<Photo>
List<Tramite> parseTramites(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Tramite>((json) => Tramite.fromJson(json)).toList();
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Tramite Documentario'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static List _buscarPor = ["NRO DE EXPEDIENTE", "NRO DE DOCUMENTO"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _selectedBuscar = _buscarPor[0];

  final _textNroExpedienteController = TextEditingController();

  final nroExpediente = "";

  @override
  void initState() {
    super.initState();

    // _textNroExpedienteController.addListener(() {});

    _dropDownMenuItems = buildAndGetDropDownMenuItems(_buscarPor);
  }

  _update() {
    setState(() {});
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List bucarPor) {
    List<DropdownMenuItem<String>> items = new List();
    for (String nro in bucarPor) {
      items.add(
        new DropdownMenuItem(value: nro, child: Text(nro)),
      );
    }
    return items;
  }

  void changedDropDownItem(String selectedDoc) {
    setState(() {
      _selectedBuscar = selectedDoc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            DropdownButton(
              value: _selectedBuscar,
              items: _dropDownMenuItems,
              onChanged: changedDropDownItem,
            ),
            TextField(
              controller: _textNroExpedienteController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Please enter a search term'),
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _update();
                });
              },
            ),
            Expanded(
              child: FutureBuilder<List<Tramite>>(
                future: fetchTramites(
                    http.Client(), _textNroExpedienteController.text),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);

                  return snapshot.hasData
                      ? TramiteList(tramite: snapshot.data)
                      : Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TramiteList extends StatelessWidget {
  final List<Tramite> tramite;

  TramiteList({Key key, this.tramite}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tramite.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(tramite[index].nombreOrigen),
          subtitle: Text(tramite[index].oficinaDestino),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ListaTramiteDetallePage(
                        tramite[index].idTramiteDetalle)));
          },
        );
      },
    );
  }
}
