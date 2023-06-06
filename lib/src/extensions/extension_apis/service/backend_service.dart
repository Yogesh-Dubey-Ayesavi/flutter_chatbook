import 'package:flutter_chatbook/src/models/models.dart';

/// `BackendManager` is used for providing support for handling transmission and receiving of messages.
/// [ChatBook] utilizes this when a [Room] sends or receives a message.
abstract class BackendManager {
  void sendMessage(Message message);

  void listenMessages(Function(Message) callback);

  void blockUser(ChatUser user);

  void deleteMessage(Message message);

  void sendAudio(AudioMessage audioFilePath);

  void updateMessage(Message updatedMessage);
}
