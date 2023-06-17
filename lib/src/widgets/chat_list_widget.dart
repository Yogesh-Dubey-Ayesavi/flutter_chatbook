part of '../../flutter_chatbook.dart';

class ChatListWidget extends StatefulWidget {
  const ChatListWidget({
    Key? key,
    required this.chatController,
    required this.chatBackgroundConfig,
    required this.assignReplyMessage,
    required this.replyMessage,
    this.loadingWidget,
    this.reactionPopupConfig,
    this.messageConfig,
    this.chatBubbleConfig,
    this.profileCircleConfig,
    this.swipeToReplyConfig,
    this.repliedMessageConfig,
    this.typeIndicatorConfig,
    this.replyPopupConfig,
    this.loadMoreData,
    this.isLastPage,
  }) : super(key: key);

  /// Provides controller for accessing few function for running chat.
  final ChatController chatController;

  /// Provides configuration for background of chat.
  final ChatBackgroundConfiguration chatBackgroundConfig;

  /// Provides widget for loading view while pagination is enabled.
  final Widget? loadingWidget;

  /// Provides configuration for reaction pop up appearance.
  final ReactionPopupConfiguration? reactionPopupConfig;

  /// Provides configuration for customisation of different types
  /// messages.
  final MessageConfiguration? messageConfig;

  /// Provides configuration of chat bubble's appearance.
  final ChatBubbleConfiguration? chatBubbleConfig;

  /// Provides configuration for profile circle avatar of user.
  final ProfileCircleConfiguration? profileCircleConfig;

  /// Provides configuration for when user swipe to chat bubble.
  final SwipeToReplyConfiguration? swipeToReplyConfig;

  /// Provides configuration for replied message view which is located upon chat
  /// bubble.
  final RepliedMessageConfiguration? repliedMessageConfig;

  /// Provides configuration of typing indicator's appearance.
  final TypeIndicatorConfiguration? typeIndicatorConfig;

  /// Provides reply message when user swipe to chat bubble.
  final Message? replyMessage;

  /// Provides configuration for reply snack bar's appearance and options.
  final ReplyPopupConfiguration? replyPopupConfig;

  /// Provides callback when user actions reaches to top and needs to load more
  /// chat
  final VoidCallBackWithFuture? loadMoreData;

  /// Provides flag if there is no more next data left in list.
  final bool? isLastPage;

  /// Provides callback for assigning reply message when user swipe to chat
  /// bubble.
  final MessageCallBack assignReplyMessage;

