import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sakina/bill_popup/utilitybill.dart';

// ─── Model ───────────────────────────────────────────────────────────────────
class NotificationModel {
  final String id;
  final String type;
  final String message;
  final bool isRead;
  final DateTime sentAt;
  final Map<String, dynamic>? metadata;

  NotificationModel({
    required this.id,
    required this.type,
    required this.message,
    required this.isRead,
    required this.sentAt,
    this.metadata,
  });

  String get title {
    switch (type) {
      case 'utility_bill': return 'Utility Bill Reminder';
      case 'match':        return 'New AI Match Found!';
      case 'message':      return 'New Message';
      case 'listing':      return 'New Listing Nearby';
      default:             return 'Notification';
    }
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['notification_id'].toString(),
      type: json['type'] ?? 'general',
      message: json['message'] ?? '',
      isRead: json['is_read'] ?? false,
      sentAt: json['sent_at'] != null
          ? DateTime.parse(json['sent_at'])
          : DateTime.now(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}

// ─── Repository ───────────────────────────────────────────────────────────────
class NotificationsRepository {
  final _supabase = Supabase.instance.client;

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return _fallbackNotifications();

      final response = await _supabase
          .from('notification')
          .select()
          .eq('user_id', userId)
          .order('sent_at', ascending: false);

      return (response as List)
          .map((e) => NotificationModel.fromJson(e))
          .toList();
    } catch (_) {
      return _fallbackNotifications();
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _supabase
          .from('notification')
          .update({'is_read': true})
          .eq('notification_id', notificationId);
    } catch (_) {}
  }

  Future<void> markAllAsRead() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;
      await _supabase
          .from('notification')
          .update({'is_read': true})
          .eq('user_id', userId);
    } catch (_) {}
  }

  List<NotificationModel> _fallbackNotifications() => [
        NotificationModel(
          id: '1',
          type: 'utility_bill',
          message: 'Your electricity & water bill for April is due.',
          isRead: false,
          sentAt: DateTime.now().subtract(const Duration(hours: 2)),
          metadata: {'amount': 'EGP 450.00', 'deadline': 'April 15th'},
        ),
        NotificationModel(
          id: '2',
          type: 'match',
          message: 'Omar Mansour is a 95% match for your lifestyle preferences.',
          isRead: false,
          sentAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        NotificationModel(
          id: '3',
          type: 'message',
          message: 'Your landlord sent you a message about your viewing request.',
          isRead: true,
          sentAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        NotificationModel(
          id: '4',
          type: 'listing',
          message: 'A new studio was listed in Zamalek — 8,500 EGP/mo.',
          isRead: true,
          sentAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ];
}

// ─── Screen ───────────────────────────────────────────────────────────────────
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _repo = NotificationsRepository();
  late Future<List<NotificationModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.getNotifications();
  }

  void _refresh() {
    setState(() => _future = _repo.getNotifications());
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'utility_bill': return Icons.receipt_long;
      case 'match':        return Icons.favorite;
      case 'message':      return Icons.chat_bubble_outline;
      case 'listing':      return Icons.home_outlined;
      default:             return Icons.notifications_outlined;
    }
  }

  Color _colorFor(String type) {
    switch (type) {
      case 'utility_bill': return const Color(0xFF3A2A00);
      case 'match':        return const Color(0xFFB85C5C);
      case 'message':      return const Color(0xFF3A6B8A);
      case 'listing':      return const Color(0xFF4A7C59);
      default:             return const Color(0xFF5A5A5A);
    }
  }

  void _onTap(NotificationModel n) async {
    await _repo.markAsRead(n.id);
    if (!mounted) return;

    if (n.type == 'utility_bill') {
      _showBillPopup(n);
    }
    _refresh();
  }

  void _showBillPopup(NotificationModel n) {
    final amount   = n.metadata?['amount']   ?? 'EGP 450.00';
    final deadline = n.metadata?['deadline'] ?? 'Soon';

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.35),
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => Center(
        child: UtilityBillPopup(amount: amount, deadline: deadline),
      ),
      transitionBuilder: (_, anim, __, child) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: Transform.translate(
            offset: Offset(0, 40 * (1 - curved.value)),
            child: Transform.scale(
              scale: 0.95 + 0.05 * curved.value,
              child: child,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EFE6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF120A00), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF120A00),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _repo.markAllAsRead();
              _refresh();
            },
            child: const Text(
              'Mark all read',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 13,
                color: Color(0xFF4C463C),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<NotificationModel>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final notifications = snap.data ?? [];

          if (notifications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notifications_off_outlined,
                      size: 56, color: Color(0xFFB0A898)),
                  SizedBox(height: 12),
                  Text(
                    'No notifications yet',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16,
                      color: Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            );
          }

          final unread = notifications.where((n) => !n.isRead).toList();
          final read   = notifications.where((n) =>  n.isRead).toList();

          return RefreshIndicator(
            onRefresh: () async => _refresh(),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                if (unread.isNotEmpty) ...[
                  _SectionLabel(label: 'NEW'),
                  const SizedBox(height: 8),
                  ...unread.map((n) => _NotificationTile(
                        notification: n,
                        icon: _iconFor(n.type),
                        color: _colorFor(n.type),
                        timeAgo: _timeAgo(n.sentAt),
                        onTap: () => _onTap(n),
                      )),
                  const SizedBox(height: 16),
                ],
                if (read.isNotEmpty) ...[
                  _SectionLabel(label: 'EARLIER'),
                  const SizedBox(height: 8),
                  ...read.map((n) => _NotificationTile(
                        notification: n,
                        icon: _iconFor(n.type),
                        color: _colorFor(n.type),
                        timeAgo: _timeAgo(n.sentAt),
                        onTap: () => _onTap(n),
                      )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Manrope',
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: Color(0xFF888888),
      ),
    );
  }
}

// ─── Notification Tile ────────────────────────────────────────────────────────
class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final IconData icon;
  final Color color;
  final String timeAgo;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.icon,
    required this.color,
    required this.timeAgo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUnread ? Colors.white : const Color(0xFFF0EBE3),
          borderRadius: BorderRadius.circular(16),
          border: isUnread
              ? Border.all(color: color.withValues(alpha: 0.25), width: 1)
              : null,
          boxShadow: isUnread
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon bubble
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 14,
                            fontWeight: isUnread
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: const Color(0xFF120A00),
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13,
                      color: Color(0xFF4C463C),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    timeAgo,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 11,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),

            if (notification.type == 'utility_bill')
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 6),
                child: Icon(Icons.chevron_right, color: color, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}