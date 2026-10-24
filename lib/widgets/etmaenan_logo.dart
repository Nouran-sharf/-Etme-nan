import 'package:flutter/material.dart';

/// The official Etmaenan brand logo widget featuring the white neon calligraphy & ribbon
/// on the soothing Pink October background.
class EtmaenanLogo extends StatelessWidget {
  final double size;
  final double borderRadius;
  final bool showShadow;

  const EtmaenanLogo({
    super.key,
    this.size = 36.0,
    this.borderRadius = 10.0,
    this.showShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'شعار تطبيق اطمئنان الرسمي / Etmaenan Official Logo',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: showShadow
              ? [
                  BoxShadow(
                    color: const Color(0xFF7F55B1).withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          'assets/etmaenan_icon_neon.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
