import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:interior_v_1/api/appConstant.dart';
import 'package:interior_v_1/model/city_drop_model.dart';
import 'package:interior_v_1/model/get_category_item_model.dart';
import 'package:interior_v_1/model/get_leads.dart';
import 'package:interior_v_1/model/get_payment_type.dart';
import 'package:interior_v_1/model/get_project_model.dart';
import 'package:interior_v_1/model/get_property_type.dart';
import 'package:interior_v_1/model/get_work_rate_list_model.dart';
import 'package:interior_v_1/model/lead_sources.dart';
import 'package:interior_v_1/model/lead_status.dart';
import 'package:interior_v_1/model/state_drop_model.dart';

import '../model/get_client_list.dart';
import '../model/get_deduction_package.dart';
import '../model/get_sales_partner.dart';
import '../model/package_drop_model.dart';

class StatesServices {
  Future<Map<String, dynamic>> postLogin(String text) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstant.postLogin),
        body: {'mobile_no': text},
      );

      Map<String, dynamic> data = jsonDecode(response.body.toString());

      if (response.statusCode == 200) {
        print(data);
        return data;
      } else {
        print(data);
        return data;
      }
    } catch (e) {
      print(e.toString());
      return {'message': e.toString()};
    }
  }

  // Future<List<PackagesDropModel>> getPackages() async {
  //   try {
  //     final response = await http.get(Uri.parse(AppConstant.packages));
  //     final body = json.decode(response.body) as List;
  //
  //     if (response.statusCode == 200) {
  //       return body.map((e) {
  //         final map = e as Map<String, dynamic>;
  //         print(map);
  //         return PackagesDropModel.fromJson(map);
  //       }).toList();
  //     }
  //   } on SocketException {
  //     throw Exception('No Internet');
  //   }
  //   throw Exception('Error Fetching Data');
  // }

  Future<PackageDropModel> getPackages(String userId) async {
    try {
      final response = await http.post(Uri.parse(AppConstant.packages),
        body: {'user_id': userId.toString()},
      );
      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        print('NewPackage123${body.toString()}');
        return PackageDropModel.fromJson(body);
      }
    } on SocketException {
      throw Exception('No Internet');
    }
    throw Exception('Error Fetching Data');
  }

  Future<GetPropertyType> getPropertyType(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstant.getPropertyType),
        body: {'user_id': userId.toString()},
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        print('NewPackage123${body.toString()}');
        return GetPropertyType.fromJson(body);
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No Internet');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<LeadSources> getLeadSource() async {
    try {
      final response = await http.get(Uri.parse(AppConstant.leadSource));
      final body = json.decode(response.body);

      if (response.statusCode == 200) {
        return LeadSources.fromJson(body);
      }
    } on SocketException {
      throw Exception('No Internet');
    }
    throw Exception('Error Fetching Data');
  }

  Future<LeadStatus> getLeadStatus() async {
    try {
      final response = await http.get(Uri.parse(AppConstant.getLeadStatus));
      final body = json.decode(response.body);

      if (response.statusCode == 200) {
        return LeadStatus.fromJson(body);
      }
    } on SocketException {
      throw Exception('No Internet');
    }
    throw Exception('Error Fetching Data');
  }

  Future<StateDropModel> getStates() async {
    try {
      final response = await http.get(Uri.parse(AppConstant.states));
      final body = json.decode(response.body);

      if (response.statusCode == 200) {
        return StateDropModel.fromJson(body);
      }
    } on SocketException {
      throw Exception('No Internet');
    }
    throw Exception('Error Fetching Data');
  }

  Future<GetCategoryItem> getCategoryItem() async {
    try {
      final response = await http.get(Uri.parse(AppConstant.getCategoryItem));
      final body = json.decode(response.body);

      if (response.statusCode == 200) {
        return GetCategoryItem.fromJson(body);
      }
    } on SocketException {
      throw Exception('No Internet');
    }
    throw Exception('Error Fetching Data');
  }

  Future<GetDeductionPackage> getDeductionPackage() async {
    try {
      final response = await http.get(Uri.parse(AppConstant.getPackageDeduction));
      final body = json.decode(response.body);

      if (response.statusCode == 200) {
        return GetDeductionPackage.fromJson(body);
      }
    } on SocketException {
      throw Exception('No Internet');
    }
    throw Exception('Error Fetching Data');
  }

  Future<GetWorkRateList> getWorkRateList() async {
    try {
      final response = await http.get(Uri.parse(AppConstant.getWorkRateList));
      final body = json.decode(response.body);

      if (response.statusCode == 200) {
        return GetWorkRateList.fromJson(body);
      }
    } on SocketException {
      throw Exception('No Internet');
    }
    throw Exception('Error Fetching Data');
  }

  Future<CityDropModel> getCities(int stateId) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstant.cities),
        body: {'state_id': stateId.toString()},
      );
      final body = json.decode(response.body);

      if (response.statusCode == 200) {
        return CityDropModel.fromJson(body);
      }
    } on SocketException {
      throw Exception('No Internet');
    }
    throw Exception('Error Fetching Data');
  }

  Future<Map<String, dynamic>> addLead(
      String name,
      String mobileNo,
      String email,
      String date,
      String address,
      String zip,
      String city,
      String state,
      String sources,
      String partner) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstant.addLead),
        body: {
          'name': name,
          'mobile_no': mobileNo,
          'email': email,
          'dateadded': date,
          'address': address,
          'zip': zip,
          'city': city,
          'state': state,
          'source': sources,
          'assigned': partner,
          'addedfrom': '2',
          'status': '1',
        },
      );

      Map<String, dynamic> data = jsonDecode(response.body.toString());

      if (response.statusCode == 200) {
        print(data);
        return data;
      } else {
        print(data);
        return data;
      }
    } catch (e) {
      print(e.toString());
      return {'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateLead(
      String leadId,
      String name,
      String email,
      String mobileNo,
      String address,
      String zip,
      String city,
      String state,
      String date,
      String source,
      String partner) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstant.updateLead),
        body: {
          'id': leadId,
          'name': name,
          'email': email,
          'mobile_no': mobileNo,
          'address': address,
          'country': 'India',
          'dateadded': date,
          'zip': zip,
          'city': city,
          'state': state,
          'source': source,
          'assigned': partner,
        },
      );
      print('DateNewq$date');
      Map<String, dynamic> data = jsonDecode(response.body.toString());

      if (response.statusCode == 200) {
        print("AddLeadNew$data");
        return data;
      } else {
        print(data);
        return data;
      }
    } catch (e) {
      print(e.toString());
      return {'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateLeadbySales(
    String leadId,
    String mobileNo,
    String date,
    String token,
    String description,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstant.updateLead),
        body: {
          'id': leadId,
          'mobile_no': mobileNo,
          'state': date,
          'description': description,
        },
      );

      Map<String, dynamic> data = jsonDecode(response.body.toString());

      if (response.statusCode == 200) {
        print("AddLeadNew$data");
        return data;
      } else {
        print(data);
        return data;
      }
    } catch (e) {
      print(e.toString());
      return {'message': e.toString()};
    }
  }

  Future<List<dynamic>> getLeads(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstant.getLeads),
        body: {'user_id': userId},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        print('Data received: $data');
        if (data.containsKey('leads')) {
          return data['leads'] as List<dynamic>;
        } else {
          throw Exception('Key "data" not found in response');
        }
      } else {
        throw Exception('Error Fetching Data');
      }
    } on SocketException {
      throw Exception('No Internet');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> addClient(
      String userId,
      String name,
      String email,
      String mobileNo,
      String address,
      String zip,
      String city,
      String state,
      String source) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstant.addClient),
        body: {
          'user_id': userId,
          'name': name,
          'email': email,
          'mobile_no': mobileNo,
          'address': address,
          'country': 'India',
          'zip': zip,
          'city': city,
          'state': state,
          'source': source,
        },
      );

      Map<String, dynamic> data = jsonDecode(response.body.toString());

      if (response.statusCode == 200) {
        print("AddLeadNew$data");
        return data;
      } else {
        print(data);
        return data;
      }
    } catch (e) {
      print(e.toString());
      return {'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateClient(
      String userId,
      String name,
      String email,
      String mobileNo,
      String address,
      String zip,
      String city,
      String state,
      String source) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstant.updateClient),
        body: {
          'client_id': userId,
          'name': name,
          'email': email,
          'mobile_no': mobileNo,
          'address': address,
          'country': 'India',
          'zip': zip,
          'city': city,
          'state': state,
          'source': source,
        },
      );

      Map<String, dynamic> data = jsonDecode(response.body.toString());

      if (response.statusCode == 200) {
        print("AddLeadNew$data");
        return data;
      } else {
        print(data);
        return data;
      }
    } catch (e) {
      print(e.toString());
      return {'message': e.toString()};
    }
  }

  Future<List<dynamic>> getClients(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstant.getClients),
        body: {'user_id': userId},
      );
      print('getClients Enter${response.toString()}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        print('Data received: $data');
        if (data.containsKey('clients')) {
          return data['clients'] as List<dynamic>;
        } else {
          throw Exception('Key "data" not found in response');
        }
      } else {
        throw Exception('Error Fetching Data');
      }
    } on SocketException {
      throw Exception('No Internet');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<GetSalesPartner> getUser(String usertype) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstant.getUser),
        body: {'usertype': usertype},
      );
      final body = json.decode(response.body);

      if (response.statusCode == 200) {
        return GetSalesPartner.fromJson(body);
      }
    } on SocketException {
      throw Exception('No Internet');
    }
    throw Exception('Error Fetching Data');
  }

  Future<GetClientList> getClient(String user_id) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstant.getClients),
        body: {'user_id': user_id},
      );

      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        return GetClientList.fromJson(body);
      }
    } on SocketException {
      throw Exception('No Internet');
    }
    throw Exception('Error Fetching Data');
  }

  Future<Map<String, dynamic>> addProject(
      String userId,
      String client_id,
      String project_name,
      String address,
      String zip,
      String city,
      String state,
      String date,
      String price,
      String package_id,
      String description) async {
    print('PriceNet : -$description');
    try {
      final response = await http.post(
        Uri.parse(AppConstant.addProject),
        body: {
          'user_id': userId,
          'client_id': client_id,
          'project_name': project_name,
          'address': address,
          'zip': zip,
          'city': city,
          'state': state,
          'date': date,
          'package_id': package_id,
          'price': price,
          'description': description,
        },
      );

      Map<String, dynamic> data = jsonDecode(response.body.toString());

      if (response.statusCode == 200) {
        print("AddLeadNew$data");
        return data;
      } else {
        print(data);
        return data;
      }
    } catch (e) {
      print(e.toString());
      return {'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getPrice(
      String userId,
      String package_id,
      String property_type) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstant.getPackage),
        body: {
          'user_id': userId,
          'package_id': package_id,
          'property_type': property_type,
        },
      );

      Map<String, dynamic> data = jsonDecode(response.body.toString());

      if (response.statusCode == 200) {
        print("AddLeadNew$data");
        return data;
      } else {
        print(data);
        return data;
      }
    } catch (e) {
      print(e.toString());
      return {'message': e.toString()};
    }
  }

  Future<List<dynamic>> getProject(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstant.getProject),
        body: {'user_id': userId},
      );
      print('getClients Enter${response.toString()}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        print('Data received: $data');
        if (data.containsKey('data')) {
          return data['data'] as List<dynamic>;
        } else {
          throw Exception('Key "data" not found in response');
        }
      } else {
        throw Exception('Error Fetching Data');
      }
    } on SocketException {
      throw Exception('No Internet');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<GetProjectDropModel> getProjectDD(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstant.getProject),
        body: {'user_id': userId},
      );
      final body = json.decode(response.body);

      if (response.statusCode == 200) {
        return GetProjectDropModel.fromJson(body);
      }
    } on SocketException {
      throw Exception('No Internet');
    }
    throw Exception('Error Fetching Data');
  }

  Future<GetPaymentType> getPaymentType() async {
    try {
      final response = await http.get(Uri.parse(AppConstant.getPaymentType));
      final body = json.decode(response.body);

      if (response.statusCode == 200) {
        return GetPaymentType.fromJson(body);
      }
    } on SocketException {
      throw Exception('No Internet');
    }
    throw Exception('Error Fetching Data');
  }

  Future<List<dynamic>> getPromotionalBanner(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstant.getPromotionalBanner),
        body: {'user_type': userId},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        print('Data received: $data');
        if (data.containsKey('promotional_banner')) {
          return data['promotional_banner'] as List<dynamic>;
        } else {
          throw Exception('Key "data" not found in response');
        }
      } else {
        throw Exception('Error Fetching Data');
      }
    } on SocketException {
      throw Exception('No Internet');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
