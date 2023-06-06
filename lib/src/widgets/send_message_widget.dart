part of '../../flutter_chatbook.dart';

class SendMessageWidget extends StatefulWidget {
  const SendMessageWidget(
      {Key? key,
      required this.onSendTap,
      required this.chatController,
      this.sendMessageConfig,
      this.backgroundColor,
      this.sendMessageBuilder,
      this.onReplyCallback,
      required this.replyMessageNotfier,
      this.onReplyCloseCallback,
      this.showToolBarButtons = false})
      : super(key: key);

  /// Provides call back when user tap on send button on text field.
  final MessageCallBack onSendTap;

  /// Provides configuration for text field appearance.
  final SendMessageConfiguration? sendMessageConfig;

  /// Allow user to set background colour.
  final Color? backgroundColor;

  /// Allow user to set custom text field.
  final ReplyMessageWithReturnWidget? sendMessageBuilder;

  /// Provides callback when user swipes chat bubble for reply.
  final ReplyMessageCallBack? onReplyCallback;

  /// Provides call when user tap on close button which is showed in reply pop-up.
  final VoidCallBack? onReplyCloseCallback;

  /// Provides controller for accessing few function for running chat.
  final ChatController chatController;

  final ValueNotifier<Message?> replyMessageNotfier;

  /// Whether to show toolbarbuttons at the text field
  final bool showToolBarButtons;

  @override
  State<SendMessageWidget> createState() => SendMessageWidgetState();
}

class SendMessageWidgetState extends State<SendMessageWidget> {
  final _textEditingController = InputTextFieldController();

  final ValueNotifier<Message?> _replyMessage = ValueNotifier(null);

  Message? get replyMessage => _replyMessage.value;

  ChatUser? get repliedUser => replyMessage?.author;

  String get _replyTo => replyMessage?.author.id == currentUser?.id
      ? PackageStrings.you
      : repliedUser?.firstName ?? '';

  ChatUser? currentUser;

  WidgetsExtension? get wigetsExtension => widget
      .chatController.chatBookController?.chatBookExtension?.widgetsExtension;

  ChatController? chatController;

