import 'package:ivrata_mobile/ui/screens/categories/category_selection/bloc/filter_selection_controller.dart';
import 'package:flutter/material.dart';

class FilterSelectionButton extends StatelessWidget {
  final String label;
  final int number;

  FilterSelectionButton({@required this.label, @required this.number});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: FilterSelectionController.stream,
        initialData: 'Movies',
        builder: (context, selected) => GestureDetector(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                width: selected.data == number ? 2 : 0.5,
                color: selected.data == number
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
                    fontWeight: FontWeight.bold,
                    color: selected.data == number
                        ? Theme.of(context).accentColor
                        : Colors.white70,
                  ),
                ),
              ),
            ),
          ),
          onTap: () => FilterSelectionController.change(
              selected.data == number ? null : number),
        ),
      ),
    );
  }
}
