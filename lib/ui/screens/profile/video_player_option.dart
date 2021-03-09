import 'package:ivrata_mobile/logic/cache/prefs.dart';
import 'package:flutter/material.dart';

class VideoPlayerOption extends StatefulWidget {
  final String label;
  final Function rebuild;

  VideoPlayerOption(
    Key key, {
    @required this.label,
    @required this.rebuild,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VideoPlayerOptionState();
  }
}

class _VideoPlayerOptionState extends State<VideoPlayerOption> {
  bool _selected;

  @override
  void initState() {
    super.initState();
    final bool nativePlayer = Prefs.instance.getBool('nativePlayer');
    _selected = nativePlayer ?? widget.label == 'VLC';
    if (nativePlayer != null && widget.label == 'nativePlayer')
      _selected = !_selected;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: _selected ? Theme.of(context).accentColor : Colors.white70,
              width: _selected ? 2 : 1,
            ),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 48,
            child: Center(
              child: Text(
                widget.label,
                style: TextStyle(
                  fontSize: 16,
                  color: _selected
                      ? Theme.of(context).accentColor
                      : Colors.white70,
                  fontWeight: _selected ? FontWeight.w900 : null,
                ),
              ),
            ),
          ),
        ),
        onTap: () async {
          await Prefs.instance
              .setBool('nativePlayer', widget.label == 'Native');
          widget.rebuild();
        },
      ),
    );
  }
}
