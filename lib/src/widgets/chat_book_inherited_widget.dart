part of '../../flutter_chatbook.dart';

/// The [ChatBookInheritedWidget] should typically be placed at the root of the widget tree to ensure its availability to all descendants.
/// Descendant widgets can access the inherited widget using the static [of] method, which returns the nearest [ChatBookInheritedWidget] instance.
///
/// Usage:
/// ```dart
/// ChatBookInheritedWidget? inheritedWidget = ChatBookInheritedWidget.of(context);
/// if (inheritedWidget != null) {
///   // Access shared values from the inherited widget
///   FeatureActiveConfig featureConfig = inheritedWidget.featureActiveConfig;
///   ChatController chatController = inheritedWidget.chatController;
///   // ...
/// }
/// ```
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

  /// Retrieves the nearest [ChatBookInheritedWidget] instance from the widget tree.
  ///
  /// This method can be used to access the shared values and configurations provided by the inherited widget.
  /// Returns null if no [ChatBookInheritedWidget] is found in the widget tree.
  static ChatBookInheritedWidget? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ChatBookInheritedWidget>();

  @override
  bool updateShouldNotify(covariant ChatBookInheritedWidget oldWidget) =>
      oldWidget.featureActiveConfig != featureActiveConfig;
}
