import 'package:flutter/material.dart';

import '../../../agora_chat_uikit.dart';

class ChatMessageListTextItem extends ChatMessageListItem {
  final TextStyle? contentStyle;

  const ChatMessageListTextItem({
    super.key,
    required super.model,
    this.contentStyle,
    super.onTap,
    super.onBubbleLongPress,
    super.onBubbleDoubleTap,
    super.onResendTap,
    super.avatarBuilder,
    super.nicknameBuilder,
    super.bubbleColor,
    super.bubblePadding,
    super.unreadFlagBuilder,
  });

  @override
  Widget build(BuildContext context) {
    ChatMessage message = model.message;
    bool isLeft = message.direction == MessageDirection.RECEIVE;
    ChatTextMessageBody body = message.body as ChatTextMessageBody;

    String contentText = decodeUnicode(body.content);

    Widget content = Text(
      contentText,
      style: contentStyle ??
          (isLeft
              ? ChatUIKit.of(context)?.theme.receiveTextStyle ??
                  const TextStyle(color: Colors.black)
              : ChatUIKit.of(context)?.theme.sendTextStyle) ??
          const TextStyle(color: Colors.white),
    );

    return getBubbleWidget(content);
  }

  String decodeUnicode(String content) {
    return content.replaceAllMapped(
      RegExp(r'U\+([0-9A-Fa-f]{4,6})'),
      (match) => String.fromCharCode(int.parse(match.group(1)!, radix: 16)),
    );
  }
}
