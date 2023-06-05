import 'package:flutter_chatbook/src/models/models.dart';
import 'package:flutter_chatbook/src/models/voice_message_configuration.dart';
import 'package:flutter/material.dart';

class MessageConfiguration {
  /// Provides configuration of image message appearance.
  final ImageMessageConfiguration? imageMessageConfig;

  /// Provides configuration of image message appearance.
  final MessageReactionConfiguration? messageReactionConfig;

  /// Provides configuration of emoji messages appearance.
  final EmojiMessageConfiguration? emojiMessageConfig;

  /// Provides builder to create view for custom messages.
  final Widget Function(Message)? customMessageBuilder;

  /// Configurations for voice message bubble
  final VoiceMessageConfiguration? voiceMessageConfig;

  const MessageConfiguration({
    this.imageMessageConfig,
    this.messageReactionConfig,
    this.emojiMessageConfig,
    this.customMessageBuilder,
    this.voiceMessageConfig,
  });
}
