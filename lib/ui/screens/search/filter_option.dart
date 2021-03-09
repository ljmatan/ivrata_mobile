import 'bloc/filter_controller.dart';
import 'package:flutter/material.dart';

class FilterOption extends StatelessWidget {
  final String label;
  final int number;

  FilterOption({@required this.label, @required this.number});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FilterController.stream,
      initialData: FilterController.currentData,
      builder: (context, selected) => Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: selected.hasData && selected.data == number
                    ? Theme.of(context).accentColor
                    : Colors.white70,
              ),
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 56,
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: selected.hasData && selected.data == number
                        ? Theme.of(context).accentColor
                        : Colors.white70,
                  ),
                ),
              ),
            ),
          ),
          onTap: () => FilterController.change(
            selected.hasData && selected.data == number ? null : number,
          ),
        ),
      ),
    );
  }
}
