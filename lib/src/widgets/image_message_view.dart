part of '../../flutter_chatbook.dart';

class ImageMessageView extends StatelessWidget {
  const ImageMessageView({
    Key? key,
    required this.message,
    required this.isMessageBySender,
    this.imageMessageConfig,
    this.messageReactionConfig,
    this.outgoingChatBubbleConfig,
    this.highlightImage = false,
    required this.isLastMessage,
    this.highlightScale = 1.2,
    this.receiptsBuilderVisibility = true,
  }) : super(key: key);

  /// Provides message instance of chat.
  final ImageMessage message;

  /// Represents current message is sent by current user.
  final bool isMessageBySender;

  /// Provides configuration for image message appearance.
  final ImageMessageConfiguration? imageMessageConfig;

  /// Provides configuration of reaction appearance in chat bubble.
  final MessageReactionConfiguration? messageReactionConfig;

  /// Represents flag of highlighting image when user taps on replied image.
  final bool highlightImage;

  final ChatBubble? outgoingChatBubbleConfig;

  /// Provides scale of highlighted image when user taps on replied image.
  final double highlightScale;

  /// To controll receiptsBuilderVisibility.
  final bool receiptsBuilderVisibility;

  /// Whether message is last or no for displaying receipts
  final bool isLastMessage;

  String get imageUrl => message.uri;

  Widget get iconButton => ShareIcon(
        shareIconConfig: imageMessageConfig?.shareIconConfig,
        imageUrl: imageUrl,
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          isMessageBySender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (isMessageBySender) iconButton,
        Stack(
          children: [
            GestureDetector(
              onTap: () => imageMessageConfig?.onTap != null
                  ? imageMessageConfig?.onTap!(imageUrl)
                  : null,
              child: Transform.scale(
                scale: highlightImage ? highlightScale : 1.0,
                alignment: isMessageBySender
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Padding(
                  padding: imageMessageConfig?.padding ?? EdgeInsets.zero,
                  child: Padding(
                      padding: imageMessageConfig?.margin ??
                          EdgeInsets.only(
                            top: 6,
                            right: isMessageBySender ? 6 : 0,
                            left: isMessageBySender ? 0 : 6,
                            bottom:
                                message.reaction?.reactions.isNotEmpty ?? false
                                    ? 15
                                    : 0,
                          ),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: imageMessageConfig?.height ?? 200,
                              width: imageMessageConfig?.width ?? 150,
                              child: ClipRRect(
                                borderRadius:
                                    imageMessageConfig?.borderRadius ??
                                        BorderRadius.circular(14),
                                child: (() {
                                  if (imageUrl.isUrl) {
                                    return Image.network(
                                      imageUrl,
                                      fit: BoxFit.contain,
                                      cacheHeight:
                                          imageMessageConfig?.height?.toInt() ??
                                              200,
                                      cacheWidth:
                                          imageMessageConfig?.width?.toInt() ??
                                              150,
                                      // fit: BoxFit.fitHeight,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                    );
                                  } else if (imageUrl.fromMemory) {
                                    return Image.memory(
                                      base64Decode(imageUrl.substring(
                                          imageUrl.indexOf('base64') + 7)),
                                      fit: BoxFit.fill,
                                      cacheHeight:
                                          imageMessageConfig?.height?.toInt() ??
                                              200,
                                      cacheWidth:
                                          imageMessageConfig?.width?.toInt() ??
                                              150,
                                    );
                                  } else {
                                    return Image.file(
                                      File(imageUrl),
                                      fit: BoxFit.fill,
                                    );
                                  }
                                }()),
                              ),
                            ),
                            if (receiptsBuilderVisibility &&
                                    isMessageBySender &&
                                    outgoingChatBubbleConfig
                                            ?.receiptsWidgetConfig
                                            ?.showReceiptsIn ==
                                        ShowReceiptsIn.allInside ||
                                outgoingChatBubbleConfig?.receiptsWidgetConfig
                                        ?.showReceiptsIn ==
                                    ShowReceiptsIn.lastMessageInside) ...[
                              outgoingChatBubbleConfig
                                      ?.receiptsWidgetConfig?.receiptsBuilder
                                      ?.call(message) ??
                                WhatsAppMessageWidget(message)
                            ]
                          ])),
                ),
              ),
            ),
            if (message.reaction?.reactions.isNotEmpty ?? false)
              ReactionWidget(
                isMessageBySender: isMessageBySender,
                reaction: message.reaction!,
                messageReactionConfig: messageReactionConfig,
              ),
          ],
        ),
        if (!isMessageBySender) iconButton,
      ],
    );
  }
}
