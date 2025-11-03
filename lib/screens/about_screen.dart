import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  final void Function(String)? onLocaleChange;
  final String localeCode;

  const AboutScreen({super.key, this.onLocaleChange, this.localeCode = 'vi'});

  bool get isVi => localeCode == 'vi';
  String tr(String vi, String en) => isVi ? vi : en;

  static const gradient = LinearGradient(
    colors: [Color(0xFFFFF7E8), Color(0xFFFFE5D9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const titleColor = Color(0xFFBF360C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: gradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🔹 Tiêu đề + chọn ngôn ngữ
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 48),
                    Text(tr('Giới thiệu nhóm', 'About Us'),
                        style: GoogleFonts.poppins(
                            fontSize: 22, fontWeight: FontWeight.bold, color: titleColor)),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.language, color: titleColor),
                      onSelected: onLocaleChange,
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'vi', child: Text('Tiếng Việt')),
                        PopupMenuItem(value: 'en', child: Text('English')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // 🔹 Thông tin thành viên
                _memberCard(),

                const SizedBox(height: 20),
                _buildInfoCard(Icons.lightbulb_rounded, tr('Đề tài', 'Project'),
                    tr('Ứng dụng theo dõi cảm xúc hằng ngày', 'Daily Mood Tracking App')),
                _buildInfoCard(Icons.person_pin_rounded, tr('Giảng viên hướng dẫn', 'Supervisor'), 'Nguyễn Xuân Quế'),
                _buildInfoCard(Icons.calendar_month_rounded, tr('Năm học', 'Academic Year'), '2025'),
                _buildInfoCard(
                    Icons.description_rounded,
                    tr('Mô tả', 'Description'),
                    tr(
                        'Ứng dụng giúp ghi lại cảm xúc và ghi chú hằng ngày với giao diện sinh động, dễ chịu.',
                        'An app to record and reflect daily emotions with a bright, comforting interface.')),

                const Spacer(),
                const Text('© 2025 - Mood Tracker Project',
                    style: TextStyle(color: Colors.brown, fontSize: 13)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Thông tin thành viên
  Widget _memberCard() => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFB5A7), Color(0xFFFF9A8B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.pinkAccent.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 6)),
          ],
        ),
        child: Row(children: [
          CircleAvatar(
              radius: 44,
              backgroundColor: Colors.white.withOpacity(0.5),
              backgroundImage: const AssetImage('assets/images/avatar.png')),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Phạm Đức Tài',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('MSSV: 23010379',
                    style: GoogleFonts.poppins(
                        color: Colors.white70, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Wrap(spacing: 8, runSpacing: 6, children: [
                  _skillChip(Icons.code_rounded, 'Lập trình', 'Developer', const Color(0xFFFF8A65)),
                  _skillChip(Icons.phone_android_rounded, 'Ứng dụng di động', 'Mobile App', const Color(0xFFFFB74D)),
                  _skillChip(Icons.brush_rounded, 'UI / UX', 'UI / UX', const Color(0xFFBA68C8)),
                ]),
              ],
            ),
          ),
        ]),
      );

  // 🔹 Chip kỹ năng
  Widget _skillChip(IconData icon, String vi, String en, Color color) => Chip(
        avatar: Icon(icon, color: Colors.white, size: 18),
        label: Text(tr(vi, en)),
        backgroundColor: color,
        labelStyle: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
        elevation: 3,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      );

  // 🔹 Card thông tin
  Widget _buildInfoCard(IconData icon, String title, String value) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.pinkAccent.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 3)),
          ],
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 20, color: const Color(0xFFFF6A88)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700, fontSize: 16, color: titleColor)),
              const SizedBox(height: 6),
              Text(value,
                  style: GoogleFonts.poppins(
                      color: const Color(0xFF4E342E),
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      height: 1.4)),
            ]),
          )
        ]),
      );
}
