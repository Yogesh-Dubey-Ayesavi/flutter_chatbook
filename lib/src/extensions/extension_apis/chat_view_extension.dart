import 'package:flutter_chatbook/src/extensions/extension_apis/service/backend_service.dart';
import '../../../flutter_chatbook.dart';

/// `ChatBookExtension` API is used for extending services and using
/// this package with custom plugins. `ChatBookExtension` can be used for
/// extending support for custom messages and custom servies.
/// [ChatBookController] and [ChatBook] can utilise only one `ChatBookExtension`
/// at a time.
/// `ChatBookExtension` hold [ServiceExtension] and [WidgetsExtension] for
/// extending services and support for new messages respectively. See [ServiceExtension] and
/// [WidgetsExtension] for more info.
class ChatBookExtension {
  
  const ChatBookExtension({this.serviceExtension, this.widgetsExtension});

  /// Used for extending services see [ServiceExtension].
  final ServiceExtension? serviceExtension;

  /// Used for adding support to new messages and widgets see [WidgetsExtension]
  final WidgetsExtension? widgetsExtension;
}

/// `ServiceExtension` are used to allocate services such as
/// 1. [DatabaseManager]
/// 2. [BackendManager]
///
/// ### DatabaseManager
/// `DatabaseManager` is used for providing support for custom
/// database, it consists of various CRUD methods that will be utilised by
/// [ChatBook] under the hood.
/// It is the place where you can implement persistence and storing logics see [DatabaseManager] for more.
///
///### BackendManager
/// `BackendManager` is used for providing support for handling transmission and recieving messages
/// [ChatBook] will utlise this when a [Room] sends or recieves a message see [BackendManager] for more info.
class ServiceExtension<T extends DatabaseManager> {
  const ServiceExtension({this.dataManager, this.backendService});

  final T? dataManager;

  final BackendManager? backendService;
}
