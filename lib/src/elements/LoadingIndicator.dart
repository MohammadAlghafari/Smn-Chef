import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingProgressIndicator extends StatelessWidget {
  const LoadingProgressIndicator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65,
      height: 65,
      child: LoadingIndicator(
        indicatorType: Indicator.ballSpinFadeLoader,
        color: Theme.of(context).accentColor,
      ),
    );
  }
}
