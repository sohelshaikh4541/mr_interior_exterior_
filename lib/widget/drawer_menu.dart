import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interior_v_1/view/addonwork/add_on_work.dart';
import 'package:interior_v_1/view/addonwork/add_on_work_history.dart';
import 'package:interior_v_1/view/approvals/payment_request.dart';
import 'package:interior_v_1/view/order/receive_order.dart';
import '../view/customer/add_customer.dart';
import '../view/customer/customer_list.dart';
import '../view/lead/add_lead.dart';
import '../view/lead/lead_list.dart';
import '../view/order/order_history.dart';
import '../view/order/order_place.dart';
import '../view/payment/add_payments.dart';
import '../view/payment/payments_history.dart';
import '../view/project/add_project.dart';
import '../view/project/assign_project.dart';
import '../view/project/project_list.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTileGroup(children: [
      ExpansionTileWithoutBorderItem(
        title: Row(
          children: [
            Image(
              image: AssetImage('assets/images/sales_add.png'),
            ),
            SizedBox(width: 10),
            Text('Lead', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        expendedBorderColor: Colors.black,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 50),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddLead()),
                  );
                },
                child: Text('Add Lead                             ',
                    style: TextStyle(fontSize: 16))),
          ),
          Padding(
            padding: EdgeInsets.only(left: 50, top: 9, bottom: 5),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LeadList()),
                  );
                },
                child: Text('Lead List                            ',
                    style: TextStyle(fontSize: 16))),
          ),
        ],
      ),
      ExpansionTileWithoutBorderItem(
        title: Row(
          children: [
            Image(
              image: AssetImage('assets/images/customer_add.png'),
            ),
            SizedBox(width: 10),
            Text('Client', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        expendedBorderColor: Colors.black,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 50),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddCustomer()),
                  );
                },
                child: Text('Add Client                           ',
                    style: TextStyle(fontSize: 16))),
          ),
          Padding(
            padding: EdgeInsets.only(left: 50, top: 9, bottom: 5),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomerList()),
                  );
                },
                child: Text('Client List                          ',
                    style: TextStyle(fontSize: 16))),
          ),
        ],
      ),
      ExpansionTileWithoutBorderItem(
        title: Row(
          children: [
            Icon(
              Icons.business,
              size: 28,
            ),
            SizedBox(width: 10),
            Text('Payment', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        expendedBorderColor: Colors.black,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 50),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddSales()),
                  );
                },
                child: Text('Add Payment                           ',
                    style: TextStyle(fontSize: 16))),
          ),
          Padding(
            padding: EdgeInsets.only(left: 50, top: 9, bottom: 5),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SalesHistory()),
                  );
                },
                child: Text('Payment List                          ',
                    style: TextStyle(fontSize: 16))),
          ),
        ],
      ),
      ExpansionTileWithoutBorderItem(
        title: Row(
          children: [
            Image(
              image: AssetImage('assets/images/project_add.png'),
            ),
            SizedBox(width: 10),
            Text('Manage Project',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        expendedBorderColor: Colors.black,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 50,
            ),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddProject()),
                  );
                },
                child: Text('Add Project                           ',
                    style: TextStyle(fontSize: 16))),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 50,
              top: 9,
            ),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AssignProject()),
                  );
                },
                child: Text('Assign Project                         ',
                    style: TextStyle(fontSize: 16))),
          ),
          Padding(
            padding: EdgeInsets.only(left: 50, top: 9, bottom: 5),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProjectList()),
                  );
                },
                child: Text('Project List                           ',
                    style: TextStyle(fontSize: 16))),
          ),
        ],
      ),
      ExpansionTileWithoutBorderItem(
        title: Row(
          children: [
            Image(
              image: AssetImage('assets/images/payment_add.png'),
            ),
            SizedBox(width: 10),
            Text('Add On Work', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        expendedBorderColor: Colors.black,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 50),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddOnWork()),
                  );
                },
                child: Text('Add On Work                          ',
                    style: TextStyle(fontSize: 16))),
          ),
          Padding(
            padding: EdgeInsets.only(left: 50, top: 9, bottom: 5),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddOnWorkHistory()),
                  );
                },
                child: Text('Add On Work History                       ',
                    style: TextStyle(fontSize: 16))),
          ),
        ],
      ),
      ExpansionTileWithoutBorderItem(
        title: Row(
          children: [
            Image(
              image: AssetImage('assets/images/payment_add.png'),
            ),
            SizedBox(width: 10),
            Text('Payment Request', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        expendedBorderColor: Colors.black,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 50),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentRequests()),
                  );
                },
                child: Text('Requests                          ',
                    style: TextStyle(fontSize: 16))),
          ),
        ],
      ),
      ExpansionTileWithoutBorderItem(
        title: Row(
          children: [
            Icon(
              CupertinoIcons.purchased_circle,
              size: 28,
            ),
            SizedBox(width: 10),
            Text('Order', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        expendedBorderColor: Colors.black,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 50,
              top: 9,
            ),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderPlaced()),
                  );
                },
                child: Text('Order Material                          ',
                    style: TextStyle(fontSize: 16))),
          ),
          Padding(
            padding: EdgeInsets.only(left: 50, top: 9, bottom: 0),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderHistory()),
                  );
                },
                child: Text('Order History                           ',
                    style: TextStyle(fontSize: 16))),
          ),
          // Padding(
          //   padding: EdgeInsets.only(left: 50, top: 9, bottom: 5),
          //   child: InkWell(
          //       onTap: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => ReceiveOrder()),
          //         );
          //       },
          //       child: Text('Receive Order                           ',
          //           style: TextStyle(fontSize: 16))),
          // ),
        ],
      ),
      ExpansionTileWithoutBorderItem(
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderPlaced()),
            );
          },
          child: Row(
            children: [
              Icon(
                CupertinoIcons.lock_shield,
                size: 28,
              ),
              SizedBox(width: 10),
              Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        trailing: SizedBox.shrink(), // Remove the trailing icon
        expendedBorderColor: Colors.black,
        children: [],
      ),
    ]);
  }
}
