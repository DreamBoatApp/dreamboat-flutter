import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dream_boat_mobile/theme/app_theme.dart';
import 'package:dream_boat_mobile/widgets/background_sky.dart';
import 'package:dream_boat_mobile/widgets/glass_card.dart';
import 'package:dream_boat_mobile/widgets/custom_button.dart';
import 'package:dream_boat_mobile/widgets/platform_widgets.dart';
import 'package:dream_boat_mobile/l10n/app_localizations.dart';
import 'package:dream_boat_mobile/services/openai_service.dart';
import 'package:dream_boat_mobile/services/dream_service.dart';
import 'package:dream_boat_mobile/models/dream_entry.dart';
import 'package:dream_boat_mobile/widgets/gradient_text.dart';
import 'package:dream_boat_mobile/services/connectivity_service.dart';
import 'package:dream_boat_mobile/widgets/pro_badge.dart';
import 'package:provider/provider.dart';
import 'package:dream_boat_mobile/providers/subscription_provider.dart';
import 'package:dream_boat_mobile/widgets/pro_upgrade_dialog.dart';
import 'package:dream_boat_mobile/services/moon_phase_service.dart';

class _MoodStat {
  int count = 0;
  int totalIntensity = 0;
}

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final OpenAIService _openAIService = OpenAIService();
  final DreamService _dreamService = DreamService();
  
  bool _isLoading = true;
  String? _analysisResult;
  DateTime? _lastAnalysisDate;



  // Chart Data
  Map<String, _MoodStat> _moodStats = {}; // Stores count and intensity

  int _totalDreamsCount = 0;

  // Weekly Analysis State
  // 0: Initial/Requirements Not Met or Met but not started
  // 1: Processing
  // 2: Done
  int _analysisState = 0; 
  bool _canAnalyze = false;


  bool _isTipLoading = false;
  String _dailyTip = "";

  // Moon Sync State
  String? _moonSyncResult;
  DateTime? _lastMoonSyncDate;
  bool _isMoonSyncLoading = false;

  @override
  void initState() {
    super.initState();
    _loadStats();
    _checkAnalysisStatus();

  }

  // Renamed from _loadData to match initState call
  Future<void> _loadStats() async {
     await _loadData();
  }
  
  void _checkAnalysisStatus() {
      // Simply ensures state variables are ready or checks specific conditions if needed.
      // For now, _loadData (called by _loadStats) handles most state initialization.
      // We can use this to explicitly check 7-day rule if not done in _loadData.
      if (_lastAnalysisDate != null) {
         final diff = DateTime.now().difference(_lastAnalysisDate!);
         if (diff.inDays < 7) {
            // Can't analyze
         }
      }
  }



  @override
  void dispose() {

    super.dispose();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 1. Load Analysis State
    final dateStr = prefs.getString('last_analysis_date');
    final result = prefs.getString('last_analysis_result');

    if (dateStr != null && result != null) {
        _lastAnalysisDate = DateTime.parse(dateStr);
        _analysisResult = result;
    }

    // 1b. Load Moon Sync State
    final moonSyncDateStr = prefs.getString('last_moon_sync_date');
    final moonSyncResult = prefs.getString('last_moon_sync_result');
    if (moonSyncDateStr != null && moonSyncResult != null) {
        _lastMoonSyncDate = DateTime.parse(moonSyncDateStr);
        _moonSyncResult = moonSyncResult;
    }

    // 2. Load Daily Tip (Moved to PostFrame for context access)
    // We defer this to ensure we have the correct locale
    WidgetsBinding.instance.addPostFrameCallback((_) {
        final locale = Localizations.localeOf(context).languageCode;
        _loadDailyTip(prefs, locale);
    });
    
    // 3. Load Real Chart Data
    final allDreams = await _dreamService.getDreams();
    // Count interpreted dreams
    _totalDreamsCount = allDreams.length; 

    final now = DateTime.now();
    
    // Filter for current month
    final monthlyDreams = allDreams.where((d) => d.date.year == now.year && d.date.month == now.month).toList();

    if (monthlyDreams.isNotEmpty) {
       final moodStats = <String, _MoodStat>{};
       
       for (var d in monthlyDreams) {
         // Collect all moods for this dream (Primary + Secondary)
         final moodsToProcess = [d.mood];
         if (d.secondaryMoods != null) {
            moodsToProcess.addAll(d.secondaryMoods!);
         }

         // Calculate Intensity (Normalized)
         int intensity = d.moodIntensity ?? 0;
         if (intensity == 0) {
            // Handle legacy nulls
            intensity = d.date.isBefore(DateTime(2026, 2, 3)) ? 2 : 3;
         }
         
         // Mapping Logic for Old Data (Before Feb 3, 2026)
         if (d.date.isBefore(DateTime(2026, 2, 3)) && intensity <= 3) {
            if (intensity == 2) intensity = 3;      // Medium 2 -> 3
            else if (intensity == 3) intensity = 5; // High 3 -> 5
            // Low 1 stays 1
         }

         // Add stats for ALL moods
         for (var m in moodsToProcess) {
             if (!moodStats.containsKey(m)) {
                moodStats[m] = _MoodStat();
             }
             moodStats[m]!.count++;
             moodStats[m]!.totalIntensity += intensity;
         }
       }
       
       if (mounted) setState(() => _moodStats = moodStats);
    } else {
       if (mounted) setState(() => _moodStats = {});
    }
    
    // Trigger rebuild to update UI with loaded data
    if (mounted) {
       setState(() {
          _isLoading = false;
          _totalDreamsCount = allDreams.length;
       });
    }
  }

  // ... (rest of simple methods skipped logic same) ...

  Future<void> _loadDailyTip(SharedPreferences prefs, String locale) async {
    // ... (unchanged)
    final todayStr = DateTime.now().toString().split(' ')[0];
    final dateKey = 'tip_date_$locale';
    final contentKey = 'tip_content_$locale';

    final lastDate = prefs.getString(dateKey);
    final cachedContent = prefs.getString(contentKey);

    if (lastDate == todayStr && cachedContent != null && cachedContent.isNotEmpty) {
       if (mounted) setState(() => _dailyTip = cachedContent);
    } else {
       await _generateNewTip(prefs, todayStr, locale, dateKey, contentKey);
    }
  }

  Future<void> _generateNewTip(SharedPreferences prefs, String todayStr, String locale, String dateKey, String contentKey) async {
    // ... (unchanged)
     if (!mounted) return;
    setState(() => _isTipLoading = true);
    
    try {
      final allDreams = await _dreamService.getDreams();
      final recentDreams = allDreams.take(5).map((d) => d.text).toList(); // Send last 5 dreams for context
      
      final tip = await _openAIService.generateDailyTip(recentDreams, locale);
      
      await prefs.setString(dateKey, todayStr);
      await prefs.setString(contentKey, tip);
      
      if (mounted) {
        setState(() => _dailyTip = tip);
      }
    } catch (e) {
       // Fallback
       if (mounted) {
          final t = AppLocalizations.of(context)!;
          setState(() => _dailyTip = t.statsTipContent);
       }
    } finally {
      if (mounted) setState(() => _isTipLoading = false);
    }
  }

  // FLOW: 1. User taps button -> 2. Show Dialog -> 3. Show Ad -> 4. Run Analysis
  Future<void> _handleAnalysisTap() async {
      // Check limit again just in case
      if (_lastAnalysisDate != null) {
        final difference = DateTime.now().difference(_lastAnalysisDate!);
        if (difference.inDays < 7) return; 
      }
      _showAnalysisInfoDialog();
  }

  void _showAnalysisInfoDialog() {
    final t = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.8), // Darken background like screenshot
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1B35).withOpacity(0.95), // Dark opaque background
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               const Icon(LucideIcons.brainCircuit, size: 48, color: Color(0xFFD8B4FE)), // Brain Icon
               const SizedBox(height: 16),
                Text(
                  t.statsAnalysisIntroTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFFD8B4FE), fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  t.statsAnalysisIntroContent,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, height: 1.5, fontSize: 14),
                ),
                const SizedBox(height: 24),
                Consumer<SubscriptionProvider>(
                  builder: (context, subProvider, child) {
                    return Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                   minimumSize: const Size(48, 48),
                                   tapTargetSize: MaterialTapTargetSize.padded,
                                   padding: const EdgeInsets.symmetric(vertical: 12),
                                   side: const BorderSide(color: Colors.white24),
                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                                ),
                                child: Text(t.cancel, style: const TextStyle(color: Colors.white70)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [Color(0xFFA78BFA), Color(0xFFEC4899)]),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close dialog
                                    _runAnalysis();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    minimumSize: const Size(48, 48),
                                    tapTargetSize: MaterialTapTargetSize.padded,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                                  ),
                                  child: Text(t.understand, style: const TextStyle(color: Colors.white, fontSize: 13), textAlign: TextAlign.center),
                                ),
                              ),
                            ),
                          ],
                        );
                  }
                )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _runAnalysis() async {
    // [FIX] 1. Check Connectivity First
    final isConnected = await ConnectivityService.isConnected;
    if (!isConnected) {
       final t = AppLocalizations.of(context)!;
       if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(t.errorNoInternet)),
          );
       }
       return;
    }

    setState(() => _isLoading = true);

    try {
      // Fetch real dreams from the last 7 days
      final allDreams = await _dreamService.getDreams();
      final now = DateTime.now();
      final lastWeek = now.subtract(const Duration(days: 7));
      
      final recentDreams = allDreams.where((d) => d.date.isAfter(lastWeek)).take(20).map((d) => d.text).toList();
      
      final locale = Localizations.localeOf(context).languageCode;
      final result = await _openAIService.analyzeDreams(recentDreams, locale);

      // [FIX] 2. Critical Check: Only save if result is valid
      if (result.isNotEmpty && !result.toLowerCase().contains('error')) {
         final prefs = await SharedPreferences.getInstance();
         await prefs.setString('last_analysis_result', result);
         await prefs.setString('last_analysis_date', DateTime.now().toIso8601String());

         if (mounted) {
           setState(() {
             _analysisResult = result;
             _lastAnalysisDate = DateTime.now();
           });
         }
      } else {
         // Service returned empty/error string
         throw Exception("Analysis service returned empty result.");
      }
    } catch (e) {
      if (mounted) {
        final t = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.errorGeneric)));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Moon Sync Analysis (30-day cooldown)
  Future<void> _runMoonSyncAnalysis() async {
    if (_isMoonSyncLoading) return;
    
    // [FIX] 1. Check Connectivity First
    final isConnected = await ConnectivityService.isConnected;
    if (!isConnected) {
       final t = AppLocalizations.of(context)!;
       if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(t.errorNoInternet)),
          );
       }
       return;
    }

    if (!mounted) return;
    
    setState(() => _isMoonSyncLoading = true);
    
    try {
      final moonPhaseService = MoonPhaseService();
      final allDreams = await _dreamService.getDreams();
      final now = DateTime.now();
      final last30Days = now.subtract(const Duration(days: 30));
      
      // Filter dreams from last 30 days
      final recentDreams = allDreams.where((d) => d.date.isAfter(last30Days)).take(30).toList();
      
      // Prepare dream data with moon phases
      final dreamData = recentDreams.map((d) {
        final phase = moonPhaseService.getMoonPhase(d.date);
        return {
          'text': d.text,
          'mood': d.mood,
          'moodIntensity': d.moodIntensity,
          'vividness': d.vividness,
          'astronomicalEvents': d.astronomicalEvents,
          'date': d.date.toIso8601String(),
          'moonPhase': moonPhaseService.getPhaseNameEn(phase),
          'isWaxing': moonPhaseService.isWaxing(d.date),
        };
      }).toList();
      
      final locale = Localizations.localeOf(context).languageCode;
      final result = await _openAIService.analyzeMoonSync(dreamData, locale);
      
      // [FIX] 2. Critical Check: Only save if result is valid
      if (result.isNotEmpty && !result.toLowerCase().contains('error')) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('last_moon_sync_result', result);
          await prefs.setString('last_moon_sync_date', DateTime.now().toIso8601String());
          
          if (mounted) {
            setState(() {
              _moonSyncResult = result;
              _lastMoonSyncDate = DateTime.now();
            });
          }
      } else {
         throw Exception("Moon Sync service returned empty result.");
      }
    } catch (e) {
      if (mounted) {
        final t = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.errorGeneric)));
      }
    } finally {
      if (mounted) {
        setState(() => _isMoonSyncLoading = false);
      }
    }
  }

  // ... helper colors ...
  Color _getMoodColor(String mood) {
     // ... (unchanged)
    switch (mood) {
      case 'love': return const Color(0xFFF24C9A);      // Canlı Pembe
      case 'happy': return const Color(0xFFFFFF00);     // Mutluluk (güncellendi)
      case 'sad': return const Color(0xFF5B9BD5);       // Mavi
      case 'scared': return const Color(0xFF6D4BC3);    // Koyu Mor
      case 'anger': return const Color(0xFFE05555);     // Kırmızı
      case 'neutral': return const Color(0xFF9CA3AF);   // Gri
      case 'awe': return const Color(0xFF8E67B2);       // Lila / Mor (Şaşkınlık)
      case 'peace': return const Color(0xFF4ADE80);     // Açık Yeşil
      case 'anxiety': return const Color(0xFFB38E1E);   // Kaygı
      case 'confusion': return const Color(0xFF2FB9B3); // Turkuaz
      case 'empowered': return const Color(0xFFF24C9A); // Same as Love
      case 'longing': return const Color(0xFF5BBDE8);   // Açık Mavi
      default: return const Color(0xFF9CA3AF);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    // Prepared Chart Data
    final List<PieChartSectionData> chartSections = [];
    final List<Widget> legendItems = [];

    if (_moodStats.isEmpty) {
        chartSections.add(PieChartSectionData(
          color: Colors.white10,
          value: 100,
          title: '',
          radius: 80,
        ));
        legendItems.add(
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              t.statsNoData, 
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70)
            ),
          )
        );
    } else {
        final total = _moodStats.values.fold(0, (sum, item) => sum + item.count);
        
        // 1. Chart Sections (Original Order - Unsorted)
        _moodStats.forEach((key, stat) {
             String label = t.moodNeutral;
             // Use new soft color palette
             Color baseColor = _getMoodColor(key);
            
            switch(key) {
              case 'love': label = t.moodLove; break;
              case 'happy': label = t.moodHappy; break;
              case 'sad': label = t.moodSad; break;
              case 'scared': label = t.moodScared; break;
              case 'anger': label = t.moodAnger; break;
              case 'neutral': label = t.moodNeutral; break;
              case 'awe': label = t.moodAwe; break;
              case 'peace': label = t.moodPeace; break;
              case 'anxiety': label = t.moodAnxiety; break;
              case 'confusion': label = t.moodConfusion; break;
              case 'empowered': label = t.moodEmpowered; break;
              case 'longing': label = t.moodLonging; break;
            }
            
            // Calculate Average Intensity
            double avgIntensity = stat.totalIntensity / stat.count;
            Color finalColor = baseColor;
            
            // [LOGIC] Intensity Visual Feedback (Updated for 5-Point Scale)
            // Low (1-2) -> <= 2.6
            // High (4-5) -> >= 3.4
            // Medium (3) -> In between
            
            if (avgIntensity <= 2.6) {
               finalColor = baseColor.withOpacity(0.4); // Hafif: Çok daha silik (0.4)
            } else if (avgIntensity >= 3.4) {
                finalColor = baseColor; // Şiddetli: Tam Canlı
            } else {
               finalColor = baseColor.withOpacity(0.8); // Orta: Normal
            }
            
            final percent = (stat.count / total * 100).round();
            
            chartSections.add(PieChartSectionData(
              color: finalColor,
              value: stat.count.toDouble(),
              title: '${percent}%', 
              titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
              radius: 70, 
              showTitle: true,
            ));
        });

        // 2. Legend Items (Sorted by Count Descending)
        final sortedStats = _moodStats.entries.toList()
          ..sort((a, b) => b.value.count.compareTo(a.value.count));

        for (var entry in sortedStats) {
            final key = entry.key;
            final stat = entry.value;

            String label = t.moodNeutral;
            // Use new soft color palette
            Color baseColor = _getMoodColor(key);
            
            switch(key) {
              case 'love': label = t.moodLove; break;
              case 'happy': label = t.moodHappy; break;
              case 'sad': label = t.moodSad; break;
              case 'scared': label = t.moodScared; break;
              case 'anger': label = t.moodAnger; break;
              case 'neutral': label = t.moodNeutral; break;
              case 'awe': label = t.moodAwe; break;
              case 'peace': label = t.moodPeace; break;
              case 'anxiety': label = t.moodAnxiety; break;
              case 'confusion': label = t.moodConfusion; break;
              case 'empowered': label = t.moodEmpowered; break;
              case 'longing': label = t.moodLonging; break;
            }
            
            double avgIntensity = stat.totalIntensity / stat.count;
            String intensityText = t.intensityFeltMedium;
            Color finalColor = baseColor;
            
            if (avgIntensity <= 2.6) {
               intensityText = t.intensityFeltLight;
               finalColor = baseColor.withOpacity(0.4); // Hafif
            } else if (avgIntensity >= 3.4) {
                intensityText = t.intensityFeltIntense;
                finalColor = baseColor; // Şiddetli
            } else {
               intensityText = t.intensityFeltMedium;
               finalColor = baseColor.withOpacity(0.8); // Orta
            }
            
            final percent = (stat.count / total * 100).round();

            
            // Legend Item
            legendItems.add(
               FractionallySizedBox(
                  widthFactor: 0.47, 
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Container(
                            width: 10, height: 10, 
                            decoration: BoxDecoration(
                              color: finalColor, 
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: finalColor.withOpacity(0.5), blurRadius: 4, spreadRadius: 1)
                              ]
                            )
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                                Text(
                                  "$label (%$percent)",
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11),
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  intensityText,
                                  style: const TextStyle(fontSize: 11, color: Colors.white54, height: 1.1),
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                             ],
                          ),
                        ),
                      ],
                    ),
                  ),
               )
            );
        }
    }

    final isPro = context.watch<SubscriptionProvider>().isPro;

    return NightSkyBackground(
      isPro: isPro,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Container(
             margin: const EdgeInsets.all(8),
             decoration: BoxDecoration(
               color: Colors.white.withOpacity(0.1),
               shape: BoxShape.circle,
             ),
             child: IconButton(
               icon: const Icon(LucideIcons.arrowLeft, color: Colors.white, size: 20),
               onPressed: () => Navigator.pop(context),
             ),
          ),
          centerTitle: true,
          title: GradientText(
            t.statsTitle,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            gradient: const LinearGradient(
              colors: [Colors.white, Color(0xFFF3E8FF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 1. Daily Tip Card (Günün Rüya Tavsiyesi)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1326).withOpacity(0.8), // Dark purple/brown bg
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                         const Icon(LucideIcons.lightbulb, color: Color(0xFFFBBF24), size: 20),
                         const SizedBox(width: 10),
                         Text(t.statsTipTitle, style: const TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_isTipLoading)
                      Center(child: PlatformWidgets.activityIndicator(color: Colors.amber, radius: 10, strokeWidth: 2))
                    else
                      Text(
                        _dailyTip.isNotEmpty ? _dailyTip : t.statsTipContent, // Fallback to localized default if empty
                        style: const TextStyle(color: Colors.white, height: 1.5, fontSize: 14),
                      )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 2. Chart Card (Monthly Emotion Distribution)
              GlassCard(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            t.statsAnalysisTitle, 
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Color(0xFFFBBF24), fontSize: 16, fontWeight: FontWeight.bold)
                          ),
                          const SizedBox(height: 2),
                          Text(
                            t.statsRecordedDreams(_totalDreamsCount),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white54, fontSize: 12)
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // New Layout: Vertical Stack (Chart Top, Legend Bottom)
                      Column(
                        children: [
                          // Chart (Center)
                          Container(
                            height: 140, // Reduced height
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.1), // Soft white glow
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                                BoxShadow(
                                  color: const Color(0xFF8B5CF6).withOpacity(0.2), // Purple mystical glow
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 2, // Small gap between slices
                                centerSpaceRadius: 0, // Full Pie
                                sections: chartSections.map((s) => s.copyWith(
                                   radius: 70, // Full radius
                                   showTitle: false, // [MODIFIED] Remove labels
                                )).toList(), 
                                borderData: FlBorderData(show: false),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Legend (Grid / Wrap)
                          SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              alignment: WrapAlignment.start,
                              children: legendItems,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 3. Analysis Section
              Builder(
                builder: (context) {
                  final isPro = context.watch<SubscriptionProvider>().isPro;
                  final widget = _analysisResult == null 
                    ? _buildIntroState(t, isPro)
                    : _buildResultState(t, isPro);
                  
                  // Wrap with GestureDetector for non-PRO users
                  if (!isPro) {
                    return GestureDetector(
                      onTap: () => showDialog(context: context, builder: (ctx) => const ProUpgradeDialog()),
                      child: widget,
                    );
                  }
                  return widget;
                },
              ),

              const SizedBox(height: 20),

              // 4. Moon Sync Section
              Builder(
                builder: (context) {
                  final isPro = context.watch<SubscriptionProvider>().isPro;
                  final widget = _moonSyncResult == null
                    ? _buildMoonSyncIntroState(t, isPro)
                    : _buildMoonSyncResultState(t, isPro);
                  
                  // Wrap with GestureDetector for non-PRO users
                  if (!isPro) {
                    return GestureDetector(
                      onTap: () => showDialog(context: context, builder: (ctx) => const ProUpgradeDialog()),
                      child: widget,
                    );
                  }
                  return widget;
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroState(AppLocalizations t, bool isPro) {
    if (_isLoading) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(20),
           border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.3)),
           color: const Color(0xFF0F0F23).withOpacity(0.8),
        ),
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PlatformWidgets.activityIndicator(color: const Color(0xFFFBBF24), radius: 16),
            const SizedBox(height: 20),
            Text(t.statsProcessing, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(20),
         border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.3)),
         gradient: LinearGradient(
           begin: Alignment.topLeft,
           end: Alignment.bottomRight,
           colors: [
             const Color(0xFF2E1065).withOpacity(0.6),
             const Color(0xFF0F0F23).withOpacity(0.6),
           ]
         )
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.brainCircuit, color: Color(0xFFA78BFA), size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            t.statsAnalysisIntroTitle, 
                            style: TextStyle(
                              color: isPro ? const Color(0xFFFBBF24) : const Color(0xFFA78BFA), 
                              fontSize: 18, 
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (!isPro)
                          const ProBadge(),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t.statsAnalysisIntroSubtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(t.statsAnalysisIntroContent, style: const TextStyle(color: Colors.white, height: 1.6, fontSize: 14)),
          const SizedBox(height: 24),
          
          if (isPro)
             // PRO FLOW
             CustomButton(
               text: _totalDreamsCount >= 5 ? t.statsAnalyzeBtn : t.statsAnalysisMinDreams,
               onPressed: _totalDreamsCount >= 5 
                  ? _runAnalysis // Direct analysis for PRO
                  : null, // Disabled if < 5
               isLoading: _isLoading,
               gradient: _totalDreamsCount >= 5 
                  ? const LinearGradient(colors: [Color(0xFFFBBF24), Color(0xFFD97706)]) // Gold for Action
                  : LinearGradient(colors: [Colors.grey.withOpacity(0.5), Colors.grey.withOpacity(0.5)]),
             )
          else
             // STANDARD FLOW (Upgrade Prompt)
             CustomButton(
               text: _totalDreamsCount >= 5 
                  ? t.proRequired  // "PRO Versiyon Gerekir"
                  : t.proRequiredDetail,  // "PRO Versiyon ve En Az 5 Kaydedilmiş Rüya Gerekir"
               onPressed: () => showDialog(context: context, builder: (ctx) => const ProUpgradeDialog()),
               gradient: const LinearGradient(colors: [Color(0xFFA78BFA), Color(0xFFEC4899)]), // Gradient for Upgrade
               isLoading: _isLoading,
             )
        ],
      ),
    );
  }

  Widget _buildResultState(AppLocalizations t, bool isPro) {
    // Basic Markdown parser for the specific format we expect
    List<Widget> contentWidgets = [];
    if (_analysisResult != null) {
      final lines = _analysisResult!.split('\n');
      for (var line in lines) {
         if (line.startsWith('###')) {
           // Header
           contentWidgets.add(Padding(
             padding: const EdgeInsets.only(top: 20, bottom: 10),
             child: Text(
               line.replaceAll('###', '').trim(),
               style: const TextStyle(color: Color(0xFFFBBF24), fontSize: 16, fontWeight: FontWeight.bold),
             ),
           ));
         } else if (line.trim().startsWith('-')) {
           // Bullet
           contentWidgets.add(Padding(
             padding: const EdgeInsets.only(bottom: 8),
             child: Row(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 const Padding(
                   padding: EdgeInsets.only(top: 6),
                   child: Icon(Icons.circle, size: 4, color: Colors.white70),
                 ),
                 const SizedBox(width: 10),
                 Expanded(child: Text(line.replaceAll('-', '').trim(), style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5))),
               ],
             ),
           ));
         } else if (line.trim().isNotEmpty) {
           // Normal text
            contentWidgets.add(Text(line.trim(), style: const TextStyle(color: Colors.white, fontSize: 14)));
         }
      }
    }

    return Container(
      decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(20),
         border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.3)),
         color: const Color(0xFF0F0F23).withOpacity(0.8),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.brainCircuit, color: Color(0xFFA78BFA), size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.statsAnalysisIntroTitle, 
                      style: const TextStyle(color: Color(0xFFA78BFA), fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t.statsAnalysisIntroSubtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(t.statsAnalysisIntroContent, style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.5)),
          const Divider(color: Colors.white10, height: 30),
          
          ...contentWidgets,
          
          const SizedBox(height: 24),
          // Matches "Haftalık Analiz Yapıldı" style in Screenshot 2
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08), // Dark Gray look
              borderRadius: BorderRadius.circular(12)
            ),
            alignment: Alignment.center,
            child: Text(
                t.statsAnalysisDone, 
                style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)
            ),
          ),
          const SizedBox(height: 12),
          Center(
              child: Text(
                  _getWaitMessage(t), 
                  style: const TextStyle(color: Colors.white24, fontSize: 12)
              )
          ),
        ],
      ),
    );
  }

  String _getWaitMessage(AppLocalizations t) {
      if (_lastAnalysisDate == null) return t.statsAnalysisWait(7);
      
      final diff = DateTime.now().difference(_lastAnalysisDate!);
      final remaining = (7 - diff.inDays).clamp(0, 7);
      return t.statsAnalysisWait(remaining);
  }

  String _getMoonSyncWaitMessage(AppLocalizations t) {
      if (_lastMoonSyncDate == null) return t.moonSyncWait(30);
      
      final diff = DateTime.now().difference(_lastMoonSyncDate!);
      final remaining = (30 - diff.inDays).clamp(0, 30);
      return t.moonSyncWait(remaining);
  }

  Widget _buildMoonSyncIntroState(AppLocalizations t, bool isPro) {
    if (_isMoonSyncLoading) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(20),
           border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3)),
           color: const Color(0xFF0F0F23).withOpacity(0.8),
        ),
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PlatformWidgets.activityIndicator(color: const Color(0xFF60A5FA), radius: 16),
            const SizedBox(height: 20),
            Text(t.moonSyncProcessing, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(20),
         border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3)),
         gradient: LinearGradient(
           begin: Alignment.topLeft,
           end: Alignment.bottomRight,
           colors: [
             const Color(0xFF1E3A5F).withOpacity(0.6),
             const Color(0xFF0F0F23).withOpacity(0.6),
           ]
         )
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.moon, color: Color(0xFF60A5FA), size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            t.moonSyncTitle, 
                            style: TextStyle(
                              color: isPro ? const Color(0xFFFBBF24) : const Color(0xFF60A5FA), 
                              fontSize: 18, 
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (!isPro)
                          const ProBadge(),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t.moonSyncSubtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(t.moonSyncDescription, style: const TextStyle(color: Colors.white, height: 1.6, fontSize: 14)),
          const SizedBox(height: 24),
          
          if (isPro)
             // PRO FLOW
             CustomButton(
               text: _totalDreamsCount >= 5 ? t.moonSyncBtn : t.moonSyncMinDreams,
               onPressed: _totalDreamsCount >= 5 
                  ? _runMoonSyncAnalysis
                  : null,
               isLoading: _isMoonSyncLoading,
               gradient: _totalDreamsCount >= 5 
                  // [MODIFIED] Matched to Dream Pattern Analysis Golden Gradient
                  ? const LinearGradient(colors: [Color(0xFFFBBF24), Color(0xFFD97706)]) 
                  : LinearGradient(colors: [Colors.grey.withOpacity(0.5), Colors.grey.withOpacity(0.5)]),
             )
          else
             // STANDARD FLOW (Upgrade Prompt)
             CustomButton(
               text: _totalDreamsCount >= 5 
                  ? t.proRequired  // "PRO Versiyon Gerekir"
                  : t.proRequiredDetail,  // "PRO Versiyon ve En Az 5 Kaydedilmiş Rüya Gerekir"
               onPressed: () => showDialog(context: context, builder: (ctx) => const ProUpgradeDialog()),
               gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)]),
               isLoading: _isMoonSyncLoading,
             )
        ],
      ),
    );
  }

  Widget _buildMoonSyncResultState(AppLocalizations t, bool isPro) {
    // Basic Markdown parser for the specific format
    List<Widget> contentWidgets = [];
    if (_moonSyncResult != null) {
      final lines = _moonSyncResult!.split('\n');
      for (var line in lines) {
         if (line.startsWith('###')) {
           contentWidgets.add(Padding(
             padding: const EdgeInsets.only(top: 20, bottom: 10),
             child: Text(
               line.replaceAll('###', '').trim(),
               style: const TextStyle(color: Color(0xFF60A5FA), fontSize: 16, fontWeight: FontWeight.bold),
             ),
           ));
         } else if (line.trim().startsWith('-')) {
           contentWidgets.add(Padding(
             padding: const EdgeInsets.only(bottom: 8),
             child: Row(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 const Padding(
                   padding: EdgeInsets.only(top: 6),
                   child: Icon(Icons.circle, size: 4, color: Colors.white70),
                 ),
                 const SizedBox(width: 10),
                 Expanded(child: Text(line.replaceAll('-', '').trim(), style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5))),
               ],
             ),
           ));
         } else if (line.trim().isNotEmpty) {
            contentWidgets.add(Text(line.trim(), style: const TextStyle(color: Colors.white, fontSize: 14)));
         }
      }
    }

    return Container(
      decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(20),
         border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3)),
         color: const Color(0xFF0F0F23).withOpacity(0.8),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.moon, color: Color(0xFF60A5FA), size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.moonSyncTitle, 
                      style: const TextStyle(color: Color(0xFF60A5FA), fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t.moonSyncSubtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(t.moonSyncDescription, style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.5)),
          const Divider(color: Colors.white10, height: 30),
          
          ...contentWidgets,
          
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12)
            ),
            alignment: Alignment.center,
            child: Text(
                t.moonSyncDone, 
                style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)
            ),
          ),
          const SizedBox(height: 12),
          Center(
              child: Text(
                  _getMoonSyncWaitMessage(t), 
                  style: const TextStyle(color: Colors.white24, fontSize: 12)
              )
          ),
        ],
      ),
    );
  }
}
