import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// Bottom navigation bar for mobile dashboard views.
class CivicBottomNav extends StatelessWidget {
  const CivicBottomNav({super.key, this.activeIndex = 0, this.onTap});

  final int activeIndex;
  final ValueChanged<int>? onTap;

  static const _items = <(IconData, String)>[
    (Icons.grid_view, 'Dashboard'),
    (Icons.add_box_outlined, 'Register'),
    (Icons.analytics_outlined, 'Track'),
    (Icons.account_circle, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _items.asMap().entries.map((e) {
          final isActive = e.key == activeIndex;
          return GestureDetector(
            onTap: () => onTap?.call(e.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    e.value.$1,
                    color: isActive
                        ? Colors.white
                        : AppColors.onSurface.withValues(alpha: 0.7),
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    e.value.$2,
                    style: GoogleFonts.publicSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isActive
                          ? Colors.white
                          : AppColors.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
