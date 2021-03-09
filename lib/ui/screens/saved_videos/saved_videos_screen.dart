import 'dart:convert';

import 'package:ivrata_mobile/logic/api/models/videos_response_model.dart';
import 'package:ivrata_mobile/logic/cache/db.dart';
import 'package:ivrata_mobile/ui/screens/saved_videos/bloc/selected_folder_controller.dart';
import 'package:ivrata_mobile/ui/screens/saved_videos/folder_filter.dart';
import 'package:ivrata_mobile/ui/shared/video_entry/video_entry.dart';
import 'package:flutter/material.dart';

class SavedVideoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SavedVideoScreenState();
  }
}

class _SavedVideoScreenState extends State<SavedVideoScreen> {
  void _rebuildParent() => setState(() {});

  final _pageController = PageController();

  void _goToPage(int page) => _pageController.animateToPage(page,
      duration: const Duration(milliseconds: 400), curve: Curves.ease);

  @override
  void initState() {
    super.initState();
    SelectedFolderController.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: DB.instance.rawQuery('SELECT * FROM Saved'),
        builder: (context, videos) {
          if (videos.connectionState != ConnectionState.done ||
              videos.hasError ||
              videos.hasData && videos.data.isEmpty)
            return Center(
              child: videos.connectionState == ConnectionState.done
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        videos.hasData && videos.data.isEmpty
                            ? 'No saved videos'
                            : videos.error.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  : CircularProgressIndicator(),
            );
          else {
            final List _favorites =
                videos.data.where((e) => e['folder'] == 'favorites').toList();
            final List _watchLater =
                videos.data.where((e) => e['folder'] == 'watchLater').toList();
            return Column(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                    child: Row(
                      children: [
                        FolderFilter(
                          label: 'Favorites',
                          page: 0,
                          goToPage: _goToPage,
                        ),
                        const SizedBox(width: 8),
                        FolderFilter(
                          label: 'Watch Later',
                          page: 1,
                          goToPage: _goToPage,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: _favorites.length,
                        itemBuilder: (context, i) {
                          return VideoEntry(
                            video: VideoData.fromJson(
                              jsonDecode(_favorites[i]['savedVideoEncoded']),
                            ),
                            index: i,
                            image: _favorites[i]['image'],
                            rebuildParent: _rebuildParent,
                          );
                        },
                      ),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: _watchLater.length,
                        itemBuilder: (context, i) {
                          return VideoEntry(
                            video: VideoData.fromJson(
                              jsonDecode(_watchLater[i]['savedVideoEncoded']),
                            ),
                            index: i,
                            image: _watchLater[i]['image'],
                            rebuildParent: _rebuildParent,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    SelectedFolderController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
