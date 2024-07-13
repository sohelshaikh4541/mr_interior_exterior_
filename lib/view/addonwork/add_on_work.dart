import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:interior_v_1/widget/text_form_y.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/apiServices.dart';
import '../../helper/custome_colour.dart';
import '../../helper/location_widget.dart';
import '../../model/get_work_rate_list_model.dart';
import '../../model/lead_sources.dart';
import '../project/project_list.dart';

class AddOnWork extends StatefulWidget {
  const AddOnWork({super.key});

  @override
  State<AddOnWork> createState() => _AddOnWorkState();
}

class _AddOnWorkState extends State<AddOnWork> {
  late TextEditingController _endDateController = TextEditingController();
  late TextEditingController _projectNameController = TextEditingController();
  late TextEditingController _flatNoController = TextEditingController();
  late TextEditingController _addressController = TextEditingController();
  late TextEditingController _priceController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController = TextEditingController();
  late TextEditingController _pincodeController = TextEditingController();

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  String errorMessage = '';
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();
  String gpsLocation = '';
  List<int> _selectedCategoryIds = [];

  DropdownItem? _selectedClient;
  DropdownItem? _selectedPayment;
  DropdownItem? _selectedPackage;
  int? _selectedPackageId;
  String? _selectedPackagePrice;
  int? _selectedClientId;
  int? _selectedPaymentId;
  bool _showErrors = false;
  bool _packageError = false;
  bool _packagePriceError = false;
  bool _clientError = false;
  bool _paymentError = false;
  bool _cityError = false;
  bool _packageTypeError = false;

  String errorDesMessage = '';
  bool isLoading = false;
  DropdownItem? _selectedState;
  int? _selectedStateId;
  bool _stateError = false;
  bool _isProjectEnabled = false;
  bool _isPropertyEnabled = false;
  DropdownItem? _selectedCity;
  DropdownItem? _selectedProperty;
  List<String> productArray = [];
  List<int> countArray = [];
  bool isCategorySelected = false;
  final List<String> noteTypes = [
    'Rs. 50',
    'Rs. 100',
    'Rs. 200',
    'Rs. 500',
    'Rs. 2000'
  ];
  final List<String> productTypes = [
    'Bed',
    'Stand',
    'Drawer',
    'Wardrobe',
    'Table'
  ];
  final Map<String, int> selectedNotes = {};
  Map<String, List<dynamic>> selectedProduct = {};
  String? _selectedNoteType;
  String? _selectedItemProduct;
  DropdownItemRate? _selectedProductType;
  DropdownItem? _selectedCategoryType;
  String? _selectedProductPrice;
  String clientId = '',
      projectName = '',
      address = '',
      date = '',
      price = '',
      packageId = '',
      description = '',
      zip = '',
      state = '',
      city = '',
      projectType = '',
      userId = '';
  double totalAmount = 0;

  final LocationService _locationService = LocationService();
  Position? _currentPosition;
  bool _locStatus = false;
  String? _currentAddress;

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
                    BorderSide(color: Colors.orange),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide:
                    BorderSide(color: Colors.orange),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide:
                    BorderSide(color: Colors.orange),
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

