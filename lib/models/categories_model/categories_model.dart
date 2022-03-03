class CategoriesModel {
  late bool? status;
  late String? message;
  late CategoriesDataModel? data;

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = CategoriesDataModel.fromJson(json['data']);
  }
}

class CategoriesDataModel {
  late int? currentPage;
  List<CategoryData> data = [];
  late String? firstPageUrl;
  late int? from;
  late int? lastPage;
  late String? lastPageUrl;
  late String? nextPageUrl;
  late String? path;
  late int? perPage;
  late String? perPageUrl;
  late int? to;
  late int? total;

  CategoriesDataModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];

    // list of objects declared as this way
    json['data'].forEach((element) {
      data.add(CategoryData.fromJson(element));
    });
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    perPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }
}

class CategoryData {
  late int? id;
  late String? name;
  late String? image;

  CategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}
