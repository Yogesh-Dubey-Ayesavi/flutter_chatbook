import 'package:flutter/material.dart';

import '../../../../flutter_chatbook.dart';

class WidgetsExtension {
  WidgetsExtension({required this.messageTypes});

  final List<NewMessageSupport> messageTypes;

  NewMessageSupport getMessageSuport(Message message) {
    message as CustomMessage;
    return messageTypes
        .firstWhere((element) => element.customType == message.customType);
  }
}

abstract class NewMessageSupport<T extends Message> {
  NewMessageSupport(this.messageClass,
      {required this.messageBuilder,
      required this.customType,
      required this.title,
      required this.onMessageCreation,
      required this.replyPreview,
      required this.repliedMessageBuilder,
      this.icon,
      this.onSendPress,
      this.priority = ToolBarPriority.medium,
      this.customToolBarWidget,
      this.isSwipeable = true,
      this.isInsideBubble = true,
      this.isReactable = false});

  final Type messageClass;

  final String customType;

  final Widget Function(BuildContext context, Message message) messageBuilder;

  final Widget? icon;

  final String title;

  final Widget? Function(BuildContext context)? customToolBarWidget;

  final Function(T message)? onSendPress;

  final Widget Function(BuildContext context, Message message) replyPreview;

  final Widget Function(BuildContext context, Message message)
      repliedMessageBuilder;

  final Future<Message?> Function(BuildContext context, ChatUser author)
      onMessageCreation;

  final ToolBarPriority priority;

  final bool isReactable;

  final bool isSwipeable;

  final bool isInsideBubble;
}
