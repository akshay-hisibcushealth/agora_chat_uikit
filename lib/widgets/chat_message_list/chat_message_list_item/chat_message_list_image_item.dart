import 'dart:io';

import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:agora_chat_uikit/tools/icon_image_provider.dart';
import 'package:flutter/material.dart';

class ChatMessageListImageItem extends ChatMessageListItem {
  const ChatMessageListImageItem(
      {super.key,
      required super.model,
      super.onTap,
      super.onBubbleLongPress,
      super.onBubbleDoubleTap,
      super.onResendTap,
      super.avatarBuilder,
      super.nicknameBuilder,
      super.bubbleColor,
      super.bubblePadding,
      super.unreadFlagBuilder});

  @override
  Widget build(BuildContext context) {
    ChatMessage message = model.message;
    ChatImageMessageBody body = message.body as ChatImageMessageBody;

    double width = MediaQuery.of(context).size.width * 0.6;
    double height = MediaQuery.of(context).size.height * 0.35;

    Widget content;

    do {
      File file = File(body.localPath);
      if (file.existsSync()) {
        content = Image(
          gaplessPlayback: true,
          image: ResizeImage(
            FileImage(file),
            width: width.toInt(),
            height: height.toInt(),
          ),
          fit: BoxFit.fill,
        );
        break;
      }
      if (body.thumbnailLocalPath != null) {
        File thumbnailFile = File(body.thumbnailLocalPath!);
        if (thumbnailFile.existsSync()) {
          content = Image(
            gaplessPlayback: true,
            image: ResizeImage(
              FileImage(thumbnailFile),
              width: width.toInt(),
              height: height.toInt(),
            ),
            fit: BoxFit.fill,
          );
          break;
        }
      }
      if (body.thumbnailRemotePath != null) {
        content = Container(
          color: const Color.fromRGBO(242, 242, 242, 1),
          child: FadeInImage(
            placeholderFit: BoxFit.contain,
            placeholder: IconImageProvider(Icons.image),
            image: NetworkImage(body.thumbnailRemotePath!),
            imageErrorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.broken_image, size: 48);
            },
            fit: BoxFit.fill,
          ),
        );
        break;
      }
      content = const Icon(Icons.broken_image, size: 58, color: Colors.white);
    } while (false);

    content = SizedBox(
      width: width,
      height: height,
      child: ClipRRect(borderRadius: BorderRadius.circular(10), child: content),
    );

    return getBubbleWidget(
      Align(
          alignment: message.direction == MessageDirection.SEND
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: content),
    );
  }
}
