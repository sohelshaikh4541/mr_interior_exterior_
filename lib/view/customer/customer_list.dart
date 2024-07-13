import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interior_v_1/api/apiServices.dart';
import 'package:interior_v_1/view/customer/add_customer.dart';
import 'package:interior_v_1/view/customer/update_customer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../lead/lead_details.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({super.key});

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  late Future<List<dynamic>> clientListFuture;
  TextEditingController searchController = TextEditingController();
  String userId = '';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      userId = sp.getString('userid') ?? '';
    });
    StatesServices statesServices = StatesServices();
    clientListFuture = statesServices.getClients(userId);
    print('getClients$userId');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Client',style: TextStyle(fontWeight: FontWeight.bold),),
          backgroundColor: Color(0xFFFFA500),
          elevation: 5,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: TextFormField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  hintText: 'Search Client',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: clientListFuture,
                  builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListView.builder(
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            period: Duration(milliseconds: 1000),
                            child: ListTile(
                              title: Container(
                                height: 20,
                                color: Colors.white,
                              ),
                              subtitle: Container(
                                height: 10,
                                color: Colors.white,
                              ),
                              leading: Container(
                                height: 50,
                                width: 50,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No Data Found'));
                    } else {
                      List<dynamic> filteredList = snapshot.data!.where((data) {
                        String name = data['name'].toString().toLowerCase();
                        return name
                            .contains(searchController.text.toLowerCase());
                      }).toList();
                      return ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          var client = filteredList[index];
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.4),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(
                                  'assets/images/shahrukh.png',
                                ),
                              ),
                              title: Text(client['name']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(client['address']),
                                  Text(
                                    'Mobile No :- ${client['mobile_no']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  Text(
                                    'Client Id :- ${client['id']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  Text(
                                    'Total Project :- ${client['id']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      print(filteredList[index]['id']);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UpdateCustomer(
                                            id: filteredList[index]['id'],
                                            name: filteredList[index]['name'],
                                            mobileNo: filteredList[index]
                                                ['mobile_no'],
                                            address: filteredList[index]
                                                ['address'],
                                            email: filteredList[index]['email'],
                                            sourceName: filteredList[index]
                                                ['source_name'],
                                            city: filteredList[index]['city'],
                                            state: filteredList[index]['state'],
                                            date: filteredList[index]
                                                ['dateadded'],
                                            zip: filteredList[index]['zip'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
