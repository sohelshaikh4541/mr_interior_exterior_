import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  int selectedFilter = 0;

  final List<Map<String, String>> trips = [
    {"title": "New Design 1", "date": "16 July 2024", "status": "upcoming","link":"https://myerpmie.in/images/imgth.png"},
    {"title": "New Design 2", "date": "13 July 2024", "status": "past","link":"https://myerpmie.in/images/interior_logo.png"},
    {"title": "New Design 3", "date": "13 July 2024", "status": "past","link":"https://myerpmie.in/images/img-1.png"},
    {"title": "New Design 4", "date": "13 July 2024", "status": "upcoming","link":"https://myerpmie.in/images/img-2.png"},
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredTrips = selectedFilter == 0
        ? trips.where((trip) => trip['status'] == 'upcoming').toList()
        : trips.where((trip) => trip['status'] == 'past').toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications',style: TextStyle(fontWeight: FontWeight.bold),),
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
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 20,),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedFilter = 0;
                  });
                },
                child: Text('Recent',style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedFilter == 0 ? Colors.orange : Colors.grey.shade800,
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedFilter = 1;
                  });
                },
                child: Text('Past',style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedFilter == 1 ? Colors.orange : Colors.grey.shade800,
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTrips.length,
              itemBuilder: (context, index) {
                return TripCard(trip: filteredTrips[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TripCard extends StatelessWidget {
  final Map<String, String> trip;

  TripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade100,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image.network('${trip['link']}'),
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: CachedNetworkImage(
                imageUrl: '${trip['link']}',
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: double.infinity,
                    height: 200.0,
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                height: 200.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10,),
            Text(
              trip['title']!,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.blueAccent.shade100),
            ),
            // Row(
            //   children: [
            //     Icon(Icons.send),
            //     SizedBox(width: 5),
            //     Text('Send Request'),
            //     SizedBox(width: 10),
            //     Icon(Icons.share),
            //     SizedBox(width: 5),
            //     Text('Share'),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${trip['date']}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.grey)),
                Row(
                  children: [
                    Icon(CupertinoIcons.eye),
                    SizedBox(width: 5),
                    Text('Viewed',style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(width: 5),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
