part of '../../flutter_chatbook.dart';

class ReactionWidget extends StatefulWidget {
  const ReactionWidget({
    Key? key,
    required this.reaction,
    this.messageReactionConfig,
    required this.isMessageBySender,
  }) : super(key: key);

  /// Provides reaction instance of message.
  final Reaction reaction;

  /// Provides configuration of reaction appearance in chat bubble.
  final MessageReactionConfiguration? messageReactionConfig;

  /// Represents current message is sent by current user.
  final bool isMessageBySender;

  @override
  State<ReactionWidget> createState() => _ReactionWidgetState();
}

class _ReactionWidgetState extends State<ReactionWidget> {
  bool needToExtend = false;

  MessageReactionConfiguration? get messageReactionConfig =>
      widget.messageReactionConfig;
  final _reactionTextStyle = const TextStyle(fontSize: 13);
  ChatController? chatController;
  ChatUser? currentUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (provide != null) {
      chatController = provide!.chatController;
      currentUser = provide!.currentUser;
    }
  }

  @override
  Widget build(BuildContext context) {
    //// Convert into set to remove reduntant values
    final reactionsSet = widget.reaction.reactions.toSet();
    return Positioned(
      bottom: 0,
      right: widget.isMessageBySender && needToExtend ? 0 : null,
      child: InkWell(
        onTap: () => chatController != null && currentUser != null
            ? ReactionsBottomSheet().show(
                context: context,
                reaction: widget.reaction,
                chatController: chatController!,
                reactionsBottomSheetConfig:
                    messageReactionConfig?.reactionsBottomSheetConfig,
              )
            : null,
        child: MeasureSize(
          onSizeChange: (extend) => setState(() => needToExtend = extend),
          child: Container(
            padding: messageReactionConfig?.padding ??
                const EdgeInsets.symmetric(vertical: 1.7, horizontal: 6),
            margin: messageReactionConfig?.margin ??
                EdgeInsets.only(
                  left: widget.isMessageBySender ? 10 : 16,
                  right: 10,
                ),
            decoration: BoxDecoration(
              color: messageReactionConfig?.backgroundColor ??
                  Colors.grey.shade200,
              borderRadius: messageReactionConfig?.borderRadius ??
                  BorderRadius.circular(16),
              border: Border.all(
                color: messageReactionConfig?.borderColor ?? Colors.white,
                width: messageReactionConfig?.borderWidth ?? 1,
              ),
            ),
            child: Row(
              children: [
                Text(
                  reactionsSet.join(' '),
                  style: TextStyle(
                    fontSize: messageReactionConfig?.reactionSize ?? 13,
                  ),
                ),
                if ((chatController?.chatUsers.length ?? 0) > 1) ...[
                  if (!(widget.reaction.reactedUserIds.length > 3) &&
                      !(reactionsSet.length > 1))
                    ...List.generate(
                      widget.reaction.reactedUserIds.length,
                      (reactedUserIndex) => widget
                          .reaction.reactedUserIds[reactedUserIndex]
                          .getUserProfilePicture(
                        getChatUser: (userId) =>
                            chatController?.getUserFromId(userId),
                        profileCirclePadding:
                            messageReactionConfig?.profileCirclePadding,
                        profileCircleRadius:
                            messageReactionConfig?.profileCircleRadius,
                      ),
                    ),
                  if (widget.reaction.reactedUserIds.length > 3 &&
                      !(reactionsSet.length > 1))
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Text(
                        '+${widget.reaction.reactedUserIds.length}',
                        style:
                            messageReactionConfig?.reactedUserCountTextStyle ??
                                _reactionTextStyle,
                      ),
                    ),
                  if (reactionsSet.length > 1)
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Text(
                        widget.reaction.reactedUserIds.length.toString(),
                        style: messageReactionConfig?.reactionCountTextStyle ??
                            _reactionTextStyle,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
