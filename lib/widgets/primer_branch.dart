import 'package:flutter/cupertino.dart';
import 'package:gogithub/models/theme.dart';
import 'package:gogithub/utils/global.dart';
import 'package:provider/provider.dart';

class PrimerBranchName extends StatelessWidget {
  final String name;

  PrimerBranchName(this.name);

  static const branchBgColor = Color(0xffeaf5ff);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      height: 16,
      decoration: BoxDecoration(
        color: branchBgColor,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Text(
        name,
        style: TextStyle(
          color: theme.palette.primary,
          fontSize: 14,
          height: 1,
          fontFamily: CommonStyle.monospace,
        ),
      ),
    );
  }
}
