import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathkids_adventure/core/theme/app_sizes.dart';

void main() {
  group('AppSizes', () {
    test('should have correct border radius values', () {
      expect(AppSizes.radiusNone, 0.0);
      expect(AppSizes.radiusXs, 4.0);
      expect(AppSizes.radiusSm, 8.0);
      expect(AppSizes.radiusMd, 12.0);
      expect(AppSizes.radiusLg, 16.0);
      expect(AppSizes.radiusXl, 20.0);
      expect(AppSizes.radiusXxl, 24.0);
      expect(AppSizes.radiusRound, 999.0);
    });

    test('should have correct semantic radius values', () {
      expect(AppSizes.radiusButton, AppSizes.radiusXl);
      expect(AppSizes.radiusCard, AppSizes.radiusXl);
      expect(AppSizes.radiusDialog, AppSizes.radiusLg);
      expect(AppSizes.radiusInput, AppSizes.radiusMd);
    });

    test('should have correct border radius helpers', () {
      expect(AppSizes.borderRadiusXs, isA<BorderRadius>());
      expect(AppSizes.borderRadiusSm, isA<BorderRadius>());
      expect(AppSizes.borderRadiusMd, isA<BorderRadius>());
      expect(AppSizes.borderRadiusLg, isA<BorderRadius>());
      expect(AppSizes.borderRadiusXl, isA<BorderRadius>());
      expect(AppSizes.borderRadiusXxl, isA<BorderRadius>());
      expect(AppSizes.borderRadiusRound, isA<BorderRadius>());
    });

    test('should have correct elevation values', () {
      expect(AppSizes.elevationNone, 0.0);
      expect(AppSizes.elevationXs, 2.0);
      expect(AppSizes.elevationSm, 4.0);
      expect(AppSizes.elevationMd, 8.0);
      expect(AppSizes.elevationLg, 12.0);
      expect(AppSizes.elevationXl, 16.0);
    });

    test('should have correct icon sizes', () {
      expect(AppSizes.iconXs, 16.0);
      expect(AppSizes.iconSm, 20.0);
      expect(AppSizes.iconMd, 24.0);
      expect(AppSizes.iconLg, 32.0);
      expect(AppSizes.iconXl, 48.0);
      expect(AppSizes.iconXxl, 64.0);
    });

    test('should have correct button sizes', () {
      expect(AppSizes.buttonHeightSmall, 40.0);
      expect(AppSizes.buttonHeightMedium, 48.0);
      expect(AppSizes.buttonHeightLarge, 56.0);
      expect(AppSizes.buttonHeightXLarge, 64.0);

      expect(AppSizes.buttonWidthSmall, 80.0);
      expect(AppSizes.buttonWidthMedium, 120.0);
      expect(AppSizes.buttonWidthLarge, 160.0);
    });

    test('should have correct answer button sizes', () {
      expect(AppSizes.answerButtonSize, 95.0);
      expect(AppSizes.answerButtonSizeSmall, 80.0);
    });

    test('should have correct card sizes', () {
      expect(AppSizes.cardWidthSmall, 200.0);
      expect(AppSizes.cardWidthMedium, 240.0);
      expect(AppSizes.cardWidthLarge, 280.0);

      expect(AppSizes.cardHeightSmall, 200.0);
      expect(AppSizes.cardHeightMedium, 240.0);
      expect(AppSizes.cardHeightLarge, 280.0);
    });

    test('should have correct avatar sizes', () {
      expect(AppSizes.avatarSizeSmall, 32.0);
      expect(AppSizes.avatarSizeMedium, 48.0);
      expect(AppSizes.avatarSizeLarge, 64.0);
      expect(AppSizes.avatarSizeXLarge, 96.0);
    });

    test('should have correct border width values', () {
      expect(AppSizes.borderWidthThin, 1.0);
      expect(AppSizes.borderWidthNormal, 2.0);
      expect(AppSizes.borderWidthThick, 3.0);
      expect(AppSizes.borderWidthXThick, 4.0);
    });

    test('should have correct breakpoints', () {
      expect(AppSizes.breakpointSmall, 360.0);
      expect(AppSizes.breakpointMedium, 390.0);
      expect(AppSizes.breakpointLarge, 430.0);
      expect(AppSizes.breakpointXLarge, 1024.0);
    });

    test('should have correct grid spacing', () {
      expect(AppSizes.gridSpacingSmall, 12.0);
      expect(AppSizes.gridSpacingNormal, 16.0);
      expect(AppSizes.gridSpacingLarge, 20.0);
    });

    test('should have shadow helpers', () {
      expect(AppSizes.shadowSm, isA<List<BoxShadow>>());
      expect(AppSizes.shadowMd, isA<List<BoxShadow>>());
      expect(AppSizes.shadowLg, isA<List<BoxShadow>>());
      expect(AppSizes.shadowXl, isA<List<BoxShadow>>());
    });
  });
}
