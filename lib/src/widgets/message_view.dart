part of '../../flutter_chatbook.dart';

class MessageView extends StatefulWidget {
  const MessageView({
    Key? key,
    required this.message,
    required this.isMessageBySender,
    required this.onLongPress,
    required this.isLongPressEnable,
    this.chatBubbleMaxWidth,
    this.inComingChatBubbleConfig,
    this.outgoingChatBubbleConfig,
    this.longPressAnimationDuration,
    this.onDoubleTap,
    this.highlightColor = Colors.grey,
    this.shouldHighlight = false,
    this.highlightScale = 1.2,
    this.messageConfig,
    this.onMaxDuration,
    this.controller,
  }) : super(key: key);

  /// Provides message instance of chat.
  final Message message;

  /// Represents current message is sent by current user.
  final bool isMessageBySender;

  /// Give callback once user long press on chat bubble.
  final DoubleCallBack onLongPress;

  /// Allow users to give max width of chat bubble.
  final double? chatBubbleMaxWidth;

  /// Provides configuration of chat bubble appearance from other user of chat.
  final ChatBubble? inComingChatBubbleConfig;

  /// Provides configuration of chat bubble appearance from current user of chat.
  final ChatBubble? outgoingChatBubbleConfig;

  /// Allow users to give duration of animation when user long press on chat bubble.
  final Duration? longPressAnimationDuration;

  /// Allow user to set some action when user double tap on chat bubble.
  final MessageCallBack? onDoubleTap;

  /// Allow users to pass colour of chat bubble when user taps on replied message.
  final Color highlightColor;

  /// Allow users to turn on/off highlighting chat bubble when user tap on replied message.
  final bool shouldHighlight;

  /// Provides scale of highlighted image when user taps on replied image.
  final double highlightScale;

  /// Allow user to giving customisation different types
  /// messages.
  final MessageConfiguration? messageConfig;

  /// Allow user to turn on/off long press tap on chat bubble.
  final bool isLongPressEnable;

  final ChatController? controller;

  final Function(int)? onMaxDuration;

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  MessageConfiguration? get messageConfig => widget.messageConfig;

  bool get isLongPressEnable => widget.isLongPressEnable;

  bool get isCupertino =>
      ChatBookInheritedWidget.of(context)?.isCupertinoApp ?? false;

  bool get isMessageBySender =>
      widget.message.author.id ==
      ChatBookInheritedWidget.of(context)?.currentUser.id;

  ValueNotifier<bool> isOn = ValueNotifier(false);

  bool selectMultipleMessages = false;

  bool receiptsVisibility = true;

  bool isLastMessage = false;

