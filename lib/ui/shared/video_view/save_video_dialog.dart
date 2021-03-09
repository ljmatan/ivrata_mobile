import 'dart:convert';
import 'dart:typed_data';

import 'package:ivrata_mobile/logic/api/models/videos_response_model.dart';
import 'package:ivrata_mobile/logic/cache/db.dart';
import 'package:ivrata_mobile/logic/cache/prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SaveVideoOption extends StatefulWidget {
  final String label, folder;
  final int videoID;
  final Function(String) save, remove;

  SaveVideoOption({
    @required this.label,
    @required this.folder,
    @required this.videoID,
    @required this.save,
    @required this.remove,
  });

  @override
  State<StatefulWidget> createState() {
    return _SaveVideoOptionState();
  }
}

class _SaveVideoOptionState extends State<SaveVideoOption> {
  bool _saved;

  @override
  void initState() {
    super.initState();
    _saved = Prefs.instance.getBool(widget.folder + 'saved') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_saved)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.check,
                  color: Colors.green.shade300,
                ),
              ),
          ],
        ),
      ),
      onTap: () async {
        Navigator.pop(context);
        _saved ? widget.remove(widget.folder) : widget.save(widget.folder);
        await Prefs.instance.setBool(widget.folder + 'saved', !_saved);
      },
    );
  }
}

class SaveVideoDialog extends StatefulWidget {
  final VideoData video;

  SaveVideoDialog({@required this.video});

  @override
  State<StatefulWidget> createState() {
    return _SaveVideoDialogState();
  }
}

class _SaveVideoDialogState extends State<SaveVideoDialog> {
  bool _saving = false;

  Map _videoInfo;

  @override
  void initState() {
    super.initState();
    _videoInfo = widget.video.toJson();
  }

  Future<void> _saveLocally(String folder) async {
    final Uint8List imageBytes =
        (await NetworkAssetBundle(Uri.parse(widget.video.images.poster))
                .load(widget.video.images.poster))
            .buffer
            .asUint8List();
    await DB.instance.insert(
      'Saved',
      {
        'videoID': widget.video.id,
        'savedVideoEncoded': jsonEncode(_videoInfo),
        'image': imageBytes,
        'folder': folder,
      },
    );
  }

  Future<void> _remove(String folder) async => await DB.instance.rawDelete(
        'DELETE FROM Saved WHERE videoID = ? AND folder = ?',
        [widget.video.id, folder],
      );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Material(
          elevation: 16,
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SaveVideoOption(
                label: 'Save to favorites',
                folder: 'favorites',
                save: _saveLocally,
                videoID: widget.video.id,
                remove: _remove,
              ),
              const Divider(height: 0),
              SaveVideoOption(
                label: 'Save for later',
                folder: 'watchLater',
                save: _saveLocally,
                videoID: widget.video.id,
                remove: _remove,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
