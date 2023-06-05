import 'package:flutter/cupertino.dart';
import '../../flutter_chatbook.dart';

void showPreview(BuildContext context, PreviewBuilder preview) {
  Navigator.of(context).push(PageRouteBuilder(
      opaque: true, pageBuilder: (BuildContext context, _, __) => preview));
}
