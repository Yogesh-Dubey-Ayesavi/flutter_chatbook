import 'package:giphy_get/giphy_get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatbook/flutter_chatbook.dart';
import 'package:giphy_message/models/giphy_message.dart';
import 'package:uuid/uuid.dart';

class GiphyMessageSupport implements NewMessageSupport<GiphyMessage> {
  GiphyMessageSupport(this.apiKey);

  final String apiKey;

  late GiphyGetWrapper giphyWrapper;

  late GiphyClient client = GiphyClient(apiKey: apiKey, randomId: '');

  // Random ID
  String randomId = "";

  final ValueNotifier<GiphyGif?> currentGif = ValueNotifier(null);

  _setGif(GiphyGif gif) => currentGif.value = gif;

  @override
  get customToolBarWidget => (context) {
        return GiphyGetWrapper(
          giphy_api_key: apiKey,
          builder: (stream, wrapper) {
            stream.listen((gif) {
              _setGif(gif);
            });
            giphyWrapper = wrapper;
            return const Icon(Icons.gif_box_outlined);
          },
        );
      };

  @override
  get icon {
    client.getRandomId().then((value) {
      randomId = value;
    });
    return GiphyGetWrapper(
      giphy_api_key: apiKey,
      builder: (stream, wrapper) {
        stream.listen((gif) {
          _setGif(gif);
        });
        giphyWrapper = wrapper;
        return const Icon(Icons.gif_box_outlined);
      },
    );
  }

  @override
  bool get isInsideBubble => false;

  @override
  bool get isReactable => false;

  @override
  bool get isSwipeable => false;

  @override
  get messageBuilder => (context, message) {
        message as GiphyMessage;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: IgnorePointer(
              ignoring: true,
              child: GiphyGifWidget(
                  gif: message.giphy, giphyGetWrapper: giphyWrapper),
            ),
          ),
        );
      };

  @override
  get onSendPress => (message) {};

  @override
  get messageClass => GiphyMessage;

  @override
  String get customType => 'giphy';

  @override
  ToolBarPriority get priority => ToolBarPriority.high;

  @override
  get replyPreview => (context, message) {
        return const Text("Giphy");
      };

  @override
  String get title => "giphy";

  @override
  get onMessageCreation => (context, author) async {
        final gif = await GiphyGet.getGif(
          context: context, //Required
          apiKey: apiKey, //Required.
          lang: GiphyLanguage.english, //Optional - Language for query.
          randomID: "abcd", // Optional - An ID/proxy for a specific user.
          tabColor: Colors.teal, // Optional- default accent color.
          debounceTimeInMilliseconds:
              350, // Optional- time to pause between search keystrokes
        );

        if (gif != null) {
          final msg = GiphyMessage(
              author: author,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              id: const Uuid().v4(),
              giphy: gif);

          if (context.mounted) {
            showPreview(
                context,
                PreviewBuilder<Message>(msg, showTextInput: false,
                    onSendTap: (txt) {
                  return msg;
                }, child: Center(child: messageBuilder(context, msg))));
          }
        }
        return null;
      };

  @override
  get repliedMessageBuilder => (context, message) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: const [Icon(Icons.gif_box_outlined), Text("Giphy")],
        );
      };
}
