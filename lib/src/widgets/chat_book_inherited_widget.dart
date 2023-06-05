part of '../../flutter_chatbook.dart';

/// This widget for alternative of excessive amount of passing arguments
/// over widgets.
///
@immutable
class ChatBookInheritedWidget extends InheritedWidget {
  const ChatBookInheritedWidget({
    Key? key,
    required Widget child,
    required this.featureActiveConfig,
    required this.chatController,
    required this.currentUser,
    required this.isCupertinoApp,
    this.cupertinoWidgetConfig,
  }) : super(key: key, child: child);

  final FeatureActiveConfig featureActiveConfig;
  final ChatController chatController;
  final ChatUser currentUser;
  final CupertinoWidgetConfiguration? cupertinoWidgetConfig;
  final bool isCupertinoApp;

  /// for appBar

  static ChatBookInheritedWidget? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ChatBookInheritedWidget>();

  @override
  bool updateShouldNotify(covariant ChatBookInheritedWidget oldWidget) =>
      oldWidget.featureActiveConfig != featureActiveConfig;
}
