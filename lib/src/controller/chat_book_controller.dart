import 'package:flutter_chatbook/flutter_chatbook.dart';
import 'package:flutter_chatbook/src/utils/constants/constants.dart';

/// To get instance:
///
/// ```dart
/// const user = ChatUser(id: 'fdslhf-dfsa854-sf784-', firstName: 'Flutter');
///
/// final ChatBookController _chatBookController = ChatBookController.getInstance(user);
/// ```
/// `ChatBookController` controls the entire chat infrastructure and serves as the entry point for the extension API.
/// All extensions are registered and managed through the `ChatBookController`.
/// It allows control over the backend, manages databases, and rooms.
/// `ChatBookController` is a singleton class.
class ChatBookController {
  /// The user who is currently sending or authoring the messages.
  final ChatUser currentUser;

  /// The chat book extension used by the chatbookcontroller.
  final ChatBookExtension? chatBookExtension;

  /// Private constructor for the `ChatBookController`.
  const ChatBookController._(this.currentUser, {this.chatBookExtension});

  /// Singleton instance of the `ChatBookController`.
  static ChatBookController? _instance;

  /// Retrieves the singleton instance of the `ChatBookController`.
  ///
  /// The [currentUser] parameter represents the user who is currently sending or authoring the messages.
  /// The [chatBookExtension] parameter is an optional [ChatBookExtension] used by the[ChatBookController].
  ///
  /// Returns the singleton instance of the `ChatBookController`.
  static ChatBookController getInstance(ChatUser currentUser,
      {ChatBookExtension? chatBookExtension}) {
    _instance ??=
        ChatBookController._(currentUser, chatBookExtension: chatBookExtension);
    if (_instance != null) {
      serviceLocator.registerSingleton<ChatBookController>(_instance!);
    }

    return _instance!;
  }
}
