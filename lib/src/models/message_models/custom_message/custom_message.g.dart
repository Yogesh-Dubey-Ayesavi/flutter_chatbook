// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// CustomMessage _$CustomMessageFromJson(Map<String, dynamic> json) =>
//     CustomMessage(
//       customType: json['customType'] as String,
//       author: ChatUser.fromJson(json['author'] as Map<String, dynamic>),
//       createdAt: json['createdAt'] as int,
//       reaction: json['reaction'] == null
//           ? null
//           : Reaction.fromJson(json['reaction'] as Map<String, dynamic>),
//       id: json['id'] as String,
//       metadata: json['metadata'] as Map<String, dynamic>?,
//       remoteId: json['remoteId'] as String?,
//       repliedMessage: json['repliedMessage'] == null
//           ? null
//           : Message.fromJson(json['repliedMessage'] as Map<String, dynamic>),
//       roomId: json['roomId'] as String?,
//       showStatus: json['showStatus'] as bool?,
//       status: $enumDecodeNullable(_$DeliveryStatusEnumMap, json['status']),
//       updatedAt: json['updatedAt'] as int?,
//     );

Map<String, dynamic> _$CustomMessageToJson(CustomMessage instance) =>
    <String, dynamic>{
      'author': instance.author.toJson(),
      'createdAt': instance.createdAt,
      'id': instance.id,
      'metadata': instance.metadata,
      'remoteId': instance.remoteId,
      'repliedMessage': instance.repliedMessage?.toJson(),
      'roomId': instance.roomId,
      'showStatus': instance.showStatus,
      'customType': instance.customType,
      'status': _$DeliveryStatusEnumMap[instance.status]!,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'updatedAt': instance.updatedAt,
      'reaction': instance.reaction?.toJson(),
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
