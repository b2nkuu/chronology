part of 'era_datetime.dart';

enum Era { common, christian, buddhist }

extension EraExtension on Era {
  int get commonEraYearGap {
    switch (this) {
      case Era.common:
      case Era.christian:
        return 0;
      case Era.buddhist:
        return 543;
    }
  }
}
