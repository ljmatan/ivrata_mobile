import 'package:ivrata_mobile/ui/screens/bloc/view_controller.dart';
import 'package:ivrata_mobile/ui/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

class NavBarEntry extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget screen;

  NavBarEntry({
    @required this.label,
    @required this.icon,
    @required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ViewController.stream,
      initialData: HomeScreen(),
      builder: (context, view) {
        final bool isSelected =
            view.data.toStringShort() == screen.toStringShort();
        return Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Icon(
                    icon,
                    size: 32,
                    color: isSelected
                        ? Theme.of(context).accentColor
                        : Colors.white, // const Color(0xff3C3B6E),
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 9,
                    color: isSelected
                        ? Theme.of(context).accentColor
                        : Colors.white, // const Color(0xff3C3B6E),
                  ),
                ),
              ],
            ),
            onTap: () => ViewController.change(screen),
          ),
        );
      },
    );
  }
}
