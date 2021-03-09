import 'package:ivrata_mobile/logic/api/social.dart';
import 'package:flutter/material.dart';

class CommentsDisplay extends StatefulWidget {
  final List comments;
  final int videoID;

  CommentsDisplay({@required this.comments, @required this.videoID});

  @override
  State<StatefulWidget> createState() {
    return _CommentsDisplayState();
  }
}

class _CommentsDisplayState extends State<CommentsDisplay> {
  bool _displayed = false;

  final _commentController = TextEditingController();

  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(),
      top: _displayed ? 0 : null,
      bottom: 0,
      child: AnimatedContainer(
        duration: const Duration(),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        width: MediaQuery.of(context).size.width,
        height: _displayed ? MediaQuery.of(context).size.height : 64,
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 64,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Comments',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        _displayed
                            ? Icons.arrow_drop_down
                            : Icons.arrow_drop_up,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () => setState(() => _displayed = !_displayed),
            ),
            if (_displayed)
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.grey[50]),
                  child: widget.comments.isEmpty
                      ? const Center(child: Text('No comments found'))
                      : ListView(
                          children: [],
                        ),
                ),
              ),
            if (_displayed)
              DecoratedBox(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 72,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Stack(
                        children: [
                          TextField(
                            enabled: !_submitting,
                            controller: _commentController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              hintText: 'Add a comment',
                              contentPadding:
                                  EdgeInsets.fromLTRB(8, 20, 48, 20),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: StatefulBuilder(
                              builder: (context, newState) => _submitting
                                  ? SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(),
                                    )
                                  : IconButton(
                                      icon: Icon(Icons.check),
                                      onPressed: () async {
                                        setState(() => _submitting = true);
                                        try {
                                          final response = await Social.comment(
                                              _commentController.text,
                                              widget.videoID);
                                        } catch (e) {
                                          print('$e');
                                        }
                                        setState(() => _submitting = false);
                                      },
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
