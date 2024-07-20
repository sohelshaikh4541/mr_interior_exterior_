import 'package:flutter/material.dart';

import 'api/apiServices.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> with SingleTickerProviderStateMixin {
  late List<dynamic> leadLog = [];
  bool isLoading = true;
  bool showScrollHint = true;
  PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchLeadLog() async {
    StatesServices statesServices = StatesServices();
    try {
      final startTime = DateTime.now();
      leadLog = await statesServices.getLeadLog('1');
      final endTime = DateTime.now();
      print('Data fetched in ${endTime.difference(startTime).inSeconds} seconds');
    } catch (e) {
      print('Error fetching lead log: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _navigateToNextItem(int index) {
    if (index < leadLog.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 400,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : PageView.builder(
            controller: _pageController,
            itemCount: leadLog.length,
            itemBuilder: (context, index) {
              return DescriptionCard(
                item: leadLog[index],
                onNext: () => _navigateToNextItem(index),
              );
            },
          ),
        ),
        if (showScrollHint)
          Positioned(
            right: 16.0,
            bottom: 16.0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Icon(
                Icons.arrow_forward,
                size: 48.0,
                color: Colors.grey,
              ),
            ),
          ),
      ],
    );
  }
}

class DescriptionCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final VoidCallback onNext;

  const DescriptionCard({required this.item, required this.onNext});

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
                Text(
                  'Date:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(width: 16.0),
                Text(
                  (widget.item['created_at']?.toString() == 'null' ||
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
                Spacer(), // This will push the icon to the right end
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: widget.onNext,
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              'Description:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
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
                      (widget.item['description']?.toString() == 'null' ||
                          widget.item['description'] == null)
                          ? 'Not Found'
                          : widget.item['description'].toString(),
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey.shade700,
                      ),
                    )
                  else
                    Text(
                      firstLine,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
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
