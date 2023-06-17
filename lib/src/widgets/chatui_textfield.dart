part of '../../flutter_chatbook.dart';

class ChatUITextField extends StatefulWidget {
  const ChatUITextField(
      {Key? key,
      this.sendMessageConfig,
      required this.focusNode,
      required this.textEditingController,
      required this.onPressed,
      required this.onRecordingComplete,
      required this.onImageSelected,
      required this.chatController,
      this.showToolBarButtons = false})
      : super(key: key);

  /// Provides configuration of default text field in chat.
  final SendMessageConfiguration? sendMessageConfig;

  /// Provides focusNode for focusing text field.
  final FocusNode focusNode;

  /// Provides functions which handles text field.
  final TextEditingController textEditingController;

  /// Provides callback when user tap on text field.
  final VoidCallBack onPressed;

  /// Provides callback once voice is recorded.
  final Function(String? path, Duration? duration) onRecordingComplete;

  /// Provides callback when user select images from camera/gallery.
  final void Function(String imagePath, String error, int? size, String? name)
      onImageSelected;

  final ChatController chatController;

  /// Whether to show toolbarbuttons at the text field
  final bool showToolBarButtons;

  @override
  State<ChatUITextField> createState() => _ChatUITextFieldState();
}

class _ChatUITextFieldState extends State<ChatUITextField> {
  final ValueNotifier<String> _inputText = ValueNotifier('');

  final ValueNotifier<bool> isUserTagging = ValueNotifier(false);

  final ImagePicker _imagePicker = ImagePicker();

  List<NewMessageSupport> get messageExtensions =>
      widget.chatController.chatBookController?.chatBookExtension
          ?.widgetsExtension?.messageTypes ??
      [];

  RecorderController? controller;

  ValueNotifier<bool> isRecording = ValueNotifier(false);

  SendMessageConfiguration? get sendMessageConfig => widget.sendMessageConfig;

  VoiceRecordingConfiguration? get voiceRecordingConfig =>
      widget.sendMessageConfig?.voiceRecordingConfiguration;

  ImagePickerIconsConfiguration? get imagePickerIconsConfig =>
      sendMessageConfig?.imagePickerIconsConfig;

  TextFieldConfiguration? get textFieldConfig =>
      sendMessageConfig?.textFieldConfig;

