import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  final void Function(String)? onLocaleChange;
  final String localeCode;

  const AboutScreen({super.key, this.onLocaleChange, this.localeCode = 'vi'});

  @override
  Widget build(BuildContext context) {
    final isVi = localeCode == 'vi';
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF7E8), Color(0xFFFFE5D9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Tiêu đề + đổi ngôn ngữ
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 48),
                    Text(
                      isVi ? 'Giới thiệu nhóm' : 'About Us',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFBF360C),
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.language, color: Color(0xFFBF360C)),
                      onSelected: (v) => onLocaleChange?.call(v),
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'vi', child: Text('Tiếng Việt')),
                        PopupMenuItem(value: 'en', child: Text('English')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Thông tin thành viên
                Container(
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
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.white.withOpacity(0.5),
                        backgroundImage:
                            const AssetImage('assets/images/avatar.png'),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Phạm Đức Tài',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                            const SizedBox(height: 6),
                            Text(
                              'MSSV: 23010379',
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                Chip(
                                  avatar: const Icon(Icons.code_rounded,
                                      color: Colors.white, size: 18),
                                  label: Text(isVi ? 'Lập trình' : 'Developer'),
                                  backgroundColor: const Color(0xFFFF8A65),
                                  labelStyle: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  elevation: 3,
                                  shadowColor: Colors.black26,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                Chip(
                                  avatar: const Icon(Icons.phone_android_rounded,
                                      color: Colors.white, size: 18),
                                  label: Text(isVi
                                      ? 'Ứng dụng di động'
                                      : 'Mobile App'),
                                  backgroundColor: const Color(0xFFFFB74D),
                                  labelStyle: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  elevation: 3,
                                  shadowColor: Colors.black26,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                Chip(
                                  avatar: const Icon(Icons.brush_rounded,
                                      color: Colors.white, size: 18),
                                  label: const Text('UI / UX'),
                                  backgroundColor: const Color(0xFFBA68C8),
                                  labelStyle: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  elevation: 3,
                                  shadowColor: Colors.black26,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
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
                const SizedBox(height: 20),

                // Các thông tin chi tiết
                _buildInfoCard(
                  icon: Icons.lightbulb_rounded,
                  title: isVi ? 'Đề tài' : 'Project',
                  value: isVi
                      ? 'Ứng dụng theo dõi cảm xúc hằng ngày'
                      : 'Daily Mood Tracking App',
                ),
                _buildInfoCard(
                  icon: Icons.person_pin_rounded,
                  title: isVi ? 'Giảng viên hướng dẫn' : 'Supervisor',
                  value: 'Nguyễn Xuân Quế',
                ),
                _buildInfoCard(
                  icon: Icons.calendar_month_rounded,
                  title: isVi ? 'Năm học' : 'Academic Year',
                  value: '2025',
                ),
                _buildInfoCard(
                  icon: Icons.description_rounded,
                  title: isVi ? 'Mô tả' : 'Description',
                  value: isVi
                      ? 'Ứng dụng giúp ghi lại cảm xúc và ghi chú hằng ngày với giao diện sinh động, rực rỡ và dễ chịu.'
                      : 'An app to record and reflect your daily emotions with a bright, lively and comforting interface.',
                ),

                const Spacer(),
                const Text(
                  '© 2025 - Mood Tracker Project',
                  style: TextStyle(color: Colors.brown, fontSize: 13),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Card thông tin
  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.pinkAccent.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFFFF6A88)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: const Color(0xFFBF360C),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF4E342E),
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
