import 'package:flutter/material.dart';

/// Responsive breakpoint helper matching the Tailwind `md:` (768px) breakpoint.
class ResponsiveHelper {
  ResponsiveHelper._();

  static const double _breakpoint = 768;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < _breakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= _breakpoint;
}
