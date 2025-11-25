import 'package:flutter/material.dart';
import 'glass_container.dart';

class HoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const HoverCard({
    super.key,
    required this.child,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()
            ..scale(_isHovered ? 1.02 : 1.0)
            ..translate(0.0, _isHovered ? -5.0 : 0.0),
          child: GlassContainer(
            width: widget.width,
            height: widget.height,
            opacity: _isHovered ? 0.1 : 0.05,
            border: Border.all(
              color: Colors.white.withOpacity(_isHovered ? 0.2 : 0.1),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
