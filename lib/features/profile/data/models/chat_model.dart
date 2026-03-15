class ChatModel {
  final String id;
  final String sellerName;
  final String lastMessage;
  final DateTime time;
  final int unreadCount;
  final String? avatarUrl;

  const ChatModel({
    required this.id,
    required this.sellerName,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.avatarUrl,
  });

  String get initials {
    final parts = sellerName.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}';
    return sellerName.substring(0, 1).toUpperCase();
  }
}
