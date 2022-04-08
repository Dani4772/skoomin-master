import 'package:flutter/material.dart';

class ChatBubbleWidget extends StatelessWidget {
  const ChatBubbleWidget({
    Key? key,
    required this.message,
    required this.time,
    required this.isMe,
  }) : super(key: key);

  final String message, time;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMe ? const Color(0xFF77A200) : Colors.grey.shade200;
    final msgTxtColor = isMe ? Colors.white : Colors.black;
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = isMe
        ? const BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(10.0))
        : const BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(5.0));
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: .5,
                spreadRadius: 1.0,
                color: Colors.black.withOpacity(.12),
              )
            ],
            color: bubbleColor,
            borderRadius: radius,
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 48.0),
                child: Text(
                  message,
                  style: TextStyle(color: msgTxtColor),
                ),
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Row(
                  children: <Widget>[
                    Text(
                      time,
                      style: TextStyle(
                        color: msgTxtColor,
                        fontSize: 10.0,
                      ),
                    ),
                    const SizedBox(width: 3.0),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
