import 'package:flutter_chatbook/flutter_chatbook.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/constants/constants.dart';
import '../utils/emoji_parser.dart';
import '../utils/package_strings.dart';

/// Extension for DateTime to get specific formats of dates and time.
extension TimeDifference on DateTime {
  String get getDay {
    final DateTime formattedDate = DateFormat(dateFormat).parse(toString());
    final DateFormat formatter = DateFormat.yMMMMd(enUS);
    final differenceInDays = formattedDate.difference(DateTime.now()).inDays;
    if (differenceInDays == 0) {
      return PackageStrings.today;
    } else if (differenceInDays <= 1 && differenceInDays >= -1) {
      return PackageStrings.yesterday;
    } else {
      return formatter.format(formattedDate);
    }
  }

  String get getDateFromDateTime {
    final DateFormat formatter = DateFormat(dateFormat);
    return formatter.format(this);
  }

  String get getTimeFromDateTime => DateFormat.Hm().format(this);
}

/// Extension on String which implements different types string validations.
extension ValidateString on String {
  bool get isImageUrl {
    final imageUrlRegExp = RegExp(imageUrlRegExpression);
    return imageUrlRegExp.hasMatch(this) || startsWith('data:image');
  }

  bool get fromMemory => startsWith('data:image');

  bool get isAllEmoji {
    for (String s in EmojiParser().unemojify(this).split(" ")) {
      if (!s.startsWith(":") || !s.endsWith(":")) {
        return false;
      }
    }
    return true;
  }

  bool get isUrl => Uri.tryParse(this)?.isAbsolute ?? false;

  Widget getUserProfilePicture({
    required ChatUser? Function(String) getChatUser,
    double? profileCircleRadius,
    EdgeInsets? profileCirclePadding,
  }) {
    return Padding(
      padding: profileCirclePadding ?? const EdgeInsets.only(left: 4),
      child: CircleAvatar(
        radius: profileCircleRadius ?? 8,
        backgroundImage:
            NetworkImage(getChatUser(this)?.imageUrl ?? profileImage),
      ),
    );
  }
}

/// Extension on MessageType for checking specific message type
extension MessageTypes on MessageType {
  bool get isImage => this == MessageType.image;

  bool get isText => this == MessageType.text;

  bool get isVoice => this == MessageType.voice;

  bool get isCustom => this == MessageType.custom;
}

extension PriorityTool on ToolBarPriority {
  bool get isHigh => this == ToolBarPriority.high;
  bool get isLow => this == ToolBarPriority.low;
  bool get isMedium => this == ToolBarPriority.medium;
}

/// Extension on ConnectionState for checking specific connection.
extension ConnectionStates on ConnectionState {
  bool get isWaiting => this == ConnectionState.waiting;

  bool get isActive => this == ConnectionState.active;
}

/// Extension on nullable sting to return specific state string.
extension ChatBookStateTitleExtension on String? {
  String getChatBookStateTitle(ChatBookState state) {
    switch (state) {
      case ChatBookState.hasMessages:
        return this ?? '';
      case ChatBookState.noData:
        return this ?? 'No Messages';
      case ChatBookState.loading:
        return this ?? '';
      case ChatBookState.error:
        return this ?? 'Something went wrong !!';
    }
  }
}

/// Extension on State for accessing inherited widget.
extension StatefulWidgetExtension on State {
  ChatBookInheritedWidget? get provide => ChatBookInheritedWidget.of(context);
}