  @override
  void initState() {
    widget.replyMessageNotfier.addListener(() {
      _replyMessage.value = widget.replyMessageNotfier.value;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (provide != null) {
      currentUser = provide!.currentUser;
      chatController = provide!.chatController;
    }
  }

  @override
  Widget build(BuildContext context) {
    final replyTitle = "${PackageStrings.replyTo} $_replyTo";
    return widget.sendMessageBuilder != null
        ? Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: widget.sendMessageBuilder!(replyMessage),
          )
        : Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    left: 0,
                    bottom: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height /
                          ((!kIsWeb && Platform.isIOS) ? 24 : 28),
                      color: widget.backgroundColor ?? Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      bottomPadding4,
                      bottomPadding4,
                      bottomPadding4,
                      _bottomPadding,
                    ),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        ValueListenableBuilder<Message?>(
                          builder: (_, state, child) {
                            if (state != null) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: widget.sendMessageConfig
                                          ?.textFieldBackgroundColor ??
                                      Colors.white,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(14),
                                  ),
                                ),
                                margin: const EdgeInsets.only(
                                  bottom: 17,
                                  right: 0.4,
                                  left: 0.4,
                                ),
                                padding: const EdgeInsets.fromLTRB(
                                  leftPadding,
                                  leftPadding,
                                  leftPadding,
                                  30,
                                ),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 2),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: widget.sendMessageConfig
                                            ?.replyDialogColor ??
                                        Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            replyTitle,
                                            style: TextStyle(
                                              color: widget.sendMessageConfig
                                                      ?.replyTitleColor ??
                                                  Colors.deepPurple,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.25,
                                            ),
                                          ),
                                          IconButton(
                                            constraints: const BoxConstraints(),
                                            padding: EdgeInsets.zero,
                                            icon: Icon(
                                              Icons.close,
                                              color: widget.sendMessageConfig
                                                      ?.closeIconColor ??
                                                  Colors.black,
                                              size: 16,
                                            ),
                                            onPressed: _onCloseTap,
                                          ),
                                        ],
                                      ),
                                      if (state.type.isVoice)
                                        _voiceReplyMessageView
                                      else if (state.type.isImage)
                                        _imageReplyMessageView
                                      else if (state.type.isCustom &&
                                          (wigetsExtension
                                                  ?.messageTypes.isNotEmpty ??
                                              false))
                                        _extensionMessageReplyView
                                      else
                                        (() {
                                          state as TextMessage;
                                          return Text(
                                            state.text,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: widget.sendMessageConfig
                                                      ?.replyMessageColor ??
                                                  Colors.black,
                                            ),
                                          );
                                        }())
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                          valueListenable: _replyMessage,
                        ),
                        ChatUITextField(
                            focusNode: chatController?.focusNode ?? FocusNode(),
                            chatController: widget.chatController,
                            textEditingController: _textEditingController,
                            onPressed: _onPressed,
                            sendMessageConfig: widget.sendMessageConfig,
                            onRecordingComplete: _onRecordingComplete,
                            onImageSelected: _onImageSelected,
                            showToolBarButtons: widget.showToolBarButtons)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget get _voiceReplyMessageView {
    final msg = replyMessage as AudioMessage?;
    return Row(
      children: [
        Icon(
          Icons.mic,
          color: widget.sendMessageConfig?.micIconColor,
        ),
        const SizedBox(width: 4),
        if (msg != null)
          Text(
            Duration(milliseconds: msg.duration).toHHMMSS(),
            style: TextStyle(
              fontSize: 12,
              color:
                  widget.sendMessageConfig?.replyMessageColor ?? Colors.black,
            ),
          ),
      ],
    );
  }

  Widget get _extensionMessageReplyView {
    return widget
        .chatController.chatBookController!.chatBookExtension!.widgetsExtension!
        .getMessageSuport(replyMessage! as CustomMessage)
        .replyPreview
        .call(context, replyMessage!);
  }

  Widget get _imageReplyMessageView {
    return Row(
      children: [
        Icon(
          Icons.photo,
          size: 20,
          color: widget.sendMessageConfig?.replyMessageColor ??
              Colors.grey.shade700,
        ),
        Text(
          PackageStrings.photo,
          style: TextStyle(
            color: widget.sendMessageConfig?.replyMessageColor ?? Colors.black,
          ),
        ),
      ],
    );
  }

  void _onRecordingComplete(String? path, Duration? duration) {
    if (path != null) {
      widget.onSendTap.call(AudioPathMessage(
        path,
        id: const Uuid().v4(),
        author: currentUser!,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        type: MessageType.voice,
        duration: duration?.inMilliseconds ?? 0,
        name: "${DateTime.now().millisecondsSinceEpoch}${currentUser!.id}",
        size: duration?.inMilliseconds ?? 0,
        repliedMessage: replyMessage,
      ));

      _assignRepliedMessage();
    }
  }

  void _onImageSelected(
      String imagePath, String error, int? size, String? name) {
    if (imagePath.isNotEmpty) {
      widget.onSendTap.call(ImageMessage(
        uri: imagePath,
        id: const Uuid().v4(),
        author: currentUser!,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        type: MessageType.image,
        // Set Size
        size: size ?? 0,
        name: name ??
            "${DateTime.now().millisecondsSinceEpoch}${currentUser!.id}-img",
        repliedMessage: replyMessage,
      ));
      _assignRepliedMessage();
    }
  }

  void _assignRepliedMessage() {
    if (replyMessage != null) {
      _replyMessage.value = null;
    }
  }

  void _onPressed() {
    if (_textEditingController.text.isNotEmpty &&
        !_textEditingController.text.startsWith('\n')) {
      widget.onSendTap.call(TextMessage(
        author: currentUser!,
        id: const Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        type: MessageType.text,
        text: _textEditingController.text.trim(),
        repliedMessage: replyMessage,
      ));
      _assignRepliedMessage();
      _textEditingController.clear();
    }
  }

  void assignReplyMessage(Message message) {
    if (currentUser != null) {
      _replyMessage.value = message;
    }
    FocusScope.of(context).requestFocus(chatController?.focusNode);
    if (widget.onReplyCallback != null) widget.onReplyCallback!(replyMessage!);
  }

  void _onCloseTap() {
    _replyMessage.value = null;
    if (widget.onReplyCloseCallback != null) widget.onReplyCloseCallback!();
  }

  double get _bottomPadding => (!kIsWeb && Platform.isIOS)
      ? (chatController?.focusNode.hasFocus ?? false
          ? bottomPadding1
          : window.viewPadding.bottom > 0
              ? bottomPadding2
              : bottomPadding3)
      : bottomPadding3;

  @override
  void dispose() {
    _textEditingController.dispose();
    chatController?.focusNode.dispose();
    _replyMessage.dispose();
    super.dispose();
  }
}
