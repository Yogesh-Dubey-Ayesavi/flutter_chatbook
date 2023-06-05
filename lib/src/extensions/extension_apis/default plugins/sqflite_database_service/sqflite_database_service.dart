import 'package:flutter_chatbook/src/utils/constants/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'sql_queries.dart';
import '../../../../../flutter_chatbook.dart';

class SqfliteDataBaseService extends DatabaseManager<SqfliteUserProfileService,
    SqfLiteChatRoomDataBaseService> {
  SqfliteDataBaseService({
    required ChatUser currentUser,
  }) : super(
          currentUser: currentUser,
        );

  late final Database database;

  late final SqfliteUserProfileService _userProfileService;

  late final SqfLiteChatRoomDataBaseService _chatRoomDataBaseService;

  @override
  SqfliteUserProfileService get profileManager => _userProfileService;

  @override
  SqfLiteChatRoomDataBaseService get roomManager => _chatRoomDataBaseService;

  @override
  void init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demoDataBase.db');
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(PluginQueries.createMessagesTable);
      await db.execute(PluginQueries.createChatUser);
      await db.execute(PluginQueries.createRooms);
      await db.execute(PluginQueries.createRoomUser);
    });
    serviceLocator.registerSingleton<SqfliteDataBaseService>(this);
    _userProfileService = SqfliteUserProfileService(currentUser, database);
    serviceLocator
        .registerSingleton<SqfliteUserProfileService>(_userProfileService);
    _chatRoomDataBaseService = SqfLiteChatRoomDataBaseService();
    if ((await _userProfileService.fetchChatUser(currentUser.id)) == null) {
      _userProfileService.createChatUser(currentUser);
    }
    serviceLocator.registerSingleton(_chatRoomDataBaseService);
  }
}
