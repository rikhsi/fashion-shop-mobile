import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/mocks/mock_profile_data.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/models/chat_model.dart';

class ChatConversationPage extends StatefulWidget {
  final ChatModel chat;
  const ChatConversationPage({super.key, required this.chat});

  @override
  State<ChatConversationPage> createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  late List<ChatMessageModel> _messages;
  ChatMessageModel? _replyingTo;

  @override
  void initState() {
    super.initState();
    _messages = List.of(
      MockProfileData.chatMessages[widget.chat.id] ?? [],
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  void _setReplyTo(ChatMessageModel msg) {
    setState(() => _replyingTo = msg);
  }

  void _clearReply() {
    setState(() => _replyingTo = null);
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessageModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        text: text,
        time: DateTime.now(),
        sender: MessageSender.user,
        replyToId: _replyingTo?.id,
        replyToText: _replyingTo?.text.isNotEmpty == true
            ? _replyingTo!.text
            : _replyingTo?.attachmentName ?? 'Attachment',
        replyToSenderName: _replyingTo != null
            ? (_replyingTo!.sender == MessageSender.user
                ? 'You'
                : widget.chat.sellerName)
            : null,
      ));
      _replyingTo = null;
    });
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _showAttachmentOptions() {
    final scheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: scheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.base),
                decoration: BoxDecoration(
                  color: scheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _AttachOption(
                icon: Icons.photo_library_rounded,
                label: 'Photo & Video',
                color: scheme.primary,
                scheme: scheme,
                onTap: () {
                  Navigator.pop(context);
                  _simulateAttachment(AttachmentType.image);
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              _AttachOption(
                icon: Icons.camera_alt_rounded,
                label: 'Camera',
                color: const Color(0xFF22C55E),
                scheme: scheme,
                onTap: () {
                  Navigator.pop(context);
                  _simulateAttachment(AttachmentType.image);
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              _AttachOption(
                icon: Icons.insert_drive_file_rounded,
                label: 'Document',
                color: const Color(0xFF3B82F6),
                scheme: scheme,
                onTap: () {
                  Navigator.pop(context);
                  _simulateAttachment(AttachmentType.file);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _simulateAttachment(AttachmentType type) {
    setState(() {
      _messages.add(ChatMessageModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        text: type == AttachmentType.image ? '' : '',
        time: DateTime.now(),
        sender: MessageSender.user,
        attachmentType: type,
        attachmentUrl: type == AttachmentType.image
            ? 'https://images.unsplash.com/photo-1564257631407-4deb1f99d992?w=400&h=400&fit=crop'
            : 'receipt.pdf',
        attachmentName: type == AttachmentType.image ? 'Photo' : 'Document.pdf',
      ));
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: scheme.primaryContainer,
              child: Text(
                widget.chat.initials,
                style: AppTextStyles.labelMedium.copyWith(
                  color: scheme.primary,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chat.sellerName,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: scheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Online',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: scheme.primary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 64,
                          color: scheme.onSurfaceVariant.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'No messages yet',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.base,
                      vertical: AppSpacing.sm,
                    ),
                    itemCount: _messages.length,
                    itemBuilder: (_, i) {
                      final msg = _messages[i];
                      final isMe = msg.sender == MessageSender.user;
                      final showDate = i == 0 ||
                          !_isSameDay(msg.time, _messages[i - 1].time);

                      return Column(
                        children: [
                          if (showDate)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: scheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusFull,
                                  ),
                                ),
                                child: Text(
                                  _formatDate(msg.time),
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: scheme.onSurfaceVariant,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                          _MessageBubble(
                            message: msg,
                            isMe: isMe,
                            sellerName: widget.chat.sellerName,
                            onSwipeReply: () => _setReplyTo(msg),
                          ),
                        ],
                      );
                    },
                  ),
          ),
          _buildInputBar(scheme),
        ],
      ),
    );
  }

  Widget _buildInputBar(ColorScheme scheme) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.sm,
        right: AppSpacing.sm,
        top: AppSpacing.sm,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(
          top: BorderSide(color: scheme.outline),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_replyingTo != null) _buildReplyPreview(scheme),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: _showAttachmentOptions,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Icon(
                    Icons.attach_file_rounded,
                    color: scheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  ),
                  child: TextField(
                    controller: _controller,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 4,
                    minLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Message...',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.base,
                        vertical: AppSpacing.md,
                      ),
                    ),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: scheme.onSurface,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.send_rounded,
                    color: scheme.onPrimary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReplyPreview(ColorScheme scheme) {
    final reply = _replyingTo!;
    final senderName = reply.sender == MessageSender.user
        ? 'You'
        : widget.chat.sellerName;
    final previewText = reply.text.isNotEmpty
        ? reply.text
        : reply.attachmentName ?? 'Attachment';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border(
          left: BorderSide(color: scheme.primary, width: 3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  senderName,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: scheme.primary,
                  ),
                ),
                Text(
                  previewText,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _clearReply,
            child: Icon(
              Icons.close_rounded,
              size: 18,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (_isSameDay(date, now)) return 'Today';
    if (_isSameDay(date, now.subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    }
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

// ── Attachment option in bottom sheet ──

class _AttachOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final ColorScheme scheme;
  final VoidCallback onTap;

  const _AttachOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.scheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              label,
              style: AppTextStyles.titleSmall.copyWith(
                color: scheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Message Bubble ──

class _MessageBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isMe;
  final String sellerName;
  final VoidCallback onSwipeReply;

  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.sellerName,
    required this.onSwipeReply,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity! > 200) {
            onSwipeReply();
          }
        },
        onLongPress: () => _showMessageMenu(context, scheme),
        child: Container(
          margin: EdgeInsets.only(
            top: AppSpacing.xs,
            bottom: AppSpacing.xs,
            left: isMe ? 60 : 0,
            right: isMe ? 0 : 60,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isMe
                ? scheme.primary.withValues(alpha: 0.15)
                : scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(AppSpacing.radiusLg),
              topRight: const Radius.circular(AppSpacing.radiusLg),
              bottomLeft: Radius.circular(isMe ? AppSpacing.radiusLg : 4),
              bottomRight: Radius.circular(isMe ? 4 : AppSpacing.radiusLg),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.replyToText != null) _buildReplyQuote(scheme),
              if (message.attachmentType == AttachmentType.image &&
                  message.attachmentUrl != null)
                _buildImageAttachment(scheme),
              if (message.attachmentType == AttachmentType.file)
                _buildFileAttachment(scheme),
              if (message.text.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(
                    top: message.replyToText != null ||
                            message.attachmentType != null
                        ? AppSpacing.xs
                        : 0,
                  ),
                  child: Text(
                    message.text,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(message.time),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontSize: 10,
                    ),
                  ),
                  if (isMe) ...[
                    const SizedBox(width: 3),
                    Icon(
                      message.isRead
                          ? Icons.done_all_rounded
                          : Icons.done_rounded,
                      size: 14,
                      color: message.isRead
                          ? scheme.primary
                          : scheme.onSurfaceVariant,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReplyQuote(ColorScheme scheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: scheme.primary,
            width: 2,
          ),
        ),
        color: scheme.primary.withValues(alpha: 0.06),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.replyToSenderName ?? '',
            style: AppTextStyles.labelMedium.copyWith(
              color: scheme.primary,
              fontSize: 11,
            ),
          ),
          Text(
            message.replyToText!,
            style: AppTextStyles.bodySmall.copyWith(
              color: scheme.onSurfaceVariant,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildImageAttachment(ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Image.network(
          message.attachmentUrl!,
          width: 200,
          height: 150,
          fit: BoxFit.cover,
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return Container(
              width: 200,
              height: 150,
              color: scheme.surfaceContainerHighest,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          errorBuilder: (_, _, _) => Container(
            width: 200,
            height: 150,
            color: scheme.surfaceContainerHighest,
            child: Icon(
              Icons.image_not_supported_outlined,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileAttachment(ColorScheme scheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.insert_drive_file_rounded,
            size: 28,
            color: scheme.primary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              message.attachmentName ?? 'File',
              style: AppTextStyles.labelMedium.copyWith(
                color: scheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showMessageMenu(BuildContext context, ColorScheme scheme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: scheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.base),
                decoration: BoxDecoration(
                  color: scheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Icon(Icons.reply_rounded, color: scheme.primary),
                title: Text('Reply',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: scheme.onSurface,
                    )),
                onTap: () {
                  Navigator.pop(context);
                  onSwipeReply();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
              ListTile(
                leading: Icon(Icons.copy_rounded, color: scheme.onSurfaceVariant),
                title: Text('Copy',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: scheme.onSurface,
                    )),
                onTap: () => Navigator.pop(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
