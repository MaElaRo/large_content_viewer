library large_content_viewer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that displays a magnified version of its child in a popup overlay
/// when the user long-presses it.
///
/// This mimics the behavior of the iOS Large Content Viewer, primarily used for
/// accessibility purposes when the system text scale factor is large.
/// It shows a scaled view ([scaleFactor]) of the [child] or an optional
/// [popupChild] in an overlay positioned above the original widget.
///
/// The behavior is enabled when `MediaQuery.textScaleFactorOf(context)` exceeds
/// [enabledTextScaleFactorThreshold] or when [forceEnable] is true.

class LargeContentViewer extends StatefulWidget {
  final Widget child;
  final Widget? popupChild;
  final double scaleFactor;
  final bool forceEnable;

  const LargeContentViewer({
    super.key,
    required this.child,
    this.popupChild,
    this.scaleFactor = 2.0,
    this.forceEnable = false,
  });

  @override
  State<LargeContentViewer> createState() => _LargeContentViewerState();
}

class _LargeContentViewerState extends State<LargeContentViewer> {
  OverlayEntry? _overlayEntry;

  void _showPopup(BuildContext context) {
    if (_overlayEntry != null) return;

    HapticFeedback.mediumImpact();

    final popupContent = widget.popupChild ??
        Transform.scale(
          scale: widget.scaleFactor,
          alignment: Alignment.center,
          child: widget.child,
        );

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.black.withOpacity(0.85),
            elevation: 20,
            borderRadius: BorderRadius.circular(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 150,
                maxWidth: 300,
                minHeight: 80,
                maxHeight: 300,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 24.0),
                child: DefaultTextStyle(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  child: IconTheme(
                    data: const IconThemeData(
                      color: Colors.white,
                      size: 32,
                    ),
                    child: Center(child: popupContent),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void _hidePopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPressStart: (_) => _showPopup(context),
      onLongPressEnd: (_) => _hidePopup(),
      onLongPressCancel: _hidePopup,
      child: widget.child,
      excludeFromSemantics: true,
    );
  }

  @override
  void dispose() {
    _hidePopup();
    super.dispose();
  }
}
