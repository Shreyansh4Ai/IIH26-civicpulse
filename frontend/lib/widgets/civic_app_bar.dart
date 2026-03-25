import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../utils/responsive_helper.dart';

/// Reusable top app-bar matching the frosted-glass header in the HTML designs.
/// Adapts between mobile (compact) and desktop (full nav) layouts.
class CivicAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CivicAppBar({
    super.key,
    this.showBackArrow = false,
    this.showMenuIcon = false,
    this.showAvatar = false,
    this.subtitle,
    this.navLinks,
    this.onBack,
    this.onMenu,
    this.backgroundColor,
    this.brandColor,
    this.showProfileButton = true,
    this.showLoginButton = true,
    this.showDashboardButton = true,
  });

  final bool showBackArrow;
  final bool showMenuIcon;
  final bool showAvatar;
  final String? subtitle;
  final List<String>? navLinks;
  final VoidCallback? onBack;
  final VoidCallback? onMenu;
  final Color? backgroundColor;
  final Color? brandColor;
  final bool showProfileButton;
  final bool showLoginButton;
  final bool showDashboardButton;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final useCompactActions = !isDesktop && screenWidth < 430;
    final bgColor = backgroundColor ?? AppColors.surfaceContainerHighest;
    final textColor = brandColor ?? AppColors.primary;

    return Container(
      height: 64 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.85),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 24),
        child: Row(
          children: [
            // Left side
            if (showMenuIcon && !isDesktop)
              GestureDetector(
                onTap: onMenu ?? () => Scaffold.of(context).openDrawer(),
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(Icons.menu, color: textColor, size: 24),
                ),
              ),
            if (showBackArrow)
              GestureDetector(
                onTap: onBack ?? () => Navigator.of(context).pop(),
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(Icons.arrow_back, color: textColor, size: 24),
                ),
              ),
            Flexible(
              child: Text(
                'Civic Pulse',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.publicSans(
                  fontSize: isDesktop ? 24 : 20,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            if (subtitle != null && isDesktop) ...[
              Container(
                width: 1,
                height: 24,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: AppColors.outlineVariant.withValues(alpha: 0.3),
              ),
              Text(
                subtitle!,
                style: GoogleFonts.publicSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface.withValues(alpha: 0.7),
                  letterSpacing: 2,
                ),
              ),
            ],
            const Spacer(),
            if (useCompactActions)
              _headerActionsMenu(context)
            else ...[
              if (showProfileButton) ...[
                _headerActionButton(
                  context,
                  label: 'Profile',
                  onPressed: () =>
                      Navigator.pushNamed(context, '/complete-profile'),
                  isDesktop: isDesktop,
                ),
                SizedBox(width: isDesktop ? 12 : 8),
              ],
              if (showLoginButton) ...[
                _headerActionButton(
                  context,
                  label: 'Login',
                  onPressed: () => Navigator.pushNamed(context, '/'),
                  isDesktop: isDesktop,
                ),
                SizedBox(width: isDesktop ? 12 : 8),
              ],
              if (showDashboardButton)
                _headerActionButton(
                  context,
                  label: 'Dashboard',
                  onPressed: () => Navigator.pushNamed(
                    context,
                    _resolveDashboardRoute(context),
                  ),
                  isDesktop: isDesktop,
                ),
            ],
            if (showAvatar && !useCompactActions) ...[
              const SizedBox(width: 12),
              Container(
                width: isDesktop ? 36 : 30,
                height: isDesktop ? 36 : 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceContainerHighest,
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.person,
                  size: isDesktop ? 18 : 14,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _headerActionsMenu(BuildContext context) {
    final items = <PopupMenuEntry<String>>[];
    if (showProfileButton) {
      items.add(
        const PopupMenuItem<String>(value: 'profile', child: Text('Profile')),
      );
    }
    if (showLoginButton) {
      items.add(
        const PopupMenuItem<String>(value: 'login', child: Text('Login')),
      );
    }
    if (showDashboardButton) {
      items.add(
        const PopupMenuItem<String>(
          value: 'dashboard',
          child: Text('Dashboard'),
        ),
      );
    }
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return PopupMenuButton<String>(
      tooltip: 'Actions',
      onSelected: (value) {
        if (value == 'profile') {
          Navigator.pushNamed(context, '/complete-profile');
        } else if (value == 'login') {
          Navigator.pushNamed(context, '/');
        } else if (value == 'dashboard') {
          Navigator.pushNamed(context, _resolveDashboardRoute(context));
        }
      },
      itemBuilder: (_) => items,
      icon: Icon(Icons.more_vert, color: AppColors.primary),
    );
  }

  static String _resolveDashboardRoute(BuildContext context) {
    final routeName = ModalRoute.of(context)?.settings.name ?? '';
    if (routeName.startsWith('/officer')) {
      return '/officer-dashboard';
    }
    return '/citizen-dashboard';
  }

  static Widget _headerActionButton(
    BuildContext context, {
    required String label,
    required VoidCallback onPressed,
    required bool isDesktop,
  }) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 14 : 10,
          vertical: isDesktop ? 8 : 6,
        ),
        textStyle: GoogleFonts.publicSans(
          fontSize: isDesktop ? 13 : 12,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(label),
    );
  }
}
