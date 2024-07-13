class GetWorkRateList {
  String? message;
  bool? status;
  List<Workpricecharts>? workpricecharts;

  GetWorkRateList({this.message, this.status, this.workpricecharts});

  GetWorkRateList.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['workpricecharts'] != null) {
      workpricecharts = <Workpricecharts>[];
      json['workpricecharts'].forEach((v) {
        workpricecharts!.add(new Workpricecharts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.workpricecharts != null) {
      data['workpricecharts'] =
          this.workpricecharts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Workpricecharts {
  int? id;
  String? category;
  String? item;
  String? measure;
  String? rate;

  Workpricecharts({this.id, this.category, this.item, this.measure, this.rate});

  Workpricecharts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    item = json['item'];
    measure = json['measure'];
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['item'] = this.item;
    data['measure'] = this.measure;
    data['rate'] = this.rate;
    return data;
  }
}

class DropdownItemRate {
  final int id;
  final String category;
  final String item;
  final String measure;
  final String rate;

  DropdownItemRate({required this.id, required this.category, required this.item, required this.measure, required this.rate});

  @override
  String toString() {
    return item;
  }
}