part of '../../../flutter_chatbook.dart';

class GestureView extends StatefulWidget {
  const GestureView(
      {super.key,
      required this.child,
      required this.isLongPressEnable,
      required this.message,
      required this.onLongPress,
      this.onDoubleTap});

  final Widget child;
  final DoubleCallBack onLongPress;
  final bool isLongPressEnable;
  final MessageCallBack? onDoubleTap;
  final Message message;

  @override
  State<GestureView> createState() => _GestureViewState();
}

class _GestureViewState extends State<GestureView> {
  final ValueNotifier<bool> isOn = ValueNotifier(false);

  ChatController? chatController;

  bool selectMultipleMessages = false;

  NewMessageSupport? get extensionMessageSupport => (widget
              .message.type.isCustom &&
          (chatController?.chatBookController?.chatBookExtension
                  ?.widgetsExtension?.messageTypes.isNotEmpty ??
              false))
      ? chatController!.chatBookController!.chatBookExtension!.widgetsExtension!
          .getMessageSuport(widget.message as CustomMessage)
      : null;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (provide != null) {
      chatController = provide!.chatController;
      selectMultipleMessages =
          provide!.featureActiveConfig.selectMultipleMessages;
    }
  }

  void _onLongPressStart(LongPressStartDetails details) {
    chatController?._addMessageSelection(widget.message);

    isOn.value = true;
    Future.delayed(const Duration(milliseconds: 150), () async {
      if (!kIsWeb && (await Vibration.hasCustomVibrationsSupport() ?? false)) {
        Vibration.vibrate(duration: 10, amplitude: 10);
      }

      if ((extensionMessageSupport?.isReactable ?? true)) {
        widget.onLongPress(
          details.globalPosition.dy - 120 - 64,
          details.globalPosition.dx,
        );
      }
    });
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    Future.delayed(const Duration(milliseconds: 200), () {
      isOn.value = false;
    });
  }

  void _onTap() {
    if (selectMultipleMessages &&
        (chatController?.multipleMessageSelection.value.isNotEmpty ?? false)) {
      chatController?._addMessageSelection(widget.message);
    }
    if (chatController?.showMessageActions.value == widget.message) {
      chatController?.hideReactionPopUp(messageActions: true);
    }
    chatController?.hideReactionPopUp();
  }

  Widget _animatedScale(Widget child) {
    return ValueListenableBuilder<bool>(
        valueListenable: isOn,
        builder: (context, value, ch) {
          return AnimatedScale(
              scale: value
                  ? selectMultipleMessages
                      ? .9325
                      : .8
                  : 1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.decelerate,
              child: child);
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      onLongPressStart: widget.isLongPressEnable ? _onLongPressStart : null,
      onLongPressEnd: widget.isLongPressEnable ? _onLongPressEnd : null,
      onDoubleTap: () async {
        if (!kIsWeb &&
            (await Vibration.hasCustomVibrationsSupport() ?? false)) {
          Vibration.vibrate(duration: 10, amplitude: 10);
        }
        widget.onDoubleTap!.call(widget.message);
      },
      child: (() {
        if (widget.isLongPressEnable) {
          return ValueListenableBuilder<List<Message>>(
              valueListenable: chatController!.multipleMessageSelection,
              builder: (BuildContext context, value, Widget? child) {
                if (value.contains(widget.message) && selectMultipleMessages) {
                  return AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      color: const Color(0xffff8aad),
                      child: _animatedScale(widget.child));
                }
                return _animatedScale(widget.child);
              });
        } else {
          return widget.child;
        }
      }()),
    );
  }
}
