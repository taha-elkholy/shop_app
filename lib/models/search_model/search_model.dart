class SearchModel {
  late bool? status;
  late String? message;
  late SearchDataModel? data;

  SearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = SearchDataModel.fromJson(json['data']);
  }
}

class SearchDataModel {
  late int? currentPage;
  List<SearchProduct> data = [];
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

  SearchDataModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];

    json['data'].forEach((element) {
      data.add(SearchProduct.fromJson(element));
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

class SearchProduct {
  late int? id;
  late dynamic price;
  late dynamic oldPrice;
  late int? discount;
  late String? image;
  late String? name;
  late String? description;
  List<String> images = [];
  late bool? inFavorites;
  late bool? inCart;

  SearchProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    json['images'].forEach((element) {
      images.add(element.toString());
    });
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }
}
