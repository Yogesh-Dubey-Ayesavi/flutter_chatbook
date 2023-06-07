![Banner](https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_chat_ui/main/preview/banner.png)

# ChatBook
 <!-- [![flutter_chatbook](https://img.shields.io/pub/v/chatview?label=chatview)](https://pub.dev/packages/chatview) -->

A Flutter package that allows you to integrate Chat View with highly customization options such as one on one
chat, group chat, message reactions, reply messages, link preview and configurations for overall view.

For web demo
visit [Chat View Example](https://chat-view-8f1b5.web.app/#/).

## Preview

![The example app running in iOS](https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_chat_ui/main/preview/chatview.gif)

## Installing   

1.  Add dependency to `pubspec.yaml`

```dart
dependencies:
  flutter_chatbook: <latest-version>
```
*Get the latest version in the 'Installing' tab on [pub.dev](https://pub.dev/packages/flutter_chatbook)*

2.  Import the package
```dart
import 'package:flutter_chatbook/flutter_chatbook.dart';
```
3. Adding a chat controller.
```dart
final chatController = ChatController(
  initialMessageList: messageList,
  scrollController: ScrollController(),
  chatUsers: [ChatUser(id: '2', name: 'Simform')],
);
```

4. Adding a `ChatBook` widget.
```dart
ChatBook(
  currentUser: ChatUser(id: '1', name: 'Flutter'),
  chatController: chatController,
  onSendTap: onSendTap,
  chatBookState: ChatBookState.hasMessages, // Add this state once data is available.
)
```

5. Adding a messageList with `Message` class.
```dart
List<Message> messageList = [
  Message(
    id: '1',
    message: "Hi",
    createdAt: createdAt,
    sendBy: userId,
  ),
  Message(
    id: '2',
    message: "Hello",
    createdAt: createdAt,
    sendBy: userId,
  ),
];
```

6. Adding a `onSendTap`.
```dart
void onSendTap(String message, ReplyMessage replyMessage, Message messageType){
  final message = Message(
    id: '3',
    message: "How are you",
    createdAt: DateTime.now(),
    sendBy: currentUser.id,
    replyMessage: replyMessage,
    messageType: messageType,
  );
  chatController.addMessage(message);
}
```

Note: you can evaluate message type from `messageType` parameter, based on that you can perform operations.

## Messages types compability

|Message Types   | Android | iOS | MacOS | Web | Linux | Windows |
| :-----:        | :-----: | :-: | :---: | :-: | :---: | :-----: |
|Text messages   |   ✔️    | ✔️  |  ✔️   | ✔️  |  ✔️   |   ✔️    |
|Image messages  |   ✔️    | ✔️  |  ✔️   | ✔️  |  ✔️   |   ✔️    |
|Voice messages  |   ✔️    | ✔️  |  ❌   | ❌  |  ❌  |   ❌  |
|Custom messages |   ✔️    | ✔️  |  ✔️   | ✔️  |  ✔️   |   ✔️    |


## Platform specific configuration

### For image Picker
#### iOS
* Add the following keys to your _Info.plist_ file, located in `<project root>/ios/Runner/Info.plist`:

```
    <key>NSCameraUsageDescription</key>
    <string>Used to demonstrate image picker plugin</string>
    <key>NSMicrophoneUsageDescription</key>
    <string>Used to capture audio for image picker plugin</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Used to demonstrate image picker plugin</string>
```

### For voice messages
#### iOS
* Add this two rows in `ios/Runner/Info.plist`
```
    <key>NSMicrophoneUsageDescription</key>
    <string>This app requires Mic permission.</string>
```
* This plugin requires ios 10.0 or higher. So add this line in `Podfile`
```
    platform :ios, '10.0'
```

#### Android
* Change the minimum Android sdk version to 21 (or higher) in your android/app/build.gradle file.
```
    minSdkVersion 21
```

* Add RECORD_AUDIO permission in `AndroidManifest.xml`
```
    <uses-permission android:name="android.permission.RECORD_AUDIO"/>
```


## Some more optional parameters

1. Enable and disable specific features with `FeatureActiveConfig`.
```dart
ChatBook(
  ...
  featureActiveConfig: FeatureActiveConfig(
    enableSwipeToReply: true,
    enableSwipeToSeeTime: false,
  ),
  ...
)
```

2. Adding an appbar with `ChatBookAppBar`.
```dart
ChatBook(
  ...
  appBar: ChatBookAppBar(
    profilePicture: profileImage,
    chatTitle: "Simform",
    userStatus: "online",
    actions: [
      Icon(Icons.more_vert),
    ],
  ),
  ...
)
```

3. Adding a message list configuration with `ChatBackgroundConfiguration` class.
```dart
ChatBook(
  ...
  chatBackgroundConfig: ChatBackgroundConfiguration(
    backgroundColor: Colors.white,
    backgroundImage: backgroundImage,
  ),
  ...
)
```

4. Adding a send message configuration with `SendMessageConfiguration` class.
```dart
ChatBook(
  ...
  sendMessageConfig: SendMessageConfiguration(
    replyMessageColor: Colors.grey,
    replyDialogColor:Colors.blue,
    replyTitleColor: Colors.black,
    closeIconColor: Colors.black,
  ),
  ...
)
```

5. Adding a chat bubble configuration with `ChatBubbleConfiguration` class.
```dart
ChatBook(
  ...
  chatBubbleConfig: ChatBubbleConfiguration(
    onDoubleTap: (){
       // Your code goes here
    },
    outgoingChatBubbleConfig: ChatBubble(      // Sender's message chat bubble 
      color: Colors.blue,
      borderRadius: const BorderRadius.only(  
        topRight: Radius.circular(12),
        topLeft: Radius.circular(12),
        bottomLeft: Radius.circular(12),
      ),
    ),
    inComingChatBubbleConfig: ChatBubble(      // Receiver's message chat bubble
      color: Colors.grey.shade200,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
        bottomRight: Radius.circular(12),
      ),
    ),
  )
  ...
)
```

6. Adding swipe to reply configuration with `SwipeToReplyConfiguration` class.
```dart
ChatBook(
  ...
  swipeToReplyConfig: SwipeToReplyConfiguration(
    onLeftSwipe: (message, sendBy){
        // Your code goes here
    },
    onRightSwipe: (message, sendBy){
        // Your code goes here
    },              
  ),
  ...
)
```

7. Adding messages configuration with `MessageConfiguration` class.
```dart
ChatBook(
  ...
  messageConfig: MessageConfiguration(
    messageReactionConfig: MessageReactionConfiguration(),      // Emoji reaction configuration for single message 
    imageMessageConfig: ImageMessageConfiguration(
      onTap: (){
          // Your code goes here
      },                          
      shareIconConfig: ShareIconConfiguration(
        onPressed: (){
           // Your code goes here
        },
      ),
    ),
  ),
  ...
)
```

8. Adding reaction pop-up configuration with `ReactionPopupConfiguration` class.
```dart
ChatBook(
  ...
  reactionPopupConfig: ReactionPopupConfiguration(
    backgroundColor: Colors.white,
    userReactionCallback: (message, emoji){
      // Your code goes here
    }
    padding: EdgeInsets.all(12),
    shadow: BoxShadow(
      color: Colors.black54,
      blurRadius: 20,
    ),
  ),
  ...
)
```

9. Adding reply pop-up configuration with `ReplyPopupConfiguration` class.
```dart
ChatBook(
  ...
  replyPopupConfig: ReplyPopupConfiguration(
    backgroundColor: Colors.white,
    onUnsendTap:(message){                   // message is 'Message' class instance
       // Your code goes here
    },
    onReplyTap:(message){                    // message is 'Message' class instance
       // Your code goes here
    },
    onReportTap:(){
       // Your code goes here
    },
    onMoreTap:(){
       // Your code goes here
    },
  ),
  ...
)
```

10. Adding replied message configuration with `RepliedMessageConfiguration` class.
```dart
ChatBook(
   ...
   repliedMessageConfig: RepliedMessageConfiguration(
     backgroundColor: Colors.blue,
     verticalBarColor: Colors.black,
     repliedMsgAutoScrollConfig: RepliedMsgAutoScrollConfig(),
   ),
   ...
)
```

11. For customizing typing indicators use `typeIndicatorConfig` with `TypeIndicatorConfig`.
```dart
ChatBook(
  ...

  typeIndicatorConfig: TypeIndicatorConfiguration(
    flashingCircleBrightColor: Colors.grey,
    flashingCircleDarkColor: Colors.black,
  ),
  ...
)
```
12. For showing hiding typeIndicatorwidget use `ChatController.setTypingIndicaor`, for more info see `ChatController`.
```dart
/// use it with your [ChatController] instance.
_chatContoller.setTypingIndicator = true; // for showing indicator
_chatContoller.setTypingIndicator = false; // for hiding indicator
```




13. Adding linkpreview configuration with `LinkPreviewConfiguration` class.
```dart
ChatBook(
  ...
  chatBubbleConfig: ChatBubbleConfiguration(
    linkPreviewConfig: LinkPreviewConfiguration(
      linkStyle: const TextStyle(
        color: Colors.white,
        decoration: TextDecoration.underline,
      ),
      backgroundColor: Colors.grey,
      bodyStyle: const TextStyle(
        color: Colors.grey.shade200,
        fontSize:16,
      ),
      titleStyle: const TextStyle(
        color: Colors.black,
        fontSize:20,
      ),
    ),
  )
  ...
)
```



13. Adding pagination.
```dart
ChatBook(
  ...
  isLastPage: false,
  featureActiveConfig: FeatureActiveConfig(
    enablePagination: true,
  ),
  loadMoreData: chatController.loadMoreData,
  ...
)
```

14. Add image picker icon configuration.
```dart
ChatBook(
  ...
  sendMessageConfig: SendMessageConfiguration(
    imagePickerIconsConfig: ImagePickerIconsConfiguration(
      cameraIconColor: Colors.black,
      galleryIconColor: Colors.black,
    )
  )
  ...
)
```

15. Add `ChatBookState` customisations.
```dart
ChatBook(
  ...
  chatBookStateConfig: ChatBookStateConfiguration(
    loadingWidgetConfig: ChatBookStateWidgetConfiguration(
      loadingIndicatorColor: Colors.pink,
    ),
    onReloadButtonTap: () {},
  ),
  ...
)
```

16. Setting auto scroll and highlight config with `RepliedMsgAutoScrollConfig` class.
```dart
ChatBook(
    ...
    repliedMsgAutoScrollConfig: RepliedMsgAutoScrollConfig(
      enableHighlightRepliedMsg: true,
      highlightColor: Colors.grey,
      highlightScale: 1.1,
    )
    ...
)
```

17.  Callback when a user starts/stops typing in `TextFieldConfiguration`
    
```dart
ChatBook(
    ...
      sendMessageConfig: SendMessageConfiguration(
       
          textFieldConfig: TextFieldConfiguration(
            onMessageTyping: (status) {
                // send composing/composed status to other client
                // your code goes here
            },   

            
        /// After typing stopped, the threshold time after which the composing
        /// status to be changed to [TypeWriterStatus.typed].
        /// Default is 1 second.
            compositionThresholdTime: const Duration(seconds: 1),

        ),
    ...
  )
)
```

18.  Passing customReceipts builder or handling stuffs related receipts see `ReceiptsWidgetConfig` in  outgoingChatBubbleConfig.
    
```dart
ChatBook(
   ...
      featureActiveConfig: const FeatureActiveConfig(
            /// Controls the visibility of message seen ago receipts default is true
            lastSeenAgoBuilderVisibility: false,
            /// Controls the visibility of the message [receiptsBuilder]
            receiptsBuilderVisibility: false),            
       ChatBubbleConfiguration(
          inComingChatBubbleConfig: ChatBubble(
            onMessageRead: (message) {
              /// send your message reciepts to the other client
              // debugPrint('Message Read');
            },

          ),
          outgoingChatBubbleConfig: ChatBubble(
              receiptsWidgetConfig: ReceiptsWidgetConfig(
                      /// custom receipts builder 
                      receiptsBuilder: _customReceiptsBuilder,
                      /// whether to display receipts in all 
                      /// message or just at the last one just like instagram
                      showReceiptsIn: ShowReceiptsIn.lastMessage
              ),
            ), 
        ), 
        
  ...
 
)
```

Here's a tabular comparison highlighting the key differences between `ChatBookController` and `ChatController`:

|                       | ChatBookController                          | ChatController                               |
|-----------------------|---------------------------------------------|----------------------------------------------|
| Purpose               | Application-specific chat controller         | Room-specific chat controller                |
| Initialization       | Initialized once during the application lifecycle | Initialized for each chat room individually |
| Necessity of Initialization | Not necessary to be initialized            | Necessary to be initialized                 |
| Functionality         | Manages chat functionality of the entire application | Manages chat functionality of a specific chat room |
| Services              | Adds custom databases, backend integration, and notification handling | Adds new messages to the UI, performs operations specific to the room |
| Flexibility           | Allows adding new categories of messages and extending functionality | Focused on managing UI and performing room-specific operations |
| Scope                 | Global scope within the entire application   | Limited to the specific chat room            |



This package has been inspired from [chatview](https://pub.dev/packages/chatviewhttps://pub.dev/packages/chatview), Thanks to [Simform Solutions](https://pub.dev/publishers/simform.com/packages) for this.