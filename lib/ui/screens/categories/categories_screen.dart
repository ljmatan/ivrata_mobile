import 'package:ivrata_mobile/logic/api/videos_api.dart';
import 'package:ivrata_mobile/ui/screens/categories/category_entry.dart';
import 'package:ivrata_mobile/ui/shared/future_builder_no_data.dart';
import 'package:ivrata_mobile/logic/api/models/category_model.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  static final Future<CategoryResponse> _getCategories =
      VideosAPI.getCategories();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getCategories,
      builder: (context, categories) =>
          categories.connectionState != ConnectionState.done ||
                  categories.hasError ||
                  categories.hasData && categories.data.error != false ||
                  categories.hasData && categories.data.response.isEmpty
              ? FutureBuilderNoData(categories)
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: categories.data.response.length,
                  itemBuilder: (context, i) => CategoryEntry(
                    category: categories.data.response[i],
                    index: i,
                  ),
                ),
    );
  }
}
