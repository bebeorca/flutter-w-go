import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:laundry_with_go/helper/api_helper.dart';
import 'package:laundry_with_go/viewcomponents/card.dart';
import 'package:laundry_with_go/views/detail.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> fetchData() async {
    try {
      await APIHelper.fetchData(() {
        setState(() {});
      });
    } catch (e) {
      log("Ini di home: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size.width / 8;
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await fetchData();
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
                    itemCount: APIHelper.listPesanan.length,
                    itemBuilder: (context, index) {
                      final getData = APIHelper.listPesanan[index];
                      return InkWell(
                        child: Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) async {
                            await showDialog(
                              context: context,
                              builder: ((context) {
                                Widget cancelButton = TextButton(
                                  child: const Text("TIDAK"),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await fetchData();
                                  },
                                );
                                Widget continueButton = TextButton(
                                  child: const Text("HAPUS"),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await APIHelper.deleteItem(getData.id);
                                    await fetchData();
                                  },
                                );

                                return AlertDialog(
                                  title: const Text("Hapus Pesanan"),
                                  content: const Text("Pesanan telah selesai?"),
                                  actions: [
                                    cancelButton,
                                    continueButton,
                                  ],
                                );
                              }),
                            );
                          },
                          background: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  8.0,
                                ),
                                color: Colors.red,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.only(right: 14.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 36,
                                    )
                                  ],
                                ),
                              )),
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
