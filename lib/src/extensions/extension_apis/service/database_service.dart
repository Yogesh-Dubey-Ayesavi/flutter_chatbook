import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../flutter_chatbook.dart';
part 'database_service.g.dart';

/// The `DatabaseManager` class adds the capability to store and retrieve messages in [ChatBook] directly.
///
/// It consists of the following components:
///
/// 1. `ProfileManager`: The `ProfileManager` class provides CRUD operations for managing `ChatUser` profiles and their attributes.
///    It allows creating new profiles, retrieving existing profiles, updating profile information, and deleting profiles from the database.
///    For more details, see [ProfileManager].
///
/// 2. `RoomManager`: The `RoomManager` class provides CRUD operations for managing rooms.
///    It allows creating new rooms, retrieving existing rooms, updating room information, and deleting rooms from the database.
///    For more details, see [RoomManager].
///
/// Example usage:
///
/// ```dart
/// class MyCustomDatabaseManager extends DatabaseManager {
///   MyCustomDatabaseManager(this.currentUser) : super(currentUser: currentUser);
///
///   final ChatUser currentUser;
///
///   @override
///   void init() {
///     // Initialize the database manager
///   }
///
///   @override
///   ProfileManager get profileManager => const MyProfileManager(currentUser);
///
///   @override
///   RoomManager get roomManager => const MyRoomManager();
/// }
/// ```
abstract class DatabaseManager<T extends ProfileManager,
    E extends RoomManager> {
  /// Creates a new instance of the `DatabaseManager` class.
  ///
  /// The [currentUser] parameter represents the current user for whom the database manager is initialized.
  DatabaseManager({required this.currentUser}) {
    init();
  }

  /// Gets the profile manager instance.
  T get profileManager;

  /// Gets the room manager instance.
  E get roomManager;

  /// The current user for whom the database manager is initialized.
  final ChatUser currentUser;

  /// Initializes the database manager.
  ///
  /// Subclasses should override this method to perform any necessary initialization tasks.
  @mustCallSuper
  @protected
  void init();
}

/// The `UpdatedReceipt` class represents an updated receipt with a new delivery status.
@JsonSerializable()
class UpdatedReceipt {
  /// Creates a new instance of the `UpdatedReceipt` class.
  ///
  /// The [id] parameter is the ID of the receipt.
  /// The [newStatus] parameter is the new delivery status of the receipt.
  const UpdatedReceipt({required this.id, required this.newStatus});

  /// The ID of the receipt.
  final String id;

  /// The new delivery status of the receipt.
  final DeliveryStatus newStatus;

  /// Converts the `UpdatedReceipt` object to a JSON map.
  Map<String, dynamic> toJson() => _$UpdatedReceiptToJson(this);

  /// Creates an `UpdatedReceipt` object from a JSON map.
  factory UpdatedReceipt.fromJson(Map<String, dynamic> json) =>
      _$UpdatedReceiptFromJson(json);
}
