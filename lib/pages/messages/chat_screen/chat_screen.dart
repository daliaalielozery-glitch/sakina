import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Message {
  final String text;
  final bool isMe;
  final String time;
  final String type;

  Message({
    required this.text,
    required this.isMe,
    required this.time,
    this.type = "text",
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static const Color bg = Color(0xFFF5F3EF);
  static const Color card = Color(0xFFEEE9DF);
  static const Color brown = Color(0xFF1B1209);
  static const Color muted = Color(0xFF7A746C);
  static const Color border = Color(0xFFE8E1D7);

  final TextEditingController controller = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _reportController = TextEditingController();

  final List<Message> _messages = [
    Message(
      text:
          "Hey! I saw your profile on Sakina. I'm also looking for a place in Maadi. Do you have a specific budget in mind?",
      isMe: false,
      time: "10:42 AM",
    ),
    Message(text: "", isMe: false, time: "", type: "safety"),
    Message(
      text:
          "Hi Malak! Nice to meet you. Yes, Maadi is great! My budget is around 8,000 to 10,000 EGP. Does that work for you?",
      isMe: true,
      time: "10:45 AM",
    ),
    Message(
      text:
          "That matches mine perfectly! I'm actually going to view a two-bedroom apartment near Degla tomorrow afternoon. Would you like to join me? It has a huge balcony with sunset views.",
      isMe: false,
      time: "10:48 AM",
    ),
    Message(text: "", isMe: false, time: "", type: "listing"),
  ];

  void _sendMessage() {
    if (controller.text.trim().isEmpty) return;

    setState(() {
      _messages.add(Message(text: controller.text, isMe: true, time: "Now"));
    });

    controller.clear();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add(
            Message(text: "Sounds good!", isMe: false, time: "Now"),
          );
        });
      }
    });
  }

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Photo Gallery'),
            onTap: () => Navigator.pop(context, 'gallery'),
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () => Navigator.pop(context, 'camera'),
          ),
        ],
      ),
    );

    if (source == null) return;

    if (source == 'gallery') {
      final picked = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          _messages.add(
            Message(text: '📷 Photo', isMe: true, time: "Now", type: 'image'),
          );
        });
      }
    } else if (source == 'camera') {
      final picked = await _imagePicker.pickImage(source: ImageSource.camera);
      if (picked != null) {
        setState(() {
          _messages.add(
            Message(text: '📷 Photo', isMe: true, time: "Now", type: 'image'),
          );
        });
      }
    }
  }

  Future<void> _pickDocument() async {
    final picked = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _messages.add(
          Message(text: '📄 Document', isMe: true, time: "Now", type: 'file'),
        );
      });
    }
  }

  void _showSOSPopup() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Emergency Numbers",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: brown,
              ),
            ),
            const SizedBox(height: 20),
            _buildEmergencyButton("Police", "191", Icons.local_police),
            const SizedBox(height: 10),
            _buildEmergencyButton("Ambulance", "123", Icons.local_hospital),
            const SizedBox(height: 10),
            _buildEmergencyButton(
              "Fire Department",
              "180",
              Icons.local_fire_department,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyButton(String name, String number, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: brown,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Text(
            "$name: $number",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showReportPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Report",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: brown,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person_off, color: brown),
              title: const Text("Report User"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.home_work, color: brown),
              title: const Text("Report Property"),
              onTap: () {},
            ),
            const SizedBox(height: 20),
            const Text(
              "Describe what happened",
              style: TextStyle(fontWeight: FontWeight.w600, color: brown),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _reportController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Write your complaint here...",
                hintStyle: TextStyle(color: muted.withValues(alpha: 0.6)),
                filled: true,
                fillColor: card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_reportController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please describe what happened"),
                      ),
                    );
                    return;
                  }
                  Navigator.pop(context);
                  _showReportSentPopup();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: brown,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Send Report",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReportSentPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.green, size: 40),
            ),
            const SizedBox(height: 20),
            const Text(
              "Report Submitted",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: brown,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "We'll review within 24 hours",
              style: TextStyle(color: muted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _reportController.clear();
            },
            child: const Text("OK", style: TextStyle(color: brown)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    _reportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            const SizedBox(height: 10),
            const Text(
              "TODAY",
              style: TextStyle(
                color: muted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];

                  if (msg.type == "safety") {
                    return _buildSafetyCard();
                  } else if (msg.type == "listing") {
                    return _buildListingCard();
                  } else {
                    return _buildMessageBubble(msg);
                  }
                },
              ),
            ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: brown),
            onPressed: () => Navigator.pop(context),
          ),
          const CircleAvatar(
            backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=47"),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Malak Ahmed",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: brown,
                  fontSize: 16,
                ),
              ),
              Text("ONLINE NOW", style: TextStyle(fontSize: 12, color: muted)),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: _showSOSPopup,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "SOS",
                style: TextStyle(color: brown, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _showReportPopup,
            child: const Icon(
              Icons.warning_amber_outlined,
              color: brown,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message msg) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: msg.isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(maxWidth: 260),
            decoration: BoxDecoration(
              color: msg.isMe ? brown : card,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              msg.text,
              style: TextStyle(
                color: msg.isMe ? Colors.white : brown,
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              msg.time,
              style: const TextStyle(fontSize: 10, color: muted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyCard() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: brown, width: 1.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: brown, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Safety First\nKeep your payments and communications \n within the platform  to ensure you're covered \n by our protection policies.",
              style: TextStyle(fontSize: 12, color: brown),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListingCard() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.network(
              "https://images.unsplash.com/photo-1505691938895-1758d7feb511",
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  color: card,
                  child: const Icon(Icons.image, color: muted),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Modern Oasis in Degla",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: brown,
                fontSize: 16,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "2 Bedrooms • 2 Bathrooms • Fully Furnished",
              style: TextStyle(color: muted, fontSize: 13),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              decoration: BoxDecoration(
                color: brown,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "VIEW FULL DETAILS",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: const Icon(Icons.add_circle_outline, color: muted),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle: TextStyle(color: muted.withValues(alpha: 0.6)),
                filled: true,
                fillColor: card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _pickDocument,
            child: const Icon(Icons.attach_file, color: muted),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: brown,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