  @override
  State<ChatListWidget> createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends State<ChatListWidget>
    with SingleTickerProviderStateMixin {
  ValueNotifier<bool>? showPopUp;

  final GlobalKey<ReactionPopupState> _reactionPopupKey = GlobalKey();

  ChatController get chatController => widget.chatController;

  List<ValueNotifier<Message>> get messageList =>
      chatController.initialMessageList;

  AutoScrollController get scrollController => chatController.scrollController;

  ChatBackgroundConfiguration get chatBackgroundConfig =>
      widget.chatBackgroundConfig;

  FeatureActiveConfig? featureActiveConfig;

  ChatUser? currentUser;

  bool isCupertino = false;

  late ValueNotifier<bool> showScrollToBottomButtonNotifier;

  @override
  void initState() {
    super.initState();
    showScrollToBottomButtonNotifier = ValueNotifier(false);
    chatController.scrollController.addListener(_scrollListener);
    _initialize();
  }

  void _scrollListener() {
    if (chatController.scrollController.offset >=
        chatController.scrollController.position.minScrollExtent + 100) {
      showScrollToBottomButtonNotifier.value = true;
    } else {
      showScrollToBottomButtonNotifier.value = false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (provide != null) {
      featureActiveConfig = provide!.featureActiveConfig;
      currentUser = provide!.currentUser;
      showPopUp = provide!.chatController.showPopUp;
      isCupertino = provide!.isCupertinoApp;
    }

    if (featureActiveConfig?.enablePagination ?? false) {
      // When flag is on then it will include pagination logic to scroll
      // controller.
      // _pagination();
    }
  }

  void _initialize() {
    chatController.messageStreamController = StreamController();
    if (!chatController.messageStreamController.isClosed) {
      chatController.messageStreamController.sink.add(messageList);
    }

    // if (messageList.isNotEmpty) chatController.scrollToLastMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              WillPopScope(
                onWillPop: () async {
                  if (showPopUp!.value == false &&
                      chatController.multipleMessageSelection.value.isEmpty) {
                    return true;
                  }
                  chatController.multipleMessageSelection.value = [];
                  chatController.showPopUp.value = false;
                  chatController.multipleMessageSelection.value = [];
                  return false;
                },
                child: ChatGroupedListWidget(
                  showPopUp: showPopUp!.value,
                  // reactionPopupConfig: widget.reactionPopupConfig,
                  scrollController: scrollController,
                  isEnableSwipeToSeeTime:
                      featureActiveConfig?.enableSwipeToSeeTime ?? true,
                  chatBackgroundConfig: widget.chatBackgroundConfig,
                  assignReplyMessage: widget.assignReplyMessage,
                  replyMessage: widget.replyMessage,
                  swipeToReplyConfig: widget.swipeToReplyConfig,
                  repliedMessageConfig: widget.repliedMessageConfig,
                  profileCircleConfig: widget.profileCircleConfig,
                  messageConfig: widget.messageConfig,
                  chatBubbleConfig: widget.chatBubbleConfig,
                  typeIndicatorConfig: widget.typeIndicatorConfig,
                  onChatBubbleLongPress: (yCoordinate, xCoordinate, message) {
                    if (!isCupertino) {
                      if (featureActiveConfig?.enableReactionPopup ?? false) {
                        _reactionPopupKey.currentState?.refreshWidget(
                          message: message,
                          xCoordinate: xCoordinate,
                          yCoordinate: yCoordinate < 0
                              ? -(yCoordinate) - 5
                              : yCoordinate,
                        );
                        showPopUp!.value = true;
                      }
                      if (featureActiveConfig?.enableReplySnackBar ?? false) {
                        _showReplyPopup(
                          message: message,
                          sendByCurrentUser:
                              message.author.id == currentUser?.id,
                        );
                      }
                    }
                  },
                  onChatListTap: _onChatListTap,
                ),
              ),
              if (featureActiveConfig?.enableReactionPopup ?? false) ...[
                ValueListenableBuilder<bool>(
                    valueListenable: showPopUp!,
                    builder: (_, showPopupValue, child) {
                      if (!showPopupValue) {
                        if (!isCupertino) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        }
                      }

                      return ReactionPopup(
                        key: _reactionPopupKey,
                        reactionPopupConfig: widget.reactionPopupConfig,
                        onTap: _onChatListTap,
                        showPopUp: showPopupValue,
                      );
                    })
              ],
              Positioned(
                bottom: 16.0,
                right: 16.0,
                child: ValueListenableBuilder<bool>(
                  valueListenable: showScrollToBottomButtonNotifier,
                  builder: (context, value, child) {
                    return AnimatedOpacity(
                      opacity: value ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 300),
                      child: FloatingActionButton(
                        backgroundColor: const Color(0xffff8aad),
                        onPressed: () {
                          chatController.scrollController.animateTo(
                            chatController
                                .scrollController.position.minScrollExtent,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Icon(Icons.arrow_downward),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _showReplyPopup({
    required Message message,
    required bool sendByCurrentUser,
  }) {
    final replyPopup = widget.replyPopupConfig;
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            duration: const Duration(hours: 1),
            backgroundColor: replyPopup?.backgroundColor ?? Colors.white,
            content: replyPopup?.replyPopupBuilder != null
                ? replyPopup!.replyPopupBuilder!(message, sendByCurrentUser)
                : ReplyPopupWidget(
                    buttonTextStyle: replyPopup?.buttonTextStyle,
                    topBorderColor: replyPopup?.topBorderColor,
                    onMoreTap: () {
                      _onChatListTap();
                      if (replyPopup?.onMoreTap != null) {
                        replyPopup?.onMoreTap!();
                      }
                    },
                    onReportTap: () {
                      _onChatListTap();
                      if (replyPopup?.onReportTap != null) {
                        replyPopup?.onReportTap!();
                      }
                    },
                    onUnsendTap: () {
                      _onChatListTap();
                      if (replyPopup?.onUnsendTap != null) {
                        replyPopup?.onUnsendTap!(message);
                      }
                    },
                    onReplyTap: () {
                      widget.assignReplyMessage(message);
                      if (featureActiveConfig?.enableReactionPopup ?? false) {
                        showPopUp!.value = false;
                      }
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      if (replyPopup?.onReplyTap != null) {
                        replyPopup?.onReplyTap!(message);
                      }
                    },
                    sendByCurrentUser: sendByCurrentUser,
                  ),
            padding: EdgeInsets.zero,
          ),
        )
        .closed;
  }

  void _onChatListTap() {
    if (!kIsWeb && Platform.isIOS) FocusScope.of(context).unfocus();
    showPopUp!.value = false;
    //TODO: Conditional when non cupertinoApp
    if (!isCupertino) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    chatController._isNextPageLoadingNotifier.dispose();
    showPopUp!.dispose();
    super.dispose();
  }
}
