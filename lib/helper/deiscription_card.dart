import 'package:flutter/material.dart';

class DescriptionCard extends StatefulWidget {
  final Map<String, dynamic> item;

  const DescriptionCard({required this.item});

  @override
  _DescriptionCardState createState() => _DescriptionCardState();
}

class _DescriptionCardState extends State<DescriptionCard> {
  bool showFullDescription = false;

  @override
  Widget build(BuildContext context) {
    String firstLine = widget.item['description']!.split('\n').first;
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Container(
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Flexible(
                //   child: Text(
                //     'Status: ${widget.item['user_id']!}',
                //     style: TextStyle(
                //       fontSize: 16.0,
                //       fontWeight: FontWeight.bold,
                //     ),
                //     overflow: TextOverflow.ellipsis,
                //   ),
                // ),
                Text(
                  'Date :',
                  style: TextStyle(
                    fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(width: 16.0),
                Text(
                  (widget.item['created_at']?.toString() ==
                      'null' ||
                      widget.item['created_at'] == null)
                      ? 'Not Found'
                      : widget.item['created_at']
                      .toString()
                      .substring(0, 10),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey.shade700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              'Description:',
              style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold, color: Colors.grey.shade800),
            ),
            SizedBox(height: 4.0),
            GestureDetector(
              onTap: () {
                setState(() {
                  showFullDescription = !showFullDescription;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showFullDescription)
                    Text(
                      (widget.item['description']?.toString() ==
                          'null' ||
                          widget.item['description'] == null)
                          ? 'Not Found'
                          : widget.item['description']
                          .toString(),
                      style: TextStyle(fontSize: 16.0, color: Colors.grey.shade700),
                    )
                  else
                    Text(
                      firstLine,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16.0, color: Colors.grey),
                    ),
                  if (!showFullDescription)
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Text(
                        'View More',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
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
