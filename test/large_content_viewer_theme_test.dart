import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:large_content_viewer/large_content_viewer.dart';

void main() {
  group(
    '$LargeContentViewerThemeData',
    () {
      test('constructor defaults', () {
        const themeData = LargeContentViewerThemeData();

        expect(themeData.backgroundColor, isNull);
        expect(themeData.elevation, isNull);
        expect(themeData.borderRadius, isNull);
        expect(themeData.padding, isNull);
        expect(themeData.constraints, isNull);
        expect(themeData.textStyle, isNull);
        expect(themeData.iconTheme, isNull);
        expect(themeData.contentScaleFactor, isNull);
      });

      test('copyWith creates a new instance with specified values', () {
        const original = LargeContentViewerThemeData();
        final copied = original.copyWith(
          backgroundColor: Colors.red,
          elevation: 10.0,
          borderRadius: BorderRadius.circular(8.0),
          padding: const EdgeInsets.all(16.0),
          constraints: const BoxConstraints(maxWidth: 100),
          textStyle: const TextStyle(color: Colors.blue),
          iconTheme: const IconThemeData(color: Colors.green),
          contentScaleFactor: 3.0,
        );

        expect(copied.backgroundColor, Colors.red);
        expect(copied.elevation, 10.0);
        expect(copied.borderRadius, BorderRadius.circular(8.0));
        expect(copied.padding, const EdgeInsets.all(16.0));
        expect(copied.constraints, const BoxConstraints(maxWidth: 100));
        expect(copied.textStyle, const TextStyle(color: Colors.blue));
        expect(copied.iconTheme, const IconThemeData(color: Colors.green));
        expect(copied.contentScaleFactor, 3.0);

        // Ensure original is unchanged
        expect(original.backgroundColor, isNull);
        expect(original.elevation, isNull);
      });

      test(
        'copyWith uses original values if not specified',
        () {
          const original = LargeContentViewerThemeData(
            backgroundColor: Colors.amber,
            elevation: 5.0,
          );
          final copied = original.copyWith(
            borderRadius: BorderRadius.circular(10.0),
            contentScaleFactor: 2.5,
          );

          expect(copied.backgroundColor, Colors.amber);
          expect(copied.elevation, 5.0);
          expect(copied.borderRadius, BorderRadius.circular(10.0));
          expect(copied.padding, isNull); // Was null in original
          expect(copied.contentScaleFactor, 2.5);
        },
      );

      test(
        'lerp interpolates correctly',
        () {
          const t1 = LargeContentViewerThemeData(
            backgroundColor: Colors.black,
            elevation: 0.0,
            borderRadius: BorderRadius.all(Radius.circular(0.0)),
            padding: EdgeInsets.all(0.0),
            constraints: BoxConstraints(minWidth: 0, maxWidth: 0),
            textStyle: TextStyle(fontSize: 10.0, color: Colors.white),
            iconTheme: IconThemeData(color: Colors.white, size: 10.0),
            contentScaleFactor: 1.0,
          );
          const t2 = LargeContentViewerThemeData(
            backgroundColor: Colors.white,
            elevation: 20.0,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            padding: EdgeInsets.all(20.0),
            constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
            textStyle: TextStyle(fontSize: 20.0, color: Colors.black),
            iconTheme: IconThemeData(color: Colors.black, size: 20.0),
            contentScaleFactor: 3.0,
          );

          final lerped0 = LargeContentViewerThemeData.lerp(t1, t2, 0.0);
          expect(lerped0.backgroundColor, t1.backgroundColor);
          expect(lerped0.elevation, t1.elevation);
          expect(lerped0.borderRadius, t1.borderRadius);
          expect(lerped0.padding, t1.padding);
          expect(lerped0.constraints, t1.constraints);
          expect(lerped0.textStyle, t1.textStyle);
          expect(lerped0.iconTheme, t1.iconTheme);
          expect(lerped0.contentScaleFactor, t1.contentScaleFactor);

          final lerped1 = LargeContentViewerThemeData.lerp(t1, t2, 1.0);
          expect(lerped1.backgroundColor, t2.backgroundColor);
          expect(lerped1.elevation, t2.elevation);
          expect(lerped1.borderRadius, t2.borderRadius);
          expect(lerped1.padding, t2.padding);
          expect(lerped1.constraints, t2.constraints);
          expect(lerped1.textStyle, t2.textStyle);
          expect(lerped1.iconTheme, t2.iconTheme);
          expect(lerped1.contentScaleFactor, t2.contentScaleFactor);

          final lerped05 = LargeContentViewerThemeData.lerp(t1, t2, 0.5);
          expect(lerped05.backgroundColor,
              Color.lerp(Colors.black, Colors.white, 0.5));
          expect(lerped05.elevation, 10.0);
          expect(lerped05.borderRadius,
              const BorderRadius.all(Radius.circular(10.0)));
          expect(lerped05.padding, const EdgeInsets.all(10.0));
          expect(lerped05.constraints,
              const BoxConstraints(minWidth: 50, maxWidth: 100));
          expect(lerped05.textStyle?.fontSize, 15.0);
          expect(lerped05.textStyle?.color,
              Color.lerp(Colors.white, Colors.black, 0.5));
          expect(lerped05.iconTheme?.color,
              Color.lerp(Colors.white, Colors.black, 0.5));
          expect(lerped05.iconTheme?.size, 15.0);
          expect(lerped05.contentScaleFactor, 2.0);
        },
      );

      test(
        'lerp handles null values',
        () {
          const t1 = LargeContentViewerThemeData(elevation: 10.0);
          const t2 = LargeContentViewerThemeData(elevation: 20.0);

          final lerped05 = LargeContentViewerThemeData.lerp(t1, t2, 0.5);
          expect(lerped05.elevation, 15.0);

          final lerpedNullA = LargeContentViewerThemeData.lerp(null, t2, 0.5);
          expect(lerpedNullA.elevation, 10.0); // 0.0 to 20.0 at 0.5

          final lerpedNullB = LargeContentViewerThemeData.lerp(t1, null, 0.5);
          expect(lerpedNullB.elevation, 5.0); // 10.0 to 0.0 at 0.5

          final lerpedBothNull =
              LargeContentViewerThemeData.lerp(null, null, 0.5);
          expect(lerpedBothNull.elevation, isNull);
        },
      );

      test(
        'equality and hashCode',
        () {
          const theme1 = LargeContentViewerThemeData(
            backgroundColor: Colors.red,
            elevation: 5.0,
            contentScaleFactor: 1.5,
          );
          const theme2 = LargeContentViewerThemeData(
            backgroundColor: Colors.red,
            elevation: 5.0,
            contentScaleFactor: 1.5,
          );
          const theme3 = LargeContentViewerThemeData(
            backgroundColor: Colors.blue,
            elevation: 5.0,
            contentScaleFactor: 1.5,
          );
          const theme4 = LargeContentViewerThemeData(
            backgroundColor: Colors.red,
            elevation: 10.0, // Different elevation
            contentScaleFactor: 1.5,
          );
          const theme5 = LargeContentViewerThemeData(
            backgroundColor: Colors.red,
            elevation: 5.0,
            contentScaleFactor: 2.0, // Different scaleFactor
          );

          expect(theme1 == theme2, isTrue);
          expect(theme1.hashCode == theme2.hashCode, isTrue);

          expect(theme1 == theme3, isFalse);
          // Hash codes can be the same for non-equal objects, though unlikely for these simple cases.
          // expect(theme1.hashCode == theme3.hashCode, isFalse);

          expect(theme1 == theme4, isFalse);
          // expect(theme1.hashCode == theme4.hashCode, isFalse);

          expect(theme1 == theme5, isFalse);
          // expect(theme1.hashCode == theme5.hashCode, isFalse);

          const themeWithAllProps = LargeContentViewerThemeData(
            backgroundColor: Colors.purple,
            elevation: 12.0,
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            padding: EdgeInsets.all(12.0),
            constraints: BoxConstraints(minWidth: 12, maxWidth: 120),
            textStyle: TextStyle(fontSize: 12.0, color: Colors.cyan),
            iconTheme: IconThemeData(color: Colors.deepOrange, size: 12.0),
            contentScaleFactor: 1.2,
          );
          const themeWithAllPropsCopy = LargeContentViewerThemeData(
            backgroundColor: Colors.purple,
            elevation: 12.0,
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            padding: EdgeInsets.all(12.0),
            constraints: BoxConstraints(minWidth: 12, maxWidth: 120),
            textStyle: TextStyle(fontSize: 12.0, color: Colors.cyan),
            iconTheme: IconThemeData(color: Colors.deepOrange, size: 12.0),
            contentScaleFactor: 1.2,
          );
          expect(themeWithAllProps == themeWithAllPropsCopy, isTrue);
          expect(themeWithAllProps.hashCode == themeWithAllPropsCopy.hashCode,
              isTrue);
        },
      );

      test('debugFillProperties', () {
        final builder = DiagnosticPropertiesBuilder();
        const LargeContentViewerThemeData(
          backgroundColor: Colors.red,
          elevation: 5.0,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          padding: EdgeInsets.all(5.0),
          constraints: BoxConstraints(maxWidth: 50),
          textStyle: TextStyle(color: Colors.green),
          iconTheme: IconThemeData(color: Colors.blue),
          contentScaleFactor: 1.5,
        ).debugFillProperties(builder);

        final props = builder.properties
            .where((p) => !p.isFiltered(DiagnosticLevel.info))
            .toList();

        expect(props.length, 8);
        expect(props[0].name, 'backgroundColor');
        expect(props[0].value, Colors.red);
        expect(props[1].name, 'elevation');
        expect(props[1].value, 5.0);
        expect(props[2].name, 'borderRadius');
        expect(props[2].value, const BorderRadius.all(Radius.circular(5.0)));
        expect(props[3].name, 'padding');
        expect(props[3].value, const EdgeInsets.all(5.0));
        expect(props[4].name, 'constraints');
        expect(props[4].value, const BoxConstraints(maxWidth: 50));
        expect(props[5].name, 'textStyle');
        expect(props[5].value, const TextStyle(color: Colors.green));
        expect(props[6].name, 'iconTheme');
        expect(props[6].value, const IconThemeData(color: Colors.blue));
        expect(props[7].name, 'contentScaleFactor');
        expect(props[7].value, 1.5);
      });
    },
  );

  group(
    '$LargeContentViewerTheme',
    () {
      testWidgets(
        'of(context) returns theme data when present',
        (tester) async {
          const themeData = LargeContentViewerThemeData(elevation: 33.0);
          late LargeContentViewerThemeData retrievedThemeData;

          await tester.pumpWidget(
            LargeContentViewerTheme(
              data: themeData,
              child: Builder(
                builder: (context) {
                  retrievedThemeData = LargeContentViewerTheme.of(context);
                  return const SizedBox();
                },
              ),
            ),
          );

          expect(retrievedThemeData, themeData);
        },
      );

      testWidgets(
        'of(context) returns default theme data when not present',
        (tester) async {
          late LargeContentViewerThemeData retrievedThemeData;

          await tester.pumpWidget(
            Builder(
              builder: (context) {
                retrievedThemeData = LargeContentViewerTheme.of(context);
                return const SizedBox();
              },
            ),
          );
          // It should return a default instance, not null.
          expect(retrievedThemeData, isNotNull);
          expect(retrievedThemeData.elevation, isNull); // Default is null
          // Check against a fresh default instance for equality
          expect(retrievedThemeData, const LargeContentViewerThemeData());
        },
      );

      testWidgets(
        'maybeOf(context) returns theme data when present',
        (tester) async {
          const themeData = LargeContentViewerThemeData(elevation: 44.0);
          LargeContentViewerThemeData? retrievedThemeData;

          await tester.pumpWidget(
            LargeContentViewerTheme(
              data: themeData,
              child: Builder(
                builder: (context) {
                  retrievedThemeData = LargeContentViewerTheme.maybeOf(context);
                  return const SizedBox();
                },
              ),
            ),
          );

          expect(retrievedThemeData, themeData);
        },
      );

      testWidgets(
        'maybeOf(context) returns null when not present',
        (tester) async {
          LargeContentViewerThemeData? retrievedThemeData;

          await tester.pumpWidget(
            Builder(
              builder: (context) {
                retrievedThemeData = LargeContentViewerTheme.maybeOf(context);
                return const SizedBox();
              },
            ),
          );

          expect(retrievedThemeData, isNull);
        },
      );

      test('updateShouldNotify returns true when data changes', () {
        const oldData = LargeContentViewerThemeData(elevation: 10.0);
        const newData = LargeContentViewerThemeData(elevation: 20.0);
        const sameData = LargeContentViewerThemeData(elevation: 10.0);

        const theme1 = LargeContentViewerTheme(
          data: oldData,
          child: SizedBox(),
        );
        const theme2 = LargeContentViewerTheme(
          data: newData,
          child: SizedBox(),
        );
        const theme3 = LargeContentViewerTheme(
          data: sameData, // Same data as theme1
          child: SizedBox(),
        );

        expect(theme2.updateShouldNotify(theme1), isTrue);
        expect(
            theme1.updateShouldNotify(theme2), isTrue); // Bidirectional check
        expect(theme1.updateShouldNotify(theme3), isFalse);
      });
    },
  );
}
