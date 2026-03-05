import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
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
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB)))),
                    child: const Text('Messages', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF111827))),
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
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Text('DIRECT MESSAGES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF9CA3AF), letterSpacing: 1)),
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
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB)))),
                    child: Row(
                      children: [
                        if (!isWide)
                          IconButton(
                            icon: const Icon(Icons.arrow_back, size: 20),
                            onPressed: () => setState(() => _chatOpen = false),
                          ),
                        Text(
                          _activeChat != null
                              ? members.where((m) => m.id == _activeChat).map((m) => m.name).firstOrNull ?? 'Unknown'
                              : 'Public Channel',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF111827)),
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
                                Icon(Icons.message_rounded, size: 48, color: Colors.grey[300]),
                                const SizedBox(height: 8),
                                const Text('No messages yet.', style: TextStyle(color: Color(0xFF9CA3AF))),
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
                                      CircleAvatar(
                                        radius: 14,
                                        backgroundColor: const Color(0xFFE5E7EB),
                                        child: Text(msg.senderName[0], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF6B7280))),
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: isMe ? const Color(0xFF2563EB) : Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: const Radius.circular(16),
                                              topRight: const Radius.circular(16),
                                              bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                                              bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                                            ),
                                            border: isMe ? null : Border.all(color: const Color(0xFFE5E7EB)),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(msg.senderName, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isMe ? Colors.white70 : const Color(0xFF374151))),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    _formatTime(msg.timestamp),
                                                    style: TextStyle(fontSize: 10, color: isMe ? Colors.white54 : const Color(0xFF9CA3AF)),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(msg.content, style: TextStyle(fontSize: 13, color: isMe ? Colors.white : const Color(0xFF374151))),
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
                    decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFE5E7EB)))),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _msgCtrl,
                            style: const TextStyle(fontSize: 13, color: Color(0xFF111827)),
                            onSubmitted: (_) => _handleSend(),
                            decoration: InputDecoration(
                              hintText: 'Type your message...',
                              hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Color(0xFFD1D5DB))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Color(0xFFD1D5DB))),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Color(0xFF2563EB))),
                              filled: true,
                              fillColor: const Color(0xFFF9FAFB),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _handleSend,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF2563EB)),
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
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: isActive ? const Color(0xFF1E3A5F) : const Color(0xFFF3F4F6),
        child: Text(initial, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isActive ? Colors.white : const Color(0xFF6B7280))),
      ),
      title: Text(name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isActive ? const Color(0xFF111827) : const Color(0xFF4B5563))),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
      selected: isActive,
      selectedTileColor: const Color(0xFFEFF6FF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: onTap,
    );
  }
}
