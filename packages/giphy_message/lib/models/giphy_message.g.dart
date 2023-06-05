// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'giphy_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GiphyMessage _$GiphyMessageFromJson(Map<String, dynamic> json) => GiphyMessage(
      author: ChatUser.fromJson(json['author'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as int,
      id: json['id'] as String,
      giphy: GiphyGif.fromJson(json['giphy'] as Map<String, dynamic>),
      metadata: json['metadata'] as Map<String, dynamic>?,
      reaction: json['reaction'] == null
          ? null
          : Reaction.fromJson(json['reaction'] as Map<String, dynamic>),
      remoteId: json['remoteId'] as String?,
      updatedAt: json['updatedAt'] as int?,
      roomId: json['roomId'] as String?,
      showStatus: json['showStatus'] as bool?,
      status: $enumDecodeNullable(_$DeliveryStatusEnumMap, json['status']),
      repliedMessage: json['repliedMessage'] == null
          ? null
          : Message.fromJson(json['repliedMessage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GiphyMessageToJson(GiphyMessage instance) =>
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
      'updatedAt': instance.updatedAt,
      'reaction': instance.reaction?.toJson(),
      'giphy': instance.giphy.toJson(),
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
