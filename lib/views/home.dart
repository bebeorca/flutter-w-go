import 'package:flutter/material.dart';
import 'package:laundry_with_go/helper/api_helper.dart';
import 'package:laundry_with_go/views/card.dart';
import 'package:laundry_with_go/views/detail.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    APIHelper.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await APIHelper.fetchData();
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
                            await APIHelper.deleteItem(getData.id);
                            await APIHelper.fetchData();
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
