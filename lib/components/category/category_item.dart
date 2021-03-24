import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_local_vendor/models/category_model.dart';
import 'package:go_local_vendor/resources/style_resources.dart';
import 'package:go_local_vendor/screens/category_item_screen.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel categoryModel;

  const CategoryItem({@required this.categoryModel}) : super();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, CategoryItemScreen.route(categoryModel));
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 4,
              height: MediaQuery.of(context).size.width / 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                // color: Colors.black,
              ),
              child: CachedNetworkImage(
                imageUrl: categoryModel.categoriesurl ?? "no-photo.png",
                fit: BoxFit.cover,
                placeholder: (context, source) =>
                    Center(child: CircularProgressIndicator()),
              ),
            ),
            SizedBox(
              height: 2,
            ),
            FittedBox(
              child: Text(
                categoryModel.categoriesname ?? "Category Title",
                style: StyleResources.categoryTitleStyle,
              ),
            )
          ],
        ),
      ),
    );
  }
}
