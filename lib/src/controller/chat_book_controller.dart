import 'package:flutter_chatbook/flutter_chatbook.dart';
import 'package:flutter_chatbook/src/utils/constants/constants.dart';

/// To get instance
///
/// ```dart
/// const user = ChatUser(id: 'fdslhf-dfsa854-sf784-', firstName: 'Flutter');
///
/// final ChatBookController _chatBookController = const ChatBookController(user);
/// ```
/// `ChatBookController` controls whole chat infrastructure. It is the
/// entry point for the extension API. All extensions are registered here,
/// Through  `ChatBookController` one can control backend, manage databases and
/// rooms. `ChatBookController` is singleton.
class ChatBookController {
  const ChatBookController._(this.currentUser, {this.chatBookExtension});

  static ChatBookController? _instance;

  static ChatBookController getInstance(ChatUser currentUser,
      {ChatBookExtension? chatBookExtension}) {
    _instance ??=
        ChatBookController._(currentUser, chatBookExtension: chatBookExtension);
    if (_instance != null) {
      serviceLocator.registerSingleton<ChatBookController>(_instance!);
    }

    return _instance!;
  }

  final ChatUser currentUser;

  final ChatBookExtension? chatBookExtension;
}
