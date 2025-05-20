library large_content_viewer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:large_content_viewer/src/large_content_viewer_theme.dart';

/// A widget that displays a magnified version of its child in a popup overlay
/// when the user long-presses it.
///
/// This mimics the behavior of the iOS Large Content Viewer, primarily used for
/// accessibility purposes. It shows a scaled view ([scaleFactor]) of the
/// [child] or an optional [customOverlayChild] in an overlay positioned centrally
/// on the screen.
///
/// The Large Content Viewer is particularly helpful for users with visual impairments,
/// as it makes small UI elements more visible on demand. It's activated by a long press,
/// which triggers a haptic feedback and displays the enlarged content.
///
/// The appearance of the popup can be customized using [LargeContentViewerTheme].
///
/// Example usage:
/// ```dart
/// LargeContentViewer(
///   child: IconButton(
///     icon: Icon(Icons.favorite),
///     onPressed: () {},
///   ),
///   scaleFactor: 2.5,
/// )
/// ```
///
/// For more complex popups, use [customOverlayChild]:
/// ```dart
/// LargeContentViewer(
///   child: TextButton(
///     child: Text('Settings'),
///     onPressed: () {},
///   ),
///   customOverlayChild: Row(
///     mainAxisSize: MainAxisSize.min,
///     children: [
///       Icon(Icons.settings, size: 32),
///       SizedBox(width: 8),
///       Text('Settings', style: TextStyle(fontSize: 24)),
///     ],
///   ),
/// )
/// ```

class LargeContentViewer extends StatefulWidget {
  /// Creates a LargeContentViewer widget.
  ///
  /// The [child] argument must not be null.
  const LargeContentViewer({
    super.key,
    required this.child,
    this.customOverlayChild,
    this.scaleFactor = 2.0,
  });

  /// The widget below this widget in the tree.
  /// This is the widget that will be long-pressed to show the popup.
  /// If [customOverlayChild] is null, a scaled version of this [child] will be shown
  /// in the popup.
  final Widget child;

  /// An optional widget to display in the popup instead of the scaled [child].
  /// If provided, this widget will be shown as is within the popup, without
  /// applying the [scaleFactor].
  ///
  /// This is useful for creating more complex or completely custom popup content
  /// that differs from the child widget.
  final Widget? customOverlayChild;

  /// How much to scale the [child] in the popup when [customOverlayChild] is null.
  /// This value is overridden by [LargeContentViewerThemeData.contentScaleFactor]
  /// if a theme is provided.
  ///
  /// Defaults to 2.0, which means the child will appear twice as large in the popup.
  final double scaleFactor;

  @override
  State<LargeContentViewer> createState() => _LargeContentViewerState();
}

// Manages the state for [LargeContentViewer].
// This includes handling the overlay entry for the popup.
class _LargeContentViewerState extends State<LargeContentViewer> {
  OverlayEntry? _overlayEntry;

  // Shows the popup overlay.
  // Creates and inserts an [OverlayEntry] containing the [_OverlayContent].
  // Haptic feedback is triggered. If an overlay is already visible,
  // this method does nothing.
  void _showPopup(BuildContext context) {
    if (_overlayEntry != null) {
      return;
    }

    HapticFeedback.mediumImpact();

    final themeData = LargeContentViewerTheme.of(context);

    final double effectiveScaleFactor =
        themeData.contentScaleFactor ?? widget.scaleFactor;

    _overlayEntry = OverlayEntry(
      builder: (overlayContext) {
        return _OverlayContent(
          customOverlayChild: widget.customOverlayChild,
          scaleFactor: effectiveScaleFactor,
          themeData: themeData,
          child: widget.child,
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  // Hides the popup overlay.
  // Removes the [OverlayEntry] if it exists.
  void _hidePopup() {
    // debugPrint("LCV: _hidePopup called");
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
      excludeFromSemantics: true,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _hidePopup();
    super.dispose();
  }
}

// The content widget displayed in the overlay popup.
// This widget is responsible for rendering the actual content of the popup,
// which is either a scaled version of the original [LargeContentViewer.child]
// or the custom [LargeContentViewer.customOverlayChild]. It applies styling from
// [LargeContentViewerThemeData].
class _OverlayContent extends StatelessWidget {
  // Creates the content for the overlay.
  const _OverlayContent({
    required this.child,
    this.customOverlayChild,
    required this.scaleFactor,
    required this.themeData,
  });

  // The original child widget from [LargeContentViewer].
  // Used if [customOverlayChild] is null.
  final Widget child;

  // The custom child widget for the overlay from [LargeContentViewer.customOverlayChild].
  // If null, [child] is scaled by [scaleFactor].
  final Widget? customOverlayChild;

  // The factor by which to scale [child] if [customOverlayChild] is null.
  final double scaleFactor;

  // The theme data to use for styling the overlay.
  final LargeContentViewerThemeData themeData;

  @override
  Widget build(BuildContext context) {
    final Widget effectiveContent = customOverlayChild ??
        Transform.scale(
          scale: scaleFactor,
          alignment: Alignment.center,
          child: child,
        );

    final mainTheme = Theme.of(context);
    final colors = mainTheme.colorScheme;
    final textTheme = mainTheme.textTheme;

    final effectiveBackgroundColor =
        themeData.backgroundColor ?? colors.surface.withValues(alpha: 0.85);

    final effectiveElevation = themeData.elevation ?? 20.0;

    final effectiveBorderRadius =
        themeData.borderRadius ?? BorderRadius.circular(16.0);

    final effectivePadding = themeData.padding ??
        const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0);

    final effectiveConstraints = themeData.constraints;
    final effectiveTextStyle = themeData.textStyle ??
        textTheme.bodyLarge!.copyWith(
          color: colors.onSurface,
          fontWeight: FontWeight.w500,
        );

    final effectiveIconTheme = themeData.iconTheme ??
        IconThemeData(
          color: colors.onSurface,
          size: 32,
        );

    return Center(
      child: Material(
        color: effectiveBackgroundColor,
        elevation: effectiveElevation,
        borderRadius: effectiveBorderRadius,
        child: Container(
          constraints: effectiveConstraints,
          child: Padding(
            padding: effectivePadding,
            child: DefaultTextStyle(
              style: effectiveTextStyle,
              child: IconTheme(
                data: effectiveIconTheme,
                child: effectiveContent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
