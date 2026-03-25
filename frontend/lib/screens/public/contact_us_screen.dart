import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/civic_app_bar.dart';
import '../../widgets/civic_footer.dart';
import '../../theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

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
            _buildContactCards(isDesktop),
            _buildFormAndMap(isDesktop),
            const CivicFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(isDesktop ? 64 : 24, 80, isDesktop ? 64 : 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Us',
            style: GoogleFonts.publicSans(
              fontSize: isDesktop ? 80 : 48,
              fontWeight: FontWeight.w900,
              height: 1.1,
              letterSpacing: -1.5,
              color: AppColors.onSurface,
            ),
          ),
          Text(
            'हमसे संपर्क करें',
            style: GoogleFonts.publicSans(
              fontSize: isDesktop ? 64 : 40,
              fontWeight: FontWeight.w900,
              height: 1.1,
              letterSpacing: -1.0,
              color: AppColors.primaryContainer,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: isDesktop ? 800 : double.infinity,
            child: Text(
              'Connecting citizens with governance. Reach out to our dedicated departments for assistance, technical support, or to voice your concerns.',
              style: GoogleFonts.inter(
                fontSize: isDesktop ? 24 : 18,
                height: 1.6,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCards(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.fromLTRB(isDesktop ? 64 : 24, 0, isDesktop ? 64 : 24, 80),
      child: isDesktop
          ? IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _contactCard('General Enquiries', 'सामान्य पूछताछ', Icons.call, AppColors.primaryFixed, AppColors.onPrimaryFixed, [
                    _infoItem('Phone / फोन', '+91 9993671926'),
                    _infoItem('Email / ईमेल', 'doorvisahu02@gmail.com'),
                  ])),
                  const SizedBox(width: 32),
                  Expanded(child: _contactCard('Technical Support', 'तकनीकी सहायता', Icons.terminal, AppColors.tertiaryFixed, AppColors.onTertiaryFixed, [
                    _infoItem('NIC Help Desk / एनआईसी हेल्प डेस्क', '1800 111 555'),
                    _infoItem('Support Portal / सहायता पोर्टल', 'helpdesk.nic.in'),
                  ])),
                  const SizedBox(width: 32),
                  Expanded(child: _contactCard('Grievance Redressal', 'शिकायत निवारण', Icons.gavel, AppColors.secondaryFixed, AppColors.onSecondaryFixed, [
                    _infoItem('Nodal Officer / नोडल अधिकारी', 'Shri R. K. Sharma'),
                    _infoItem('Official Address / आधिकारिक पता', 'Room 402, Ministry of Electronics & IT'),
                  ])),
                ],
              ),
            )
          : Column(
              children: [
                _contactCard('General Enquiries', 'सामान्य पूछताछ', Icons.call, AppColors.primaryFixed, AppColors.onPrimaryFixed, [
                  _infoItem('Phone / फोन', '+91 9993671926'),
                  _infoItem('Email / ईमेल', 'doorvisahu02@gmail.com'),
                ]),
                const SizedBox(height: 32),
                _contactCard('Technical Support', 'तकनीकी सहायता', Icons.terminal, AppColors.tertiaryFixed, AppColors.onTertiaryFixed, [
                  _infoItem('NIC Help Desk / एनआईसी हेल्प डेस्क', '1800 111 555'),
                  _infoItem('Support Portal / सहायता पोर्टल', 'helpdesk.nic.in'),
                ]),
                const SizedBox(height: 32),
                _contactCard('Grievance Redressal', 'शिकायत निवारण', Icons.gavel, AppColors.secondaryFixed, AppColors.onSecondaryFixed, [
                  _infoItem('Nodal Officer / नोडल अधिकारी', 'Shri R. K. Sharma'),
                  _infoItem('Official Address / आधिकारिक पता', 'Room 402, Ministry of Electronics & IT'),
                ]),
              ],
            ),
    );
  }

  Widget _contactCard(String title, String subtitle, IconData icon, Color iconBgColor, Color iconColor, List<Widget> items) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 32),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: GoogleFonts.publicSans(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 32),
          ...items.expand((item) => [item, const SizedBox(height: 16)]),
        ],
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildFormAndMap(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.fromLTRB(isDesktop ? 64 : 24, 0, isDesktop ? 64 : 24, 80),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 7, child: _buildForm()),
                const SizedBox(width: 64),
                Expanded(flex: 5, child: _buildMapSection()),
              ],
            )
          : Column(
              children: [
                _buildForm(),
                const SizedBox(height: 64),
                _buildMapSection(),
              ],
            ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Send us a Message',
            style: GoogleFonts.publicSans(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          Text(
            'हमें संदेश भेजें',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 500) {
                return Row(
                  children: [
                    Expanded(child: _formField('FULL NAME / पूरा नाम', 'Enter your name')),
                    const SizedBox(width: 32),
                    Expanded(child: _formField('EMAIL ADDRESS / ईमेल पता', 'email@example.gov.in')),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _formField('FULL NAME / पूरा नाम', 'Enter your name'),
                    const SizedBox(height: 32),
                    _formField('EMAIL ADDRESS / ईमेल पता', 'email@example.gov.in'),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 32),
          _formField('SUBJECT / विषय', 'How can we help you?'),
          const SizedBox(height: 32),
          _formField('MESSAGE / संदेश', 'Write your message here...', maxLines: 5),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryContainer,
              foregroundColor: AppColors.onSecondaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.send),
            label: Text(
              'SUBMIT MESSAGE / संदेश भेजें',
              style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formField(String label, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildMapSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Office Locations',
                style: GoogleFonts.publicSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                'कार्यालय स्थान',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on, color: AppColors.primaryContainer, size: 32),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'National Informatics Centre (NIC)',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'A-Block, CGO Complex, Lodhi Road,\nNew Delhi - 110003, India',
                          style: GoogleFonts.inter(
                            height: 1.6,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.surfaceDim,
                  image: const DecorationImage(
                    image: NetworkImage(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuBk-wicxaVdFVcSKoPJ6MacZF4n77PGjBecJClBmdTyJrEhKe_s1f_F1hUTLZGDdBQrBr0GywtIGY7wMCcSQ0qdLy0aUvI9Y6fSO0gZYHIVFofZnh8eDs_RKbr6gO3XTsFVJSG_QLZYk2H957jPSGJLn-KHSDiEJNAsn1330lXtr33n8IRp_hSIzVDWYTl5FVeYfdy5Se60RBASbA8HuhN9Ovu7eyvkgrUDKXFlgGbFKOXmvIfajtTtrCHujLQqgydT0YU1xw7QDg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black45, BlendMode.saturation),
                  ),
                ),
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                  ),
                  child: const Icon(Icons.push_pin, color: AppColors.error, size: 32),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.tertiaryContainer,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              const Icon(Icons.verified_user, color: AppColors.tertiaryFixed, size: 48),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Official Channel',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onTertiary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Always check for .gov.in domain for secure communication.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.onTertiary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
