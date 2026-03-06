import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../styles/app_theme.dart';
import '../../../providers/profile/profile_provider.dart';

class MessagesTab extends ConsumerStatefulWidget {
  const MessagesTab({super.key});

  @override
  ConsumerState<MessagesTab> createState() => _MessagesTabState();
}

class _MessagesTabState extends ConsumerState<MessagesTab> {
  String? _activeChat;
  bool _chatOpen = false;
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (_msgCtrl.text.trim().isEmpty) return;
    ref.read(profileProvider.notifier).sendMessage(_msgCtrl.text.trim(), receiverId: _activeChat);
    _msgCtrl.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);
    final members = state.clubMembers;
    final isWide = MediaQuery.of(context).size.width > 600;

    final filteredMessages = state.clubMessages.where((m) {
      if (_activeChat != null) {
        return m.senderId == _activeChat || m.receiverId == _activeChat;
      }
      return m.receiverId == null;
    }).toList();

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder),
      ),
      clipBehavior: Clip.antiAlias,
      height: MediaQuery.of(context).size.height - 200,
      child: Row(
        children: [
          // Contacts sidebar
          if (isWide || !_chatOpen)
            SizedBox(
              width: isWide ? 240 : double.infinity,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder))),
                    child: Text('Messages', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Theme.of(context).colorScheme.onSurface)),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(8),
                      children: [
                        // Public channel
                        _ContactTile(
                          name: 'Public Channel',
                          subtitle: 'General',
                          initial: '📢',
                          isActive: _activeChat == null && _chatOpen,
                          onTap: () => setState(() { _activeChat = null; _chatOpen = true; }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Text('DIRECT MESSAGES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.textSecondary, letterSpacing: 1)),
                        ),
                        ...members.map((m) => _ContactTile(
                              name: m.name,
                              subtitle: m.role,
                              initial: m.name[0],
                              isActive: _activeChat == m.id,
                              onTap: () => setState(() { _activeChat = m.id; _chatOpen = true; }),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Chat area
          if (isWide || _chatOpen)
            Expanded(
              child: Column(
                children: [
                  // Chat header
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder))),
                    child: Row(
                      children: [
                        if (!isWide)
                          IconButton(
                            icon: Icon(Icons.arrow_back, size: 20, color: Theme.of(context).colorScheme.onSurface),
                            onPressed: () => setState(() => _chatOpen = false),
                          ),
                        Text(
                          _activeChat != null
                              ? members.where((m) => m.id == _activeChat).map((m) => m.name).firstOrNull ?? 'Unknown'
                              : 'Public Channel',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                        ),
                        if (_activeChat != null) ...[
                          const SizedBox(width: 8),
                          Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF22C55E))),
                        ],
                      ],
                    ),
                  ),

                  // Messages
                  Expanded(
                    child: filteredMessages.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.message_rounded, size: 48, color: AppTheme.textSecondary.withOpacity(0.3)),
                                const SizedBox(height: 8),
                                Text('No messages yet.', style: TextStyle(color: AppTheme.textSecondary)),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollCtrl,
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredMessages.length,
                            itemBuilder: (context, index) {
                              final msg = filteredMessages[index];
                              final isMe = msg.senderName == state.profile.name;
                              return Align(
                                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    textDirection: isMe ? TextDirection.rtl : TextDirection.ltr,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(1.5),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: AppTheme.accentGradient,
                                        ),
                                        child: CircleAvatar(
                                          radius: 13,
                                          backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppTheme.backgroundDark : Colors.white,
                                          child: Text(msg.senderName[0], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppTheme.primaryAccent)),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: isMe ? null : (Theme.of(context).brightness == Brightness.dark ? AppTheme.glassSurface : AppTheme.lightBg),
                                            borderRadius: BorderRadius.only(
                                              topLeft: const Radius.circular(16),
                                              topRight: const Radius.circular(16),
                                              bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                                              bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                                            ),
                                            border: isMe ? null : Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                   Text(msg.senderName, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isMe ? Colors.white70 : Theme.of(context).colorScheme.onSurface)),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    _formatTime(msg.timestamp),
                                                    style: TextStyle(fontSize: 10, color: isMe ? Colors.white54 : AppTheme.textSecondary),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                               Text(msg.content, style: TextStyle(fontSize: 13, color: isMe ? Colors.white : Theme.of(context).colorScheme.onSurface.withOpacity(0.9))),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  // Input
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(border: Border(top: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder))),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _msgCtrl,
                            style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                            onSubmitted: (_) => _handleSend(),
                            decoration: InputDecoration(
                              hintText: 'Type your message...',
                              hintStyle: TextStyle(color: AppTheme.textSecondary),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppTheme.primaryAccent)),
                              filled: true,
                              fillColor: Theme.of(context).brightness == Brightness.dark ? AppTheme.backgroundDark.withOpacity(0.5) : AppTheme.lightBg,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _handleSend,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppTheme.accentGradient,
                            ),
                            child: const Icon(Icons.send, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(String timestamp) {
    try {
      final dt = DateTime.parse(timestamp);
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }
}

class _ContactTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final String initial;
  final bool isActive;
  final VoidCallback onTap;

  const _ContactTile({
    required this.name,
    required this.subtitle,
    required this.initial,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: isActive
            ? LinearGradient(colors: [
                AppTheme.primaryAccent.withOpacity(0.15),
                AppTheme.secondaryAccent.withOpacity(0.05),
              ])
            : null,
      ),
      child: ListTile(
        dense: true,
        leading: isActive
            ? Container(
                padding: const EdgeInsets.all(1.5),
                decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppTheme.accentGradient),
                child: CircleAvatar(
                  radius: 17,
                  backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppTheme.backgroundDark : Colors.white,
                  child: Text(initial, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppTheme.primaryAccent)),
                ),
              )
            : CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassSurface : AppTheme.lightBg,
                child: Text(initial, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.textSecondary)),
              ),
        title: Text(name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isActive ? (Theme.of(context).brightness == Brightness.dark ? Colors.white : AppTheme.primaryAccent) : Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: onTap,
      ),
    );
  }
}
