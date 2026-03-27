import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/civic_app_bar.dart';
import '../../widgets/civic_footer.dart';
import '../../theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CivicAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHero(isDesktop),
            _buildMission(isDesktop),
            _buildCoreValues(isDesktop),
            _buildImpactStats(isDesktop),
            _buildStakeholders(isDesktop),
            _buildCTA(context, isDesktop),
            const CivicFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(bool isDesktop) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 500),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64 : 24,
        vertical: 80,
      ),
      child: Stack(
        children: [
          // Background decorations could go here
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'About Civic Pulse',
                style: GoogleFonts.publicSans(
                  fontSize: isDesktop ? 80 : 48,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                  letterSpacing: -1.5,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                'नागरिक पल्स के बारे में',
                style: GoogleFonts.publicSans(
                  fontSize: isDesktop ? 64 : 40,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                  letterSpacing: -1.0,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: isDesktop ? 800 : double.infinity,
                child: Text(
                  'A unified digital bridge for citizen grievance redressal, engineered by the National Informatics Centre (NIC) to foster a responsive and transparent governance ecosystem.',
                  style: GoogleFonts.inter(
                    fontSize: isDesktop ? 24 : 18,
                    height: 1.6,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMission(bool isDesktop) {
    return Container(
      width: double.infinity,
      color: AppColors.surfaceContainerLow,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64 : 24,
        vertical: isDesktop ? 120 : 64,
      ),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: _missionText()),
                const SizedBox(width: 80),
                Expanded(child: _missionImage()),
              ],
            )
          : Column(
              children: [
                _missionText(),
                const SizedBox(height: 48),
                _missionImage(),
              ],
            ),
    );
  }

  Widget _missionText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Mission',
          style: GoogleFonts.publicSans(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
          ),
        ),
        Text(
          'हमारा मिशन',
          style: GoogleFonts.publicSans(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'To empower every citizen with a direct, accountable, and digitally sovereign voice. We aim to bridge the functional gap between public concerns and government departments through cutting-edge technological intervention.',
          style: GoogleFonts.inter(
            fontSize: 18,
            height: 1.6,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 48),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.tertiaryFixed,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.handshake, color: AppColors.onTertiaryFixedVariant),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Citizen Empowerment',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Giving power back to the people through direct access.',
                    style: GoogleFonts.inter(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _missionImage() {
    return Container(
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuC4cZE0K2m6MIJmCcn5t38x1SGKfW-L-JUAdroHEKK_783rIXQHBybyUC3-w2DDoQ7MAv5Z1PpHdqZUKhwgbCbl-ApJmIDWIKqPRgvMN6D2fmiIdr02WmZyUNTZDWzFsZklm36Phk4OE_Hby2NU2MPYSnAyNfSb2fb162MSzaR8Hkw5irHgXBdhLXv2RDF82d2e7PunGJFa2GtsKv-ASNJ0yPsCtxTyNIPtKr5N1F5G79llHomwwMNHr-LcihYEHOaLz64L9aKO1w'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildCoreValues(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64 : 24,
        vertical: isDesktop ? 120 : 64,
      ),
      child: Column(
        children: [
          Text(
            'Core Values',
            style: GoogleFonts.publicSans(
              fontSize: isDesktop ? 48 : 36,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurface,
            ),
          ),
          Text(
            'मुख्य मूल्य',
            style: GoogleFonts.publicSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 64),
          isDesktop
              ? Row(
                  children: [
                    Expanded(child: _valueCard('Transparency', 'पारदर्शिता', 'Every step of your grievance journey is visible, trackable, and verifiable in real-time.', Icons.visibility, false)),
                    const SizedBox(width: 32),
                    Expanded(child: _valueCard('Accountability', 'जवाबदेही', 'Direct departmental ownership ensures that every concern is addressed within mandated timelines.', Icons.verified_user, true)),
                    const SizedBox(width: 32),
                    Expanded(child: _valueCard('Accessibility', 'सुगम्यता', 'Designing for all citizens, ensuring linguistic and physical barriers never stand in the way of justice.', Icons.accessibility_new, false)),
                  ],
                )
              : Column(
                  children: [
                    _valueCard('Transparency', 'पारदर्शिता', 'Every step of your grievance journey is visible, trackable, and verifiable in real-time.', Icons.visibility, false),
                    const SizedBox(height: 32),
                    _valueCard('Accountability', 'जवाबदेही', 'Direct departmental ownership ensures that every concern is addressed within mandated timelines.', Icons.verified_user, true),
                    const SizedBox(height: 32),
                    _valueCard('Accessibility', 'सुगम्यता', 'Designing for all citizens, ensuring linguistic and physical barriers never stand in the way of justice.', Icons.accessibility_new, false),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _valueCard(String title, String subtitle, String text, IconData icon, bool isHighlighted) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: isHighlighted ? AppColors.primary : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: isHighlighted ? null : Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
        boxShadow: isHighlighted ? [const BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 48,
            color: isHighlighted ? AppColors.onPrimary : AppColors.primary,
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: GoogleFonts.publicSans(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: isHighlighted ? AppColors.onPrimary : AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isHighlighted ? AppColors.onPrimary.withValues(alpha: 0.8) : AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            text,
            style: GoogleFonts.inter(
              height: 1.6,
              color: isHighlighted ? AppColors.onPrimary.withValues(alpha: 0.9) : AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactStats(bool isDesktop) {
    return Container(
      width: double.infinity,
      color: AppColors.surfaceContainerHighest,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64 : 24,
        vertical: 80,
      ),
      child: isDesktop
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statItem('12M+', 'Resolved Grievances', 'सुलझाई गई शिकायतें'),
                _statItem('750+', 'Districts Covered', 'कवर किए गए जिले'),
                _statItem('98%', 'Satisfaction Rate', 'संतुष्टि दर'),
                _statItem('24/7', 'Active Monitoring', 'सक्रिय निगरानी'),
              ],
            )
          : Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _statItem('12M+', 'Resolved Grievances', 'सुलझाई गई शिकायतें')),
                    Expanded(child: _statItem('750+', 'Districts Covered', 'कवर किए गए जिले')),
                  ],
                ),
                const SizedBox(height: 48),
                Row(
                  children: [
                    Expanded(child: _statItem('98%', 'Satisfaction Rate', 'संतुष्टि दर')),
                    Expanded(child: _statItem('24/7', 'Active Monitoring', 'सक्रिय निगरानी')),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _statItem(String value, String title, String subtitle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: GoogleFonts.publicSans(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStakeholders(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64 : 24,
        vertical: isDesktop ? 120 : 80,
      ),
      child: Column(
        children: [
          Text(
            'Key Stakeholders',
            style: GoogleFonts.publicSans(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurface,
            ),
          ),
          Text(
            'प्रमुख हितधारक',
            style: GoogleFonts.publicSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 64),
          Wrap(
            spacing: 64,
            runSpacing: 48,
            alignment: WrapAlignment.center,
            children: [
              _stakeholderItem(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDBF2hIjrduNAMkYdIXnomU-9jocxFTP-_SVRA2-bOohF1EyjP6TxHZckHmvFArFgzC2EU5SuLrmtz6BJRwu62JeHiYYDdtsJO0FyW_FYcw2yxOjB_eTtTy24ChC5Q6YsqGL0X-DoqvVUNSKe8F-Uy6xncZOfT-_vujyywo84mhlg9gheWQ3P1e2YR9f_Fdnj7q-p4QoN49MRfckib78flHIo9acIyMyjTlmGZb7SEk8rHEvtfqP0xTISxJ1oq7TxRy7CBaupvcxQ',
                'National Informatics Centre',
              ),
              _stakeholderItem(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDv4EQuCw5WLMnrk26qX7Kio86GfAwWGnr6FKPfMC7S7_ceLu7AbPnLAp5-4IVdivveuOZlYF-fE8VOju3QaiGt_mCEAj3uf-ePuNe1n3We9cSYTC0_m1grNYvgUQlsGFmkZc6wYIy5k3vMYaXQHuMCB6haseKMpHvx5Q_8vVjOYF6niNyV6jYCvjztgVgSBUcRFugBw9L1eymJnZ2syoY6bGqTdVhwPG1XO5r_bxYwZu1d6_DrREKEV6Y-Madl62_jnmEqg6uHJQ',
                'Digital India',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stakeholderItem(String imageUrl, String label) {
    return Column(
      children: [
        SizedBox(
          height: 80,
          child: Image.network(imageUrl, fit: BoxFit.contain),
        ),
        const SizedBox(height: 16),
        Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildCTA(BuildContext context, bool isDesktop) {
    return Padding(
      padding: EdgeInsets.fromLTRB(isDesktop ? 64 : 24, 0, isDesktop ? 64 : 24, isDesktop ? 128 : 80),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isDesktop ? 64 : 32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryContainer],
          ),
        ),
        child: Column(
          children: [
            Text(
              'Experience Better Governance',
              style: GoogleFonts.publicSans(
                fontSize: isDesktop ? 36 : 28,
                fontWeight: FontWeight.w900,
                color: AppColors.onPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              'Join millions of citizens who are shaping the future of India through active participation and constructive feedback.',
              style: GoogleFonts.inter(
                fontSize: isDesktop ? 20 : 16,
                color: AppColors.onPrimary.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register-complaint');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryContainer,
                foregroundColor: AppColors.onSecondaryContainer,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 10,
              ),
              child: Text(
                'Register Your Grievance / शिकायत दर्ज करें',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
