import 'package:flutter/material.dart';
import 'package:sakina/core/widgets/custom_app_bar.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Conversations',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A1A1A)),
//         useMaterial3: true,
//         fontFamily: 'Georgia',
//       ),
//       home: const ConversationsScreen(),
//     );
//   }
// }

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Roommates', 'Landlords'];

  final List<ConversationItem> _conversations = [
    ConversationItem(
      name: 'Omar Farouk',
      message: 'Hey, did you check the kitch...',
      time: '2M AGO',
      avatarUrl:
          'https://plus.unsplash.com/premium_photo-1689565611422-b2156cc65e47?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8bWFuJTIwcHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D',
      isOnline: true,
      unreadCount: 2,
    ),
    ConversationItem(
      name: 'Dr. Nadia Mansour',
      message: 'The viewing is confirmed for...',
      time: 'YESTERDAY',
      avatarUrl:
          'https://plus.unsplash.com/premium_photo-1689565611422-b2156cc65e47?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8bWFuJTIwcHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D',
      isOnline: false,
      unreadCount: 0,
      isRead: true,
    ),
    ConversationItem(
      name: 'Layla Hassan',
      message: "I'll send the deposit receipt soon!",
      time: 'TUE',
      avatarUrl:
          'https://plus.unsplash.com/premium_photo-1689565611422-b2156cc65e47?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8bWFuJTIwcHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D',
      isOnline: false,
      unreadCount: 0,
      isRead: true,
      isSent: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Myappbar(),
      backgroundColor: Color(0xFFF2ECDE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildFilterTabs(),
              ..._conversations.map((c) => _buildConversationTile(c)),
              _buildSakinaSafetyTip(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
            'Keep up with your potential roommates and hosts.',
            style: TextStyle(
              color: const Color(0xFF4C463C),
              fontSize: 16,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
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
        child: Row(
          children: [
            const SizedBox(width: 14),
            Icon(Icons.search, color: Colors.grey[400], size: 20),
            const SizedBox(width: 8),
            Text(
              'Search messages...',
              style: TextStyle(
                color: const Color(0xFF7E766B),
                fontSize: 16,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: List.generate(_filters.length, (index) {
          final selected = _selectedFilter == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF1A1A1A) : Color(0xFFEAE8E5),
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
                  height: 1.43,
                  color: selected ? Colors.white : Color(0xFF4C463C),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildConversationTile(ConversationItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFFF5F3F0),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundImage: NetworkImage(item.avatarUrl),
              backgroundColor: Colors.grey[200],
            ),
            if (item.isOnline)
              Positioned(
                bottom: 1,
                right: 1,
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.8),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          item.name,
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
              if (item.isSent)
                Padding(
                  padding: const EdgeInsets.only(right: 3),
                  child:
                      Icon(Icons.done_all, size: 14, color: Colors.grey[400]),
                ),
              Expanded(
                child: Text(
                  item.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[500],
                  ),
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
              item.time,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            if (item.unreadCount > 0)
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${item.unreadCount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else if (item.isRead)
              Icon(Icons.chevron_right, size: 18, color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }

  Widget _buildSakinaSafetyTip() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F0),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: const Color(0xFFE8A857),
            width: 4,
          ),
        ),
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
                    color:  Color(0xFF3A0B00),
                    fontSize: 14,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    height: 1.43,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Never share your password or bank details through chat. Always conduct transactions within our secure platform.',
                  style: TextStyle(
                    color: const Color(0xFF3A0B00),
                    fontSize: 12,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w400,
                    height: 1.63,
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

class ConversationItem {
  final String name;
  final String message;
  final String time;
  final String avatarUrl;
  final bool isOnline;
  final int unreadCount;
  final bool isRead;
  final bool isSent;

  ConversationItem({
    required this.name,
    required this.message,
    required this.time,
    required this.avatarUrl,
    this.isOnline = false,
    this.unreadCount = 0,
    this.isRead = false,
    this.isSent = false,
  });
}
