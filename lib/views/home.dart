import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:laundry_with_go/models/data_laundry.dart';
import 'package:http/http.dart' as http;
import 'package:laundry_with_go/views/card.dart';
import 'package:laundry_with_go/views/detail.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Data> listPesanan = [];
  var isLoading = false;
  String url = "http://192.168.1.11:8080/api";

  Future _fetchData() async {
    String daftarPesananEndPoint = "$url/daftarpesanan";
    try {
      final response = await http.get(Uri.parse(daftarPesananEndPoint));

      if (response.statusCode == 200) {
        isLoading = true;
        final data = jsonDecode(response.body);
        log("$data");

        setState(() {
          listPesanan.clear();
          for (Map<String, dynamic> i in data["data"]) {
            listPesanan.add(Data.fromJson(i));
          }
          isLoading = false;
        });
      }
    } catch (e) {
      log("Ada anu: $e");
    }
  }

  Future _deleteItem(int id) async {
    String deleteItemep = "$url/pesanan/";

    var arg = jsonEncode({
      "id": id,
    });

    try {
      final response = await http.delete(Uri.parse(deleteItemep), body: arg);

      if (response.statusCode == 200) {
        final resp = jsonDecode(response.body);
        log("$resp");
      }
    } catch (e) {
      log("Error di sini: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _fetchData();
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Daftar Pemesan",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: listPesanan.length,
                    itemBuilder: (context, index) {
                      final getData = listPesanan[index];
                      return InkWell(
                        child: Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) async {
                            await _deleteItem(getData.id);
                            await _fetchData();
                          },
                          background: Container(
                            color: Colors.red,
                          ),
                          child: MyCard(
                            data: getData,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return DetailPesanan(
                                  namaPemesan: getData.name,
                                  beratTotal: getData.berat,
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