  OutlineInputBorder get _outLineBorder => OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: textFieldConfig?.borderRadius ??
            BorderRadius.circular(textFieldBorderRadius),
      );

  ValueNotifier<TypeWriterStatus> composingStatus =
      ValueNotifier(TypeWriterStatus.typed);

  List<NewMessageSupport> get lessPriorityExtensions => messageExtensions
      .where((element) => element.priority != ToolBarPriority.high)
      .toList();

  late Debouncer debouncer;

  ChatUser? currentUser;

  @override
  void initState() {
    attachListeners();
    debouncer = Debouncer(
        sendMessageConfig?.textFieldConfig?.compositionThresholdTime ??
            const Duration(seconds: 1));
    super.initState();

    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      controller = RecorderController();
    }
  }

  @override
  void dispose() {
    debouncer.dispose();
    composingStatus.dispose();
    isRecording.dispose();
    _inputText.dispose();
    super.dispose();
  }

  void attachListeners() {
    composingStatus.addListener(() {
      widget.sendMessageConfig?.textFieldConfig?.onMessageTyping
          ?.call(composingStatus.value);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (provide != null) {
      currentUser = provide!.currentUser;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          textFieldConfig?.padding ?? const EdgeInsets.symmetric(horizontal: 6),
      margin: textFieldConfig?.margin,
      decoration: BoxDecoration(
        borderRadius: textFieldConfig?.borderRadius ??
            BorderRadius.circular(textFieldBorderRadius),
        color: sendMessageConfig?.textFieldBackgroundColor ?? Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<bool>(
              valueListenable: isUserTagging,
              builder: (context, value, child) => value
                  ? AnimatedContainer(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: textFieldConfig?.borderRadius ??
                            BorderRadius.circular(textFieldBorderRadius),
                        color: sendMessageConfig?.textFieldBackgroundColor ??
                            Colors.white,
                      ),
                      height: 200,
                      duration: const Duration(seconds: 2),
                      curve: Curves.linear,
                      child: Stack(
                        children: [
                          ListView.builder(
                              itemCount: widget.chatController.chatUsers.length,
                              padding: const EdgeInsets.all(5),
                              itemBuilder: (context, index) {
                                if (widget.chatController.chatUsers[index].id ==
                                    currentUser?.id) return const SizedBox();
                                return ListTile(
                                  title: Text(
                                    widget.chatController.chatUsers[index]
                                            .firstName ??
                                        '',
                                    style: textFieldConfig?.textStyle ??
                                        const TextStyle(color: Colors.white),
                                  ),
                                  leading: widget.chatController
                                              .chatUsers[index].imageUrl !=
                                          null
                                      ? CircleAvatar(
                                          child: Image.network(widget
                                                  .chatController
                                                  .chatUsers[index]
                                                  .imageUrl ??
                                              ""),
                                        )
                                      : null,
                                );
                              }),
                          Positioned(
                              top: 10,
                              right: 10,
                              child: IconButton(
                                onPressed: () {
                                  isUserTagging.value = false;
                                },
                                icon: const Icon(CupertinoIcons.xmark_circle),
                              ))
                        ],
                      ),
                    )
                  : const SizedBox()),
          ValueListenableBuilder<bool>(
            valueListenable: isRecording,
            builder: (_, isRecordingValue, child) {
              return Row(
                children: [
                  if (isRecordingValue && controller != null && !kIsWeb)
                    AudioWaveforms(
                      size: Size(MediaQuery.of(context).size.width * 0.75, 50),
                      recorderController: controller!,
                      margin: voiceRecordingConfig?.margin,
                      padding: voiceRecordingConfig?.padding ??
                          const EdgeInsets.symmetric(horizontal: 8),
                      decoration: voiceRecordingConfig?.decoration ??
                          BoxDecoration(
                            color: voiceRecordingConfig?.backgroundColor,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                      waveStyle: voiceRecordingConfig?.waveStyle ??
                          WaveStyle(
                            extendWaveform: true,
                            showMiddleLine: false,
                            waveColor:
                                voiceRecordingConfig?.waveStyle?.waveColor ??
                                    Colors.black,
                          ),
                    )
                  else
                    Expanded(
                      child: TextField(
                        focusNode: widget.focusNode,
                        controller: widget.textEditingController,
                        style: textFieldConfig?.textStyle ??
                            const TextStyle(color: Colors.white),
                        maxLines: textFieldConfig?.maxLines ?? 5,
                        minLines: textFieldConfig?.minLines ?? 1,
                        keyboardType: textFieldConfig?.textInputType,
                        inputFormatters: textFieldConfig?.inputFormatters,
                        onChanged: _onChanged,
                        textCapitalization:
                            textFieldConfig?.textCapitalization ??
                                TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: textFieldConfig?.hintText ??
                              PackageStrings.message,
                          fillColor:
                              sendMessageConfig?.textFieldBackgroundColor ??
                                  Colors.white,
                          filled: true,
                          hintStyle: textFieldConfig?.hintStyle ??
                              TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade600,
                                letterSpacing: 0.25,
                              ),
                          prefixIcon: IconButton(
                            constraints: const BoxConstraints(),
                            onPressed: () =>
                                _showEmojiBottomSheet.call(context),
                            icon: sendMessageConfig?.emojiPickerIcon ??
                                Icon(Icons.emoji_emotions_outlined,
                                    color:
                                        sendMessageConfig?.emojiPickerColor ??
                                            Colors.black),
                          ),
                          contentPadding: textFieldConfig?.contentPadding ??
                              const EdgeInsets.symmetric(horizontal: 6),
                          border: _outLineBorder,
                          focusedBorder: _outLineBorder,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: textFieldConfig?.borderRadius ??
                                BorderRadius.circular(textFieldBorderRadius),
                          ),
                        ),
                      ),
                    ),
                  ValueListenableBuilder<String>(
                    valueListenable: _inputText,
                    builder: (_, inputTextValue, child) {
                      if (widget.textEditingController.text.trim().isNotEmpty ||
                          widget.showToolBarButtons) {
                        return IconButton(
                          color: sendMessageConfig?.defaultSendButtonColor ??
                              Colors.green,
                          onPressed: () {
                            if (widget.textEditingController.text
                                .trim()
                                .isNotEmpty) {
                              isUserTagging.value = false;
                              widget.onPressed();
                            }
                            widget.textEditingController.clear();
                            _inputText.value = '';
                          },
                          icon: sendMessageConfig?.sendButtonIcon ??
                              const Icon(Icons.send),
                        );
                      } else {
                        return Row(
                          children: [
                            if (!isRecordingValue) ...[
                              IconButton(
                                constraints: const BoxConstraints(),
                                onPressed: () =>
                                    _onIconPressed(ImageSource.camera),
                                icon: imagePickerIconsConfig
                                        ?.cameraImagePickerIcon ??
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      color: imagePickerIconsConfig
                                          ?.cameraIconColor,
                                    ),
                              ),
                              IconButton(
                                constraints: const BoxConstraints(),
                                onPressed: () =>
                                    _onIconPressed(ImageSource.gallery),
                                icon: imagePickerIconsConfig
                                        ?.galleryImagePickerIcon ??
                                    Icon(
                                      Icons.image,
                                      color: imagePickerIconsConfig
                                          ?.galleryIconColor,
                                    ),
                              ),
                              if ((widget
                                      .chatController
                                      .chatBookController
                                      ?.chatBookExtension
                                      ?.widgetsExtension
                                      ?.messageTypes
                                      .isNotEmpty) ??
                                  false) ...[..._getActionWidgets()],
                              if (lessPriorityExtensions.isNotEmpty) ...[
                                IconButton(
                                  constraints: const BoxConstraints(),
                                  onPressed: () =>
                                      _onExtensionPress.call(context),
                                  icon: imagePickerIconsConfig
                                          ?.attachMentPickerIcon ??
                                      Transform.rotate(
                                          angle: 225,
                                          child: Icon(
                                            Icons.attachment,
                                            color: imagePickerIconsConfig
                                                ?.attachMentIconColor,
                                          )),
                                ),
                              ]
                            ],
                            if (widget.sendMessageConfig?.allowRecordingVoice ??
                                true &&
                                    Platform.isIOS &&
                                    Platform.isAndroid &&
                                    !kIsWeb)
                              IconButton(
                                onPressed: _recordOrStop,
                                icon: (isRecordingValue
                                        ? voiceRecordingConfig?.micIcon
                                        : voiceRecordingConfig?.stopIcon) ??
                                    Icon(isRecordingValue
                                        ? Icons.stop
                                        : Icons.mic),
                                color: voiceRecordingConfig?.recorderIconColor,
                              )
                          ],
                        );
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _showEmojiBottomSheet(BuildContext context) =>
      showModalBottomSheet<void>(
        context: context,
        builder: (context) => EmojiPickerWidget(onSelected: (emoji) {
          widget.textEditingController.text += emoji;
          _onChanged(widget.textEditingController.text);
        }),
      );

  List<Widget> _getActionWidgets() {
    return widget.chatController.chatBookController!.chatBookExtension!
        .widgetsExtension!.messageTypes
        .where((element) => element.priority.isHigh)
        .toList()
        .map((e) => IconButton(
              constraints: const BoxConstraints(),
              onPressed: () => e.onMessageCreation.call(context, currentUser!),
              icon: e.icon ?? Text(e.title),
            ))
        .toList();
  }

  void _onExtensionPress(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 45 / 100,
                maxWidth: double.infinity,
              ),
              child: ListView.builder(
                itemCount: lessPriorityExtensions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      onTap: () => _onTilePress.call(index),
                      title: Text(messageExtensions[index].title),
                      leading: messageExtensions[index].icon
                      // other ListTile properties
                      );
                },
              ));
        });
  }

  _onTilePress(int index) async {
    if (context.mounted) {
      Navigator.pop(context);
    }
    final msg = await messageExtensions[index]
        .onMessageCreation
        .call(context, currentUser!);
    if (msg != null) {
      widget.chatController.addMessage(msg);
    }
  }

  Future<void> _recordOrStop() async {
    assert(
      defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android,
      "Voice messages are only supported with android and ios platform",
    );
    if (!isRecording.value) {
      await controller?.record();
      isRecording.value = true;
    } else {
      final path = await controller?.stop();
      final duration = controller?.recordedDuration;
      isRecording.value = false;
      widget.onRecordingComplete(path, duration);
    }
  }

  void _onIconPressed(ImageSource imageSource) async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: imageSource);

      widget.onImageSelected(
          image?.path ?? '', '', await image?.length() ?? 0, image?.name);
    } catch (e) {
      widget.onImageSelected('', e.toString(), null, null);
    }
  }

  void _onChanged(String inputText) {
    if (widget.textEditingController.text
            .split(' ')
            .indexWhere((element) => element.startsWith('@')) !=
        -1) {
      isUserTagging.value = true;
    } else if (inputText.trim().isEmpty) {
      isUserTagging.value = false;
    }
    debouncer.run(() {
      composingStatus.value = TypeWriterStatus.typed;
    }, () {
      composingStatus.value = TypeWriterStatus.typing;
    });
    _inputText.value = inputText;
  }
}
