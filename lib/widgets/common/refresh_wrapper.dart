import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gogithub/models/theme.dart';
import 'package:provider/provider.dart';

import '../error_reload.dart';
import 'loading.dart';

class RefreshWrapper extends StatelessWidget {
  final Widget body;
  final void Function() onRefresh;

  RefreshWrapper({
    @required this.onRefresh,
    @required this.body,
  });

  @override
  Widget build(BuildContext context) {
    switch (Provider.of<ThemeModel>(context).theme) {
      case AppThemeType.cupertino:
        return CupertinoScrollbar(
          child: CustomScrollView(
            slivers: <Widget>[
              CupertinoSliverRefreshControl(onRefresh: onRefresh),
              SliverToBoxAdapter(child: body),
            ],
          ),
        );
      default:
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: Scrollbar(
            child: SingleChildScrollView(child: body),
          ),
        );
    }
  }
}

class ErrorLoadingWrapper extends StatelessWidget {
  final String error;
  final bool loading;
  final void Function() reload;
  final Widget Function() bodyBuilder;

  ErrorLoadingWrapper({
    @required this.error,
    @required this.loading,
    @required this.reload,
    @required this.bodyBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (error.isNotEmpty) {
      return ErrorReload(text: error, onTap: reload);
    }

    if (loading) {
      return Loading();
    }

    return bodyBuilder();
  }
}

Widget wrapBuilder(Widget Function() builder) {
  if (builder == null) return null;
  return builder();
}
