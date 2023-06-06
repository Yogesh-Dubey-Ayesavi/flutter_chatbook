import 'package:flutter_chatbook/flutter_chatbook.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
part 'custom_message.g.dart';

/// A class that represents custom message. Use [metadata] to store anything
/// you want.
///

final JsonConstructor customMessageConstructors = {};

@JsonSerializable(explicitToJson: true)
@immutable
class CustomMessage extends Message {
  /// Creates a custom message.
  CustomMessage({
    required super.author,
    required super.createdAt,
    required super.id,
    required this.customType,
    super.metadata,
    super.remoteId,
    super.repliedMessage,
    super.roomId,
    super.showStatus,
    super.status,
    super.reaction,
    super.updatedAt,
  }) : super(type: MessageType.custom);

  /// Give custom type to the message for uniquely identifying the builders
  /// associated with each message.
  /// It must be defined in all small cases.
  /// See Difference between `type` and `customType` below
  /// | property    | customType                                                                                                                                               | type                                                                                                                                                                                                              |   |   |
  /// |-------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---|---|
  /// | datatype    | `String`                                                                                                                                                 | `MessageType`                                                                                                                                                                                                     |   |   |
  /// | description | `customType` is defined inside  `CustomMessage` to uniquely identify each `CustomMessage` as  they all are going to have `type` as `MessageType.custom`  | `type` is used each type of message  it defines which kind of message it is primarily there are 4 types of messages they are `MessageType.text`,`MessageType.voice`, `MessageType.image` and `MessageType.custom` |   |   |
  /// |             |                                                                                                                                                          |                                                                                                                                                                                                                   |   |   |
  final String customType;

  /// Creates a custom message from a map (decoded JSON).
  factory CustomMessage.fromJson(Map<String, dynamic> json) {

    final constructor = customMessageConstructors[json['customType']];
    if (constructor != null) {
      return constructor(json);
    } else {
      throw Exception('Unknown messageType ${[json["customType"]]}');
    }
  }


  /// Equatable props.
  @override
  List<Object?> get props => [
        author,
        createdAt,
        id,
        customType,
        metadata,
        remoteId,
        repliedMessage,
        roomId,
        status,
        updatedAt,
      ];

  @override
  Message copyWith({
    ChatUser? author,
    int? createdAt,
    String? id,
    String? customType,
    Map<String, dynamic>? metadata,
    String? remoteId,
    Message? repliedMessage,
    Reaction? reaction,
    String? roomId,
    bool? showStatus,
    DeliveryStatus? status,
    int? updatedAt,
  }) =>
      CustomMessage(
        customType: customType ?? this.customType,
        author: author ?? this.author,
        createdAt: createdAt ?? this.createdAt,
        id: id ?? this.id,
        metadata: metadata ?? this.metadata,
        reaction: reaction ?? this.reaction,
        remoteId: remoteId ?? this.remoteId,
        repliedMessage: repliedMessage ?? this.repliedMessage,
        roomId: roomId ?? this.roomId ?? roomId,
        showStatus: showStatus ?? this.showStatus,
        status: status ?? this.status,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  /// Converts a custom message to the map representation,
  /// encodable to JSON.
  @override
  Map<String, dynamic> toJson() => _$CustomMessageToJson(this);
}
