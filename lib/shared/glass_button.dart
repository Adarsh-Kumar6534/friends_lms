import 'package:flutter/material.dart';
import 'glass_container.dart';

class GlassButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double? width;
  final double? height;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const GlassButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
          child: GlassContainer(
            width: widget.width,
            height: widget.height,
            borderRadius: widget.borderRadius ?? 12,
            padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            opacity: _isHovered ? 0.15 : 0.1,
            child: Center(child: widget.child),
          ),
        ),
      ),
    );
  }
}
