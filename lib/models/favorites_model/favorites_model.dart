class FavoritesModel {
  late bool? status;
  late String? message;
  late FavoriteDataModel? data;

  FavoritesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = FavoriteDataModel.fromJson(json['data']);
  }
}

class FavoriteDataModel {
  late int? currentPage;
  List<FavProductData> data = [];
  late String? firstPageUrl;
  late int? from;
  late int? lastPage;
  late String? lastPageUrl;
  late String? nextPageUrl;
  late String? path;
  late int? perPage;
  late String? prevPageUrl;
  late int? to;
  late int? total;

  FavoriteDataModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];

    json['data'].forEach((element) {
      data.add(FavProductData.fromJson(element));
    });

    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }
}

class FavProductData {
  late int? id;
  late Product? product;

  FavProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = Product.fromJson(json['product']);
  }
}

class Product {
  late int? id;
  late dynamic price;
  late dynamic oldPrice;
  late int? discount;
  late String? image;
  late String? name;
  late String? description;

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }
}
