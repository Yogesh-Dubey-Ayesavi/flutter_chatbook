part of '../../flutter_chatbook.dart';

class ReplyMessageWidget extends StatelessWidget {
  const ReplyMessageWidget({
    Key? key,
    required this.message,
    this.repliedMessageConfig,
    this.onTap,
  }) : super(key: key);

  /// Provides message instance of chat.
  final Message message;

  /// Provides configurations related to replied message such as textstyle
  /// padding, margin etc. Also, this widget is located upon chat bubble.
  final RepliedMessageConfiguration? repliedMessageConfig;

  /// Provides call back when user taps on replied message.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final currentUser = ChatBookInheritedWidget.of(context)?.currentUser;
    final replyBySender = message.repliedMessage?.author.id == currentUser?.id;
    final textTheme = Theme.of(context).textTheme;
    final chatController = ChatBookInheritedWidget.of(context)?.chatController;
    final messagedUser = message.repliedMessage?.author;
    final isMessageByCurrentUser = message.author.id == currentUser?.id;
    final replyBy =
        replyBySender ? PackageStrings.you : messagedUser?.firstName;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: repliedMessageConfig?.margin ??
            const EdgeInsets.only(
              right: horizontalPadding,
              left: horizontalPadding,
              bottom: 4,
              top: 10,
            ),
        constraints:
            BoxConstraints(maxWidth: repliedMessageConfig?.maxWidth ?? 280),
        child: Column(
          crossAxisAlignment: isMessageByCurrentUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              "${PackageStrings.repliedBy} $replyBy",
              style: repliedMessageConfig?.replyTitleTextStyle ??
                  textTheme.bodyMedium!
                      .copyWith(fontSize: 14, letterSpacing: 0.3),
            ),
            const SizedBox(height: 6),
            IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: isMessageByCurrentUser
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  if (!isMessageByCurrentUser)
                    VerticalLine(
                      verticalBarWidth: repliedMessageConfig?.verticalBarWidth,
                      verticalBarColor: repliedMessageConfig?.verticalBarColor,
                      rightPadding: 4,
                    ),
                  Flexible(
                    child: Opacity(
                        opacity: repliedMessageConfig?.opacity ?? 0.8,
                        child: replyWidget(context, message, textTheme,
                            chatController, replyBySender)),
                  ),
                  if (isMessageByCurrentUser)
                    VerticalLine(
                      verticalBarWidth: repliedMessageConfig?.verticalBarWidth,
                      verticalBarColor: repliedMessageConfig?.verticalBarColor,
                      leftPadding: 4,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  replyWidget(BuildContext context, Message message, TextTheme textTheme,
      ChatController? chatController, bool replyBySender) {
    final replyMessage = message.repliedMessage!;

    switch (message.repliedMessage!.type) {
      case MessageType.custom:
        if (chatController?.chatBookController?.chatBookExtension
                ?.widgetsExtension?.messageTypes.isNotEmpty ??
            false) {
          final index = chatController!.chatBookController!.chatBookExtension!
              .widgetsExtension!.messageTypes
              .indexWhere((element) =>
                  element.customType ==
                  (message.repliedMessage as CustomMessage).customType);
          return chatController.chatBookController!.chatBookExtension!
              .widgetsExtension!.messageTypes[index].repliedMessageBuilder
              .call(context, message);
        }
        break;
      case MessageType.image:
        return Container(
            height: repliedMessageConfig?.repliedImageMessageHeight ?? 100,
            width: repliedMessageConfig?.repliedImageMessageWidth ?? 80,
            decoration: (() {
              final msg = replyMessage as ImageMessage;
              return BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(msg.uri),
                  fit: BoxFit.fill,
                ),
                borderRadius: repliedMessageConfig?.borderRadius ??
                    BorderRadius.circular(14),
              );
            }()));

      case MessageType.text:
        final msg = replyMessage as TextMessage;
        return Container(
            constraints: BoxConstraints(
              maxWidth: repliedMessageConfig?.maxWidth ?? 280,
            ),
            padding: repliedMessageConfig?.padding ??
                const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
            decoration: BoxDecoration(
              borderRadius: _borderRadius(
                replyMessage: replyMessage.id,
                replyBySender: replyBySender,
              ),
              color:
                  repliedMessageConfig?.backgroundColor ?? Colors.grey.shade500,
            ),
            child: Text(
              msg.text,
              style: repliedMessageConfig?.textStyle ??
                  textTheme.bodyMedium!.copyWith(color: Colors.black),
            ));

      case MessageType.unsupported:
        break;
      case MessageType.voice:
        final msg = replyMessage as AudioMessage;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.mic,
              color: repliedMessageConfig?.micIconColor ?? Colors.white,
            ),
            const SizedBox(width: 2),
            Text(
              msg.duration.toString(),
              style: repliedMessageConfig?.textStyle,
            ),
          ],
        );
    }
  }

  BorderRadiusGeometry _borderRadius({
    required String replyMessage,
    required bool replyBySender,
  }) =>
      replyBySender
          ? repliedMessageConfig?.borderRadius ??
              (replyMessage.length < 37
                  ? BorderRadius.circular(replyBorderRadius1)
                  : BorderRadius.circular(replyBorderRadius2))
          : repliedMessageConfig?.borderRadius ??
              (replyMessage.length < 29
                  ? BorderRadius.circular(replyBorderRadius1)
                  : BorderRadius.circular(replyBorderRadius2));
}
