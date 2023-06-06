// ignore_for_file: invalid_use_of_visible_for_testing_member

part of '../../flutter_chatbook.dart';

/// Through ChatController User must be able to access room's underlying
/// backend and database services.
class ChatController {
  /// Represents the initial message list in the chat, which can be added by the user.
  ///
  /// The [initialMessageList] variable is a [MessageNotifierList] that holds the initial list of messages in the chat.
  /// Users can add messages to this list, and it will be displayed in the chat UI.
  final MessageNotifierList initialMessageList;

  /// The [AutoScrollController] used for custom scrolling to messages and managing scroll positions.
  ///
  /// The [scrollController] allows you to programmatically scroll to specific messages or manage the scroll position within the chat UI.
  final AutoScrollController scrollController;

  /// The [ChatBookController] that controls the entire chat infrastructure, including managing rooms, databases, and networks.
  ///
  /// The [chatBookController] is responsible for handling various chat-related functions and operations.
  /// It provides a centralized interface for managing the chat functionality within the application.
  final ChatBookController? chatBookController;

  /// A [ValueNotifier] that indicates whether the typing indicator should be shown or hidden.
  ///
  /// The [_showTypingIndicator] variable is a [ValueNotifier] that holds a boolean value indicating whether the typing indicator should be displayed in the chat UI.
  /// By default, it is set to `false`, meaning the typing indicator is hidden.
  final ValueNotifier<bool> _showTypingIndicator = ValueNotifier(false);

  /// The [ChatDataBaseService] used for chat-specific functions.
  ///
  /// The [chatService] provides functionality related to managing chat data, such as adding and deleting messages, updating message states, and interacting with the chat database service.
  /// It is responsible for handling the underlying data operations for the chat functionality.
  final ChatDataBaseService? chatService;

  /// The [focusNode] is used to manage the focus state of [SendMessageWidget] within the [ChatBook].
  ///
  /// It is initialized in the [initState] method and can be used to control the focus of the input field.
  /// It is typically used in conjunction with [ChatUITextField] widget to determine which input field should receive focus.

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

  /// A [ValueNotifier] that holds the currently selected message for displaying message actions.
  ///
  /// The [showMessageActions] variable is used to store the currently selected message
  /// for which message actions (e.g., reply, delete, edit) are being displayed at the AppBar.
  final ValueNotifier<Message?> showMessageActions = ValueNotifier(null);

  /// A [ValueNotifier] that indicates whether a pop-up is currently being shown.
  ///
  /// The [showPopUp] variable is used to control the visibility of a pop-up in the user interface.
  /// When its value is `true`, a pop-up is displayed, and when its value is `false`, the pop-up is hidden.
  final ValueNotifier<bool> showPopUp = ValueNotifier(false);

  /// A [ValueNotifier] that indicates whether the menu manager is currently being shown.
  ///
  /// The [showMenuManager] variable is used to control the visibility of the menu manager in the user interface.
  /// When its value is `true`, the menu manager is displayed, and when its value is `false`, the menu manager is hidden.
  final ValueNotifier<bool> showMenuManager = ValueNotifier(false);

  /// A [ValueNotifier] that holds a list of messages for multiple message selection.
  ///
  /// The [multipleMessageSelection] variable is used to store a list of messages
  /// that have been selected for performing actions on multiple messages simultaneously.
  final ValueNotifier<List<Message>> multipleMessageSelection =
      ValueNotifier([]);

  /// Used to dispose [ChatController]
  void dispose() {
    showMessageActions.dispose();
    showPopUp.dispose();
    multipleMessageSelection.dispose();
    showMenuManager.dispose();
    messageStreamController.close();
  }

  /// Adds a message to the message list.
  ///
  /// The [addMessage] method is used to add a [Message] to the [initialMessageList].
  /// It inserts the message into the list using a [ValueNotifier] and notifies the [messageStreamController] to update the UI.
  /// Additionally, it calls the `addMessageWrapper` method of the [chatService] to handle the message addition.
  void addMessage(Message message) {
    initialMessageList.insert(0, ValueNotifier(message));
    messageStreamController.sink.add(initialMessageList);
    chatService?.addMessageWrapper(message);
  }

  /// Hides the reaction pop-up and clears the multiple message selection if specified.
  ///
  /// The [hideReactionPopUp] method sets the value of [showPopUp] to `false` to hide the pop-up.
  /// If [messageActions] is `true`, it clears the [multipleMessageSelection] by setting its value to an empty list.
  void hideReactionPopUp({bool messageActions = false}) {
    showPopUp.value = false;
    if (messageActions == true) {
      multipleMessageSelection.value = [];
    }
  }

