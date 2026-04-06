import 'package:flutter/material.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    _buildSearchBar(),
                    const SizedBox(height: 32),
                    _buildActiveGroups(),
                    const SizedBox(height: 32),
                    _buildChatList(context),
                    const SizedBox(height: 120), // Spacer
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Consultations',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.more_horiz_rounded, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Search doctors...',
          hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildActiveGroups() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Active Doctors',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: 6,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, i) {
              return Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF10B981), width: 2),
                      image: const DecorationImage(
                        image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuC9s6caATreQl8lsqAZ4Sjxbij1sV7DWXDvUl-UjBxweezGFPEvyMVvBKwE1Yh7X7mtGHm55kZg8MlRA_8oA27IaqAyDiA3amZbofK4jS4fw3GWCkcEfJfohcKRDYN4-E9_7WnbrQtDiD9OrPnWj1L1kvF9xLV9ACsmoS0ncXpF_YThCZK29KVSV8JcqYpVr-wtt7RP1LJtL92RQHKuCjcC_jiPyzkyHM2YwHdOMKFX1AzzA3tHzwBOJJDfE9QX2ibUYewYFI3dvNUR'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChatList(BuildContext context) {
    final chats = [
      {'name': 'Dr. Tasim Jara', 'lastMsg': 'Please share your latest report.', 'count': 2, 'time': '10:30 AM'},
      {'name': 'Dr. Rose Miller', 'lastMsg': 'That seems normal. Keep hydrated.', 'count': 0, 'time': 'Yesterday'},
      {'name': 'Dr. Sarah Jenkins', 'lastMsg': 'Let me check on your reports.', 'count': 1, 'time': 'Monday'},
      {'name': 'Dr. Raj Kumar', 'lastMsg': 'You can start the meds today.', 'count': 0, 'time': 'Oct 20'},
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: chats.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final chat = chats[i];
        return _buildChatItem(context, chat);
      },
    );
  }

  Widget _buildChatItem(BuildContext context, Map<String, dynamic> chat) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(
              name: chat['name'] as String,
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC9s6caATreQl8lsqAZ4Sjxbij1sV7DWXDvUl-UjBxweezGFPEvyMVvBKwE1Yh7X7mtGHm55kZg8MlRA_8oA27IaqAyDiA3amZbofK4jS4fw3GWCkcEfJfohcKRDYN4-E9_7WnbrQtDiD9OrPnWj1L1kvF9xLV9ACsmoS0ncXpF_YThCZK29KVSV8JcqYpVr-wtt7RP1LJtL92RQHKuCjcC_jiPyzkyHM2YwHdOMKFX1AzzA3tHzwBOJJDfE9QX2ibUYewYFI3dvNUR',
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuC9s6caATreQl8lsqAZ4Sjxbij1sV7DWXDvUl-UjBxweezGFPEvyMVvBKwE1Yh7X7mtGHm55kZg8MlRA_8oA27IaqAyDiA3amZbofK4jS4fw3GWCkcEfJfohcKRDYN4-E9_7WnbrQtDiD9OrPnWj1L1kvF9xLV9ACsmoS0ncXpF_YThCZK29KVSV8JcqYpVr-wtt7RP1LJtL92RQHKuCjcC_jiPyzkyHM2YwHdOMKFX1AzzA3tHzwBOJJDfE9QX2ibUYewYFI3dvNUR'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chat['name'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        chat['time'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          chat['lastMsg'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: (chat['count'] as int) > 0
                                ? const Color(0xFF1E293B)
                                : const Color(0xFF64748B),
                            fontWeight: (chat['count'] as int) > 0 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      if ((chat['count'] as int) > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            chat['count'].toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
