
import 'package:intl/intl.dart';

class AstronomyService {
  // Event Types
  static const String superMoon = 'superMoon';
  static const String bloodMoon = 'bloodMoon'; // Total Lunar Eclipse
  static const String lunarEclipse = 'lunarEclipse'; // Partial/Penumbral
  static const String solarEclipse = 'solarEclipse';

  static final Map<String, List<String>> _events = {
    // === 2025 ===
    '2025-03-14': [bloodMoon], // Total Lunar Eclipse (Americas/Pacific)
    '2025-03-29': [solarEclipse], // Partial Solar Eclipse (Europe/Africa/Russia)
    '2025-09-07': [bloodMoon], // Total Lunar Eclipse (Africa/Europe/Asia/Australia)
    '2025-09-21': [solarEclipse], // Partial Solar Eclipse (Antarctica/NZ)
    '2025-10-07': [superMoon], // Hunter's Moon
    '2025-11-05': [superMoon], // Beaver Moon
    '2025-12-04': [superMoon], // Cold Moon

    // === 2026 ===
    '2026-01-03': [superMoon], // Wolf Moon
    '2026-02-17': [solarEclipse], // Annular (Antarctica)
    '2026-03-03': [bloodMoon], // Total Lunar Eclipse (Asia/Americas/Pacific)
    '2026-08-12': [solarEclipse], // Total Solar Eclipse (Europe/North America)
    '2026-08-28': [lunarEclipse], // Partial Lunar Eclipse
    '2026-11-24': [superMoon], // Beaver Moon
    '2026-12-24': [superMoon], // Cold Moon (Closest of year)

    // === 2027 ===
    '2027-01-22': [superMoon], // Wolf Moon
    '2027-02-06': [solarEclipse], // Annular (Africa/S.America)
    '2027-02-20': [superMoon, lunarEclipse], // Penumbral Eclipse (Not Blood Moon)
    '2027-07-18': [lunarEclipse], // Penumbral
    '2027-08-02': [solarEclipse], // Total Solar Eclipse (Africa/Europe/Middle East)
    '2027-08-17': [lunarEclipse], // Penumbral
    

    // === 2028 ===
    '2028-01-12': [lunarEclipse], // Partial
    '2028-01-26': [solarEclipse], // Annular (S.America/Atlantic)
    '2028-02-10': [superMoon], // Snow Moon
    '2028-03-11': [superMoon], // Worm Moon
    '2028-07-06': [lunarEclipse], // Partial
    '2028-07-22': [solarEclipse], // Total Solar Eclipse (Australia/NZ)
    '2028-08-20': [superMoon], // Sturgeon Moon
    '2028-09-18': [superMoon], // Harvest Moon
    '2028-10-18': [superMoon], // Hunter's Moon
    '2028-12-31': [bloodMoon], // Total Lunar Eclipse (Europe/Africa/Asia/Australia)

    // === 2029 ===
    '2029-02-28': [superMoon], // Snow Moon
    '2029-03-30': [superMoon], // Worm Moon
    '2029-04-28': [superMoon], // Pink Moon
    '2029-06-26': [bloodMoon], // Total Lunar Eclipse (Americas/Africa/Europe)
    '2029-12-05': [solarEclipse], // Partial
    '2029-12-20': [bloodMoon], // Total Lunar Eclipse (Europe/Africa/Asia)

    // === 2030 ===
    '2030-05-17': [superMoon],
    '2030-06-01': [solarEclipse], // Annular (Europe/Africa/Asia)
    '2030-06-15': [superMoon, bloodMoon], // Total Lunar Eclipse (Asia/Aust/Pacific)
    '2030-11-25': [solarEclipse], // Total Solar Eclipse (Africa/Aust)
    '2030-12-09': [bloodMoon], // Total Lunar Eclipse (N.America/Pacific)

    // === 2031 ===
    '2031-05-07': [superMoon, lunarEclipse], // Penumbral
    '2031-05-21': [solarEclipse], // Annular
    '2031-06-06': [superMoon],
    '2031-07-06': [superMoon],
    '2031-11-14': [solarEclipse], // Total (Pacific/Panama)

    // === 2032 ===
    '2032-04-25': [bloodMoon], // Total Lunar Eclipse (Asia/Aust/Pacific)
    '2032-05-09': [solarEclipse], // Annular
    '2032-08-22': [superMoon],
    '2032-09-20': [superMoon],
    '2032-10-19': [bloodMoon, superMoon], // Total Lunar Eclipse
    '2032-11-03': [solarEclipse], // Partial

    // === 2033 ===
    '2033-03-30': [solarEclipse], // Total (Alaska/Russia)
    '2033-04-14': [bloodMoon], // Total Lunar Eclipse
    '2033-09-23': [solarEclipse], // Annular
    '2033-10-08': [bloodMoon], // Total Lunar Eclipse
    '2033-11-09': [superMoon],
    '2033-12-09': [superMoon],

    // === 2034 ===
    '2034-01-08': [superMoon],
    '2034-02-07': [superMoon],
    '2034-03-20': [solarEclipse], // Total (Africa/Asia)
    '2034-04-03': [bloodMoon], // Total Lunar Eclipse
    '2034-09-12': [solarEclipse], // Annular
    '2034-09-28': [bloodMoon], // Partial

    // === 2035 ===
    '2035-02-22': [lunarEclipse], // Penumbral
    '2035-03-09': [solarEclipse], // Annular (NZ/South Pacific)
    '2035-04-25': [superMoon],
    '2035-05-25': [superMoon],
    '2035-06-24': [superMoon],
    '2035-09-02': [solarEclipse], // Total (Asia/Pacific)
  };

  /// Get astronomical events for a specific date
  static List<String> getEvents(DateTime date) {
    final key = DateFormat('yyyy-MM-dd').format(date);
    return _events[key] ?? [];
  }
}
