/*
 * Copyright (c) 2022 Simform Solutions
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

part of '../../chatview.dart';

class ChatBubbleWidget extends StatefulWidget {
  const ChatBubbleWidget({
    required GlobalKey key,
    required this.message,
    required this.onLongPress,
    required this.slideAnimation,
    required this.onSwipe,
    this.profileCircleConfig,
    this.chatBubbleConfig,
    this.repliedMessageConfig,
    this.swipeToReplyConfig,
    this.messageTimeTextStyle,
    this.messageTimeIconColor,
    this.messageConfig,
    this.onReplyTap,
    this.reactionPopupConfig,
    this.shouldHighlight = false,
  }) : super(key: key);

  /// Represent current instance of message.
  final Message message;

  /// Give callback once user long press on chat bubble.
  final DoubleCallBack onLongPress;

  /// Provides configuration related to user profile circle avatar.
  final ProfileCircleConfiguration? profileCircleConfig;

  /// Provides configurations related to chat bubble such as padding, margin, max
  /// width etc.
  final ChatBubbleConfiguration? chatBubbleConfig;

  /// Provides configurations related to replied message such as textstyle
  /// padding, margin etc. Also, this widget is located upon chat bubble.
  final RepliedMessageConfiguration? repliedMessageConfig;

  /// Provides configurations related to swipe chat bubble which triggers
  /// when user swipe chat bubble.
  final SwipeToReplyConfiguration? swipeToReplyConfig;

  /// Provides textStyle of message created time when user swipe whole chat.
  final TextStyle? messageTimeTextStyle;

  /// Provides default icon color of message created time view when user swipe
  /// whole chat.
  final Color? messageTimeIconColor;

  /// Provides slide animation when user swipe whole chat.
  final Animation<Offset>? slideAnimation;

  /// Provides configuration of all types of messages.
  final MessageConfiguration? messageConfig;

  /// Provides callback of when user swipe chat bubble for reply.
  final MessageCallBack onSwipe;

  /// Provides callback when user tap on replied message upon chat bubble.
  final Function(String message)? onReplyTap;

  /// Flag for when user tap on replied message and highlight actual message.
  final bool shouldHighlight;

  final ReactionPopupConfiguration? reactionPopupConfig;

  @override
  State<ChatBubbleWidget> createState() => _ChatBubbleWidgetState();
}

class _ChatBubbleWidgetState extends State<ChatBubbleWidget> {
  Message? get replyMessage => widget.message.repliedMessage;

  bool get isMessageBySender => widget.message.author.id == currentUser?.id;

  bool get isLastMessage =>
      chatController?.initialMessageList.first.value.id == widget.message.id;

  bool isCupertino = false;

  ProfileCircleConfiguration? get profileCircleConfig =>
      widget.profileCircleConfig;

  FeatureActiveConfig? featureActiveConfig;

  ChatController? chatController;

  ChatUser? currentUser;

  int? maxDuration;

  ValueNotifier<double> isOn = ValueNotifier(0.00);

  ChatUser get messagedUser => widget.message.author;

  bool selectMultipleMessages = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (provide != null) {
      featureActiveConfig = provide!.featureActiveConfig;
      chatController = provide!.chatController;
      currentUser = provide!.currentUser;
      isCupertino = provide!.isCupertinoApp;
      selectMultipleMessages =
          provide?.featureActiveConfig.selectMultipleMessages ?? true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get user from id.

    return Stack(
      children: [
        if (featureActiveConfig?.enableSwipeToSeeTime ?? true) ...[
          Visibility(
            visible: widget.slideAnimation?.value.dx == 0.0 ? false : true,
            child: Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: MessageTimeWidget(
                  messageTime: DateTime.fromMillisecondsSinceEpoch(
                      widget.message.createdAt),
                  isCurrentUser: isMessageBySender,
                  messageTimeIconColor: widget.messageTimeIconColor,
                  messageTimeTextStyle: widget.messageTimeTextStyle,
                ),
              ),
            ),
          ),
          SlideTransition(
            position: widget.slideAnimation!,
            child: _chatBubbleWidget(messagedUser),
          ),
        ] else
          _chatBubbleWidget(messagedUser),
      ],
    );
  }

  Widget _chatBubbleWidget(ChatUser? messagedUser) {
    return ConditionalWrapper(

        /// Todo: for our usecase only not for the community.
        condition: false,
        // isCupertino &&
        //     (ChatViewInheritedWidget.of(context)
        //             ?.cupertinoWidgetConfig
        //             ?.cupertinoMenuConfig
        //             ?.showCupertinoContextMenu ??
        //         true),
        wrapper: (child) => CupertinoMenuWrapper(
            reactionPopupConfig: widget.reactionPopupConfig,
            message: widget.message,
            child: child),
        child: Padding(
          padding: widget.chatBubbleConfig?.padding ??
              const EdgeInsets.only(left: 5.0, bottom: 5),
          child: Padding(
            padding: widget.chatBubbleConfig?.margin ??
                const EdgeInsets.only(bottom: 10),
            child: ConditionalWrapper(
                condition: selectMultipleMessages,
                wrapper: (child) => GestureView(
                      message: widget.message,
                      onLongPress: widget.onLongPress,
                      onDoubleTap: widget.chatBubbleConfig?.onDoubleTap,
                      isLongPressEnable:
                          (featureActiveConfig?.enableReactionPopup ?? true) ||
                              (featureActiveConfig?.enableReplySnackBar ??
                                  true),
                      child: child,
                    ),
                child: Column(children: [
                  featureActiveConfig?.enableSwipeToSeeTime != true
                      ? _swipeWidget(_messageRow)
                      : _messageRow,
                  if (isLastMessage && chatController!.showTypingIndicator) ...[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                              height: 100,
                              width: 200,
                              child: ValueListenableBuilder(
                                  valueListenable:
                                      chatController!.typingIndicatorNotifier,
                                  builder: (context, value, child) =>
                                      TypingIndicator(
                                        // typeIndicatorConfig: widget.typeIndicatorConfig,
                                        chatBubbleConfig: widget
                                            .chatBubbleConfig
                                            ?.inComingChatBubbleConfig,
                                        showIndicator: value,
                                        // profilePic: widget
                                        //     .profileCircleConfig?.profileImageUrl,
                                      )))
                        ])
                  ]
                ])),
          ),
        ));
  }

  Widget _swipeWidget(Widget child) {
    return SwipeableTile.swipeToTrigger(
        key: Key((Random().nextInt(1) * 100000).toString()),
        backgroundBuilder: (context, direction, progress) {
          progress.addListener(() {
            isOn.value = progress.value;
          });

          return ValueListenableBuilder<double>(
              valueListenable: isOn,
              builder: (context, value, child) =>
                  widget.swipeToReplyConfig?.backgroundBuilder
                      ?.call(context, direction, progress, value) ??
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 200),
                      scale: value,
                      child: AnimatedOpacity(
                        opacity: value,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          CupertinoIcons.reply,
                          color: widget.swipeToReplyConfig?.replyIconColor,
                        ),
                      ),
                    ),
                  ));
        },
        direction: SwipeDirection.startToEnd,
        color: Colors.transparent,
        isElevated: false,
        onSwiped: (direction) {
          widget.onSwipe(widget.message);
          chatController!.getFocus();
          featureActiveConfig?.enableSwipeToReply ?? true
              ? () {
                  if (maxDuration != null) {
                    // widget.message.voiceMessageDuration =
                    //     Duration(milliseconds: maxDuration!);
                  }
                  if (widget.swipeToReplyConfig?.onRightSwipe != null) {
                    ///TODO: Add the functionality of below ones.
                    // widget.swipeToReplyConfig?.onRightSwipe!(
                    //     widget.message.message,
                    //     widget.message.sendBy);
                  }
                  widget.onSwipe(widget.message);
                }
              : null;
        },
        child: child);
  }

  Widget get _messageRow => Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            isMessageBySender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMessageBySender &&
              (featureActiveConfig?.enableOtherUserProfileAvatar ?? true))
            ProfileCircle(
              bottomPadding:
                  widget.message.reaction?.reactions.isNotEmpty ?? false
                      ? profileCircleConfig?.bottomPadding ?? 15
                      : profileCircleConfig?.bottomPadding ?? 2,
              profileCirclePadding: profileCircleConfig?.padding,
              imageUrl: messagedUser.imageUrl,
              circleRadius: profileCircleConfig?.circleRadius,
              onTap: () => _onAvatarTap(messagedUser),
              onLongPress: () => _onAvatarLongPress(messagedUser),
            ),
          featureActiveConfig?.enableSwipeToSeeTime == true
              ? _swipeWidget(_messagesWidgetColumn())
              : _messagesWidgetColumn(),
          if (isMessageBySender &&
              widget.chatBubbleConfig?.outgoingChatBubbleConfig
                      ?.receiptsWidgetConfig?.receiptsBubblePreference ==
                  ReceiptsBubblePreference.outSide) ...[getReciept()],
          if (isMessageBySender &&
              (featureActiveConfig?.enableCurrentUserProfileAvatar ?? true))
            ProfileCircle(
              bottomPadding:
                  widget.message.reaction?.reactions.isNotEmpty ?? false
                      ? profileCircleConfig?.bottomPadding ?? 15
                      : profileCircleConfig?.bottomPadding ?? 2,
              profileCirclePadding: profileCircleConfig?.padding,
              imageUrl: currentUser?.imageUrl,
              circleRadius: profileCircleConfig?.circleRadius,
              onTap: () => _onAvatarTap(messagedUser),
              onLongPress: () => _onAvatarLongPress(messagedUser),
            ),
        ],
      );

  void _onAvatarTap(ChatUser? user) {
    if (profileCircleConfig?.onAvatarTap != null && user != null) {
      profileCircleConfig?.onAvatarTap!(user);
    }
  }

  Widget getReciept() {
    final showReceipts = widget.chatBubbleConfig?.outgoingChatBubbleConfig
            ?.receiptsWidgetConfig?.showReceiptsIn ??
        ShowReceiptsIn.lastMessage;

    if (showReceipts == ShowReceiptsIn.all) {
      if (featureActiveConfig?.receiptsBuilderVisibility ?? true) {
        return widget.chatBubbleConfig?.outgoingChatBubbleConfig
                ?.receiptsWidgetConfig?.receiptsBuilder
                ?.call(widget.message) ??
            sendMessageAnimationBuilder(widget.message.status);
      }
      return const SizedBox();
    } else if (showReceipts == ShowReceiptsIn.lastMessage && isLastMessage) {
      if (featureActiveConfig?.receiptsBuilderVisibility ?? true) {
        return widget.chatBubbleConfig?.outgoingChatBubbleConfig
                ?.receiptsWidgetConfig?.receiptsBuilder
                ?.call(widget.message) ??
            sendMessageAnimationBuilder(widget.message.status);
      }
      return sendMessageAnimationBuilder(widget.message.status);
    }
    return const SizedBox();
  }

  void _onAvatarLongPress(ChatUser? user) {
    if (profileCircleConfig?.onAvatarLongPress != null && user != null) {
      profileCircleConfig?.onAvatarLongPress!(user);
    }
  }

  Widget _messagesWidgetColumn() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: isMessageBySender
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if ((chatController?.chatUsers.length ?? 0) > 1 && !isMessageBySender)
            Padding(
              padding:
                  widget.chatBubbleConfig?.inComingChatBubbleConfig?.padding ??
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                messagedUser.firstName ?? '',
                style: widget.chatBubbleConfig?.inComingChatBubbleConfig
                    ?.senderNameTextStyle,
              ),
            ),
          if (replyMessage != null)
            widget.repliedMessageConfig?.repliedMessageWidgetBuilder != null
                ? widget.repliedMessageConfig!
                    .repliedMessageWidgetBuilder!(widget.message.repliedMessage)
                : ReplyMessageWidget(
                    message: widget.message,
                    repliedMessageConfig: widget.repliedMessageConfig,
                    onTap: () => widget.onReplyTap
                        ?.call(widget.message.repliedMessage!.id),
                  ),
          MaterialConditionalWrapper(
            condition: isCupertino,
            child: MessageView(
              outgoingChatBubbleConfig:
                  widget.chatBubbleConfig?.outgoingChatBubbleConfig,
              isLongPressEnable:
                  (featureActiveConfig?.enableReactionPopup ?? true) ||
                      (featureActiveConfig?.enableReplySnackBar ?? true),
              inComingChatBubbleConfig:
                  widget.chatBubbleConfig?.inComingChatBubbleConfig,
              message: widget.message,
              isMessageBySender: isMessageBySender,
              messageConfig: widget.messageConfig,
              onLongPress: widget.onLongPress,
              chatBubbleMaxWidth: widget.chatBubbleConfig?.maxWidth,
              longPressAnimationDuration:
                  widget.chatBubbleConfig?.longPressAnimationDuration,
              onDoubleTap: featureActiveConfig?.enableDoubleTapToLike ?? false
                  ? widget.chatBubbleConfig?.onDoubleTap ??
                      (message) => currentUser != null
                          ? chatController?.setReaction(
                              emoji: heart,
                              messageId: message.id,
                              userId: currentUser!.id,
                            )
                          : null
                  : null,
              shouldHighlight: widget.shouldHighlight,
              controller: chatController,
              highlightColor: widget.repliedMessageConfig
                      ?.repliedMsgAutoScrollConfig.highlightColor ??
                  Colors.grey,
              highlightScale: widget.repliedMessageConfig
                      ?.repliedMsgAutoScrollConfig.highlightScale ??
                  1.1,
              onMaxDuration: _onMaxDuration,
            ),
          ),
        ],
      ),
    );
  }

  void _onMaxDuration(int duration) => maxDuration = duration;
}
