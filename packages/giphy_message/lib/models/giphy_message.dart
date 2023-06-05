import 'package:flutter_chatbook/flutter_chatbook.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:json_annotation/json_annotation.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
part 'giphy_message.g.dart';

/// A class that represents custom message. Use [metadata] to store anything
/// you want.
@JsonSerializable(explicitToJson: true)
@immutable
class GiphyMessage extends CustomMessage {
  /// Giphy for the message.
  final GiphyGif giphy;

  GiphyMessage({
    required super.author,
    required super.createdAt,
    required super.id,
    required this.giphy,
    super.metadata,
    super.reaction,
    super.remoteId,
    super.updatedAt,
    super.roomId,
    super.showStatus,
    super.status,
    super.repliedMessage,
  }) : super(customType: "giphy");

  @override
  GiphyMessage copyWith({
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
    GiphyGif? giphy,
    int? updatedAt,
  }) {
    return GiphyMessage(
      author: author ?? this.author,
      giphy: giphy ?? this.giphy,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      metadata: metadata ?? this.metadata,
      remoteId: remoteId ?? this.remoteId,
      repliedMessage: repliedMessage ?? this.repliedMessage,
      reaction: reaction ?? this.reaction,
      roomId: roomId ?? this.roomId,
      showStatus: showStatus ?? this.showStatus,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Creates a text message from a map (decoded JSON).
  factory GiphyMessage.fromJson(Map<String, dynamic> json) =>
      _$GiphyMessageFromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final res = _$GiphyMessageToJson(this);
    res['customType'] = "giphy";
    return res;
  }
}
