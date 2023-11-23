import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DaftarPelanggan extends StatefulWidget {
  const DaftarPelanggan({super.key});

  @override
  State<DaftarPelanggan> createState() => _DaftarPelangganState();
}

class _DaftarPelangganState extends State<DaftarPelanggan> {
  List<dynamic> customers = [];
  int page = 1;
  int limit = 10;
  bool loading = false;
  bool searchLoading = false;
  bool searchActive = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      loading = true;
    });

    String url =
        'https://retoolapi.dev/yZjtsj/customers?_page=$page&_limit=$limit';

    try {
      var response = await http.get(Uri.parse(url));
      var data = json.decode(response.body);

      setState(() {
        customers.addAll(data);
        loading = false;
      });
    } catch (error) {
      print('data error: $error');
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> seachData() async {
    setState(() {
      searchLoading = true;
      searchActive = true;
    });

    String customerName = searchController.text;
    String url =
        'https://retoolapi.dev/yZjtsj/customers?customer_name=$customerName';

    try {
      var response = await http.get(Uri.parse(url));
      var data = json.decode(response.body);

      setState(() {
        customers.clear();
        customers.addAll(data);
        searchLoading = false;
      });
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        searchLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pelanggan', style: TextStyle(color: Colors.cyan),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0,),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {

                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                         seachData();
                        });
                      },
                    ),
                    hintText: 'Cari Nama Customers',
                    enabledBorder: OutlineInputBorder(
                      borderRadius:  BorderRadius.circular(25)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:  BorderRadius.circular(25)),
                  ),
                ),
              ),
              
              IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        setState(() {
                          searchActive = false;
                          page = 1;
                          fetchData();
                        });
                      },
                    ),
            ],
          ),
          Expanded(
            child: searchActive
                ? ListView.builder(
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Text(customers[index]['customer_name']),
                          subtitle: Text(customers[index]['email']),
                          onTap: () async {
                            await Navigator.pushNamed(
                              context,
                              '/customerDetail',
                              arguments: customers[index]['id'],
                            );
                          }
                          );
                    },
                  )
                : NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!loading &&
                          scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent &&
                          customers.isNotEmpty) {
                        setState(() {
                          page++;
                        });
                        fetchData();
                      }
                      return true;
                    },
                    child: ListView.builder(
                      itemCount: customers.length + 1,
                      itemBuilder: (context, index) {
                        if (index == customers.length) {
                          return Container(
                            padding: const EdgeInsets.all(8.0),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          return ListTile(
                              title: Text(customers[index]['customer_name']),
                              subtitle: Text(customers[index]['email']),
                              onTap: () async {
                                await Navigator.pushNamed(
                                  context,
                                  '/customerDetail',
                                  arguments: customers[index]['id'],
                                );
                              }
                              );
                        }
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}