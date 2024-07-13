import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:interior_v_1/view/project/project_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../api/apiServices.dart';

class ClientHome extends StatefulWidget {
  final String usertype;
  final String name;

  ClientHome({required this.usertype, required this.name});

  @override
  _ClientHomeState createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  int _currentPage = 0;
  late Timer _timer;
  late PageController _pageOneController;
  Future<List<dynamic>>? clientListFuture;
  Future<List<String>>? bannerImagesFuture;
  TextEditingController searchController = TextEditingController();
  String userId = '';

  @override
  void initState() {
    super.initState();
    _pageOneController = PageController(initialPage: _currentPage);
    loadData();
    _startTimer();
  }

  Future<List<String>> fetchBannerImages(String userId) async {
    StatesServices statesServices = StatesServices();
    List<String> bannerImages = [];
    try {
      List<dynamic> promotionalBanners = await statesServices.getPromotionalBanner(userId);
      for (var banner in promotionalBanners) {
        bannerImages.add('https://myerpmie.in/images/${banner['image']}');
      }
    } catch (e) {
      print(e);
    }
    return bannerImages;
  }

  loadData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      userId = sp.getString('userid') ?? '';
      clientListFuture = StatesServices().getProject(userId);
      bannerImagesFuture = fetchBannerImages(userId);
    });
    print('getClients$userId');
  }

  @override
  void dispose() {
    _pageOneController.dispose();
    _stopTimer();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_pageOneController.hasClients) {
        int nextPage = _currentPage + 1;
        bannerImagesFuture?.then((bannerImages) {
          if (nextPage >= bannerImages.length) {
            nextPage = 0;
          }
          _pageOneController.animateToPage(
            nextPage,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
          setState(() {
            _currentPage = nextPage;
          });
        });
      }
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              'Welcome Back!',
              style: TextStyle(
                color: Color(0xFF2A2828),
                fontSize: 20,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, top: 5),
            child: Text(
              'Hi, ${widget.name}',
              style: TextStyle(
                color: Color(0xFF959393),
                fontSize: 11,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 5),
            child: Container(
              height: 150,
              width: screenWidth - 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: FutureBuilder<List<String>>(
                  future: bannerImagesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No Banners Found'));
                    } else {
                      return PageView.builder(
                        controller: _pageOneController,
                        itemCount: snapshot.data!.length,
                        onPageChanged: (int index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.network(
                                snapshot.data![index],
                                fit: BoxFit.fill,
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 13),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: screenWidth * 0.45,
                height: 90,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.shade400,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.notes,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            'Total Project',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth * 0.04,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                            overflow: TextOverflow.ellipsis, // Handle overflow
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: FittedBox(
                          child: Text(
                            '100',
                            style: TextStyle(
                              color: Colors.blueGrey.shade900,
                              fontSize: 30,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: screenWidth * 0.45,
                height: 90,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.shade400,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              CupertinoIcons.checkmark_alt,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            'Complete Project',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth * 0.04,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: FittedBox(
                          child: Text(
                            '80',
                            style: TextStyle(
                              color: Colors.blueGrey.shade900,
                              fontSize: 30,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: clientListFuture == null
                ? Center(child: CircularProgressIndicator())
                : FutureBuilder<List<dynamic>>(
              future: clientListFuture,
              builder: (context, snapshot) {
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
                  List<dynamic> filteredList =
                  snapshot.data!.where((data) {
                    String name = data['name'].toString().toLowerCase();
                    return name
                        .contains(searchController.text.toLowerCase());
                  }).toList();
                  return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      var project = filteredList[index];
                      return Container(
                        padding: EdgeInsets.all(2),
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.orange, width: 3),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: Icon(Icons.folder, color: Colors.orange),
                              title: Text('Project Name', style: TextStyle(fontSize: 14)),
                              subtitle: Text(
                                project['project_name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ListTile(
                                    leading: Icon(Icons.assignment_ind, color: Colors.orange),
                                    title: Text('Project ID', style: TextStyle(fontSize: 14)),
                                    subtitle: Text(
                                      project['project_id'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    leading: Icon(Icons.hourglass_empty, color: Colors.orange),
                                    title: Text('Status', style: TextStyle(fontSize: 14)),
                                    subtitle: Text(
                                      'Active',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                print(filteredList[index]['id']);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Project_Detail(
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
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'View More',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
