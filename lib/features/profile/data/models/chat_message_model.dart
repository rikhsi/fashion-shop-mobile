enum MessageSender { user, seller }

enum AttachmentType { image, file }

class ChatMessageModel {
  final String id;
  final String text;
  final DateTime time;
  final MessageSender sender;
  final bool isRead;
  final String? replyToId;
  final String? replyToText;
  final String? replyToSenderName;
  final String? attachmentUrl;
  final AttachmentType? attachmentType;
  final String? attachmentName;

  const ChatMessageModel({
    required this.id,
    required this.text,
    required this.time,
    required this.sender,
    this.isRead = true,
    this.replyToId,
    this.replyToText,
    this.replyToSenderName,
    this.attachmentUrl,
    this.attachmentType,
    this.attachmentName,
  });
}
