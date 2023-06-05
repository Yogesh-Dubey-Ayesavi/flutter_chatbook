// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextMessage _$TextMessageFromJson(Map<String, dynamic> json) => TextMessage(
      author: ChatUser.fromJson(json['author'] as Map<String, dynamic>),
      id: json['id'] as String,
      createdAt: json['createdAt'] as int,
      reaction: json['reaction'] == null
          ? null
          : Reaction.fromJson(json['reaction'] as Map<String, dynamic>),
      metadata: json['metadata'] as Map<String, dynamic>?,
      remoteId: json['remoteId'] as String?,
      repliedMessage: json['repliedMessage'] == null
          ? null
          : Message.fromJson(json['repliedMessage'] as Map<String, dynamic>),
      roomId: json['roomId'] as String?,
      showStatus: json['showStatus'] as bool?,
      status: $enumDecodeNullable(_$DeliveryStatusEnumMap, json['status']),
      text: json['text'] as String,
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']),
      updatedAt: json['updatedAt'] as int?,
    );

Map<String, dynamic> _$TextMessageToJson(TextMessage instance) =>
    <String, dynamic>{
      'author': instance.author.toJson(),
      'createdAt': instance.createdAt,
      'id': instance.id,
      'metadata': instance.metadata,
      'remoteId': instance.remoteId,
      'repliedMessage': instance.repliedMessage?.toJson(),
      'roomId': instance.roomId,
      'showStatus': instance.showStatus,
      'status': _$DeliveryStatusEnumMap[instance.status]!,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'updatedAt': instance.updatedAt,
      'reaction': instance.reaction?.toJson(),
      'text': instance.text,
    };

const _$DeliveryStatusEnumMap = {
  DeliveryStatus.error: 'error',
  DeliveryStatus.sending: 'sending',
  DeliveryStatus.sent: 'sent',
  DeliveryStatus.read: 'read',
  DeliveryStatus.delivered: 'delivered',
  DeliveryStatus.undelivered: 'undelivered',
  DeliveryStatus.pending: 'pending',
  DeliveryStatus.custom: 'custom',
};

const _$MessageTypeEnumMap = {
  MessageType.custom: 'custom',
  MessageType.image: 'image',
  MessageType.text: 'text',
  MessageType.unsupported: 'unsupported',
  MessageType.voice: 'voice',
};
