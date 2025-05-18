<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Large Content Viewer

A Flutter widget that mimics the iOS Large Content Viewer behavior, showing a
magnified view of its child on long-press. This is particularly useful for
improving accessibility when the system's text scale factor is increased.

Works on both iOS and Android.

[![Pub Version](https://img.shields.io/pub/v/large_content_viewer)](https://pub.dev/packages/large_content_viewer) <!-- Optional: Update if you publish -->
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

*   Wraps any widget (`child`).
*   Activates on long-press when `MediaQuery.textScaleFactor` exceeds a `enabledTextScaleFactorThreshold` (default: 1.2) or when `forceEnable` is true.
*   Shows a styled, magnified popup above the `child`.
*   Popup content can be a scaled version of the `child` (controlled by `scaleFactor`) or a custom `popupChild` widget.
*   Smooth fade and scale animations for popup appearance/disappearance.
*   Configurable background color, border radius, elevation, and vertical offset.
*   Includes haptic feedback on activation.
*   Lightweight and dependency-free (uses only Flutter SDK components).

## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  large_content_viewer: ^latest # Or specify a version
```

Then import it:

```dart
import 'package:large_content_viewer/large_content_viewer.dart';
```

## Usage

Wrap the widget you want to provide a large content view for with `LargeContentViewer`:

```dart
LargeContentViewer(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: const [
      Icon(Icons.home),
      Text('Home'),
    ],
  ),
  // Optional parameters:
  // enabledTextScaleFactorThreshold: 1.1, // Default: 1.2
  // forceEnable: false,                // Default: false
  // scaleFactor: 2.5,                  // Default: 2.0
  // verticalOffset: -12.0,             // Default: -8.0
  // backgroundColor: Colors.blueGrey,  // Default: Theme-based grey
  // borderRadius: BorderRadius.circular(16.0), // Default: 12.0
  // elevation: 10.0,                   // Default: 8.0
  // animationDuration: const Duration(milliseconds: 200), // Default: 150ms
  // popupChild: MyCustomPopupContent(), // Default: null (uses scaled child)
)
```

See the `example/` directory for a more detailed example using `BottomNavigationBar`.

## Configuration

| Parameter                       | Description                                                                 |
| ------------------------------- | --------------------------------------------------------------------------- |
| `child`                         | **Required.** The widget to wrap.                                           |
| `popupChild`                    | An optional widget to display in the popup instead of the scaled `child`.   |
| `scaleFactor`                   | How much to scale the `child` in the popup (if `popupChild` is null).       |
| `enabledTextScaleFactorThreshold` | Text scale factor threshold to enable the viewer.                           |
| `forceEnable`                   | If true, always enables the viewer regardless of text scale factor.         |
| `backgroundColor`               | Background color of the popup.                                              |
| `borderRadius`                  | Border radius of the popup.                                                 |
| `elevation`                     | Shadow elevation of the popup.                                              |
| `verticalOffset`                | Vertical distance between the child and the popup (negative means above). |
| `animationDuration`             | Duration of the popup's entrance/exit animation.                            |

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
