import 'dart:math' as math;

/// Moon Phase calculation service using synodic month algorithm
/// No external API calls - pure mathematical calculation

enum MoonPhase {
  newMoon,
  waxingCrescent,
  firstQuarter,
  waxingGibbous,
  fullMoon,
  waningGibbous,
  thirdQuarter,
  waningCrescent,
}

class MoonPhaseService {
  // Known new moon reference date (January 6, 2000 at 18:14 UTC)
  static final DateTime _referenceNewMoon = DateTime.utc(2000, 1, 6, 18, 14);
  
  // Synodic month length in days (average time between new moons)
  static const double _synodicMonth = 29.53058867;

  /// Calculate moon phase for a given date
  MoonPhase getMoonPhase(DateTime date) {
    final daysSinceReference = date.difference(_referenceNewMoon).inHours / 24.0;
    final lunarCycles = daysSinceReference / _synodicMonth;
    final currentCycleProgress = lunarCycles - lunarCycles.floor();
    
    // Convert progress (0-1) to phase
    // 0.0 = New Moon, 0.25 = First Quarter, 0.5 = Full Moon, 0.75 = Third Quarter
    if (currentCycleProgress < 0.0625) return MoonPhase.newMoon;
    if (currentCycleProgress < 0.1875) return MoonPhase.waxingCrescent;
    if (currentCycleProgress < 0.3125) return MoonPhase.firstQuarter;
    if (currentCycleProgress < 0.4375) return MoonPhase.waxingGibbous;
    if (currentCycleProgress < 0.5625) return MoonPhase.fullMoon;
    if (currentCycleProgress < 0.6875) return MoonPhase.waningGibbous;
    if (currentCycleProgress < 0.8125) return MoonPhase.thirdQuarter;
    if (currentCycleProgress < 0.9375) return MoonPhase.waningCrescent;
    return MoonPhase.newMoon;
  }

  /// Get moon illumination percentage (0.0 to 1.0)
  double getMoonIllumination(DateTime date) {
    final daysSinceReference = date.difference(_referenceNewMoon).inHours / 24.0;
    final lunarCycles = daysSinceReference / _synodicMonth;
    final currentCycleProgress = lunarCycles - lunarCycles.floor();
    
    // Illumination follows a sinusoidal pattern
    // 0 at new moon, 1 at full moon
    return (1 - math.cos(currentCycleProgress * 2 * math.pi)) / 2;
  }

  /// Check if moon is waxing (growing) or waning (shrinking)
  bool isWaxing(DateTime date) {
    final daysSinceReference = date.difference(_referenceNewMoon).inHours / 24.0;
    final lunarCycles = daysSinceReference / _synodicMonth;
    final currentCycleProgress = lunarCycles - lunarCycles.floor();
    return currentCycleProgress < 0.5;
  }

  /// Get phase key for localization lookup
  String getPhaseKey(MoonPhase phase) {
    switch (phase) {
      case MoonPhase.newMoon: return 'moonPhaseNewMoon';
      case MoonPhase.waxingCrescent: return 'moonPhaseWaxingCrescent';
      case MoonPhase.firstQuarter: return 'moonPhaseFirstQuarter';
      case MoonPhase.waxingGibbous: return 'moonPhaseWaxingGibbous';
      case MoonPhase.fullMoon: return 'moonPhaseFullMoon';
      case MoonPhase.waningGibbous: return 'moonPhaseWaningGibbous';
      case MoonPhase.thirdQuarter: return 'moonPhaseThirdQuarter';
      case MoonPhase.waningCrescent: return 'moonPhaseWaningCrescent';
    }
  }

  /// Get phase name in English (for API calls)
  String getPhaseNameEn(MoonPhase phase) {
    switch (phase) {
      case MoonPhase.newMoon: return 'New Moon';
      case MoonPhase.waxingCrescent: return 'Waxing Crescent';
      case MoonPhase.firstQuarter: return 'First Quarter';
      case MoonPhase.waxingGibbous: return 'Waxing Gibbous';
      case MoonPhase.fullMoon: return 'Full Moon';
      case MoonPhase.waningGibbous: return 'Waning Gibbous';
      case MoonPhase.thirdQuarter: return 'Third Quarter';
      case MoonPhase.waningCrescent: return 'Waning Crescent';
    }
  }
}
