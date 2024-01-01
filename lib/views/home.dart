import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:laundry_with_go/models/data_laundry.dart';
import 'package:http/http.dart' as http;
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

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
              Container(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          await _fetchData();
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              listPesanan.length,
                              (index) {
                                final getData = listPesanan[index];
                                return InkWell(
                                  child: Card(
                                    child: ListTile(
                                      title: Text(
                                        getData.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      subtitle: Text(
                                        getData.berat.toString(),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return DetailPesanan(
                                            namaPemesan: getData.name,
                                            beratTotal: getData.berat);
                                      },
                                    ));
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
