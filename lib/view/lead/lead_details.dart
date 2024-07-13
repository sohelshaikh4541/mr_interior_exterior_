import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interior_v_1/helper/custome_colour.dart';
import 'package:interior_v_1/widget/text_form_y.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../api/apiServices.dart';
import '../../helper/deiscription_card.dart';
import '../../model/lead_sources.dart';
import 'lead_list.dart';

class LeadDetails extends StatefulWidget {
  int? id;
  String? mobileNo,
      name,
      address,
      sourceName,
      assignedtoName,
      city,
      state,
      date;

  LeadDetails({
    this.id,
    this.mobileNo,
    this.name,
    this.address,
    this.sourceName,
    this.assignedtoName,
    this.city,
    this.state,
    this.date,
  });

  @override
  State<LeadDetails> createState() => _LeadDetailsState();
}

class _LeadDetailsState extends State<LeadDetails> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  DropdownItem? _selectedStatus;
  DateTime? selectedDateTime;
  DateTime toDate = DateTime.now();
  bool isLoading = false;
  bool _formValid = false;
  int statuss = 1;
  bool _statusError = false;
  bool _showErrors = false;
  String errorMessage = '', errorDesMessage = '';

  String date = '', description = '', tokenAmount = '', status = '';
  final List<String> noteTypes = [
    'Rs. 50',
    'Rs. 100',
    'Rs. 200',
    'Rs. 500',
    'Rs. 2000'
  ];
  final Map<String, int> selectedNotes = {};
  String? _selectedNoteType;
  TextEditingController _dateController = TextEditingController();
  late TextEditingController _descriptionController = TextEditingController();
  late TextEditingController _tokenController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _response = {};

  final List<Map<String, String>> items = [
    {'title': 'Active', 'date': '2023-07-01', 'description': 'Description 1gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg'},
    {'title': 'Active', 'date': '2023-07-02', 'description': 'Description 2'},
    {'title': 'Active', 'date': '2023-07-03', 'description': 'Description 3'},
  ];

  void _showNoteCountDialog(BuildContext context, String noteType) {
    final TextEditingController noteCountController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter No Of $noteType Notes'),
          backgroundColor: Colors.orange.shade50,
          content: TextField(
            controller: noteCountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Number of Notes',
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide:
                    BorderSide(color: Colors.orange), // Change border color
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide:
                    BorderSide(color: Colors.orange), // Change border color
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide:
                    BorderSide(color: Colors.orange), // Change border color
              ),
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedNotes[noteType] =
                        int.parse(noteCountController.text);
                    _selectedNoteType = noteType;
                  });
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _submitForm() {
    setState(() {
      _showErrors = true;
      _statusError = _selectedStatus == null;
    });

    if (_dateController.text.isEmpty) {
      setState(() {
        errorMessage = 'Please select a date';
      });
    } else {
      setState(() {
        errorMessage = '';
      });
    }

    if (_descriptionController.text.isEmpty) {
      setState(() {
        errorDesMessage = 'Please enter description';
      });
    } else {
      setState(() {
        errorDesMessage = '';
      });
    }
    bool _selectDate = _dateController.text.isNotEmpty;
    bool _tokenValid = _tokenController.text.isNotEmpty;
    bool _descriptionValid = _descriptionController.text.isNotEmpty;

    if (_selectedStatus.toString() == "3") {
      _formValid = _selectedStatus != null &&
          _selectDate &&
          _tokenValid &&
          _descriptionValid;
    } else if (_selectedStatus.toString() == "2") {
      _formValid = _selectedStatus != null && _selectDate && _descriptionValid;
    } else {
      _formValid = _selectedStatus != null && _descriptionValid;
    }

    if (_formValid && _formKey.currentState!.validate()) {
      print('tehfehehrh');
      _updateLead();
    }
  }

  Future<void> _updateLead() async {
    setState(() {
      isLoading = true;
    });

    date = _dateController.text.trim();
    tokenAmount = _tokenController.text.trim();
    description = _descriptionController.text.trim();
    status = _selectedStatus.toString();
    print(description);
    StatesServices statesServices = StatesServices();
    Map<String, dynamic> response = await statesServices.updateLeadbySales(
      widget.id.toString(),
      widget.mobileNo.toString(),
      status,
      date,
      description,
    );
    setState(() {
      _response = response;
      isLoading = false;
    });
    _showResponseAlert(response);
  }

  void _showResponseAlert(Map<String, dynamic> response) {
    bool status = response['status'] ?? false;
    String title = status ? "Done!" : "Ohh..!";
    _dateController.clear();
    _tokenController.clear();
    _descriptionController.clear();
    _selectedStatus = null;
    _showErrors = false;
    // _clearErrors();
    Alert(
      context: context,
      type: status ? AlertType.success : AlertType.info,
      title: title,
      content: Center(
          child: Text(
        response['message'],
        style: TextStyle(fontSize: 18),
      )),
      buttons: [
        DialogButton(
          child: Text(
            "OKAY",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.push(
            context,
            status
                ? MaterialPageRoute(builder: (context) => LeadList())
                : MaterialPageRoute(builder: (context) => LeadList()),
          ),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
          width: 120,
        )
      ],
    ).show();
  }

  Future<void> _selectToDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: toDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      String formattedDate = "${picked.day}-${picked.month}-${picked.year}";
      _dateController.text = formattedDate;
      errorMessage = '';
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<List<DropdownItem>> _fetchLeadStatus(String filter) async {
    final leadStatus = await StatesServices().getLeadStatus();
    if (leadStatus.status != true) {
      return [DropdownItem(id: -1, name: 'No data found')];
    }

    final statuses = leadStatus.statuses ?? [];
    if (filter.isEmpty) {
      return statuses
          .map((source) => DropdownItem(
              id: source.id!, name: source.status ?? 'Unknown Source'))
          .toList();
    } else {
      return statuses
          .where((source) =>
              source.status != null &&
              source.status!.toLowerCase().contains(filter.toLowerCase()))
          .map((source) => DropdownItem(id: source.id!, name: source.status!))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lead',style: TextStyle(fontWeight: FontWeight.bold),),
          backgroundColor: Color(0xFFFFA500),
          elevation: 5,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      width: w * 0.9,
                      height: h * 0.35,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: Color(0x33FFA500),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0x4CFFA500)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Name:',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              height: 1.4,
                                            ),
                                          ),
                                          Text(
                                            (widget.name?.toString() ==
                                                        'null' ||
                                                    widget.name == null)
                                                ? 'Not Found'
                                                : widget.name.toString(),
                                            style: TextStyle(
                                              color: CustomColors.greyTextColor,
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Lead Id:',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              height: 1.4,
                                            ),
                                          ),
                                          Text(
                                            (widget.id?.toString() == 'null' ||
                                                    widget.id == null)
                                                ? 'Not Found'
                                                : '#${widget.id.toString()}',
                                            style: TextStyle(
                                              color: CustomColors.greyTextColor,
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Address:',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              height: 1.4,
                                            ),
                                          ),
                                          Text(
                                            (widget.id == null ||
                                                        widget.id
                                                            .toString()
                                                            .isEmpty) &&
                                                    (widget.city == null ||
                                                        widget.city
                                                            .toString()
                                                            .isEmpty)
                                                ? 'Not found'
                                                : '${widget.id ?? ''},${widget.city ?? ''}',
                                            style: TextStyle(
                                              color: CustomColors.greyTextColor,
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Mobile No:',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              height: 1.4,
                                            ),
                                          ),
                                          Text(
                                            (widget.mobileNo?.toString() ==
                                                        'null' ||
                                                    widget.mobileNo == null)
                                                ? 'Not Found'
                                                : widget.mobileNo.toString(),
                                            style: TextStyle(
                                              color: CustomColors.greyTextColor,
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Email:',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              height: 1.4,
                                            ),
                                          ),
                                          Text(
                                            '',
                                            style: TextStyle(
                                              color: CustomColors.greyTextColor,
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Sources:',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              height: 1.4,
                                            ),
                                          ),
                                          Text(
                                            (widget.sourceName?.toString() ==
                                                        'null' ||
                                                    widget.sourceName == null)
                                                ? 'Not Found'
                                                : widget.sourceName.toString(),
                                            style: TextStyle(
                                              color: CustomColors.greyTextColor,
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Sales Partner:',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              height: 1.4,
                                            ),
                                          ),
                                          Text(
                                            (widget.assignedtoName
                                                            ?.toString() ==
                                                        'null' ||
                                                    widget.assignedtoName ==
                                                        null)
                                                ? 'Not Found'
                                                : widget.assignedtoName
                                                    .toString(),
                                            style: TextStyle(
                                              color: CustomColors.greyTextColor,
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Date:',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              height: 1.4,
                                            ),
                                          ),
                                          Text(
                                            (widget.date?.toString() ==
                                                        'null' ||
                                                    widget.date == null)
                                                ? 'Not Found'
                                                : widget.date
                                                    .toString()
                                                    .substring(0, 10),
                                            style: TextStyle(
                                              color: CustomColors.greyTextColor,
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Assigned Date:',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              height: 1.4,
                                            ),
                                          ),
                                          Text(
                                            (widget.date?.toString() ==
                                                        'null' ||
                                                    widget.date == null)
                                                ? 'Not Found'
                                                : widget.date
                                                    .toString()
                                                    .substring(0, 10),
                                            style: TextStyle(
                                              color: CustomColors.greyTextColor,
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_statusError)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6, left: 4),
                            child: Text(
                              'Please select a status',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        if (_statusError) SizedBox(height: 5),
                        Container(
                          height: 48,
                          width: w * 0.903,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: DropdownSearch<DropdownItem>(
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                hintText: "Select Status",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: Color(0x4CFFA500), width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: Color(0x4CFFA500), width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: Color(0x4CFFA500), width: 1),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.only(
                                  left: 20,
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              baseStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            onChanged: (DropdownItem? value) {
                              setState(() {
                                _selectedStatus = value;
                                statuss = value?.id ?? 0;
                                _statusError = false;
                              });
                            },
                            selectedItem: _selectedStatus,
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                        color: Color(0xFFFFA500), width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                        color: Color(0xFFFFA500), width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                        color: Color(0xFFFFA500), width: 1),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  hintText: "Search Status",
                                ),
                              ),
                              itemBuilder: (context, item, isSelected) {
                                return ListTile(
                                  title: Text(item.name,
                                      style: TextStyle(fontSize: 16)),
                                  selected: isSelected,
                                );
                              },
                              constraints: BoxConstraints(
                                maxHeight:
                                    250, // Set your desired maximum height here
                              ),
                            ),
                            asyncItems: (String filter) async {
                              return await _fetchLeadStatus(filter);
                            },
                          ),
                        ),
                      ],
                    ),
                    if (statuss == 3 || statuss == 2)
                      SizedBox(
                        height: 10,
                      ),
                    if (statuss == 3 || statuss == 2)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (errorMessage.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 6, left: 4),
                              child: Text(
                                errorMessage,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                          Container(
                            height: 48,
                            width: w * 0.9,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1, color: Color(0x4CFFA500)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 3,
                                  top: 4,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(),
                                    child: IconButton(
                                      icon: Icon(CupertinoIcons.calendar),
                                      onPressed: () {
                                        _selectToDate(context);
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 42, right: 10),
                                  child: TextFormField(
                                    controller: _dateController,
                                    readOnly: true,
                                    onTap: () {
                                      _selectToDate(context);
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Select Date',
                                      hintStyle: TextStyle(
                                          fontSize: 16, fontFamily: 'Roboto'),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 13, horizontal: 6.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    // if (statuss == 3)
                    SizedBox(
                      height: 10,
                    ),
                    // if (statuss == 3)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (errorDesMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6, left: 4),
                            child: Text(
                              errorDesMessage,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 250),
                          height: _isFocused ? h * 0.14 : h * 0.056,
                          width: w * 0.9,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _isFocused
                                  ? CustomColors.orangeColor
                                  : CustomColors.yellowBorderColor,
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _descriptionController,
                            onChanged: (text) {
                              setState(() {
                                if (text.length >= 1) {
                                  errorDesMessage = '';
                                }
                              });
                            },
                            style: TextStyle(fontSize: 17, color: Colors.black),
                            focusNode: _focusNode,
                            textAlign: TextAlign.justify,
                            maxLength: 125,
                            decoration: InputDecoration(
                              hintText: 'Enter Description',
                              hintStyle: TextStyle(
                                fontSize: 17,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Colors.white,
                              isDense: true,
                              counterText: '',
                              icon: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.description,
                                  size: 24,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 0.0),
                            ),
                            minLines: 4,
                            maxLines: null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_statusError)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6, left: 4),
                            child: Text(
                              'Please select a payment type',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        if (_statusError) SizedBox(height: 5),
                        Container(
                          height: 48,
                          width: w * 0.903,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: DropdownSearch<DropdownItem>(
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                hintText: "Select Payment Type",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: Color(0x4CFFA500), width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: Color(0x4CFFA500), width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: Color(0x4CFFA500), width: 1),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.only(
                                  left: 20,
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              baseStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            onChanged: (DropdownItem? value) {
                              setState(() {
                                _selectedStatus = value;
                                statuss = value?.id ?? 0;
                                _statusError = false;
                              });
                            },
                            selectedItem: _selectedStatus,
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                        color: Color(0xFFFFA500), width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                        color: Color(0xFFFFA500), width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                        color: Color(0xFFFFA500), width: 1),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  hintText: "Search Payment Type",
                                ),
                              ),
                              itemBuilder: (context, item, isSelected) {
                                return ListTile(
                                  title: Text(item.name,
                                      style: TextStyle(fontSize: 16)),
                                  selected: isSelected,
                                );
                              },
                              constraints: BoxConstraints(
                                maxHeight:
                                    250, // Set your desired maximum height here
                              ),
                            ),
                            asyncItems: (String filter) async {
                              return await _fetchLeadStatus(filter);
                            },
                          ),
                        ),
                      ],
                    ),
                    // if (statuss == 3)
                    SizedBox(
                      height: 10,
                    ),
                    if (statuss == 3)
                      CustomTextField(
                        controller: _tokenController,
                        hintText: 'Enter Token Amount',
                        icon: Icons.currency_rupee,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Token Amount';
                          }
                          return null;
                        },
                        showError: _showErrors,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                      ),
                    if (statuss == 3)
                      SizedBox(
                        height: 10,
                      ),
                    if (statuss == 3)
                      Container(
                        height: 48,
                        width: w * 0.903,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: DropdownSearch<String>(
                          items: noteTypes,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              hintText: "Select Notes",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Color(0x4CFFA500), width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Color(0x4CFFA500), width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Color(0x4CFFA500), width: 1),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.only(left: 20),
                              hintStyle:
                              TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            baseStyle:
                            TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              _showNoteCountDialog(context, newValue);
                            }
                          },
                          selectedItem: _selectedNoteType,
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: Color(0xFFFFA500), width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: Color(0xFFFFA500), width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: Color(0xFFFFA500), width: 1),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                hintText: "Search Notes",
                              ),
                            ),
                            itemBuilder: (context, item, isSelected) {
                              return ListTile(
                                title:
                                Text(item, style: TextStyle(fontSize: 16)),
                                trailing: Checkbox(
                                  value: selectedNotes.containsKey(item),
                                  onChanged: (bool? checked) {
                                    if (checked == true) {
                                      _showNoteCountDialog(context, item);
                                    } else {
                                      setState(() {
                                        selectedNotes.remove(item);
                                      });
                                    }
                                  },
                                ),
                                selected: isSelected,
                              );
                            },
                            constraints: BoxConstraints(
                              maxHeight: 250,
                            ),
                          ),
                        ),
                      ),
                    ...selectedNotes.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, top: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${entry.key} Note',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'No of Notes: ${entry.value}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    SizedBox(height: 30),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 150,
                        height: 50,
                        child: TextButton(
                          onPressed: _submitForm,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFFFFA500)),
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Color(0xFF2B9EBFF).withOpacity(0.2);
                              } else {
                                return Colors.transparent;
                              }
                            }),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                    color: Color(0x4CFFA500), width: 1),
                              ),
                            ),
                          ),
                          child: isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Previous Updates History',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                    Container(
                      height: 400,
                      child: PageView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return DescriptionCard(item: items[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
