import 'package:flutter_chatbook/src/wrappers/condition_wrapper.dart';
import 'package:flutter/material.dart';

class MaterialConditionalWrapper extends StatelessWidget {
  const MaterialConditionalWrapper(
      {Key? key, this.condition = false, required this.child})
      : super(key: key);

  final bool condition;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConditionalWrapper(
        condition: condition,
        wrapper: (widget) =>
            Material(type: MaterialType.transparency, child: widget),
        child: child);
  }
}
