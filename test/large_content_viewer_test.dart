import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:large_content_viewer/large_content_viewer.dart';
import 'package:flutter/gestures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Helper to pump widget with MaterialApp and a theme
  Future<void> pumpLargeContentViewer(
    WidgetTester tester, {
    required Widget child,
    Widget? customOverlayChild,
    double scaleFactor = 2.0,
    LargeContentViewerThemeData? themeData,
  }) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.6)),
        child: MaterialApp(
          home: LargeContentViewerTheme(
            data: themeData ?? const LargeContentViewerThemeData(),
            child: Scaffold(
              body: Center(
                child: LargeContentViewer(
                  scaleFactor: scaleFactor,
                  customOverlayChild: customOverlayChild,
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Mock haptic feedback
  final List<MethodCall> hapticLog = <MethodCall>[];

  setUp(() {
    hapticLog.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      SystemChannels.platform,
      (MethodCall methodCall) async {
        if (methodCall.method == 'HapticFeedback.vibrate') {
          hapticLog.add(methodCall);
        }
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  Finder findOverlayMaterial() {
    // The overlay is a Material widget. We find it by type.
    // It should be the one that's not part of the main scaffold.
    return find.byType(Material).last;
  }

  group(
    'LargeContentViewer Widget Tests',
    () {
      const testChildKey = Key('testChild');
      final testChildWidget = Container(
        key: testChildKey,
        width: 50,
        height: 50,
        color: Colors.blue,
        child: const Icon(Icons.home, size: 20, key: Key('childIcon')),
      );

      testWidgets(
        'renders child widget',
        (WidgetTester tester) async {
          await pumpLargeContentViewer(tester, child: testChildWidget);
          expect(find.byKey(testChildKey), findsOneWidget);
          expect(find.byKey(const Key('childIcon')), findsOneWidget);
        },
      );

      testWidgets(
        'shows scaled child in overlay on long-press',
        (WidgetTester tester) async {
          await pumpLargeContentViewer(
            tester,
            child: testChildWidget,
            scaleFactor: 3.0,
          );

          final int initialMaterialCount =
              tester.widgetList(find.byType(Material)).length;

          final TestGesture gesture = await tester
              .startGesture(tester.getCenter(find.byKey(testChildKey)));
          await tester
              .pump(kLongPressTimeout + const Duration(milliseconds: 100));
          await tester.pump();

          final int afterLongPressMaterialCount =
              tester.widgetList(find.byType(Material)).length;

          expect(
            afterLongPressMaterialCount,
            initialMaterialCount + 1,
            reason: "Overlay should be visible after long press start and pump",
          );

          final Finder overlayMaterialFinder = findOverlayMaterial();
          expect(overlayMaterialFinder, findsOneWidget);

          final transformFinder = find.descendant(
            of: overlayMaterialFinder,
            matching: find.byType(Transform),
          );
          expect(transformFinder, findsOneWidget);
          final Transform transformWidget =
              tester.widget<Transform>(transformFinder);
          final Matrix4 matrix = transformWidget.transform;
          expect(matrix.storage[0], closeTo(3.0, 0.01)); // ScaleX
          expect(matrix.storage[5], closeTo(3.0, 0.01)); // ScaleY

          expect(
            find.descendant(
              of: transformFinder,
              matching: find.byKey(const Key('childIcon')),
            ),
            findsOneWidget,
          );

          await gesture.up();
          await tester.pumpAndSettle(); // Let it hide

          expect(
            tester.widgetList(find.byType(Material)).length,
            initialMaterialCount,
            reason: "Overlay should be hidden after gesture up",
          );
        },
      );

      testWidgets(
        'shows customOverlayChild in overlay on long-press',
        (WidgetTester tester) async {
          const customOverlayKey = Key('customOverlay');
          final customOverlay = Container(
            key: customOverlayKey,
            width: 100,
            height: 100,
            color: Colors.red,
            child: const Text('Custom'),
          );

          await pumpLargeContentViewer(
            tester,
            child: testChildWidget,
            customOverlayChild: customOverlay,
          );

          final int initialMaterialCount =
              tester.widgetList(find.byType(Material)).length;

          final TestGesture gesture = await tester
              .startGesture(tester.getCenter(find.byKey(testChildKey)));
          await tester
              .pump(kLongPressTimeout + const Duration(milliseconds: 100));
          await tester.pump(); // Allow overlay to build

          final int afterLongPressMaterialCount =
              tester.widgetList(find.byType(Material)).length;

          expect(
            afterLongPressMaterialCount,
            initialMaterialCount + 1,
            reason: "Custom overlay should be visible",
          );

          final Finder overlayMaterialFinder = findOverlayMaterial();
          expect(overlayMaterialFinder, findsOneWidget);

          expect(find.byKey(customOverlayKey), findsOneWidget);
          expect(find.text('Custom'), findsOneWidget);

          final transformFinder = find.descendant(
            of: overlayMaterialFinder,
            matching: find.byType(Transform),
          );
          expect(transformFinder, findsNothing);

          await gesture.up();
          await tester.pumpAndSettle();
          expect(
            tester.widgetList(find.byType(Material)).length,
            initialMaterialCount,
            reason: "Custom overlay should be hidden after gesture up",
          );
        },
      );

      testWidgets(
        'respects widget.scaleFactor for scaled child',
        (WidgetTester tester) async {
          await pumpLargeContentViewer(
            tester,
            child: testChildWidget,
            scaleFactor: 2.5,
          );

          final int initialMaterialCount =
              tester.widgetList(find.byType(Material)).length;
          final TestGesture gesture = await tester
              .startGesture(tester.getCenter(find.byKey(testChildKey)));
          await tester
              .pump(kLongPressTimeout + const Duration(milliseconds: 100));
          await tester.pump(); // Allow overlay to build

          expect(
            tester.widgetList(find.byType(Material)).length,
            initialMaterialCount + 1,
          );

          final Finder overlayMaterialFinder = findOverlayMaterial();
          final Transform transformWidget = tester.widget<Transform>(
            find.descendant(
              of: overlayMaterialFinder,
              matching: find.byType(Transform),
            ),
          );
          final Matrix4 matrix = transformWidget.transform;
          expect(matrix.storage[0], closeTo(2.5, 0.01));
          expect(matrix.storage[5], closeTo(2.5, 0.01));

          // Release gesture
          await gesture.up();
          await tester.pumpAndSettle();
          expect(
            tester.widgetList(find.byType(Material)).length,
            initialMaterialCount,
          );
        },
      );

      testWidgets(
        'respects theme.contentScaleFactor for scaled child',
        (WidgetTester tester) async {
          await pumpLargeContentViewer(
            tester,
            child: testChildWidget,
            scaleFactor: 1.5, // This should be overridden by theme
            themeData:
                const LargeContentViewerThemeData(contentScaleFactor: 3.5),
          );

          final int initialMaterialCount =
              tester.widgetList(find.byType(Material)).length;
          final TestGesture gesture = await tester
              .startGesture(tester.getCenter(find.byKey(testChildKey)));
          await tester
              .pump(kLongPressTimeout + const Duration(milliseconds: 100));
          await tester.pump(); // Allow overlay to build

          expect(
            tester.widgetList(find.byType(Material)).length,
            initialMaterialCount + 1,
          );

          final Finder overlayMaterialFinder = findOverlayMaterial();
          final Transform transformWidget = tester.widget<Transform>(
            find.descendant(
              of: overlayMaterialFinder,
              matching: find.byType(Transform),
            ),
          );
          final Matrix4 matrix = transformWidget.transform;
          expect(matrix.storage[0], closeTo(3.5, 0.01));
          expect(matrix.storage[5], closeTo(3.5, 0.01));

          // Release gesture
          await gesture.up();
          await tester.pumpAndSettle();
          expect(
            tester.widgetList(find.byType(Material)).length,
            initialMaterialCount,
          );
        },
      );

      testWidgets(
        'applies theme properties to the overlay',
        (WidgetTester tester) async {
          final theme = LargeContentViewerThemeData(
            backgroundColor: Colors.green,
            elevation: 10.0,
            borderRadius: BorderRadius.circular(5.0),
            padding: const EdgeInsets.all(10.0),
            constraints: const BoxConstraints(maxWidth: 200, maxHeight: 200),
            textStyle: const TextStyle(fontSize: 20, color: Colors.yellow),
            iconTheme: const IconThemeData(color: Colors.orange, size: 40),
          );

          await pumpLargeContentViewer(
            tester,
            child: const Text("Theme Test"),
            customOverlayChild: const Column(
              children: [Text("Overlay Text"), Icon(Icons.star)],
            ),
            themeData: theme,
          );

          final int initialMaterialCount =
              tester.widgetList(find.byType(Material)).length;
          final TestGesture gesture = await tester
              .startGesture(tester.getCenter(find.text("Theme Test")));
          await tester
              .pump(kLongPressTimeout + const Duration(milliseconds: 100));
          await tester.pump(); // Allow overlay to build

          expect(
            tester.widgetList(find.byType(Material)).length,
            initialMaterialCount + 1,
            reason: "Overlay should be visible for theme test",
          );

          final Finder overlayMaterialFinder = findOverlayMaterial();
          expect(overlayMaterialFinder, findsOneWidget);

          final Material material =
              tester.widget<Material>(overlayMaterialFinder);
          expect(material.color, Colors.green);
          expect(material.elevation, 10.0);
          expect(material.borderRadius, BorderRadius.circular(5.0));

          final Padding padding = tester.widget<Padding>(
            find.descendant(
              of: overlayMaterialFinder,
              matching: find.byType(Padding),
            ),
          );
          expect(padding.padding, const EdgeInsets.all(10.0));

          final ConstrainedBox constrainedBox = tester.widget<ConstrainedBox>(
            find.descendant(
              of: overlayMaterialFinder,
              matching: find.byType(ConstrainedBox),
            ),
          );
          expect(
            constrainedBox.constraints,
            const BoxConstraints(maxWidth: 200, maxHeight: 200),
          );

          // Find the Padding widget that is a descendant of the overlay's Material widget.
          final Finder paddingFinder = find.descendant(
            of: overlayMaterialFinder,
            matching: find.byType(Padding),
          );
          expect(
            paddingFinder,
            findsOneWidget,
            reason:
                "There should be one Padding widget in the themed overlay content.",
          );

          // Now find the DefaultTextStyle that is a descendant of that Padding widget.
          final DefaultTextStyle defaultTextStyle =
              tester.widget<DefaultTextStyle>(
            find.descendant(
              of: paddingFinder, // Changed from overlayMaterialFinder
              matching: find.byType(DefaultTextStyle),
            ),
          );
          expect(defaultTextStyle.style.fontSize, 20);
          expect(defaultTextStyle.style.color, Colors.yellow);

          final IconTheme iconTheme = tester.widget<IconTheme>(
            find.descendant(
              of: overlayMaterialFinder,
              matching: find.byType(IconTheme),
            ),
          );
          expect(iconTheme.data.color, Colors.orange);
          expect(iconTheme.data.size, 40);

          final Text overlayText =
              tester.widget<Text>(find.text("Overlay Text"));
          expect(
            overlayText.style?.color ?? defaultTextStyle.style.color,
            Colors.yellow,
          );
          expect(
            overlayText.style?.fontSize ?? defaultTextStyle.style.fontSize,
            20,
          );

          final Icon overlayIcon = tester.widget<Icon>(find.byIcon(Icons.star));
          expect(overlayIcon.color ?? iconTheme.data.color, Colors.orange);
          expect(overlayIcon.size ?? iconTheme.data.size, 40);

          // Release gesture
          await gesture.up();
          await tester.pumpAndSettle();
          expect(
            tester.widgetList(find.byType(Material)).length,
            initialMaterialCount,
            reason: "Overlay should be hidden after theme test",
          );
        },
      );

      testWidgets(
        'overlay uses default theme values if no theme is provided',
        (WidgetTester tester) async {
          await pumpLargeContentViewer(
            tester,
            child: const Text("Default Theme Test"),
            customOverlayChild: const Text("Overlay Content"),
          );

          final int initialMaterialCount =
              tester.widgetList(find.byType(Material)).length;
          final TestGesture gesture = await tester
              .startGesture(tester.getCenter(find.text("Default Theme Test")));
          await tester
              .pump(kLongPressTimeout + const Duration(milliseconds: 100));
          await tester.pump(); // Allow overlay to build

          expect(
            tester.widgetList(find.byType(Material)).length,
            initialMaterialCount + 1,
            reason: "Overlay should be visible for default theme test",
          );

          final Finder overlayMaterialFinder = findOverlayMaterial();
          expect(overlayMaterialFinder, findsOneWidget);

          final Material material =
              tester.widget<Material>(overlayMaterialFinder);
          expect(material.elevation, 20.0);
          expect(material.borderRadius, BorderRadius.circular(16.0));

          // Find the Padding widget that is a descendant of the overlay's Material widget.
          final Finder paddingFinder = find.descendant(
            of: overlayMaterialFinder,
            matching: find.byType(Padding),
          );
          expect(
            paddingFinder,
            findsOneWidget,
            reason:
                "There should be one Padding widget in the overlay content.",
          );

          // Now find the DefaultTextStyle that is a descendant of that Padding widget.
          // This is the DefaultTextStyle applied by _OverlayContent.
          final DefaultTextStyle defaultTextStyle =
              tester.widget<DefaultTextStyle>(
            find.descendant(
              of: paddingFinder,
              matching: find.byType(DefaultTextStyle),
            ),
          );
          expect(defaultTextStyle.style.fontSize, isNotNull);
          expect(defaultTextStyle.style.color, isNotNull);

          // Release gesture
          await gesture.up();
          await tester.pumpAndSettle();
          expect(
            tester.widgetList(find.byType(Material)).length,
            initialMaterialCount,
            reason: "Overlay should be hidden after default theme test",
          );
        },
      );

      testWidgets(
        'dismisses overlay on long-press end',
        (WidgetTester tester) async {
          await pumpLargeContentViewer(tester, child: testChildWidget);
          final int initialMaterialCount =
              tester.widgetList(find.byType(Material)).length;

          final TestGesture gesture = await tester
              .startGesture(tester.getCenter(find.byKey(testChildKey)));
          // Hold long enough for onLongPressStart to fire and overlay to be inserted
          await tester
              .pump(kLongPressTimeout + const Duration(milliseconds: 100));
          await tester.pump(); // Allow OverlayState to build the entry

          // Check overlay is visible
          expect(
            tester.widgetList(find.byType(Material)).length,
            initialMaterialCount + 1,
            reason: "Overlay should appear before gesture up",
          );
          expect(findOverlayMaterial(), findsOneWidget);

          await gesture.up(); // End long press
          await tester
              .pumpAndSettle(); // For animations and overlay to disappear

          expect(
            tester.widgetList(find.byType(Material)).length,
            initialMaterialCount,
            reason: "Overlay should disappear after gesture up",
          );
        },
      );

      testWidgets(
        'dismisses overlay on long-press cancel (move)',
        (WidgetTester tester) async {
          await pumpLargeContentViewer(tester, child: testChildWidget);
          final int initialMaterialCount =
              tester.widgetList(find.byType(Material)).length;

          final TestGesture gesture = await tester
              .startGesture(tester.getCenter(find.byKey(testChildKey)));
          // Hold long enough for onLongPressStart to fire and overlay to be inserted
          await tester
              .pump(kLongPressTimeout + const Duration(milliseconds: 100));
          await tester.pump(); // Allow OverlayState to build the entry

          // Check overlay is visible
          expect(
            tester.widgetList(find.byType(Material)).length,
            initialMaterialCount + 1,
            reason: "Overlay should appear before gesture move",
          );
          expect(findOverlayMaterial(), findsOneWidget);

          // Target the original child for the gesture continuation
          final Finder originalChildFinder = find.descendant(
            of: find.byType(LargeContentViewer),
            matching: find.byKey(testChildKey),
          );
          expect(
            originalChildFinder,
            findsOneWidget,
          );

          await gesture.cancel(); // Explicitly cancel the gesture
          await tester
              .pumpAndSettle(); // For animations and overlay to disappear

          expect(
            tester.widgetList(find.byType(Material)).length,
            initialMaterialCount,
            reason: "Overlay should disappear after gesture move",
          );
        },
      );

      testWidgets(
        'triggers haptic feedback on long-press start',
        (WidgetTester tester) async {
          await pumpLargeContentViewer(tester, child: testChildWidget);

          expect(hapticLog, isEmpty);
          await tester.longPress(find.byKey(testChildKey));
          await tester.pumpAndSettle();

          expect(hapticLog.length, 1);
          expect(hapticLog.first.method, 'HapticFeedback.vibrate');
          expect(hapticLog.first.arguments, 'HapticFeedbackType.mediumImpact');
        },
      );

      testWidgets(
        'overlay is removed on dispose',
        (WidgetTester tester) async {
          await pumpLargeContentViewer(tester, child: testChildWidget);
          final int initialMaterialCount =
              tester.widgetList(find.byType(Material)).length;

          // Show the overlay reliably
          await tester.startGesture(tester.getCenter(find.byKey(testChildKey)));
          await tester
              .pump(kLongPressTimeout + const Duration(milliseconds: 100));
          await tester.pump(); // Allow overlay to build

          expect(
            tester.widgetList(find.byType(Material)).length,
            initialMaterialCount + 1,
            reason: "Overlay should be visible before dispose",
          );

          // Dispose by pumping a different minimal widget
          await tester.pumpWidget(
            const Directionality(
              textDirection: TextDirection.ltr,
              child: SizedBox.shrink(),
            ),
          );

          expect(
            find.byType(Material),
            findsNothing,
            reason:
                "All materials, including overlay, should be gone after dispose",
          );
        },
      );
    },
  );
}