  List<NewMessageSupport>? get extensionMessageTypes => (widget
              .message.type.isCustom &&
          (widget.controller?.chatBookController?.chatBookExtension
                  ?.widgetsExtension?.messageTypes.isNotEmpty ??
              false))
      ? widget.controller!.chatBookController!.chatBookExtension!
          .widgetsExtension!.messageTypes
      : null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (provide != null) {
      selectMultipleMessages =
          provide!.featureActiveConfig.selectMultipleMessages;
      receiptsVisibility =
          provide!.featureActiveConfig.receiptsBuilderVisibility;
      isLastMessage = provide!.chatController.initialMessageList.first.value ==
          widget.message;
    }
  }

  @override
  Widget build(BuildContext context) {
    return selectMultipleMessages
        ? _messageView
        : GestureView(
            onLongPress: widget.onLongPress,
            isLongPressEnable: isLongPressEnable,
            message: widget.message,
            child: _messageView,
          );
  }

  Widget get _messageView {
    final emojiMessageConfiguration = messageConfig?.emojiMessageConfig;
    return Padding(
      padding: EdgeInsets.only(
        bottom: widget.message.reaction?.reactions.isNotEmpty ?? false ? 6 : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          (() {
                if (widget.message.type.isText && _isAllEmoji(widget.message)) {
                  final msg = widget.message as TextMessage;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: emojiMessageConfiguration?.padding ??
                            EdgeInsets.fromLTRB(
                              leftPadding2,
                              4,
                              leftPadding2,
                              widget.message.reaction?.reactions.isNotEmpty ??
                                      false
                                  ? 14
                                  : 0,
                            ),
                        child: Transform.scale(
                          scale: widget.shouldHighlight
                              ? widget.highlightScale
                              : 1.0,
                          child: Text(
                            msg.text,
                            style: emojiMessageConfiguration?.textStyle ??
                                const TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                      if (widget.message.reaction?.reactions.isNotEmpty ??
                          false)
                        ReactionWidget(
                          reaction: widget.message.reaction!,
                          messageReactionConfig:
                              messageConfig?.messageReactionConfig,
                          isMessageBySender: widget.isMessageBySender,
                        ),
                    ],
                  );
                } else if (widget.message.type.isImage) {
                  return ImageMessageView(
                    message: widget.message as ImageMessage,
                    isLastMessage: isLastMessage,
                    receiptsBuilderVisibility: receiptsVisibility,
                    isMessageBySender: widget.isMessageBySender,
                    imageMessageConfig: messageConfig?.imageMessageConfig,
                    messageReactionConfig: messageConfig?.messageReactionConfig,
                    highlightImage: widget.shouldHighlight,
                    highlightScale: widget.highlightScale,
                    outgoingChatBubbleConfig: widget.outgoingChatBubbleConfig,
                  );
                } else if (widget.message.type.isText) {
                  return TextMessageView(
                    isLastMessage: isLastMessage,
                    inComingChatBubbleConfig: widget.inComingChatBubbleConfig,
                    receiptsBuilderVisibility: receiptsVisibility,
                    outgoingChatBubbleConfig: widget.outgoingChatBubbleConfig,
                    isMessageBySender: widget.isMessageBySender,
                    message: widget.message as TextMessage,
                    chatBubbleMaxWidth: widget.chatBubbleMaxWidth,
                    messageReactionConfig: messageConfig?.messageReactionConfig,
                    highlightColor: widget.highlightColor,
                    highlightMessage: widget.shouldHighlight,
                  );
                } else if (widget.message.type.isVoice) {
                  return VoiceMessageView(
                    screenWidth: MediaQuery.of(context).size.width,
                    message: widget.message as AudioMessage,
                    config: messageConfig?.voiceMessageConfig,
                    onMaxDuration: widget.onMaxDuration,
                    isMessageBySender: widget.isMessageBySender,
                    messageReactionConfig: messageConfig?.messageReactionConfig,
                    inComingChatBubbleConfig: widget.inComingChatBubbleConfig,
                    outgoingChatBubbleConfig: widget.outgoingChatBubbleConfig,
                  );
                } else if (widget.message.type.isCustom &&
                    messageConfig?.customMessageBuilder != null) {
                  return messageConfig?.customMessageBuilder!(widget.message);
                } else if (widget.message.type.isCustom &&
                    (widget.controller?.chatBookController?.chatBookExtension
                            ?.widgetsExtension?.messageTypes.isNotEmpty ??
                        false)) {
                  final index = widget.controller!.chatBookController!
                      .chatBookExtension!.widgetsExtension!.messageTypes
                      .indexWhere((element) =>
                          element.customType ==
                          (widget.message as CustomMessage).customType);
                  return Stack(children: [
                    ConditionalWrapper(
                      condition: extensionMessageTypes![index].isInsideBubble,
                      wrapper: (child) {
                        return Container(
                            constraints: BoxConstraints(
                                maxWidth: widget.chatBubbleMaxWidth ??
                                    MediaQuery.of(context).size.width * 0.75),
                            padding: _padding ??
                                const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                            margin: _margin ??
                                EdgeInsets.fromLTRB(
                                    5,
                                    0,
                                    6,
                                    widget.message.reaction?.reactions
                                                .isNotEmpty ??
                                            false
                                        ? 15
                                        : 2),
                            decoration: BoxDecoration(
                              color: widget.shouldHighlight
                                  ? widget.highlightColor
                                  : _color,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: child);
                      },
                      child: extensionMessageTypes![index]
                          .messageBuilder
                          .call(context, widget.message),
                    ),
                    if (extensionMessageTypes![index].isReactable &&
                        (widget.message.reaction?.reactions.isNotEmpty ??
                            false))
                      ReactionWidget(
                        isMessageBySender: widget.isMessageBySender,
                        reaction: widget.message.reaction!,
                        messageReactionConfig:
                            messageConfig?.messageReactionConfig,
                      ),
                  ]);
                }
              }()) ??
              const SizedBox(),
          // ValueListenableBuilder(
          //   valueListenable: widget.message.statusNotifier,
          //   builder: (context, value, child) {
          //     debugPrint('rebuilt');
          //     if (widget.isMessageBySender &&
          //         widget.controller?.initialMessageList.last.value.id ==
          //             widget.message.id &&
          //         widget.message.status == DeliveryStatus.read) {
          //       if (ChatBookInheritedWidget.of(context)
          //               ?.featureActiveConfig
          //               .lastSeenAgoBuilderVisibility ??
          //           true) {
          //         return widget.outgoingChatBubbleConfig?.receiptsWidgetConfig
          //                 ?.lastSeenAgoBuilder
          //                 ?.call(
          //                     widget.message,
          //                     applicationDateFormatter(
          //                         widget.message.createdAt)) ??
          //             lastSeenAgoBuilder(widget.message,
          //                 applicationDateFormatter(widget.message.createdAt));
          //       }
          //       return const SizedBox();
          //     }
          //     return const SizedBox();
          //   },
          // )
        ],
      ),
    );
  }

  Color get _color => widget.isMessageBySender
      ? widget.outgoingChatBubbleConfig?.color ?? Colors.purple
      : widget.inComingChatBubbleConfig?.color ?? Colors.grey.shade500;

  EdgeInsetsGeometry? get _padding => widget.isMessageBySender
      ? widget.outgoingChatBubbleConfig?.padding
      : widget.inComingChatBubbleConfig?.padding;

  EdgeInsetsGeometry? get _margin => widget.isMessageBySender
      ? widget.outgoingChatBubbleConfig?.margin
      : widget.inComingChatBubbleConfig?.margin;

  @override
  void dispose() {
    super.dispose();
  }

  bool _isAllEmoji(Message message) {
    message as TextMessage;
    return message.text.isAllEmoji ? true : false;
  }
}
