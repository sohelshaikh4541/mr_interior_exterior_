import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interior_v_1/api/apiServices.dart';
import 'package:interior_v_1/model/lead_sources.dart';
import 'package:interior_v_1/widget/text_form_y.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class AssignProject extends StatefulWidget {
  const AssignProject({super.key});

  @override
  State<AssignProject> createState() => _AssignProjectState();
}

class _AssignProjectState extends State<AssignProject> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  DropdownItem? _selectedProject;
  DropdownItem? _selectedDesigner;
  DropdownItem? _selectedSupervisor;

  Future<List<DropdownItem>> _fetchDesigner(String filter) async {
    final statelist = await StatesServices().getStates();
    if (statelist.status != true) {
      return [DropdownItem(id: -1, name: 'No data found')];
    }

    final states = statelist.states ?? [];
    if (filter.isEmpty) {
      return states
          .map((state) =>
              DropdownItem(id: state.id!, name: state.name ?? 'Unknown Source'))
          .toList();
    } else {
      return states
          .where((state) =>
              state.name != null &&
              state.name!.toLowerCase().contains(filter.toLowerCase()))
          .map((state) => DropdownItem(id: state.id!, name: state.name!))
          .toList();
    }
  }

  Future<List<DropdownItem>> _fetchSupervisor(String filter) async {
    final statelist = await StatesServices().getStates();
    if (statelist.status != true) {
      return [DropdownItem(id: -1, name: 'No data found')];
    }

    final states = statelist.states ?? [];
    if (filter.isEmpty) {
      return states
          .map((state) =>
              DropdownItem(id: state.id!, name: state.name ?? 'Unknown Source'))
          .toList();
    } else {
      return states
          .where((state) =>
              state.name != null &&
              state.name!.toLowerCase().contains(filter.toLowerCase()))
          .map((state) => DropdownItem(id: state.id!, name: state.name!))
          .toList();
    }
  }

  Future<List<DropdownItem>> _fetchProject(String filter) async {
    final statelist = await StatesServices().getStates();
    if (statelist.status != true) {
      return [DropdownItem(id: -1, name: 'No data found')];
    }

    final states = statelist.states ?? [];
    if (filter.isEmpty) {
      return states
          .map((state) =>
              DropdownItem(id: state.id!, name: state.name ?? 'Unknown Source'))
          .toList();
    } else {
      return states
          .where((state) =>
              state.name != null &&
              state.name!.toLowerCase().contains(filter.toLowerCase()))
          .map((state) => DropdownItem(id: state.id!, name: state.name!))
          .toList();
    }
  }

  Future<void> _selectFromDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      String formattedDate = "${picked.day}-${picked.month}-${picked.year}";
      _startDateController.text = formattedDate;
      setState(() {});
    }
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
      _endDateController.text = formattedDate;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

    return Scaffold(
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '   Assign Project',
                    style: TextStyle(
                      color: Color(0xFF2A2828),
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
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
                        hintText: "Select Project",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x4CFFA500), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x4CFFA500), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x4CFFA500), width: 1),
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
                    ),
                    onChanged: (DropdownItem? value) {
                      setState(() {
                        _selectedProject = value;
                      });
                    },
                    selectedItem: _selectedProject,
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                BorderSide(color: Color(0xFFFFA500), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                BorderSide(color: Color(0xFFFFA500), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                BorderSide(color: Color(0xFFFFA500), width: 1),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          hintText: "Search Project",
                        ),
                      ),
                      itemBuilder: (context, item, isSelected) {
                        return ListTile(
                          title: Text(item.name, style: TextStyle(fontSize: 14)),
                          selected: isSelected,
                        );
                      },
                    ),
                    asyncItems: (String filter) async {
                      return await _fetchProject(filter);
                    },
                  ),
                ),
                SizedBox(height: 10),
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
                        hintText: "Select Designer",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x4CFFA500), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x4CFFA500), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x4CFFA500), width: 1),
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
                    ),
                    onChanged: (DropdownItem? value) {
                      setState(() {
                        _selectedDesigner = value;
                      });
                    },
                    selectedItem: _selectedDesigner,
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                BorderSide(color: Color(0xFFFFA500), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                BorderSide(color: Color(0xFFFFA500), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                BorderSide(color: Color(0xFFFFA500), width: 1),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          hintText: "Search Designer",
                        ),
                      ),
                      itemBuilder: (context, item, isSelected) {
                        return ListTile(
                          title: Text(item.name, style: TextStyle(fontSize: 14)),
                          selected: isSelected,
                        );
                      },
                    ),
                    asyncItems: (String filter) async {
                      return await _fetchDesigner(filter);
                    },
                  ),
                ),
                SizedBox(height: 10),
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
                        hintText: "Select Supervisor",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x4CFFA500), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x4CFFA500), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x4CFFA500), width: 1),
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
                    ),
                    onChanged: (DropdownItem? value) {
                      setState(() {
                        _selectedSupervisor = value;
                      });
                    },
                    selectedItem: _selectedSupervisor,
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                BorderSide(color: Color(0xFFFFA500), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                BorderSide(color: Color(0xFFFFA500), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                BorderSide(color: Color(0xFFFFA500), width: 1),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          hintText: "Search Supervisor",
                        ),
                      ),
                      itemBuilder: (context, item, isSelected) {
                        return ListTile(
                          title: Text(item.name, style: TextStyle(fontSize: 14)),
                          selected: isSelected,
                        );
                      },
                    ),
                    asyncItems: (String filter) async {
                      return await _fetchSupervisor(filter);
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 150,
                    height: 50,
                    child: TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFFFFA500)),
                        overlayColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Color(0xFF2B9EBFF).withOpacity(0.2);
                          } else {
                            return Colors.transparent;
                          }
                        }),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side:
                                BorderSide(color: Color(0x4CFFA500), width: 1),
                          ),
                        ),
                      ),
                      child: Text(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
