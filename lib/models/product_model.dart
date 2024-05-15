class ProductResponse {
  bool? success;
  List<ProductModel>? list;
  String? msg;

  ProductResponse({this.success, this.list, this.msg});

  ProductResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['list'] != null) {
      list = <ProductModel>[];
      json['list'].forEach((v) {
        list!.add(ProductModel.fromJson(v));
      });
    }
    msg = json['msg'];
  }

  get data => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
    }
    data['msg'] = msg;
    return data;
  }
}


class ProductModel {
  
  String? title;
  int? price;
  String? image;
  String? type;

  ProductModel({this.title, this.price, this.image, this.type});

  ProductModel.fromJson(Map<String, dynamic> json) {
    
    title = json['title'];
    price = json['price'];
    image = json['image'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['price'] = this.price;
    data['image'] = this.image;
    data['type'] = this.type;
    return data;
  }
}
