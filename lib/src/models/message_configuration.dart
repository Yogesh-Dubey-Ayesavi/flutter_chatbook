import 'package:flutter_chatbook/src/models/models.dart';
import 'package:flutter_chatbook/src/models/read_more_config.dart';
import 'package:flutter_chatbook/src/models/voice_message_configuration.dart';
import 'package:flutter/material.dart';

/// A class that provides configuration options for messages in a chat application.
class MessageConfiguration {
  /// Configuration for the appearance of image messages.
  final ImageMessageConfiguration? imageMessageConfig;

  /// Configuration for the appearance of message reactions.
  final MessageReactionConfiguration? messageReactionConfig;

  /// Configuration for the appearance of emoji messages.
  final EmojiMessageConfiguration? emojiMessageConfig;

  /// A builder function that creates a view for custom messages.
  final Widget Function(Message)? customMessageBuilder;

  /// Configuration for voice message bubbles.
  final VoiceMessageConfiguration? voiceMessageConfig;

  /// Configuration options for customizing the "Read More" feature in text messages.
  final ReadMoreConfig? readMoreConfig;

  /// Creates an instance of [MessageConfiguration] with the specified configurations.
  const MessageConfiguration({
    this.imageMessageConfig,
    this.messageReactionConfig,
    this.emojiMessageConfig,
    this.customMessageBuilder,
    this.voiceMessageConfig,
    this.readMoreConfig,
  });
}

