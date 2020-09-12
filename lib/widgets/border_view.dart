import 'package:flutter/cupertino.dart';
import 'package:gogithub/models/theme.dart';
import 'package:provider/provider.dart';

class BorderView extends StatelessWidget {
  final double height;
  final double lefPadding;

  BorderView({this.height, this.lefPadding = 0});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);

    if (height == null) {
      return Container(
        margin: EdgeInsets.only(left: lefPadding),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: theme.palette.border, width: 0),
          ),
        ),
      );
    }

    return Row(
      children: <Widget>[
        SizedBox(
          width: lefPadding,
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(color: theme.palette.background),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: height,
            child: DecoratedBox(
              decoration: BoxDecoration(color: theme.palette.border),
            ),
          ),
        ),
      ],
    );
  }
}
