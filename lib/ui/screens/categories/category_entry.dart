import 'package:ivrata_mobile/ui/screens/categories/category_selection/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:ivrata_mobile/logic/api/models/category_model.dart';

class CategoryEntry extends StatelessWidget {
  final CategoryData category;
  final int index;

  CategoryEntry({@required this.category, @required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14, index == 0 ? 18 : 0, 14, 16),
      child: GestureDetector(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            image: DecorationImage(
              fit: BoxFit.cover,
              image:
                  AssetImage('assets/images/categories/${category.name}.jpeg'),
            ),
          ),
          child: Stack(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black,
                      Colors.black87,
                      Colors.black54,
                      Colors.black45,
                      Colors.black45,
                      Colors.black12,
                    ],
                  ),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: Text(
                        category.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                CategoryScreen(category: category))),
      ),
    );
  }
}
