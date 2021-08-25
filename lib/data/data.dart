import 'package:wallpaper_app/model/catergory_model.dart';

List<CategoryModel> getCategory() {
  // empty list
  List<CategoryModel> categories = [];

  CategoryModel newCategory = CategoryModel();
  newCategory.imgUrl =
      "https://images.pexels.com/photos/545008/pexels-photo-545008.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500";
  newCategory.categoryName = "Street Art";
  categories.add(newCategory);

//
  newCategory = new CategoryModel();
  newCategory.imgUrl =
      "https://images.pexels.com/photos/704320/pexels-photo-704320.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500";
  newCategory.categoryName = "Wild Life";
  categories.add(newCategory);

//
  newCategory = new CategoryModel();
  newCategory.imgUrl =
      "https://images.pexels.com/photos/34950/pexels-photo.jpg?auto=compress&cs=tinysrgb&dpr=2&w=500";
  newCategory.categoryName = "Nature";
  categories.add(newCategory);

//
  newCategory = new CategoryModel();
  newCategory.imgUrl =
      "https://images.pexels.com/photos/466685/pexels-photo-466685.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500";
  newCategory.categoryName = "City";
  categories.add(newCategory);

//
  newCategory = new CategoryModel();
  newCategory.imgUrl =
      "https://images.pexels.com/photos/1434819/pexels-photo-1434819.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260";
  newCategory.categoryName = "Motivation";
  categories.add(newCategory);

  //
  newCategory = new CategoryModel();
  newCategory.imgUrl =
      "https://images.pexels.com/photos/2116475/pexels-photo-2116475.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500";
  newCategory.categoryName = "Bikes";
  categories.add(newCategory);

  //
  newCategory = new CategoryModel();
  newCategory.imgUrl =
      "https://images.pexels.com/photos/1149137/pexels-photo-1149137.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500";
  newCategory.categoryName = "Cars";
  categories.add(newCategory);

  return categories;
}
