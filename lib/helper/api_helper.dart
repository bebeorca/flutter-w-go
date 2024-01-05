import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:laundry_with_go/models/data_laundry.dart';

class APIHelper {
  static String url = "http://192.168.1.11:8080/api";
  static List<Data> listPesanan = [];

  static Future<void> fetchData() async {
    String daftarPesananEndPoint = "$url/daftarpesanan";
    try {
      final response = await http.get(Uri.parse(daftarPesananEndPoint));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log("$data");

        listPesanan.clear();
        for (Map<String, dynamic> i in data["data"]) {
          listPesanan.add(Data.fromJson(i));
        }
      }
    } catch (e) {
      log("Ada anu: $e");
    }
  }

  static Future<void> deleteItem(int id) async {
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
}
