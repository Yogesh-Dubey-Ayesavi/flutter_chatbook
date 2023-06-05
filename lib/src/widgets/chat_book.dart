part of '../../flutter_chatbook.dart';

class ChatBook extends StatefulWidget {
  const ChatBook({
    super.key,
    required this.chatController,
    required this.currentUser,
    this.isCupertinoApp = false,
    this.onSendTap,
    this.profileCircleConfig,
    this.chatBubbleConfig,
    this.repliedMessageConfig,
    this.swipeToReplyConfig,
    this.replyPopupConfig,
    this.reactionPopupConfig,
    this.loadMoreData,
    this.loadingWidget,
    this.messageConfig,
    this.isLastPage,
    this.appBar,
    this.cupertinoWidgetConfig,
    this.chatBackgroundConfig = const ChatBackgroundConfiguration(),
    this.typeIndicatorConfig,
    this.sendMessageBuilder,
    this.showTypingIndicator = false,
    this.sendMessageConfig,
    required this.chatBookState,
    this.chatBookStateConfig = const ChatBookStateConfiguration(),
    this.featureActiveConfig = const FeatureActiveConfig(),
  });

  /// Provides configuration related to user profile circle avatar.
  final ProfileCircleConfiguration? profileCircleConfig;

  /// Provides configurations related to chat bubble such as padding, margin, max
  /// width etc.
  final ChatBubbleConfiguration? chatBubbleConfig;

  /// Allow user to giving customisation different types
  /// messages.
  final MessageConfiguration? messageConfig;

  /// Provides configuration for replied message view which is located upon chat
  /// bubble.
  final RepliedMessageConfiguration? repliedMessageConfig;

  /// Provides configurations related to swipe chat bubble which triggers
  /// when user swipe chat bubble.
  final SwipeToReplyConfiguration? swipeToReplyConfig;

  /// Provides configuration for reply snack bar's appearance and options.
  final ReplyPopupConfiguration? replyPopupConfig;

  /// Provides configuration for reaction pop up appearance.
  final ReactionPopupConfiguration? reactionPopupConfig;

  /// Allow user to give customisation to background of chat
  final ChatBackgroundConfiguration chatBackgroundConfig;

  /// Provides callback when user actions reaches to top and needs to load more
  /// chat
  final VoidCallBackWithFuture? loadMoreData;

  /// Provides widget for loading view while pagination is enabled.
  final Widget? loadingWidget;

  /// Provides flag if there is no more next data left in list.
  final bool? isLastPage;

  /// Provides call back when user tap on send button in text field. It returns
  /// message, reply message and message type.
  final MessageCallBack? onSendTap;

  /// Provides builder which helps you to make custom text field and functionality.
  final ReplyMessageWithReturnWidget? sendMessageBuilder;

  @Deprecated('Use [ChatController.setTypingIndicator]  instead')

  /// Allow user to show typing indicator.
  final bool showTypingIndicator;

  /// Allow user to giving customisation typing indicator.
  final TypeIndicatorConfiguration? typeIndicatorConfig;

  /// Provides controller for accessing few function for running chat.
  final ChatController chatController;

  /// Provides configuration of default text field in chat.
  final SendMessageConfiguration? sendMessageConfig;

  /// Provides current state of chat.
  final ChatBookState chatBookState;

  /// Provides configuration for chat view state appearance and functionality.
  final ChatBookStateConfiguration? chatBookStateConfig;

  /// Provides current user which is sending messages.
  final ChatUser currentUser;

  /// Provides configuration for turn on/off specific features.
  final FeatureActiveConfig featureActiveConfig;

  /// Provides parameter so user can assign ChatBookAppbar.
  final Widget? appBar;

  final bool isCupertinoApp;

  final CupertinoWidgetConfiguration? cupertinoWidgetConfig;

  @override
  State<ChatBook> createState() => _ChatBookState();
}

