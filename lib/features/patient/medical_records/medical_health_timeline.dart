import 'package:flutter/material.dart';

class MedicalHealthTimeline extends StatelessWidget {
  const MedicalHealthTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildHealthScoreCard(),
                    const SizedBox(height: 32),
                    _buildTimeline(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 40),
        height: 64,
        width: 64,
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xFF10B981),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.add, size: 32, color: Colors.white),
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.chevron_left, size: 24),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
          const Text(
            'My Health Journey',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          Stack(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF10B981).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuA2CddRDroFXVxRit3PLkQJLn2Qn6sYEf806UDRQdelnFfC_81hYP5GN2CMA6Dyqsf3131EQO0qI9fP8wb1Zy0GTsMVbCo9gs3qsWqMWciJsX0B_h9NVroTSrPl-BxJJJum-mIFhLdpMHPCfMFlIaxdlYnwMWTySVID4mNeTA2tb3u7EO0ay4ULmtrEa_rjvB5JjDeio4FKEdkaUOPg0kdK8lsALMgBrwndyZnSFNprwTgrqj1DLHtE43t2i79aCF7AjvPpu4OzbgzF',
                  ),
                ),
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: const Text(
                    'ONE-ID',
                    style: TextStyle(
                      fontSize: 6,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthScoreCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Health Score',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: '84',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: '/100',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.analytics_outlined,
                size: 40,
                color: Colors.white24,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Icon(Icons.trending_up, size: 16, color: Colors.white),
              SizedBox(width: 8),
              Text(
                '3% better than last month',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Column(
      children: [
        _buildTimelineItem(
          '12 OCT 2025',
          'Blood Test - City Lab',
          Icons.science,
          tags: ['ROUTINE CHECKUP', 'COMPLETED'],
          buttonLabel: 'View PDF Report',
          isFirst: true,
        ),
        _buildTimelineItem(
          '10 SEP 2025',
          'Consultation - Dr. Smith',
          Icons.medical_services,
          subtitle: 'Cardiology Department',
          doctorImage:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuA4p4RRAh1icTTXG7chCRtDvVP6KhCKRzeYvOGxwIg7gM3NKeXNJ5Sqtdr2lcMgnSCAad8ZdBzMR7XL8pNoSzxX-8v_RqS-5bc6CExi9dW4aK701l_O7Wf7MpwTWaUrM2bObyAjbn7M4IcsJhuln9cY-RPUcPmVMYn57wI_A68zlV-Jt0FKO4PaOS1tzy12Khz6Gk2uGD9MM95GQhZxjqsnKYaGppZ4IFVcfBUZCbiYY8zRj3hnG6SpcFaiUGTc87yGpNpXZfDEizMp',
          buttonLabel: 'View Prescription',
        ),
        _buildTimelineItem(
          '15 AUG 2025',
          'Vaccination Record Added',
          Icons.history,
          isLast: true,
          isMinimal: true,
        ),
      ],
    );
  }

  Widget _buildTimelineItem(
    String date,
    String title,
    IconData icon, {
    List<String>? tags,
    String? subtitle,
    String? doctorImage,
    String? buttonLabel,
    bool isFirst = false,
    bool isLast = false,
    bool isMinimal = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: isMinimal ? Colors.white : const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: isMinimal
                          ? Border.all(color: const Color(0xFFE2E8F0), width: 3)
                          : Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: const Color(0xFF10B981).withOpacity(0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isMinimal ? const Color(0xFFF8FAFC) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isMinimal
                          ? const Color(0xFFF1F5F9)
                          : const Color(0xFFF1F5F9),
                      style: isMinimal ? BorderStyle.solid : BorderStyle.solid,
                    ),
                    boxShadow: isMinimal
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                date,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF10B981),
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isMinimal
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isMinimal
                                  ? const Color(0xFFF1F5F9)
                                  : const Color(0xFFF0FDF4),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              icon,
                              color: isMinimal
                                  ? const Color(0xFFCBD5E1)
                                  : const Color(0xFF10B981),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      if (tags != null) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: tags
                              .map(
                                (tag) => Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: tag == 'COMPLETED'
                                        ? const Color(0xFFD1FAE5)
                                        : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    tag,
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: tag == 'COMPLETED'
                                          ? const Color(0xFF059669)
                                          : const Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                      if (subtitle != null) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            if (doctorImage != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  doctorImage,
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            const SizedBox(width: 8),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (buttonLabel != null) ...[
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              buttonLabel.contains('PDF')
                                  ? Icons.description_outlined
                                  : Icons.medication_outlined,
                              size: 18,
                            ),
                            label: Text(buttonLabel),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonLabel.contains('PDF')
                                  ? const Color(0xFF059669)
                                  : const Color(0xFFF1F5F9),
                              foregroundColor: buttonLabel.contains('PDF')
                                  ? Colors.white
                                  : const Color(0xFF475569),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildBottomNav() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined),
          _buildNavItem(Icons.insights_outlined, isActive: true),
          const SizedBox(width: 40),
          _buildNavItem(Icons.chat_bubble_outline),
          _buildNavItem(Icons.person_outline),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, {bool isActive = false}) {
    return Icon(
      icon,
      color: isActive ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
    );
  }
}
