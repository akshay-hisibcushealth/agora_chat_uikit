import 'package:flutter/material.dart';

import '../../../agora_chat_uikit.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.model,
    required this.childBuilder,
    this.unreadFlagBuilder,
    this.onTap,
    this.onBubbleLongPress,
    this.onBubbleDoubleTap,
    this.avatarBuilder,
    this.nicknameBuilder,
    this.onResendTap,
    this.bubbleColor,
    this.padding,
    this.maxWidth,
  });

  final double? maxWidth;
  final ChatMessageListItemModel model;
  final ChatMessageTapAction? onTap;
  final ChatMessageTapAction? onBubbleLongPress;
  final ChatMessageTapAction? onBubbleDoubleTap;
  final ChatWidgetBuilder? avatarBuilder;
  final ChatWidgetBuilder? nicknameBuilder;

  final VoidCallback? onResendTap;
  final WidgetBuilder childBuilder;
  final WidgetBuilder? unreadFlagBuilder;
  final Color? bubbleColor;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    double max = maxWidth ?? MediaQuery.of(context).size.width * 0.7;
    final boxConstraints = BoxConstraints(maxWidth: max);
    ChatMessage message = model.message;
    bool isLeft = message.direction == MessageDirection.RECEIVE;
    Widget content = Container(
      decoration: BoxDecoration(
        color: bubbleColor ??
            (isLeft
                ? ChatUIKit.of(context)?.theme.receiveBubbleColor ??
                    const Color.fromRGBO(242, 244, 245, 1)
                : ChatUIKit.of(context)?.theme.sendBubbleColor ??
                    const Color.fromRGBO(71, 121, 217, 1)),
        borderRadius: BorderRadius.circular(isLeft ? 16 : 20),
      ),
      constraints: boxConstraints,
      child: Padding(
        padding: padding ?? const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: childBuilder(context),
      ),
    );

    List<Widget> insideBubbleWidgets = [];

    if (nicknameBuilder != null && isLeft) {
      insideBubbleWidgets.add(
        Container(
          constraints: boxConstraints,
          child: nicknameBuilder!.call(context, message.from!),
        ),
      );

      insideBubbleWidgets.add(Flexible(flex: 1, child: content));

      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: insideBubbleWidgets.toList(),
      );
      insideBubbleWidgets.clear();
    }

    if (avatarBuilder != null) {
      insideBubbleWidgets.add(avatarBuilder!.call(context, message.from!));
      insideBubbleWidgets.add(const SizedBox(width: 10));
    }

    insideBubbleWidgets.add(Flexible(flex: 1, child: content));
    insideBubbleWidgets.add(SizedBox(width: isLeft ? 0 : 10.4));

    if (!isLeft) {
      insideBubbleWidgets
          .add(ChatMessageStatusWidget(message, onTap: onResendTap));
    }
    content = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      textDirection: isLeft ? TextDirection.ltr : TextDirection.rtl,
      mainAxisSize: MainAxisSize.min,
      children: insideBubbleWidgets.toList(),
    );

    insideBubbleWidgets.clear();

    if (unreadFlagBuilder != null && isLeft) {
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          content,
          const SizedBox(
            width: 10,
          ),
          unreadFlagBuilder!.call(context)
        ],
      );
    }

    content = Padding(
      padding: EdgeInsets.fromLTRB(15, 4, isLeft ? 7.5 : 15, 15),
      child: content,
    );

    content = InkWell(
      onDoubleTap: () => onBubbleDoubleTap?.call(context, message),
      onTap: () => onTap?.call(context, message),
      onLongPress: () => onBubbleLongPress?.call(context, message),
      child: content,
    );
    content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // if (model.needTime) dayDivider(context, message.serverTime),
        content,
        Align(
          alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
          child: Transform.translate(
            offset: const Offset(0, -12),
            child: Padding(
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  model.message.body.type == MessageType.IMAGE
                      ? isLeft
                          ? TimeTool.timeStrByMs(message.serverTime).padLeft(12)
                          : TimeTool.timeStrByMs(message.serverTime).padRight(12)
                      : TimeTool.timeStrByMs(message.serverTime),
                  style: ChatUIKit.of(context)?.theme.messageTimeTextStyle ??
                      const TextStyle(color: Colors.grey, fontSize: 14),
                )),
          ),
        )
      ],
    );
    return content;
  }

  Widget dayDivider(BuildContext context, int? time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Divider(color: Color(0xffD9D9D9), thickness: 1, indent: 32),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              TimeTool.timeDate(time),
              style: ChatUIKit.of(context)?.theme.dayDividerTextStyle ??
                  const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          const Expanded(
            child:
                Divider(color: Color(0xffD9D9D9), thickness: 1, endIndent: 32),
          ),
        ],
      ),
    );
  }
}
