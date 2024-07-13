import 'package:flutter/material.dart';

class AddOnWorkHistory extends StatefulWidget {
  const AddOnWorkHistory({super.key});

  @override
  State<AddOnWorkHistory> createState() => _AddOnWorkHistoryState();
}

class _AddOnWorkHistoryState extends State<AddOnWorkHistory> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Payment',style: TextStyle(fontWeight: FontWeight.bold),),
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
              padding: const EdgeInsets.only(top: 8,left: 8,right: 8),
              child: TextFormField(
                // controller: searchController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  hintText: 'Search Payment',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Container(
                    child: ListView.builder(
                        itemCount: 100,
                        itemBuilder: (context, index) {
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
                              // leading: CircleAvatar(
                              //   backgroundImage: AssetImage(
                              //     index / 2 == 3
                              //         ? 'assets/images/shahrukh.png'
                              //         : 'assets/images/shahrukh.png',
                              //   ),
                              // ),
                              title: Text(
                                'Transaction No : #023',
                                style: TextStyle(
                                    fontFamily: 'Roboto Regular',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    index / 2 == 2
                                        ? 'Client Name : Sohel Shaikh'
                                        : 'Client Name : Siddhant Katke',
                                    style: TextStyle(
                                        fontFamily: 'Roboto Regular',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'Project No : #101',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontFamily: 'Roboto Regular',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Transaction Date : 15-04-2024',
                                    style:
                                        TextStyle(fontSize: 12, color: Colors.black),
                                  ),
                                  Text(
                                    'Receiver :- Sahil Shaikh',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey.shade700),
                                  ),
                                ],
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Text(
                                  //   'Placed',
                                  //   style: TextStyle(
                                  //       color: Colors.green,
                                  //       fontSize: 15,
                                  //       fontWeight: FontWeight.bold),
                                  // ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                  ),
                                  // Icon(
                                  //   Icons.remove_red_eye,
                                  //   size: 20,
                                  // ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
