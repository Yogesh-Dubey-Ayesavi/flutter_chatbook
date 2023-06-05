// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdatedReceipt _$UpdatedReceiptFromJson(Map<String, dynamic> json) =>
    UpdatedReceipt(
      id: json['id'] as String,
      newStatus: $enumDecode(_$DeliveryStatusEnumMap, json['newStatus']),
    );

Map<String, dynamic> _$UpdatedReceiptToJson(UpdatedReceipt instance) =>
    <String, dynamic>{
      'id': instance.id,
      'newStatus': _$DeliveryStatusEnumMap[instance.newStatus]!,
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
