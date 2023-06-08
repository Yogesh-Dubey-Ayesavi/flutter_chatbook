import 'dart:math';
import 'package:flutter_chatbook/flutter_chatbook.dart';
import 'package:example/create_user_screen.dart';
import 'package:example/service_locator.dart';
import 'package:example/users_screen.dart';
import 'theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

String apiKey = 'ApiKy';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  const user = ChatUser(id: '7489016865', firstName: 'Flutter');

  ChatBookController.getInstance(user,
      chatBookExtension: ChatBookExtension(
          widgetsExtension: WidgetsExtension(messageTypes: []),
          serviceExtension: ServiceExtension<SqfliteDataBaseService>(
              dataManager: SqfliteDataBaseService(currentUser: user))));
  runApp(const Example());
}

class Example extends StatelessWidget {
  const Example({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: const Key('Main App'),
      title: 'Example',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const ChatScreen(),
        '/create_user_screen': (context) => const UserFormScreen(),
        '/user_screen': (context) => const UserListScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    Future.delayed(const Duration(seconds: 2), () async {
      _chatRooms.value = await _chatroomService?.fetchRooms() ?? [];
    });
  }

  Future<void> _onRefresh() async {
    _chatRooms.value = await _chatroomService?.fetchRooms() ?? [];
  }

  SqfLiteChatRoomDataBaseService? get _chatroomService => serviceLocator
      .get<ChatBookController>()
      .chatBookExtension
      ?.serviceExtension
      ?.dataManager
      ?.roomManager as SqfLiteChatRoomDataBaseService;

  final ValueNotifier<List<ChatDataBaseService>> _chatRooms = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('John Doe'),
              accountEmail: Text('johndoe@example.com'),
              currentAccountPicture: CircleAvatar(
                child: Text('JD'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.supervised_user_circle),
              title: const Text('Create User'),
              onTap: () {
                Navigator.pushNamed(context, '/create_user_screen');
                // Perform action when user taps on the Settings item
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_add_outlined),
              title: const Text('Create Room'),
              onTap: () {
                Navigator.pushNamed(context, '/user_screen');
                // Perform action when user taps on the Settings item
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('My App'),
        actions: [
          IconButton(
            onPressed: () {
              // Perform action when user taps on the user icon
            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () {
              _chatroomService?.deleteMessages();
              // Perform action when user taps on the menu icon
            },
            icon: const Icon(Icons.menu),
          ),
          IconButton(
            onPressed: () {
              _chatroomService?.createMessages();

              // Perform action when user taps on the search icon
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: ValueListenableBuilder<List<ChatDataBaseService>>(
        valueListenable: _chatRooms,
        builder: (context, value, child) {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              itemCount: value.length,
              itemBuilder: (BuildContext context, int index) {
                final chatUser = value[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(chatUser.room.name ?? chatUser.room.id),
                  ),
                  title: Text(chatUser.room.name ?? chatUser.room.id),
                  subtitle: StreamBuilder<Message>(
                    stream: chatUser.lastMessageStream.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.type == MessageType.text) {
                          return Text((snapshot.data as TextMessage).text);
                        }
                        return const SizedBox();
                      }
                      return const SizedBox();
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatScreen(
                            // chatService: chatUser,
                            ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    // required this.chatService,
  }) : super(key: key);

  // final ChatDataBaseService chatService;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  AppTheme theme = LightTheme();
  bool isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  final chatUsers = [const ChatUser(id: '7489016865', firstName: 'Flutter')];

  void init() async {
    _chatController = ChatController(
      // chatBookController: _chatBookController,
      initialMessageList: [],
      // chatService: widget.chatService,
      scrollController: AutoScrollController(),
      chatUsers: chatUsers,
    );

    // _chatController.loadMoreData(widget.chatService.messages);
    // final result = await _userProfileService?.fetchUsers();
    // if (result != null) {
    //   chatUsers.addAll(result);
    // }
  }

  // ChatBookController get _chatBookController =>
  //     serviceLocator.get<ChatBookController>();

  // SqfliteUserProfileService? get _userProfileService => serviceLocator
  //     .get<ChatBookController>()
  //     .chatBookExtension
  //     ?.serviceExtension
  //     ?.dataManager
  //     ?.profileManager as SqfliteUserProfileService;

  late final ChatController _chatController;

  void _showHideTypingIndicator() {
    _chatController.showHideTyping('id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatBook(
        isCupertinoApp: false,
        currentUser: chatUsers[0],
        chatController: _chatController,
        onSendTap: _onSendTap,
        featureActiveConfig: const FeatureActiveConfig(
            lastSeenAgoBuilderVisibility: true,
            enablePagination: true,
            enableSwipeToSeeTime: false,
            enableSwipeToReply: true,
            selectMultipleMessages: true,
            enableReplySnackBar: false,
            receiptsBuilderVisibility: true),
        chatBookState: ChatBookState.hasMessages,
        chatBookStateConfig: ChatBookStateConfiguration(
          loadingWidgetConfig: ChatBookStateWidgetConfiguration(
            loadingIndicatorColor: theme.outgoingChatBubbleColor,
          ),
          onReloadButtonTap: () {},
        ),
        typeIndicatorConfig: TypeIndicatorConfiguration(
          flashingCircleBrightColor: theme.flashingCircleBrightColor,
          flashingCircleDarkColor: theme.flashingCircleDarkColor,
        ),
        appBar: ChatBookAppBar(
          messageActionsBuilder: (message) {
            return [
              IconButton(
                tooltip: 'Delete a Message',
                onPressed: () {
                  _chatController.hideReactionPopUp(messageActions: true);
                  _chatController.deleteMessage(message);
                },
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: theme.themeIconColor,
                ),
              ),
              PopupMenuButton(itemBuilder: (context) {
                _chatController.hideReactionPopUp();
                _chatController.unFocus();
                return const [
                  PopupMenuItem(child: Text('Share')),
                  PopupMenuItem(child: Text('Report'))
                ];
              })
            ];
          },
          elevation: theme.elevation,
          backGroundColor: theme.appBarColor,
          backArrowColor: theme.backArrowColor,
          chatTitle: "ram",
          //  widget.chatService.room.name ?? "",
          chatTitleTextStyle: TextStyle(
            color: theme.appBarTitleTextStyle,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 0.25,
          ),
          userStatus: "online",
          userStatusTextStyle: const TextStyle(color: Colors.grey),
          actions: [
            IconButton(
              onPressed: _onThemeIconTap,
              icon: Icon(
                isDarkTheme
                    ? Icons.brightness_4_outlined
                    : Icons.dark_mode_outlined,
                color: theme.themeIconColor,
              ),
            ),
            IconButton(
              tooltip: 'Toggle TypingIndicator',
              onPressed: _showHideTypingIndicator,
              icon: Icon(
                Icons.keyboard,
                color: theme.themeIconColor,
              ),
            ),
          ],
        ),
        chatBackgroundConfig: ChatBackgroundConfiguration(
          messageTimeIconColor: theme.messageTimeIconColor,
          messageTimeTextStyle: TextStyle(color: theme.messageTimeTextColor),
          defaultGroupSeparatorConfig: DefaultGroupSeparatorConfiguration(
            textStyle: TextStyle(
              color: theme.chatHeaderColor,
              fontSize: 17,
            ),
          ),
          backgroundColor: theme.backgroundColor,
        ),
        sendMessageConfig: SendMessageConfiguration(
          allowRecordingVoice: false,
          imagePickerIconsConfig: ImagePickerIconsConfiguration(
            cameraIconColor: theme.cameraIconColor,
            galleryIconColor: theme.galleryIconColor,
          ),
          replyMessageColor: theme.replyMessageColor,
          defaultSendButtonColor: theme.sendButtonColor,
          replyDialogColor: theme.replyDialogColor,
          replyTitleColor: theme.replyTitleColor,
          textFieldBackgroundColor: theme.textFieldBackgroundColor,
          closeIconColor: theme.closeIconColor,
          textFieldConfig: TextFieldConfiguration(
            onMessageTyping: (status) {
              /// Do with status
              // debugPrint(status.toString());
            },
            compositionThresholdTime: const Duration(seconds: 1),
            textStyle: TextStyle(color: theme.textFieldTextColor),
          ),
          micIconColor: theme.replyMicIconColor,
          voiceRecordingConfiguration: VoiceRecordingConfiguration(
            backgroundColor: theme.waveformBackgroundColor,
            recorderIconColor: theme.recordIconColor,
            waveStyle: WaveStyle(
              showMiddleLine: false,
              waveColor: theme.waveColor ?? Colors.white,
              extendWaveform: true,
            ),
          ),
        ),
        chatBubbleConfig: ChatBubbleConfiguration(
          outgoingChatBubbleConfig: ChatBubble(
            linkPreviewConfig: LinkPreviewConfiguration(
              backgroundColor: theme.linkPreviewOutgoingChatColor,
              bodyStyle: theme.outgoingChatLinkBodyStyle,
              titleStyle: theme.outgoingChatLinkTitleStyle,
            ),
            receiptsWidgetConfig: const ReceiptsWidgetConfig(
                showReceiptsIn: ShowReceiptsIn.allInside),
            color: theme.outgoingChatBubbleColor,
          ),
          inComingChatBubbleConfig: ChatBubble(
            linkPreviewConfig: LinkPreviewConfiguration(
              linkStyle: TextStyle(
                color: theme.inComingChatBubbleTextColor,
                decoration: TextDecoration.underline,
              ),
              backgroundColor: theme.linkPreviewIncomingChatColor,
              bodyStyle: theme.incomingChatLinkBodyStyle,
              titleStyle: theme.incomingChatLinkTitleStyle,
            ),
            textStyle: TextStyle(color: theme.inComingChatBubbleTextColor),
            onMessageRead: (message) {
              /// send your message reciepts to the other client
              // debugPrint('Message Read');
            },
            senderNameTextStyle:
                TextStyle(color: theme.inComingChatBubbleTextColor),
            color: theme.inComingChatBubbleColor,
          ),
        ),
        replyPopupConfig: ReplyPopupConfiguration(
          backgroundColor: theme.replyPopupColor,
          buttonTextStyle: TextStyle(color: theme.replyPopupButtonColor),
          topBorderColor: theme.replyPopupTopBorderColor,
        ),
        reactionPopupConfig: ReactionPopupConfiguration(
          shadow: BoxShadow(
            color: isDarkTheme ? Colors.black54 : Colors.grey.shade400,
            blurRadius: 20,
          ),
          backgroundColor: theme.reactionPopupColor,
        ),
        messageConfig: MessageConfiguration(
          messageReactionConfig: MessageReactionConfiguration(
            backgroundColor: theme.messageReactionBackGroundColor,
            borderColor: theme.messageReactionBackGroundColor,
            reactedUserCountTextStyle:
                TextStyle(color: theme.inComingChatBubbleTextColor),
            reactionCountTextStyle:
                TextStyle(color: theme.inComingChatBubbleTextColor),
            reactionsBottomSheetConfig: ReactionsBottomSheetConfiguration(
              backgroundColor: theme.backgroundColor,
              reactedUserTextStyle: TextStyle(
                color: theme.inComingChatBubbleTextColor,
              ),
              reactionWidgetDecoration: BoxDecoration(
                color: theme.inComingChatBubbleColor,
                boxShadow: [
                  BoxShadow(
                    color: isDarkTheme ? Colors.black12 : Colors.grey.shade200,
                    offset: const Offset(0, 20),
                    blurRadius: 40,
                  )
                ],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          imageMessageConfig: ImageMessageConfiguration(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            shareIconConfig: ShareIconConfiguration(
              defaultIconBackgroundColor: theme.shareIconBackgroundColor,
              defaultIconColor: theme.shareIconColor,
            ),
          ),
        ),
        profileCircleConfig: const ProfileCircleConfiguration(),
        repliedMessageConfig: RepliedMessageConfiguration(
          backgroundColor: theme.repliedMessageColor,
          verticalBarColor: theme.verticalBarColor,
          repliedMsgAutoScrollConfig: RepliedMsgAutoScrollConfig(
            enableHighlightRepliedMsg: true,
            highlightColor: Colors.pinkAccent.shade100,
            highlightScale: 1.1,
          ),
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.25,
          ),
          replyTitleTextStyle: TextStyle(color: theme.repliedTitleTextColor),
        ),
        swipeToReplyConfig: SwipeToReplyConfiguration(
          replyIconColor: theme.swipeToReplyIconColor,
        ),
      ),
    );
  }

  void _onSendTap(Message message) async {
    final msg = message.copyWith(
      author: chatUsers[Random().nextInt(chatUsers.length)],
    );

    _chatController.addMessage(msg);

    // final amsg = CustomMessage.fromJson(msg.toJson());
    // print(amsg.runtimeType);
    Future.delayed(const Duration(milliseconds: 300), () async {
      final newMessage = _chatController.initialMessageList.first.value
          .copyWith(status: DeliveryStatus.read);
      _chatController.initialMessageList.first.value = newMessage;
      // await widget.chatService.updateMessage(newMessage);
    });
  }

  void _onThemeIconTap() {
    setState(() {
      if (isDarkTheme) {
        theme = LightTheme();
        isDarkTheme = false;
      } else {
        theme = DarkTheme();
        isDarkTheme = true;
      }
    });
  }
}
