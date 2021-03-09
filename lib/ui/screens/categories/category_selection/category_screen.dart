import 'dart:async';

import 'package:ivrata_mobile/logic/api/models/videos_response_model.dart';
import 'package:ivrata_mobile/logic/api/videos_api.dart';
import 'package:ivrata_mobile/ui/screens/categories/category_selection/bloc/filter_selection_controller.dart';
import 'package:ivrata_mobile/ui/screens/categories/category_selection/filter_selection.dart';
import 'package:ivrata_mobile/ui/shared/future_builder_no_data.dart';
import 'package:ivrata_mobile/ui/shared/video_entry/video_entry.dart';
import 'package:flutter/material.dart';
import 'package:ivrata_mobile/logic/api/models/category_model.dart';

class CategoryScreen extends StatefulWidget {
  final CategoryData category;

  CategoryScreen({@required this.category});

  @override
  State<StatefulWidget> createState() {
    return _CategoryScreenState();
  }
}

class _CategoryScreenState extends State<CategoryScreen> {
  int _currentPage = 1;
  int _seriesOption;

  StreamSubscription _seriesOptionSubscription;

  @override
  void initState() {
    super.initState();
    FilterSelectionController.init();
    _seriesOptionSubscription = FilterSelectionController.stream
        .listen((value) => setState(() => _seriesOption = value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.category.name),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 60),
          child: DecoratedBox(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: Row(
                  children: [
                    FilterSelectionButton(label: 'Movies', number: 0),
                    const SizedBox(width: 10),
                    FilterSelectionButton(label: 'Series', number: 1),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: VideosAPI.getVideosByCategory(
          widget.category.name,
          _currentPage,
          _seriesOption,
        ),
        builder: (context, AsyncSnapshot<VideosResponse> videos) =>
            videos.connectionState != ConnectionState.done ||
                    videos.hasError ||
                    videos.hasData && videos.data.error != false ||
                    videos.hasData && videos.data.response.rows.isEmpty
                ? videos.hasData && videos.data.response.rows.isEmpty
                    ? Center(
                        child: Text(
                          'No videos found in this category.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    : FutureBuilderNoData(videos)
                : Stack(
                    children: [
                      ListView.builder(
                        itemCount: videos.data.response.rows.length,
                        itemBuilder: (context, i) => VideoEntry(
                            video: videos.data.response.rows[i], index: i),
                      ),
                      if (_currentPage != 1)
                        Positioned(
                          bottom: 16,
                          left: 16,
                          child: GestureDetector(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: kElevationToShadow[2],
                                color: Theme.of(context).accentColor,
                              ),
                              child: SizedBox(
                                width: 56,
                                height: 56,
                                child: Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_left_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () => setState(() => _currentPage -= 1),
                          ),
                        ),
                      if (videos.data.response.rows.length == 60)
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: GestureDetector(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: kElevationToShadow[2],
                                color: Theme.of(context).accentColor,
                              ),
                              child: SizedBox(
                                width: 56,
                                height: 56,
                                child: Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () => setState(() => _currentPage += 1),
                          ),
                        ),
                    ],
                  ),
      ),
    );
  }

  @override
  void dispose() {
    FilterSelectionController.dispose();
    super.dispose();
  }
}
