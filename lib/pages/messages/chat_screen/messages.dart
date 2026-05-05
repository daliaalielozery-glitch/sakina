import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'chat_screen.dart';
import 'package:sakina/landlord/dashboard_screen.dart';
import 'package:sakina/pages/home.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  final supabase = Supabase.instance.client;
  int _selectedFilter = 0;
  List<String> _filters = ['All', 'Roommates', 'Landlords'];
  List<Map<String, dynamic>> _conversations = [];
  List<Map<String, dynamic>> _allConversations = [];
  bool _isLoading = true;
  bool _isLandlord = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _checkUserRole();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text);
      _filterConversations();
    });
  }

  void _filterConversations() {
    String query = _searchQuery.toLowerCase();
    List<Map<String, dynamic>> filtered = List.from(_allConversations);
    if (query.isNotEmpty) {
      filtered = filtered.where((conv) {
        final name = conv['other_user_name']?.toLowerCase() ?? '';
        final message = conv['last_message']?.toLowerCase() ?? '';
        return name.contains(query) || message.contains(query);
      }).toList();
    }
    setState(() => _conversations = filtered);
  }

  Future<void> _checkUserRole() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;
    final landlordCheck = await supabase
        .from('landlord')
        .select('landlord_id')
        .eq('landlord_id', userId)
        .maybeSingle();
    setState(() {
      _isLandlord = landlordCheck != null;
      if (_isLandlord) {
        _filters = ['All', 'Tenants', 'Properties'];
      } else {
        _filters = ['All', 'Roommates', 'Landlords'];
      }
      _loadConversations();
      _subscribeToMessages();
    });
  }

  Future<void> _loadConversations() async {
    setState(() => _isLoading = true);
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      // ---- as landlord ----
      final landlordConvs = await supabase
          .from('conversation')
          .select(
              'conversation_id, created_at, messages:messages(content, sent_at, sender_id)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final List<Map<String, dynamic>> landlordList = [];
      for (var conv in landlordConvs) {
        final convId = conv['conversation_id'];
        final participants = await supabase
            .from('conversation_participants')
            .select('tenant_id')
            .eq('conversation_id', convId)
            .maybeSingle();
        if (participants == null) continue;
        final tenantId = participants['tenant_id'];
        final tenantUser = await supabase
            .from('users')
            .select('full_name, avatar_url')
            .eq('user_id', tenantId)
            .maybeSingle();

        final lastMessages = await supabase
            .from('messages')
            .select()
            .eq('conversation_id', convId)
            .order('sent_at', ascending: false)
            .limit(1);
        final unreadMessages = await supabase
            .from('messages')
            .select()
            .eq('conversation_id', convId)
            .eq('is_read', false)
            .neq('sender_id', userId);
        final lastMessage = lastMessages.isNotEmpty ? lastMessages.first : null;
        landlordList.add({
          'conversation_id': convId,
          'other_user_id': tenantId,
          'other_user_name': tenantUser?['full_name'] ?? 'Tenant',
          'other_user_avatar': tenantUser?['avatar_url'],
          'last_message': lastMessage?['content'] ?? 'No messages yet',
          'last_message_time': lastMessage?['sent_at'],
          'unread_count': unreadMessages.length,
          'is_my_message': lastMessage?['sender_id'] == userId,
        });
      }

      // ---- as tenant ----
      final participantRows = await supabase
          .from('conversation_participants')
          .select('conversation_id')
          .eq('tenant_id', userId);
      final tenantConvIds = (participantRows as List)
          .map((e) => e['conversation_id'] as String)
          .toList();

      final List<Map<String, dynamic>> tenantList = [];
      for (final convId in tenantConvIds) {
        final conversation = await supabase
            .from('conversation')
            .select('user_id')
            .eq('conversation_id', convId)
            .maybeSingle();
        if (conversation == null) continue;
        final landlordId = conversation['user_id'];
        final landlordUser = await supabase
            .from('users')
            .select('full_name, avatar_url')
            .eq('user_id', landlordId)
            .maybeSingle();

        final lastMessages = await supabase
            .from('messages')
            .select()
            .eq('conversation_id', convId)
            .order('sent_at', ascending: false)
            .limit(1);
        final unreadMessages = await supabase
            .from('messages')
            .select()
            .eq('conversation_id', convId)
            .eq('is_read', false)
            .neq('sender_id', userId);
        final lastMessage = lastMessages.isNotEmpty ? lastMessages.first : null;
        tenantList.add({
          'conversation_id': convId,
          'other_user_id': landlordId,
          'other_user_name': landlordUser?['full_name'] ?? 'Landlord',
          'other_user_avatar': landlordUser?['avatar_url'],
          'last_message': lastMessage?['content'] ?? 'No messages yet',
          'last_message_time': lastMessage?['sent_at'],
          'unread_count': unreadMessages.length,
          'is_my_message': lastMessage?['sender_id'] == userId,
        });
      }

      List<Map<String, dynamic>> allConversations = [
        ...landlordList,
        ...tenantList
      ];
      allConversations.sort((a, b) {
        if (a['last_message_time'] == null) return 1;
        if (b['last_message_time'] == null) return -1;
        return b['last_message_time'].compareTo(a['last_message_time']);
      });

      setState(() {
        _allConversations = allConversations;
        _conversations = List.from(allConversations);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Error loading conversations: $e');
    }
  }

  void _subscribeToMessages() {
    supabase
        .channel('messages_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (payload) => _loadConversations(),
        )
        .subscribe();
  }

  String _formatTime(String? timestamp) {
    if (timestamp == null) return '';
    final dt = DateTime.parse(timestamp).toLocal();
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[dt.weekday - 1];
    }
    return '${dt.day}/${dt.month}';
  }

  @override
  void dispose() {
    _searchController.dispose();
    supabase.channel('messages_changes').unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = _isLandlord
        ? 'Keep up with your tenants and property inquiries.'
        : 'Keep up with your potential roommates and hosts.';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF120A00)),
          onPressed: () {
            if (_isLandlord) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
                (route) => false,
              );
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
                (route) => false,
              );
            }
          },
        ),
        title: const Text('Conversations'),
        backgroundColor: const Color(0xFFF2ECDE),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF2ECDE),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(subtitle),
            _buildSearchBar(),
            _buildFilterTabs(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _conversations.isEmpty
                      ? const Center(
                          child: Text(
                            'No conversations found',
                            style: TextStyle(
                                color: Color(0xFF7E766B),
                                fontFamily: 'Manrope'),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          itemCount: _conversations.length,
                          itemBuilder: (context, index) =>
                              _buildConversationTile(_conversations[index]),
                        ),
            ),
            _buildSakinaSafetyTip(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String subtitle) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Conversations',
            style: TextStyle(
              color: Color(0xFF120A00),
              fontSize: 36,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              height: 1.11,
              letterSpacing: -0.90,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF4C463C),
              fontSize: 16,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search by name or message...',
            hintStyle: const TextStyle(
              color: Color(0xFF7E766B),
              fontSize: 14,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        children: List.generate(_filters.length, (index) {
          final selected = _selectedFilter == index;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedFilter = index);
              _filterConversations();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFFEAE8E5),
                borderRadius: BorderRadius.circular(4),
                border: selected
                    ? null
                    : Border.all(color: Colors.grey[300]!, width: 1.2),
              ),
              child: Text(
                _filters[index],
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
                  color: selected ? Colors.white : const Color(0xFF4C463C),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildConversationTile(Map<String, dynamic> conv) {
    final unread = conv['unread_count'] as int;
    final isMyMessage = conv['is_my_message'] as bool;
    final otherName = conv['other_user_name'] ?? 'User';
    final avatarUrl = conv['other_user_avatar'] as String?;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              conversationId: conv['conversation_id'],
              otherUserId: conv['other_user_id'],
              otherUserName: otherName,
              otherUserAvatar: avatarUrl,
            ),
          ),
        ).then((_) => _loadConversations());
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F3F0),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          leading: CircleAvatar(
            radius: 26,
            backgroundColor: Colors.grey[200],
            backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                ? NetworkImage(avatarUrl)
                : null,
            child: (avatarUrl == null || avatarUrl.isEmpty)
                ? Text(
                    otherName.isNotEmpty ? otherName[0].toUpperCase() : '?',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  )
                : null,
          ),
          title: Text(
            otherName,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14.5,
              color: Color(0xFF1A1A1A),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Row(
              children: [
                if (isMyMessage)
                  Padding(
                    padding: const EdgeInsets.only(right: 3),
                    child:
                        Icon(Icons.done_all, size: 14, color: Colors.grey[400]),
                  ),
                Expanded(
                  child: Text(
                    conv['last_message'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
                ),
              ],
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatTime(conv['last_message_time']),
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              if (unread > 0)
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                      color: Color(0xFF1A1A1A), shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Text(
                    '$unread',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                )
              else
                Icon(Icons.chevron_right, size: 18, color: Colors.grey[300]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSakinaSafetyTip() {
    final tipText = _isLandlord
        ? 'Verify tenant identities and always use the Sakina payment system for rent collection.'
        : 'Never share your password or bank details through chat. Always conduct transactions within our secure platform.';
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F0),
        borderRadius: BorderRadius.circular(16),
        border:
            const Border(left: BorderSide(color: Color(0xFFE8A857), width: 4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: Color(0xFFE8A857), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sakina Safety Tip',
                  style: TextStyle(
                    color: Color(0xFF3A0B00),
                    fontSize: 14,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  tipText,
                  style: const TextStyle(
                    color: Color(0xFF3A0B00),
                    fontSize: 12,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
