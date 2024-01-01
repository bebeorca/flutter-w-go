import 'package:flutter/material.dart';

class DetailPesanan extends StatefulWidget {
  final String namaPemesan;
  final int beratTotal;

  const DetailPesanan({
    super.key,
    required this.namaPemesan,
    required this.beratTotal,
  });

  @override
  State<DetailPesanan> createState() => _DetailPesananState();
}

class _DetailPesananState extends State<DetailPesanan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListTile(
        title: Text(widget.namaPemesan),
        subtitle: Text("${widget.beratTotal}"),
      ),
    );
  }
}