  void _showAddOnWorkCountDialog(
      BuildContext context, String noteType, String Measure, String Rate) {
    final TextEditingController sqftCountController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter $Measure Of $noteType'),
          backgroundColor: Colors.orange.shade50,
          content: TextField(
            controller: sqftCountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Enter $Measure',
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.orange),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.orange),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.orange),
              ),
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedProduct[noteType] = [
                      int.parse(sqftCountController.text),
                      int.parse(Rate),
                      Measure
                    ];
                    _selectedProductPrice = noteType;
                    _updateTotalAmount();
                    _selectedItemProduct = sqftCountController.text;
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

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  Future<void> _fetchLocation() async {
    try {
      Position position = await _locationService.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });

      String address = await _locationService.getAddressFromLatLng(position);
      setState(() {
        _currentAddress = address;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _addProject() async {
    setState(() {
      isLoading = true;
    });

    clientId = _selectedClientId.toString();
    projectName = _projectNameController.text.trim();
    address = _addressController.text.trim();
    date = _endDateController.text.trim();
    price = _priceController.text.trim();
    packageId = _selectedPackageId.toString();
    zip = _pincodeController.text.trim();
    state = _selectedState.toString();
    city = _selectedCity.toString();
    description = _descriptionController.text.trim();

    print('41105 $zip');

    StatesServices statesServices = StatesServices();
    Map<String, dynamic> response = await statesServices.addProject(
        userId,
        clientId,
        projectName,
        address,
        zip,
        city,
        state,
        date,
        price,
        packageId,
        description);

    Map<String, dynamic> _response = {};

    setState(() {
      _response = response;
      isLoading = false;
    });

    _showResponseAlert(response);
  }

  Future<void> _postPrice() async {
    setState(() {
      isLoading = true;
    });

    packageId = _selectedPackageId.toString();
    projectType = _selectedProperty.toString();

    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      userId = sp.getString('userid') ?? '';
    });

    print('41105 $zip');

    StatesServices statesServices = StatesServices();
    Map<String, dynamic> response =
        await statesServices.getPrice(userId, packageId, projectType);

    Map<String, dynamic> _response = {};

    setState(() {
      _response = response;
      isLoading = false;
      _priceController = TextEditingController(text: response['data']['price']);
    });
  }

  void _showResponseAlert(Map<String, dynamic> response) {
    bool status = response['status'] ?? false;
    String title = status ? "Done!" : "Ohh..!";
    _endDateController.clear();
    _addressController.clear();
    _pincodeController.clear();
    _flatNoController.clear();
    _selectedPackage = null;
    _selectedCity = null;
    _selectedState = null;
    _selectedClient = null;

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
                ? MaterialPageRoute(builder: (context) => ProjectList())
                : MaterialPageRoute(builder: (context) => ProjectList()),
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

  void _submitForm() {
    setState(() {
      _showErrors = true;
      _packageError = _selectedPackage == null;
      _clientError = _selectedClient == null;
      _cityError = _selectedCity == null;
      _packageTypeError = _selectedProperty == null;
      _stateError = _selectedState == null;
    });

    if (_endDateController.text.isEmpty) {
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

    bool _projectNameValid = _projectNameController.text.isNotEmpty;
    bool _flatNoValid = _flatNoController.text.isNotEmpty;
    bool _addressValid = _addressController.text.isNotEmpty;
    bool _priceValid = _selectedPackagePrice.toString().isNotEmpty;
    bool _pincodeValid = _pincodeController.text.isNotEmpty;

    bool _formValid = _projectNameValid &&
        _flatNoValid &&
        _addressValid &&
        _priceValid &&
        _pincodeValid &&
        _selectedPackage != null;
    _selectedProperty != null;
    _selectedClient != null;
    _selectedCity != null;
    _selectedState != null;

    if (_formValid && _formKey.currentState!.validate()) {
      _addProject();
    }
  }

  Future<List<DropdownItem>> _fetchClient(String filter) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      userId = sp.getString('userid') ?? '';
    });

    final clients = await StatesServices().getClient(userId);
    if (clients.status != true) {
      return [DropdownItem(id: -1, name: 'No data found')];
    }
    final client = clients.clients ?? [];
    if (filter.isEmpty) {
      return client
          .map((client) => DropdownItem(
              id: client.id!, name: client.name ?? 'Unknown Source'))
          .toList();
    } else {
      return client
          .where((client) =>
              client.name != null &&
              client.name!.toLowerCase().contains(filter.toLowerCase()))
          .map((client) => DropdownItem(id: client.id!, name: client.name!))
          .toList();
    }
  }

  Future<List<DropdownItem>> _fetchPaymentType(String filter) async {
    final paayment_type = await StatesServices().getPaymentType();
    if (paayment_type.status != true) {
      return [DropdownItem(id: -1, name: 'No data found')];
    }
    final payments = paayment_type.data ?? [];
    if (filter.isEmpty) {
      return payments
          .map((payment) => DropdownItem(
          id: payment.id!, name: payment.paymentType ?? 'Unknown Source'))
          .toList();
    } else {
      return payments
          .where((payment) =>
      payment.paymentType != null &&
          payment.paymentType!.toLowerCase().contains(filter.toLowerCase()))
          .map((client) => DropdownItem(id: client.id!, name: client.paymentType!))
          .toList();
    }
  }

  Future<List<DropdownItem>> _fetchProject(String filter, int client) async {
    final projectlist = await StatesServices().getProjectDD(client.toString());
    if (projectlist.status != true) {
      print('NewPackage${projectlist.data}');
      return [DropdownItem(id: -1, name: 'No data found')];
    }

    final projects = projectlist.data ?? [];
    if (filter.isEmpty) {
      return projects
          .map((project) => DropdownItem(
              id: project.id!, name: project.projectName ?? 'Unknown Package'))
          .toList();
    } else {
      return projects
          .where((project) =>
              project.projectName != null &&
              project.projectName!.toLowerCase().contains(filter.toLowerCase()))
          .map((project) => DropdownItem(
                id: project.id!,
                name: project.projectName!,
              ))
          .toList();
    }
  }

  Future<List<DropdownItem>> _fetchCategory(String filter) async {
    final categoryItem = await StatesServices().getCategoryItem();
    if (categoryItem.status != true) {
      return [DropdownItem(id: -1, name: 'No data found')];
    }

    final category = categoryItem.categories ?? [];
    if (filter.isEmpty) {
      return category
          .map((category) => DropdownItem(
              id: category.id!, name: category.category ?? 'Unknown Source'))
          .toList();
    } else {
      return category
          .where((category) =>
              category.category != null &&
              category.category!.toLowerCase().contains(filter.toLowerCase()))
          .map((category) =>
              DropdownItem(id: category.id!, name: category.category!))
          .toList();
    }
  }

  Future<List<DropdownItemRate>> _fetchFilteredWorkRateList(
      String filter) async {
    print('Selected Category IDs: $_selectedCategoryIds');
    final workpricecharts = await StatesServices().getWorkRateList();
    print('API Response: ${workpricecharts.toJson()}');
    if (workpricecharts.status != true) {
      return [
        DropdownItemRate(
            id: -1, category: 'No data found', item: '', measure: '', rate: '')
      ];
    }

    final workpricechartList = workpricecharts.workpricecharts ?? [];
    List<DropdownItemRate> filteredList = workpricechartList
        .where((workpricechart) {
          int? categoryId = int.tryParse(workpricechart.category ?? '');
          print('Category ID: $categoryId');
          return categoryId != null &&
              _selectedCategoryIds.contains(categoryId);
        })
        .map((workpricechart) => DropdownItemRate(
              id: workpricechart.id!,
              category: workpricechart.category ?? 'Unknown Source',
              item: workpricechart.item ?? 'Unknown Item',
              measure: workpricechart.measure ?? 'Unknown Measure',
              rate: workpricechart.rate ?? 'Unknown Rate',
            ))
        .toList();

    print('Filtered list before applying filter: $filteredList');

    if (filter.isEmpty) {
      print('No filter applied, returning filtered list.');
      return filteredList;
    } else {
      List<DropdownItemRate> finalFilteredList =
          filteredList.where((workpricechart) {
        bool matches =
            workpricechart.item.toLowerCase().contains(filter.toLowerCase());
        print('Filtering item: ${workpricechart.item}, matches: $matches');
        return matches;
      }).toList();

      print('Filtered list after applying filter: $finalFilteredList');
      return finalFilteredList;
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
      errorMessage = '';
      setState(() {});
    }
  }

  void _updateTotalAmount() {
    double total = 0;
    selectedProduct.forEach((key, value) {
      int quantity;
      int unitPrice = value[1];
      String measure = value[2];
      int totalPrice;
      if (measure == 'Sqft' || measure == 'Peice') {
        quantity = value[0];
        total += quantity * unitPrice;
      } else if (measure == 'Total Package') {
        quantity = value[0];
        double decimalForm = unitPrice / 100.0;
        total += quantity * decimalForm;
      } else {
        print(unitPrice);
        total += unitPrice;
      }
    });
    setState(() {
      totalAmount = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '   Add Project',
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_clientError)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6, left: 4),
                          child: Text(
                            'Please select a Client',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      if (_clientError) SizedBox(height: 5),
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
                              hintText: "Select Client",
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
                              _selectedClient = value;
                              _selectedClientId = value?.id;
                              _clientError = false;
                              _isProjectEnabled = value != null;
                            });
                          },
                          selectedItem: _selectedClient,
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
                                hintText: "Search Client",
                              ),
                            ),
                            itemBuilder: (context, item, isSelected) {
                              return ListTile(
                                title: Text(item.name.toUpperCase(),
                                    style: TextStyle(fontSize: 14)),
                                selected: isSelected,
                              );
                            },
                          ),
                          asyncItems: (String filter) async {
                            return await _fetchClient(filter);
                          },
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
                      if (_packageError)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6, left: 4),
                          child: Text(
                            'Please select a Project',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      if (_packageError) SizedBox(height: 5),
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
                        child: IgnorePointer(
                          ignoring: !_isProjectEnabled,
                          child: DropdownSearch<DropdownItem>(
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                hintText: _isProjectEnabled
                                    ? "Select Project"
                                    : "Please select a Client first",
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
                                _selectedPackage = value;
                                _selectedPackageId = value?.id;
                                _isPropertyEnabled = value != null;
                                _packageError = false;
                              });
                            },
                            selectedItem: _selectedPackage,
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
                                  hintText: "Search Project",
                                ),
                              ),
                              itemBuilder: (context, item, isSelected) {
                                return ListTile(
                                  title: Text(item.name,
                                      style: TextStyle(fontSize: 14)),
                                  selected: isSelected,
                                );
                              },
                              constraints: BoxConstraints(
                                maxHeight:
                                    300, // Set your desired maximum height here
                              ),
                            ),
                            asyncItems: (String filter) async {
                              if (_selectedClient == null) {
                                return [
                                  DropdownItem(
                                      id: -1,
                                      name: 'Please select a Client first')
                                ];
                              }
                              return await _fetchProject(
                                  filter, _selectedClient!.id);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
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
                          hintText: "Select Category",
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
                          contentPadding: EdgeInsets.only(left: 20),
                          hintStyle:
                              TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        baseStyle: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      onChanged: (DropdownItem? newValue) {
                        if (newValue != null) {
                          setState(() {
                            if (_selectedCategoryIds.contains(newValue.id)) {
                              _selectedCategoryIds.remove(newValue.id);
                            } else {
                              _selectedCategoryIds.add(newValue.id);
                            }
                            isCategorySelected = true;
                          });
                        }
                      },
                      selectedItem: _selectedCategoryType,
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
                            hintText: "Search Category",
                          ),
                        ),
                        itemBuilder: (context, item, isSelected) {
                          return ListTile(
                            title:
                                Text(item.name, style: TextStyle(fontSize: 16)),
                            trailing: Checkbox(
                              value: _selectedCategoryIds.contains(item.id),
                              onChanged: (bool? checked) {
                                setState(() {
                                  if (checked == true) {
                                    _selectedCategoryIds.add(item.id);
                                  } else {
                                    _selectedCategoryIds.remove(item.id);
                                  }
                                });
                              },
                            ),
                            selected: isSelected,
                          );
                        },
                        constraints: BoxConstraints(
                          maxHeight: 350,
                        ),
                      ),
                      asyncItems: (String filter) async {
                        return await _fetchCategory(filter);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      if (!isCategorySelected) {
                        Fluttertoast.showToast(
                          msg: "Please select a category first",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                    child: AbsorbPointer(
                      absorbing: !isCategorySelected,
                      child: Container(
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
                        child: DropdownSearch<DropdownItemRate>(
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              hintText: "Select Product",
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
                          onChanged: (DropdownItemRate? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedProductType = newValue;
                              });
                              if (newValue.measure == 'Sqft' ||
                                  newValue.measure == 'Peice') {
                                _showAddOnWorkCountDialog(
                                    context,
                                    newValue.item,
                                    newValue.measure,
                                    newValue.rate);
                              } else if (newValue.measure == 'Total Package') {
                                selectedProduct[newValue.item] = [
                                  20000,
                                  int.parse(newValue.rate),
                                  newValue.measure,
                                ];
                                _updateTotalAmount();
                                _selectedItemProduct = '20';
                              } else {
                                selectedProduct[newValue.item] = [
                                  newValue.measure,
                                  int.parse(newValue.rate),
                                  newValue.measure,
                                ];
                                _updateTotalAmount();
                                _selectedItemProduct = newValue.measure;
                              }
                            }
                          },
                          selectedItem: _selectedProductType,
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
                                hintText: "Search Product",
                              ),
                            ),
                            itemBuilder: (context, item, isSelected) {
                              return ListTile(
                                title: Text(item.item,
                                    style: TextStyle(fontSize: 16)),
                                selected: isSelected,
                              );
                            },
                            constraints: BoxConstraints(
                              maxHeight: 350,
                            ),
                          ),
                          asyncItems: (String filter) async {
                            return await _fetchFilteredWorkRateList(filter);
                          },
                        ),
                      ),
                    ),
                  ),
                  if (_selectedItemProduct != null)
                    SizedBox(
                      height: 10,
                    ),
                  if (_selectedItemProduct != null)
                    Container(
                      width: w * 0.9,
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
                      child: Column(
                        children: [
                          ...selectedProduct.entries.map((entry) {
                            int quantity = 0;
                            String quantityStr = '';
                            int unitPrice = entry.value[1];
                            String measure = entry.value[2];
                            print('jdjdkdkdkdkd$measure');
                            int totalPrice;
                            if (measure == 'Sqft' || measure == 'Peice') {
                              quantity = entry.value[0];
                              totalPrice = quantity * unitPrice;
                            } else if (measure == 'Total Package') {
                              quantity = entry.value[0];
                              double decimalForm = unitPrice / 100.0;
                              double totalP = quantity * decimalForm;
                              totalPrice = totalP.toInt();
                            } else {
                              quantityStr = measure;
                              totalPrice = unitPrice;
                            }
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 30, right: 30, top: 10, bottom: 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          '${entry.key}',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${measure == 'Sqft' || measure == 'Peice' ? quantity : ''} ${measure == 'Total Package' ? quantity : measure} X ${measure == 'Total Package' ? '$unitPrice%' : 'Rs.$unitPrice'}',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          Text(
                                            '= Rs.$totalPrice',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          Divider(
                            // This adds the horizontal line
                            color: Colors.black,
                            thickness: 1.2,
                            height: 10,
                            indent: 20,
                            endIndent: 20,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: 25,
                              right: 25,
                              top: 5,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Amount',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '= Rs.$totalAmount/-',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     productArray.clear();
                  //     countArray.clear();
                  //
                  //     selectedProduct.forEach((product, count) {
                  //       productArray.add(product);
                  //       countArray.add(count);
                  //     });
                  //
                  //     // Print arrays to verify
                  //     print('Product Array: $productArray');
                  //     print('Count Array: $countArray');
                  //
                  //     // Handle the submit action, e.g., send to server or navigate to another page
                  //   },
                  //   child: Text('Submit'),
                  // ),
                  if (_packagePriceError)
                    SizedBox(
                      height: 10,
                    ),
                  if (_packagePriceError)
                    CustomTextField(
                      controller: _priceController,
                      hintText: '',
                      icon: Icons.currency_rupee,
                      editable: false,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                    ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_paymentError)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6, left: 4),
                          child: Text(
                            'Please select a Payment Mode',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      if (_paymentError) SizedBox(height: 5),
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
                              hintText: "Select Payment Mode",
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
                              _selectedPayment = value;
                              _selectedPaymentId = value?.id;
                              _paymentError = false;
                            });
                          },
                          selectedItem: _selectedClient,
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
                                hintText: "Search Payment Mode",
                              ),
                            ),
                            itemBuilder: (context, item, isSelected) {
                              return ListTile(
                                title: Text(item.name.toUpperCase(),
                                    style: TextStyle(fontSize: 14)),
                                selected: isSelected,
                              );
                            },
                          ),
                          asyncItems: (String filter) async {
                            return await _fetchPaymentType(filter);
                          },
                        ),
                      ),
                    ],
                  ),
                  if (_selectedPayment != null && _selectedPayment!.name != 'Cash')
                    SizedBox(
                      height: 10,
                    ),
                  if (_selectedPayment != null && _selectedPayment!.name != 'Cash')
                    CustomTextField(
                      controller: _priceController,
                      hintText: 'Enter Transaction Id',
                      icon: Icons.confirmation_number_outlined,
                      editable: false,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                    ),
                  if (_selectedPayment != null && _selectedPayment!.name == 'Cash')
                  SizedBox(height: 10),
                  if (_selectedPayment != null && _selectedPayment!.name == 'Cash')
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
                          contentPadding: EdgeInsets.only(left: 20),
                          hintStyle:
                              TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        baseStyle: TextStyle(fontSize: 16, color: Colors.black),
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
                            title: Text(item, style: TextStyle(fontSize: 16)),
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
                          maxHeight: 350,
                        ),
                      ),
                    ),
                  ),
                  if (_selectedPayment != null && _selectedPayment!.name == 'Cash')
                    SizedBox(height: 10),
                  if (_selectedPayment != null && _selectedPayment!.name == 'Cash')                    Container(
                    width: w * 0.9,
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
                    child: Column(
                      children: [
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
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6, left: 4),
                          child: Text(
                            errorMessage,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      Container(
                        height: 48,
                        width: w * 0.9,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side:
                                BorderSide(width: 1, color: Color(0x4CFFA500)),
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
                                  icon: Icon(CupertinoIcons.calendar_today),
                                  onPressed: () {
                                    _selectToDate(context);
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 42, right: 10),
                              child: TextFormField(
                                controller: _endDateController,
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
                      SizedBox(
                        height: 10,
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
                    height: 30,
                  ),
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                  color: Color(0x4CFFA500), width: 1),
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
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
