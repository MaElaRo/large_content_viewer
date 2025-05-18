import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Defines the visual properties for the [LargeContentViewer]'s popup.
///
/// Used by [LargeContentViewerTheme] to control the appearance of the popup.
/// All properties are nullable, which means they will fall back to default values
/// derived from the current [ThemeData] when not specified.
///
/// Example:
/// ```dart
/// LargeContentViewerThemeData(
///   backgroundColor: Colors.blueGrey.withOpacity(0.9),
///   elevation: 12.0,
///   borderRadius: BorderRadius.circular(16.0),
///   padding: EdgeInsets.all(20.0),
///   contentScaleFactor: 2.5,
///   textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
/// )
/// ```
@immutable
class LargeContentViewerThemeData with Diagnosticable {
  /// The background color of the popup.
  ///
  /// If null, it defaults to `colorScheme.surface` with 85% opacity.
  final Color? backgroundColor;

  /// The elevation of the popup.
  ///
  /// Controls the size of the shadow below the popup.
  /// If null, it defaults to 20.0.
  final double? elevation;

  /// The border radius of the popup.
  ///
  /// If null, it defaults to a circular radius of 16.0.
  final BorderRadiusGeometry? borderRadius;

  /// The padding inside the popup.
  ///
  /// If null, it defaults to `EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0)`.
  final EdgeInsetsGeometry? padding;

  /// The constraints for the size of the popup.
  ///
  /// If null, it defaults to `min/maxWidth: 150/300, min/maxHeight: 80/300`.
  final BoxConstraints? constraints;

  /// The default text style for content within the popup.
  ///
  /// If null, it defaults to the current theme's bodyLarge with onSurface color.
  final TextStyle? textStyle;

  /// The default icon theme for icons within the popup.
  ///
  /// If null, it defaults to the current theme's onSurface color with size 32.
  final IconThemeData? iconTheme;

  /// How much to scale the `child` in the popup if `customOverlayChild` is null.
  /// This overrides the `scaleFactor` property of the [LargeContentViewer] widget
  /// if provided.
  ///
  /// If null, it defaults to 2.0, making content twice as large in the popup.
  final double? contentScaleFactor;

  /// Creates a theme data for [LargeContentViewerTheme].
  const LargeContentViewerThemeData({
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.padding,
    this.constraints,
    this.textStyle,
    this.iconTheme,
    this.contentScaleFactor,
  });

  /// Creates a copy of this theme data but with the given fields replaced with
  /// the new values.
  ///
  /// This is useful for creating derived themes with only a few differences
  /// from the original theme.
  LargeContentViewerThemeData copyWith({
    Color? backgroundColor,
    double? elevation,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? padding,
    BoxConstraints? constraints,
    TextStyle? textStyle,
    IconThemeData? iconTheme,
    double? contentScaleFactor,
  }) {
    return LargeContentViewerThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      elevation: elevation ?? this.elevation,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      constraints: constraints ?? this.constraints,
      textStyle: textStyle ?? this.textStyle,
      iconTheme: iconTheme ?? this.iconTheme,
      contentScaleFactor: contentScaleFactor ?? this.contentScaleFactor,
    );
  }

  /// Linearly interpolates between two [LargeContentViewerThemeData].
  static LargeContentViewerThemeData lerp(LargeContentViewerThemeData? a,
      LargeContentViewerThemeData? b, double t) {
    return LargeContentViewerThemeData(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      elevation: lerpDouble(a?.elevation, b?.elevation, t),
      borderRadius:
          BorderRadiusGeometry.lerp(a?.borderRadius, b?.borderRadius, t),
      padding: EdgeInsetsGeometry.lerp(a?.padding, b?.padding, t),
      constraints: BoxConstraints.lerp(a?.constraints, b?.constraints, t),
      textStyle: TextStyle.lerp(a?.textStyle, b?.textStyle, t),
      iconTheme: IconThemeData.lerp(a?.iconTheme, b?.iconTheme, t),
      contentScaleFactor:
          lerpDouble(a?.contentScaleFactor, b?.contentScaleFactor, t),
    );
  }

  @override
  int get hashCode => Object.hash(
        backgroundColor,
        elevation,
        borderRadius,
        padding,
        constraints,
        textStyle,
        iconTheme,
        contentScaleFactor,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is LargeContentViewerThemeData &&
        other.backgroundColor == backgroundColor &&
        other.elevation == elevation &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.constraints == constraints &&
        other.textStyle == textStyle &&
        other.iconTheme == iconTheme &&
        other.contentScaleFactor == contentScaleFactor;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        ColorProperty('backgroundColor', backgroundColor, defaultValue: null));
    properties.add(DoubleProperty('elevation', elevation, defaultValue: null));
    properties.add(DiagnosticsProperty<BorderRadiusGeometry>(
        'borderRadius', borderRadius,
        defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<BoxConstraints>(
        'constraints', constraints,
        defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>('textStyle', textStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty<IconThemeData>('iconTheme', iconTheme,
        defaultValue: null));
    properties.add(DoubleProperty('contentScaleFactor', contentScaleFactor,
        defaultValue: null));
  }
}

/// An inherited widget that defines the configuration for
/// [LargeContentViewer]s in this widget's subtree.
///
/// Values specified here are used for [LargeContentViewer] properties that are not
/// overridden explicitly. This allows for consistent styling of all large content
/// viewers in a section of your app.
///
/// Example usage:
/// ```dart
/// LargeContentViewerTheme(
///   data: LargeContentViewerThemeData(
///     backgroundColor: Colors.teal.withOpacity(0.9),
///     contentScaleFactor: 2.5,
///     borderRadius: BorderRadius.circular(20),
///   ),
///   child: Column(
///     children: [
///       // These LargeContentViewers will use the theme above
///       LargeContentViewer(child: IconButton(...)),
///       LargeContentViewer(child: TextButton(...)),
///     ],
///   ),
/// )
/// ```
class LargeContentViewerTheme extends InheritedTheme {
  /// The data from the closest [LargeContentViewerTheme] instance that encloses
  /// the given context.
  ///
  /// This configures how [LargeContentViewer] widgets in this subtree should look.
  final LargeContentViewerThemeData data;

  /// Creates a theme that controls the appearance of [LargeContentViewer]s.
  ///
  /// Both [data] and [child] arguments are required.
  const LargeContentViewerTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The data from the closest instance of this class that encloses the given
  /// context.
  ///
  /// If there is no [LargeContentViewerTheme] in scope, this will return null.
  /// Consider using [LargeContentViewerTheme.of(context)] to get a
  /// [LargeContentViewerThemeData] with default fallbacks.
  ///
  /// This method is useful when you need to explicitly handle the case where
  /// no theme is available.
  static LargeContentViewerThemeData? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<LargeContentViewerTheme>()
        ?.data;
  }

  /// The data from the closest instance of this class that encloses the given
  /// context.
  ///
  /// If there is no [LargeContentViewerTheme] in scope, this will return a
  /// default [LargeContentViewerThemeData] with values derived from the current
  /// [ThemeData].
  ///
  /// See also:
  ///
  ///  * [maybeOf], which returns null if no theme is found instead of a default theme.
  static LargeContentViewerThemeData of(BuildContext context) {
    final LargeContentViewerTheme? theme =
        context.dependOnInheritedWidgetOfExactType<LargeContentViewerTheme>();
    // If no theme is found, construct defaults based on the current ThemeData
    return theme?.data ?? const LargeContentViewerThemeData();
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return LargeContentViewerTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(LargeContentViewerTheme oldWidget) =>
      data != oldWidget.data;
}