class _ChatBookState extends State<ChatBook>
    with SingleTickerProviderStateMixin {
  ValueNotifier<Message?> replyMessageNotifier = ValueNotifier(null);

  ChatController get chatController => widget.chatController;
  // bool get showTypingIndicator => widget.showTypingIndicator;

  ChatBackgroundConfiguration get chatBackgroundConfig =>
      widget.chatBackgroundConfig;

  ChatBookState get chatBookState => widget.chatBookState;

  ChatBookStateConfiguration? get chatBookStateConfig =>
      widget.chatBookStateConfig;

  FeatureActiveConfig get featureActiveConfig => widget.featureActiveConfig;

  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    GetIt.I.registerSingleton<ChatBook>(widget);
    focusNode = FocusNode();
    // Adds current user in users list.
    chatController.chatUsers.add(widget.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    // Scroll to last message on in hasMessages state.
    // TODO: Remove this in new versions.
    // ignore: deprecated_member_use_from_same_package
    if (widget.showTypingIndicator ||
        widget.chatController.showTypingIndicator &&
            chatBookState.hasMessages) {
      chatController.scrollToLastMessage();
    }
    return ChatBookInheritedWidget(
      isCupertinoApp: widget.isCupertinoApp,
      chatController: chatController,
      cupertinoWidgetConfig: widget.cupertinoWidgetConfig,
      featureActiveConfig: featureActiveConfig,
      currentUser: widget.currentUser,
      child: MaterialConditionalWrapper(
          condition: widget.isCupertinoApp,
          child: Stack(children: [
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.appBar != null) widget.appBar!,
                Flexible(
                  child: getWidget(),
                ),
                // widget.showTypingIndicator
                //     ? TypingIndicator(
                //         typeIndicatorConfig: widget.typeIndicatorConfig,
                //         chatBubbleConfig:
                //             widget.chatBubbleConfig?.inComingChatBubbleConfig,
                //         showIndicator: widget.showTypingIndicator,
                //         profilePic: widget.profileCircleConfig?.profileImageUrl,
                //       )
                //     : ValueListenableBuilder(
                //         valueListenable:
                //             widget.chatController.typingIndicatorNotifier,
                //         builder: (context, value, child) => TypingIndicator(
                //               typeIndicatorConfig: widget.typeIndicatorConfig,
                //               chatBubbleConfig: widget
                //                   .chatBubbleConfig?.inComingChatBubbleConfig,
                //               showIndicator: value,
                //               profilePic:
                //                   widget.profileCircleConfig?.profileImageUrl,
                //             )),
                if (featureActiveConfig.enableTextField)
                  SendMessageWidget(
                    replyMessageNotfier: replyMessageNotifier,
                    chatController: chatController,
                    sendMessageBuilder: widget.sendMessageBuilder,
                    sendMessageConfig: widget.sendMessageConfig,
                    backgroundColor: chatBackgroundConfig.backgroundColor,
                    onSendTap: _onSendTap,
                    onReplyCallback: (reply) {},
                    onReplyCloseCallback: () {
                      replyMessageNotifier.value = null;
                    },
                  ),
              ],
            )
          ])),
    );
  }

  void _onSendTap(Message message) {
    if (widget.sendMessageBuilder == null) {
      if (widget.onSendTap != null) {
        widget.onSendTap!(message);
      }
      _assignReplyMessage();
    }
    chatController.scrollToLastMessage();
  }

  Widget getWidget() {
    if (chatBookState.isLoading) {
      return ChatBookStateWidget(
        chatBookStateWidgetConfig: chatBookStateConfig?.loadingWidgetConfig,
        chatBookState: chatBookState,
      );
    } else if (chatBookState.noMessages) {
      return ChatBookStateWidget(
        chatBookStateWidgetConfig: chatBookStateConfig?.noMessageWidgetConfig,
        chatBookState: chatBookState,
        onReloadButtonTap: chatBookStateConfig?.onReloadButtonTap,
      );
    } else if (chatBookState.isError) {
      return ChatBookStateWidget(
        chatBookStateWidgetConfig: chatBookStateConfig?.errorWidgetConfig,
        chatBookState: chatBookState,
        onReloadButtonTap: chatBookStateConfig?.onReloadButtonTap,
      );
    } else if (chatBookState.hasMessages) {
      return ValueListenableBuilder<Message?>(
        valueListenable: replyMessageNotifier,
        builder: (_, state, child) {
          return ChatListWidget(

              /// TODO: Remove this in future releases.
              // ignore: deprecated_member_use_from_same_package
              showTypingIndicator: widget.showTypingIndicator,
              focusNode: focusNode,
              replyMessage: state,
              chatController: widget.chatController,
              chatBackgroundConfig: widget.chatBackgroundConfig,
              reactionPopupConfig: widget.reactionPopupConfig,
              typeIndicatorConfig: widget.typeIndicatorConfig,
              chatBubbleConfig: widget.chatBubbleConfig,
              loadMoreData: widget.loadMoreData,
              isLastPage: widget.isLastPage,
              replyPopupConfig: widget.replyPopupConfig,
              loadingWidget: widget.loadingWidget,
              messageConfig: widget.messageConfig,
              profileCircleConfig: widget.profileCircleConfig,
              repliedMessageConfig: widget.repliedMessageConfig,
              swipeToReplyConfig: widget.swipeToReplyConfig,
              assignReplyMessage: (message) {
                replyMessageNotifier.value = message;
              });
        },
      );
    } else {
      return const SizedBox();
    }
  }

  void _assignReplyMessage() {
    if (replyMessageNotifier.value != null) {
      replyMessageNotifier.value = null;
    }
  }

  @override
  void dispose() {
    replyMessageNotifier.dispose();
    serviceLocator.unregister<ChatBook>();
    super.dispose();
  }
}
