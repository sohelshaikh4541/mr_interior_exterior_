class GetDeductionPackage {
  String? message;
  bool? status;
  List<Data>? data;

  GetDeductionPackage({this.message, this.status, this.data});

  GetDeductionPackage.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? items;
  String? deductionRate;

  Data({this.id, this.items, this.deductionRate});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    items = json['items'];
    deductionRate = json['deduction_rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['items'] = this.items;
    data['deduction_rate'] = this.deductionRate;
    return data;
  }
}

class DropdownItemDeduct {
  final int id;
  final String items;
  final String deduction_rate;

  DropdownItemDeduct({required this.id, required this.items, required this.deduction_rate,});

  @override
  String toString() {
    return items;
  }
}