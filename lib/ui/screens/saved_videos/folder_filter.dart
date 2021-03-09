import 'package:ivrata_mobile/ui/screens/saved_videos/bloc/selected_folder_controller.dart';
import 'package:flutter/material.dart';

class FolderFilter extends StatelessWidget {
  final String label;
  final int page;
  final Function goToPage;

  FolderFilter({
    @required this.label,
    @required this.page,
    @required this.goToPage,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: SelectedFolderController.stream,
        initialData: 'Favorites',
        builder: (context, selected) => GestureDetector(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                width: selected.data == label ? 2 : 1,
                color: selected.data == label
                    ? Theme.of(context).accentColor
                    : Colors.white70,
              ),
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 44,
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: selected.data == label ? FontWeight.w900 : null,
                    color: selected.data == label
                        ? Theme.of(context).accentColor
                        : Colors.white70,
                  ),
                ),
              ),
            ),
          ),
          onTap: () {
            SelectedFolderController.change(label);
            goToPage(page);
          },
        ),
      ),
    );
  }
}
