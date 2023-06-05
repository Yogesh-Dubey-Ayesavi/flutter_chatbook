// ignore_for_file: invalid_use_of_visible_for_testing_member

part of '../../flutter_chatbook.dart';

/// Through ChatController User must be able to access room's underlying
/// backend and database services.
class ChatController {
  /// Represents initial message list in chat which can be add by user.
  final MessageNotifierList initialMessageList;

  /// AutoScrollController for custom scrolling to messages and
  /// scroll positions.
  AutoScrollController scrollController;

  /// [ChatBookController] controls whole chat infrastructure including
  /// managing rooms, databases and networks see [ChatBookController].
  final ChatBookController? chatBookController;

  /// Allow user to show typing indicator defaults to false.
  final ValueNotifier<bool> _showTypingIndicator = ValueNotifier(false);

  /// For Chat specific functions.
  final ChatDataBaseService? chatService;

  final FocusNode focusNode = FocusNode();

  /// TypingIndicator as [ValueNotifier] for [GroupedChatList] widget's typingIndicator [ValueListenableBuilder].
  ///  Use this for listening typing indicators
  ///   ```dart
  ///    chatcontroller.typingIndicatorNotifier.addListener((){});
  ///  ```
  /// For more functionalities see [ValueNotifier].
  ValueNotifier<bool> get typingIndicatorNotifier => _showTypingIndicator;

  /// Getter for typingIndicator value instead of accessing [_showTypingIndicator.value]
  /// for better accessibility.
  bool get showTypingIndicator => _showTypingIndicator.value;

  /// Setter for changing values of typingIndicator
  /// ```dart
  ///  chatContoller.setTypingIndicator = true; // for showing indicator
  ///  chatContoller.setTypingIndicator = false; // for hiding indicator
  ///  ````
  set setTypingIndicator(bool value) => _showTypingIndicator.value = value;

  /// Represents list of chat users
  List<ChatUser> chatUsers;

  final ValueNotifier<bool> _isNextPageLoadingNotifier = ValueNotifier(false);

  ChatController({
    required this.initialMessageList,
    required this.scrollController,
    required this.chatUsers,
    this.chatService,
    this.chatBookController,
  });

  /// Represents message stream of chat
  StreamController<MessageNotifierList> messageStreamController =
      StreamController();

  final ValueNotifier<Message?> showMessageActions = ValueNotifier(null);

  final ValueNotifier<bool> showPopUp = ValueNotifier(false);

  final ValueNotifier<bool> showMenuManager = ValueNotifier(false);

  final ValueNotifier<List<Message>> multipleMessageSelection =
      ValueNotifier([]);

  /// Used to dispose stream.
  void dispose() => messageStreamController.close();

  /// Used to add message in message list.
  void addMessage(Message message) {
    initialMessageList.insert(0, ValueNotifier(message));
    messageStreamController.sink.add(initialMessageList);
    chatService?.addMessageWrapper(message);
  }

  void hideReactionPopUp({bool messageActions = false}) {
    showPopUp.value = false;
    if (messageActions == true) {
      multipleMessageSelection.value = [];
    }
  }

  void deleteMessage(List<Message> messages) {
    for (int i = 0; i < messages.length; i++) {
      final message = messages[i];
      initialMessageList.removeWhere((item) => item.value.id == message.id);
      messageStreamController.sink.add(initialMessageList);
      chatService?.deleteMessage(message);
      if (initialMessageList.isNotEmpty) {
        chatService?.lastMessageStream.sink.add(initialMessageList.first.value);
      }
    }
  }

  void _addMultipleMessage(Message message) {
    if (multipleMessageSelection.value.contains(message)) {
      multipleMessageSelection.value.remove(message);
    } else {
      multipleMessageSelection.value.add(message);
    }

    // ignore: invalid_use_of_protected_member
    multipleMessageSelection.notifyListeners();
  }

  getFocus() {
    focusNode.requestFocus();
  }

  unFocus() {
    focusNode.unfocus();
  }

  showHideTyping(String id) {
    setTypingIndicator = !showTypingIndicator;
    messageStreamController.sink.add(initialMessageList);
  }

  /// Function for setting reaction on specific chat bubble
  void setReaction({
    required String emoji,
    required String messageId,
    required String userId,
  }) {
    final message = initialMessageList
        .firstWhere((element) => element.value.id == messageId);
    final indexOfMessage = initialMessageList.indexOf(message);

    if (message.value.reaction != null) {
      if (message.value.reaction?.reactedUserIds.contains(userId) ?? false) {
        final userIndex =
            message.value.reaction!.reactedUserIds.indexOf(userId);
        final emojiAtIndex = message.value.reaction?.reactions[userIndex];

        if (emojiAtIndex == emoji) {
          /// Remove Emoticon.
          message.value.reaction!.reactions.removeAt(userIndex);
          message.value.reaction!.reactedUserIds.removeAt(userIndex);
        } else {
          message.value.reaction?.reactions[
              message.value.reaction!.reactedUserIds.indexOf(userId)] = emoji;
        }
      } else {
        /// Add new user and emoticon.
        message.value.reaction!.reactions.add(emoji);
        message.value.reaction!.reactedUserIds.add(userId);
      }
      final newMessage = message.value.copyWith();
      message.value = newMessage;
      chatService?.updateReaction(newMessage);
      messageStreamController.sink.add(initialMessageList);
    } else {
      final newMessage = message.value.copyWith(
          reaction: Reaction(reactions: [emoji], reactedUserIds: [userId]));
      chatService?.updateReaction(newMessage);
      initialMessageList[indexOfMessage] = ValueNotifier(newMessage);
      messageStreamController.sink.add(initialMessageList);
    }
    multipleMessageSelection.value = [];
  }

  Future<void> _pagintationLoadMore() async {
    await chatService?.fetchlastMessages();
    messageStreamController.sink.add(initialMessageList);
  }

  /// Function to scroll to last messages in chat view
  void scrollToLastMessage() => Timer(
        const Duration(milliseconds: 300),
        () => scrollController.animateTo(
          scrollController.position.minScrollExtent,
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 300),
        ),
      );

  // updateReciepts(List<UpdateReciept> updatedReceipts) {}
  /// Function for loading data while pagination.
  /// TODO: Add a converter version.
  void loadMoreData(MessageNotifierList messageList) {
    initialMessageList.addAll(messageList);
    messageStreamController.sink.add(initialMessageList);
  }

  /// Function for getting ChatUser object from user id
  ChatUser getUserFromId(String userId) =>
      chatUsers.firstWhere((element) => element.id == userId);
}
