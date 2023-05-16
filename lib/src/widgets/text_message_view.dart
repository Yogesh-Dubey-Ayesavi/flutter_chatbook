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

class TextMessageView extends StatelessWidget {
  const TextMessageView({
    Key? key,
    required this.isMessageBySender,
    required this.message,
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                textMessage.isUrl
                    ? LinkPreview(
                        linkPreviewConfig: _linkPreviewConfig,
                        url: textMessage,
                      )
                    : ParsedText(
                        selectable: false,
                        text: message.text,
                        style: _textStyle ??
                            textTheme.bodyMedium!.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                        parse: [
                          MatchText(
                            pattern: PatternStyle.bold.pattern,
                            style: PatternStyle.bold.textStyle,
                            renderText: (
                                    {required String str,
                                    required String pattern}) =>
                                {
                              'display': str.replaceAll(
                                PatternStyle.bold.from,
                                PatternStyle.bold.replace,
                              ),
                            },
                          ),
                          MatchText(
                            pattern: PatternStyle.italic.pattern,
                            style: PatternStyle.italic.textStyle,
                            renderText: (
                                    {required String str,
                                    required String pattern}) =>
                                {
                              'display': str.replaceAll(
                                PatternStyle.italic.from,
                                PatternStyle.italic.replace,
                              ),
                            },
                          ),
                          MatchText(
                            pattern: PatternStyle.lineThrough.pattern,
                            style: (PatternStyle.lineThrough.textStyle),
                            renderText: (
                                    {required String str,
                                    required String pattern}) =>
                                {
                              'display': str.replaceAll(
                                PatternStyle.lineThrough.from,
                                PatternStyle.lineThrough.replace,
                              ),
                            },
                          ),
                          MatchText(
                            pattern: PatternStyle.code.pattern,
                            style: (PatternStyle.code.textStyle),
                            renderText: (
                                    {required String str,
                                    required String pattern}) =>
                                {
                              'display': str.replaceAll(
                                PatternStyle.code.from,
                                PatternStyle.code.replace,
                              ),
                            },
                          ),
                        ],
                      ),
                if (receiptsBuilderVisibility &&
                    isMessageBySender &&
                    outgoingChatBubbleConfig
                            ?.receiptsWidgetConfig?.receiptsBubblePreference ==
                        ReceiptsBubblePreference.inside) ...[
                  outgoingChatBubbleConfig
                          ?.receiptsWidgetConfig?.receiptsBuilder
                          ?.call(message) ??
                      WhatsappStyleMessageTimeWidget(message)
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