  /// Deletes the specified list of messages from the message list.
  ///
  /// The [deleteMessage] method iterates over the given [messages] list and removes each message
  /// from the [initialMessageList] using the `removeWhere` method based on the message's ID.
  /// It notifies the [messageStreamController] to update the UI.
  /// Additionally, it calls the `deleteMessage` method of the [chatService] to handle the message deletion.
  /// If the [initialMessageList] is not empty, it updates the last message using the [lastMessageStream].
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

  /// Adds or removes a message from the [multipleMessageSelection] list.
  ///
  /// The [_addMessageSelection] method is used to toggle the selection of a [Message] in the [multipleMessageSelection] list.
  /// If the message is already selected, it removes it from the list; otherwise, it adds it to the list.
  /// It then notifies the listeners of [multipleMessageSelection] to update the UI.
  void _addMessageSelection(Message message) {
    if (multipleMessageSelection.value.contains(message)) {
      multipleMessageSelection.value.remove(message);
    } else {
      multipleMessageSelection.value.add(message);
    }
    // ignore: invalid_use_of_protected_member
    multipleMessageSelection.notifyListeners();
  }

  /// Requests focus for the [focusNode].
  ///
  /// The [getFocus] method is used to request focus for the [focusNode].
  /// It ensures that the focus is set to the [focusNode] so that the corresponding text field receives input focus.
  void getFocus() {
    focusNode.requestFocus();
  }

  /// Removes focus from the [focusNode].
  ///
  /// The [unFocus] method is used to remove focus from the [focusNode].
  /// It unfocuses the [focusNode], removing the input focus from the associated text field.
  void unFocus() {
    focusNode.unfocus();
  }

  /// Toggles the visibility of the typing indicator.
  ///
  /// The [showHideTyping] method is used to toggle the visibility of the typing indicator.
  /// It sets the value of [setTypingIndicator] to the opposite of [showTypingIndicator]
  /// and notifies the [messageStreamController] to update the UI.
  void showHideTyping(String id) {
    setTypingIndicator = !showTypingIndicator;
    messageStreamController.sink.add(initialMessageList);
  }

  /// Sets a reaction on a specific chat bubble.
  ///
  /// The [setReaction] function allows you to set a reaction, represented by an emoji, on a specific chat bubble identified by its [messageId].
  /// The [emoji] parameter represents the emoji to be set as a reaction, and the [userId] parameter identifies the user who is setting the reaction.
  /// This function handles adding or removing the reaction based on the current state of the message.
  /// It updates the message's reaction data, notifies the chat service to update the reaction, and refreshes the UI by notifying the [messageStreamController].
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

  /// Loads more messages for pagination.
  ///
  /// The [_pagintationLoadMore] function is called to load more messages for pagination.
  /// It triggers the chat service to fetch the last messages and updates the UI by notifying the [messageStreamController].
  Future<void> _pagintationLoadMore() async {
    await chatService?.fetchlastMessages();
    messageStreamController.sink.add(initialMessageList);
  }

  /// Scrolls to the last message in the chat view.
  ///
  /// The [scrollToLastMessage] function scrolls to the last message in the [ChatBook].
  /// It animates the scroll to the minimum scroll extent using the [scrollController].
  /// This is typically used when new messages are added to the chat, and you want to automatically scroll to the latest message.
  void scrollToLastMessage() => Timer(
        const Duration(milliseconds: 300),
        () => scrollController.animateTo(
          scrollController.position.minScrollExtent,
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 300),
        ),
      );

  /// Loads more data for pagination.
  ///
  /// The [loadMoreData] function is used to load more data for pagination.
  /// It appends the [messageList] to the [initialMessageList], notifies the [messageStreamController], and refreshes the UI.
  void loadMoreData(MessageNotifierList messageList) {
    initialMessageList.addAll(messageList);
    messageStreamController.sink.add(initialMessageList);
  }

  /// Retrieves a [ChatUser] object from the given user ID.
  ///
  /// The [getUserFromId] function retrieves the [ChatUser] object associated with the provided [userId].
  /// It searches the [chatUsers] list and returns the matching user object.
  /// This is useful when you need to retrieve user information based on their ID.
  ChatUser getUserFromId(String userId) =>
      chatUsers.firstWhere((element) => element.id == userId);
}
