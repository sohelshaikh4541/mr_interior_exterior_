import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interior_v_1/view/project/project_remind.dart';
import 'package:interior_v_1/view/project/update_project.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../api/apiServices.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({super.key});

  @override
  State<ProjectList> createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {

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
    clientListFuture = statesServices.getProject(userId);
    print('getClients$userId');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Project',style: TextStyle(fontWeight: FontWeight.bold),),
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
                  hintText: 'Search Project',
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
                          var project = filteredList[index];
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.4),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: ListTile(
                              title: Text('Project No : ${project['project_id']}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(project['address']+' ,'+project['city']),
                                  Text(
                                    'Client Name :- ${project['client_name']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  Text(
                                    'Date :- ${project['date']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  Text(
                                    'Mobile No :- ${project['client_mobile_no']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      print(filteredList[index]['id']);
                                     Navigator.push(
                                       context,
                                        MaterialPageRoute(
                                          builder: (context) => UpdateProject(
                                            client_name: filteredList[index]['client_name'],
                                            project_name: filteredList[index]['project_name'],
                                            address: filteredList[index]
                                            ['address'],
                                            zip: filteredList[index]['zip'],
                                            city: filteredList[index]['city'],
                                            state: filteredList[index]['state'],
                                            date: filteredList[index]['date'],
                                            package_id: filteredList[index]
                                            ['package_id'].toString(),
                                            price: filteredList[index]['price'],
                                            description: filteredList[index]['description'],
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
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Project_Remind(
                                            client_name: filteredList[index]['client_name'],
                                            project_name: filteredList[index]['project_name'],
                                            address: filteredList[index]['address'],
                                            zip: filteredList[index]['zip'],
                                            city: filteredList[index]['city'],
                                            state: filteredList[index]['state'],
                                            date: filteredList[index]['date'],
                                            package_id: filteredList[index]['package_id'].toString(),
                                            price: filteredList[index]['price'],
                                            project_id: filteredList[index]['project_id'],
                                            package_name: filteredList[index]['name'],
                                            client_mobile_no: filteredList[index]['client_mobile_no'],
                                            description: filteredList[index]['description'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                    ),
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
