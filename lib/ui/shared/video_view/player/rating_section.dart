import 'dart:convert';

import 'package:ivrata_mobile/data/auth/user_data.dart';
import 'package:ivrata_mobile/logic/api/models/videos_response_model.dart';
import 'package:ivrata_mobile/logic/api/social.dart';
import 'package:ivrata_mobile/logic/cache/prefs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RatingSection extends StatefulWidget {
  final VideoData video;

  RatingSection({@required this.video});

  @override
  State<StatefulWidget> createState() {
    return _RatingSectionState();
  }
}

class _RatingSectionState extends State<RatingSection> {
  bool _updating = false;
  bool _updated = false;

  bool _liked;
  bool _disliked;

  @override
  void initState() {
    super.initState();
    _liked =
        Prefs.instance.getBool(widget.video.id.toString() + 'liked') ?? false;
    _disliked =
        Prefs.instance.getBool(widget.video.id.toString() + 'disliked') ??
            false;
  }

  @override
  Widget build(BuildContext context) {
    return _updating
        ? SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Icon(
                  Icons.thumb_up,
                  color: _liked ? Colors.green.shade300 : Colors.white,
                ),
                onTap: User.loggedIn
                    ? () async {
                        setState(() => _updating = true);
                        try {
                          final response = await Social.like(widget.video.id);
                          final decoded = jsonDecode(response.body);
                          if (decoded['error'] == false) {
                            setState(() {
                              _updated = true;
                              _liked = decoded['response']['myVote'] == 1;
                              if (_liked) _disliked = false;
                            });
                          } else
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(decoded['message'])));
                        } catch (e) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('$e')));
                        }
                        setState(() => _updating = false);
                      }
                    : () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('You must be logged in to do that'))),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 16,
                ),
                child: Text(
                  NumberFormat.compact().format(
                    widget.video.likes + (_updated && _liked ? 1 : 0),
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Icon(
                  Icons.thumb_down,
                  color: _disliked ? Colors.red.shade300 : Colors.white,
                ),
                onTap: User.loggedIn
                    ? () async {
                        setState(() => _updating = true);
                        try {
                          final response =
                              await Social.dislike(widget.video.id);
                          final decoded = jsonDecode(response.body);
                          if (decoded['error'] == false) {
                            setState(() {
                              _updated = true;
                              _disliked = decoded['response']['myVote'] == -1;
                              if (_disliked) _liked = false;
                            });
                          } else
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(decoded['message'])));
                        } catch (e) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('$e')));
                        }
                        setState(() => _updating = false);
                      }
                    : () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('You must be logged in to do that'))),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  NumberFormat.compact().format(
                    widget.video.dislikes + (_updated && _disliked ? 1 : 0),
                  ),
                ),
              ),
            ],
          );
  }
}
