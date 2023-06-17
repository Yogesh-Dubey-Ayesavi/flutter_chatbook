part of '../../flutter_chatbook.dart';

class TextMessageView extends StatelessWidget {
  TextMessageView({
    Key? key,
    required this.isMessageBySender,
    required this.message,
    required this.isLastMessage,
    this.messageConfiguration,
    this.chatBubbleMaxWidth,
    this.inComingChatBubbleConfig,
    this.outgoingChatBubbleConfig,
    this.messageReactionConfig,
    this.highlightMessage = false,
    this.receiptsBuilderVisibility = true,
    this.highlightColor,
  }) : super(key: key);

  /// Represents current message is sent by current user.
  final bool isMessageBySender;

  /// Provides message instance of chat.
  final TextMessage message;

  /// Allow users to give max width of chat bubble.
  final double? chatBubbleMaxWidth;

  /// Provides configuration of chat bubble appearance from other user of chat.
  final ChatBubble? inComingChatBubbleConfig;

  /// Provides configuration of chat bubble appearance from current user of chat.
  final ChatBubble? outgoingChatBubbleConfig;

  /// Provides configuration of reaction appearance in chat bubble.
  final MessageReactionConfiguration? messageReactionConfig;

  /// Represents message should highlight.
  final bool highlightMessage;

  /// Allow user to set color of highlighted message.
  final Color? highlightColor;

  /// To controll receiptsBuilderVisibility.
  final bool receiptsBuilderVisibility;

  /// Whether message is last or no for displaying receipts
  final bool isLastMessage;

  /// For [ReadMoreConfig] to access read more configuration.
  final MessageConfiguration? messageConfiguration;

  final ValueNotifier<bool> _isExpanded = ValueNotifier(false);

  Widget textWidget(TextTheme textTheme, String text) => ParsedText(
        selectable: false,
        text: text,
        style: _textStyle ??
            textTheme.bodyMedium!.copyWith(
              color: Colors.white,
              fontSize: 16,
            ),
        parse: [
          MatchText(
            pattern: PatternStyle.bold.pattern,
            style: PatternStyle.bold.textStyle,
            renderText: ({required String str, required String pattern}) => {
              'display': str.replaceAll(
                PatternStyle.bold.from,
                PatternStyle.bold.replace,
              ),
            },
          ),
          MatchText(
            pattern: PatternStyle.italic.pattern,
            style: PatternStyle.italic.textStyle,
            renderText: ({required String str, required String pattern}) => {
              'display': str.replaceAll(
                PatternStyle.italic.from,
                PatternStyle.italic.replace,
              ),
            },
          ),
          MatchText(
            pattern: PatternStyle.lineThrough.pattern,
            style: (PatternStyle.lineThrough.textStyle),
            renderText: ({required String str, required String pattern}) => {
              'display': str.replaceAll(
                PatternStyle.lineThrough.from,
                PatternStyle.lineThrough.replace,
              ),
            },
          ),
          MatchText(
            pattern: PatternStyle.code.pattern,
            style: (PatternStyle.code.textStyle),
            renderText: ({required String str, required String pattern}) => {
              'display': str.replaceAll(
                PatternStyle.code.from,
                PatternStyle.code.replace,
              ),
            },
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textMessage = message.text;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
            constraints: BoxConstraints(
                maxWidth: chatBubbleMaxWidth ??
                    MediaQuery.of(context).size.width * 0.75),
            padding: _padding ??
                const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
            margin: _margin ??
                EdgeInsets.fromLTRB(5, 0, 6,
                    message.reaction?.reactions.isNotEmpty ?? false ? 15 : 2),
            decoration: BoxDecoration(
              color: highlightMessage ? highlightColor : _color,
              borderRadius: _borderRadius(textMessage),
            ),
            //TODO: add functinality to opt for readmore
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: textMessage.isUrl
                      ? LinkPreview(
                          linkPreviewConfig: _linkPreviewConfig,
                          url: textMessage,
                        )
                      : message.text.length <=
                              (messageConfiguration?.readMoreConfig
                                      ?.numOfWordsAfterEnableReadMore ??
                                  400)
                          ? textWidget(textTheme, message.text)
                          : ValueListenableBuilder<bool>(
                              valueListenable: _isExpanded,
                              builder:
                                  (BuildContext context, value, Widget? child) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    textWidget(
                                        textTheme,
                                        !_isExpanded.value
                                            ? '${message.text.substring(0, messageConfiguration?.readMoreConfig?.numOfWordsAfterEnableReadMore ?? 400)}...'
                                            : message.text),
                                    messageConfiguration
                                            ?.readMoreConfig?.readMoreWidget ??
                                        GestureDetector(
                                            onTap: () => _isExpanded.value =
                                                !_isExpanded.value,
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: !_isExpanded.value
                                                    ? const Text("Read More")
                                                    : const Text("Read Less")))
                                  ],
                                );
                              },
                            ),
                ),
                if (receiptsBuilderVisibility &&
                    isMessageBySender &&
                    outgoingChatBubbleConfig
                            ?.receiptsWidgetConfig?.showReceiptsIn ==
                        ShowReceiptsIn.allInside) ...[
                  outgoingChatBubbleConfig
                          ?.receiptsWidgetConfig?.receiptsBuilder
                          ?.call(message) ??
                      WhatsAppMessageWidget(message)
                ],
                if (receiptsBuilderVisibility &&
                    isMessageBySender &&
                    outgoingChatBubbleConfig
                            ?.receiptsWidgetConfig?.showReceiptsIn ==
                        ShowReceiptsIn.lastMessageInside &&
                    isLastMessage) ...[
                  outgoingChatBubbleConfig
                          ?.receiptsWidgetConfig?.receiptsBuilder
                          ?.call(message) ??
                      WhatsAppMessageWidget(message)
                ],
              ],
            )),
        if (message.reaction?.reactions.isNotEmpty ?? false)
          ReactionWidget(
            isMessageBySender: isMessageBySender,
            reaction: message.reaction!,
            messageReactionConfig: messageReactionConfig,
          ),
      ],
    );
  }

  EdgeInsetsGeometry? get _padding => isMessageBySender
      ? outgoingChatBubbleConfig?.padding
      : inComingChatBubbleConfig?.padding;

  EdgeInsetsGeometry? get _margin => isMessageBySender
      ? outgoingChatBubbleConfig?.margin
      : inComingChatBubbleConfig?.margin;

  LinkPreviewConfiguration? get _linkPreviewConfig => isMessageBySender
      ? outgoingChatBubbleConfig?.linkPreviewConfig
      : inComingChatBubbleConfig?.linkPreviewConfig;

  TextStyle? get _textStyle => isMessageBySender
      ? outgoingChatBubbleConfig?.textStyle
      : inComingChatBubbleConfig?.textStyle;

  BorderRadiusGeometry _borderRadius(String message) => isMessageBySender
      ? outgoingChatBubbleConfig?.borderRadius ??
          (message.length < 37
              ? BorderRadius.circular(replyBorderRadius1)
              : BorderRadius.circular(replyBorderRadius2))
      : inComingChatBubbleConfig?.borderRadius ??
          (message.length < 29
              ? BorderRadius.circular(replyBorderRadius1)
              : BorderRadius.circular(replyBorderRadius2));

  Color get _color => isMessageBySender
      ? outgoingChatBubbleConfig?.color ?? Colors.purple
      : inComingChatBubbleConfig?.color ?? Colors.grey.shade500;
}
