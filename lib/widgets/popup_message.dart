import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodvibes/providers.dart/login_provider.dart';
import 'package:provider/provider.dart';


class MyShowDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (BuildContext context, state, _) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // state.isloding ? CupertinoActivityIndicator(): CupertinoIcons.check_mark,
                state.statusWidget,
                SizedBox(
                  height: 15,
                ),
                Text(state.status)
              ],
            ),
          ),
    );
  }
}
