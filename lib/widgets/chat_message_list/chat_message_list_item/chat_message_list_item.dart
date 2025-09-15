import 'dart:math';

import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:flutter/widgets.dart';



class ChatMessageListItem extends StatelessWidget {
  const ChatMessageListItem({
    super.key,
    required this.model,
    this.onTap,
    this.onBubbleLongPress,
    this.onBubbleDoubleTap,
    this.onResendTap,
    this.avatarBuilder,
    this.nicknameBuilder,
    this.bubbleColor,
    this.bubblePadding,
    this.unreadFlagBuilder,
  });

  final ChatMessageListItemModel model;
  final ChatMessageTapAction? onTap;
  final ChatMessageTapAction? onBubbleLongPress;
  final ChatMessageTapAction? onBubbleDoubleTap;
  final VoidCallback? onResendTap;
  final ChatWidgetBuilder? avatarBuilder;
  final ChatWidgetBuilder? nicknameBuilder;
  final Color? bubbleColor;
  final EdgeInsets? bubblePadding;
  final WidgetBuilder? unreadFlagBuilder;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  Widget getBubbleWidget(Widget content) {
    Widget ret = ChatMessageBubble(
      model: model,
      padding: bubblePadding,
      bubbleColor: bubbleColor,
      childBuilder: (context) => content,
      unreadFlagBuilder: unreadFlagBuilder,
      onBubbleDoubleTap: onBubbleDoubleTap,
      onBubbleLongPress: onBubbleLongPress,
      onTap: onTap,
      avatarBuilder: avatarBuilder,
      nicknameBuilder: nicknameBuilder,
      onResendTap: onResendTap,
    );

    return ret;
  }

  /// get max bubble max width.
  double getMaxWidth(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;
    double max = min(screenW, screenH) * 0.7;
    return max;
  }
}
