import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:dream_boat_mobile/theme/app_theme.dart';
import 'package:dream_boat_mobile/widgets/background_sky.dart';
import 'package:dream_boat_mobile/widgets/glass_card.dart';

import 'package:dream_boat_mobile/l10n/app_localizations.dart';
import 'package:dream_boat_mobile/models/dream_entry.dart';
import 'package:dream_boat_mobile/services/dream_service.dart';
import 'package:dream_boat_mobile/widgets/gradient_text.dart';
import 'package:dream_boat_mobile/widgets/animated_list_item.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dream_boat_mobile/providers/subscription_provider.dart';
import 'package:dream_boat_mobile/services/moon_phase_service.dart';
import 'package:dream_boat_mobile/services/share_service.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  // 0: All, 1: Favorites
  int _selectedIndex = 0; 
  late PageController _pageController;

  // Multi-select state
  bool _isSelectionMode = false;
  Set<String> _selectedDreamIds = {};
  
  List<DreamEntry> _dreams = [];
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    // Defer Ad loading to check PRO status
    WidgetsBinding.instance.addPostFrameCallback((_) {
       // Pro check logic removed/simplified if needed
    });
    _loadDreams();
  }
  


  Future<void> _loadDreams() async {
    setState(() => _isLoading = true);
    final dreams = await DreamService().getDreams();
    setState(() {
      _dreams = dreams;
      _isLoading = false;
    });
  }

  void _onTabTapped(int index) {
      setState(() {
          _selectedIndex = index;
      });
      _pageController.animateToPage(
          index, 
          duration: const Duration(milliseconds: 300), 
          curve: Curves.easeInOut
      );
  }

  void _onPageChanged(int index) {
      setState(() {
          _selectedIndex = index;
      });
  }

  Future<bool> _deleteDream(String id) async {
    // Show Confirmation Dialog
    final t = AppLocalizations.of(context)!;
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1B35).withOpacity(0.95), // Premium Dark Background
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 5
              )
            ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

               const Text(
                 "Rüya Silinsin Mi?",
                 style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                 textAlign: TextAlign.center,
               ),
               const SizedBox(height: 8),
               Text(
                 "Bu rüyayı silmek istediğine emin misin? Bu işlem geri alınamaz.",
                 style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14, height: 1.5),
                 textAlign: TextAlign.center,
               ),
               const SizedBox(height: 24),
               Row(
                 children: [
                   Expanded(
                     child: TextButton(
                       onPressed: () => Navigator.pop(ctx, false),
                       style: TextButton.styleFrom(
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
                         gradient: const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFEC4899)]), // Red to Pink
                         borderRadius: BorderRadius.circular(12),
                         boxShadow: [
                           BoxShadow(color: Colors.redAccent.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
                         ]
                       ),
                       child: ElevatedButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          style: ElevatedButton.styleFrom(
                             backgroundColor: Colors.transparent,
                             shadowColor: Colors.transparent,
                             padding: const EdgeInsets.symmetric(vertical: 12),
                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                          ),
                          child: Text(t.delete, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                       ),
                     ),
                   )
                 ],
               )
            ],
          ),
        ),
      )
    );

    if (confirm != true) return false;

    await DreamService().deleteDream(id);
    _loadDreams();
    return true;
  }

  Future<void> _toggleFavorite(DreamEntry dream) async {
      final updated = dream.copyWith(isFavorite: !dream.isFavorite);
      await DreamService().updateDream(updated);
      _loadDreams();
  }

  List<DreamEntry> _filterDreams(List<DreamEntry> dreams) {
     if (_searchQuery.isEmpty) return dreams;
     return dreams.where((d) => 
        d.text.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        d.interpretation.toLowerCase().contains(_searchQuery.toLowerCase())
     ).toList();
  }

  // === MULTI-SELECT METHODS ===
  void _enterSelectionMode(String dreamId) {
    setState(() {
      _isSelectionMode = true;
      _selectedDreamIds = {dreamId};
    });
  }

  void _toggleSelection(String dreamId) {
    setState(() {
      if (_selectedDreamIds.contains(dreamId)) {
        _selectedDreamIds.remove(dreamId);
        if (_selectedDreamIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedDreamIds.add(dreamId);
      }
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedDreamIds = {};
    });
  }

  Future<void> _deleteSelectedDreams() async {
    final t = AppLocalizations.of(context)!;
    final count = _selectedDreamIds.length;
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1B35).withOpacity(0.95),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 5
              )
            ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Text(
                 "$count Rüya Silinsin Mi?",
                 style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                 textAlign: TextAlign.center,
               ),
               const SizedBox(height: 8),
               Text(
                 "Seçili rüyaları silmek istediğine emin misin? Bu işlem geri alınamaz.",
                 style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14, height: 1.5),
                 textAlign: TextAlign.center,
               ),
               const SizedBox(height: 24),
               Row(
                 children: [
                   Expanded(
                     child: TextButton(
                       onPressed: () => Navigator.pop(ctx, false),
                       style: TextButton.styleFrom(
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
                         gradient: const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFEC4899)]),
                         borderRadius: BorderRadius.circular(12),
                         boxShadow: [
                           BoxShadow(color: Colors.redAccent.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
                         ]
                       ),
                       child: ElevatedButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          style: ElevatedButton.styleFrom(
                             backgroundColor: Colors.transparent,
                             shadowColor: Colors.transparent,
                             padding: const EdgeInsets.symmetric(vertical: 12),
                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                          ),
                          child: Text(t.delete, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                       ),
                     ),
                   )
                 ],
               )
            ],
          ),
        ),
      )
    );

    if (confirm != true) return;

    for (final id in _selectedDreamIds) {
      await DreamService().deleteDream(id);
    }
    _exitSelectionMode();
    _loadDreams();
  }

  void _showDreamDetails(BuildContext context, DreamEntry dream) {
    final t = AppLocalizations.of(context)!;
    final date = dream.date;
    
    // Date formatting
    final locale = Localizations.localeOf(context).languageCode;
    final dateStr = DateFormat('dd MMM yyyy • HH:mm', locale).format(date).toUpperCase();
    
    // Use AI-generated title if available, otherwise fallback
    String generateFallbackTitle(String text) {
      if (text.length <= 40) return text;
      final firstSentence = text.split(RegExp(r'[.!?]')).first;
      if (firstSentence.length <= 50) return "$firstSentence...";
      return "${text.substring(0, 40)}...";
    }
    final title = dream.title ?? generateFallbackTitle(dream.text);

    // Helper to get localized phase name
    String getLocalizedMoonPhase() {
      final phase = MoonPhaseService().getMoonPhase(date);
      switch(phase) {
        case MoonPhase.newMoon: return t.moonPhaseNewMoon;
        case MoonPhase.waxingCrescent: return t.moonPhaseWaxingCrescent;
        case MoonPhase.firstQuarter: return t.moonPhaseFirstQuarter;
        case MoonPhase.waxingGibbous: return t.moonPhaseWaxingGibbous;
        case MoonPhase.fullMoon: return t.moonPhaseFullMoon;
        case MoonPhase.waningGibbous: return t.moonPhaseWaningGibbous;
        case MoonPhase.thirdQuarter: return t.moonPhaseThirdQuarter;
        case MoonPhase.waningCrescent: return t.moonPhaseWaningCrescent;
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        // Initialize mutable state with the dream passed to the function
        var currentDream = dream;
        
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.85,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (context, scrollController) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF13132B).withOpacity(0.98), // Darker Top
                      const Color(0xFF0F0F23).withOpacity(0.98), // Darker Bottom
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // Handle bar
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    
                    // Content
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dateStr,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                 children: [
                                   Icon(LucideIcons.moon, size: 14, color: Colors.white.withOpacity(0.5)),
                                   const SizedBox(width: 6),
                                   Text(
                                     "${t.moonPhaseLabel} ${getLocalizedMoonPhase()}",
                                     style: TextStyle(
                                       color: Colors.white.withOpacity(0.5),
                                       fontSize: 12,
                                       fontStyle: FontStyle.italic,
                                     ),
                                   ),
                                 ],
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Title (AI Summary)
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Dream Text
                          Text(
                            currentDream.text,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 16,
                              height: 1.8,
                              letterSpacing: 0.2,
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Interpretation Box (Glassmorphism)
                          if (currentDream.interpretation.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFF8B5CF6).withOpacity(0.3),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF8B5CF6).withOpacity(0.1),
                                    blurRadius: 20,
                                    spreadRadius: -5,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  
                                  // Header (NO sparkle icon)
                                  Text(
                                    t.dreamInterpretationTitle,
                                    style: const TextStyle(
                                      color: Color(0xFFA78BFA),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // Interpretation text
                                  Text(
                                    currentDream.interpretation,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                      height: 1.7,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          
                          const SizedBox(height: 40),
                          
                          // Action Buttons (inside scroll, not fixed)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Favori
                              _ActionButton(
                                icon: currentDream.isFavorite ? LucideIcons.heart : LucideIcons.heart,
                                label: t.actionFavorite,
                                // Change icon color based on state
                                iconColor: currentDream.isFavorite ? Colors.redAccent : Colors.white,
                                onTap: () async {
                                  // 1. Calculate new state
                                  final newStatus = !currentDream.isFavorite;
                                  final updated = currentDream.copyWith(isFavorite: newStatus);

                                  // 2. Optimistic UI Update (Local)
                                  setModalState(() {
                                    currentDream = updated;
                                  });

                                  // 3. Backend Update
                                  await DreamService().updateDream(updated);
                                  _loadDreams(); // Notify parent list
                                },
                              ),
                              
                              // Yorumu Paylaş
                              _ActionButton(
                                icon: LucideIcons.share2,
                                label: t.actionShareInterpretation,
                                onTap: () async {
                                  if (currentDream.interpretation.isNotEmpty) {
                                    await ShareService.shareInterpretation(
                                      context,
                                      currentDream.interpretation,
                                      t.shareCardWatermark,
                                      t.shareCardHeader,
                                    );
                                  }
                                },
                              ),
                              
                              // Sil
                              _ActionButton(
                                icon: LucideIcons.trash2,
                                label: t.delete,
                                onTap: () async {
                                  // Wait for confirmation result
                                  final deleted = await _deleteDream(currentDream.id);
                                  // Only close modal if actually deleted
                                  if (deleted) {
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Privacy Hint
                          Text(
                            t.sharePrivacyHint,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                          
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }


  Widget _buildDreamList(List<DreamEntry> dreams, String emptyMsg, AppLocalizations t) {
      final filtered = _filterDreams(dreams);
      
      if (_isLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFA78BFA)));
      }
      
      if (filtered.isEmpty) {
          return Center(
              child: Text(
                emptyMsg, 
                style: TextStyle(color: Colors.white.withOpacity(0.4)),
                textAlign: TextAlign.center,
              ),
          );
      }

      return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
              final dream = filtered[index];
              final isSelected = _selectedDreamIds.contains(dream.id);
              
              return AnimatedListItem(
                  index: index,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _isSelectionMode && !isSelected ? 0.5 : 1.0,
                      child: _DreamCard(
                          dream: dream,
                          t: t,
                          isSelectionMode: _isSelectionMode,
                          isSelected: isSelected,
                          onLongPress: () => _enterSelectionMode(dream.id),
                          onToggleFavorite: () => _toggleFavorite(dream),
                          onDelete: () => _deleteDream(dream.id),
                          onTap: () {
                            if (_isSelectionMode) {
                              _toggleSelection(dream.id);
                            } else {
                              _showDreamDetails(context, dream);
                            }
                          },
                      ),
                    ),
                  )
              );
          }
      );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isPro = context.watch<SubscriptionProvider>().isPro; // Watch PRO status
    
    final allDreams = _dreams;
    final favoriteDreams = _dreams.where((d) => d.isFavorite).toList();

    return NightSkyBackground(
      child: Scaffold(
        resizeToAvoidBottomInset: false, // Prevent keyboard from resizing background weirdly
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            t.journalTitle,
            style: const TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          children: [
             // Filter Tabs (hide in selection mode)
             if (!_isSelectionMode)
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     _FilterTab(
                       text: t.journalAll, 
                       isSelected: _selectedIndex == 0,
                       onTap: () => _onTabTapped(0),
                     ),
                     const SizedBox(width: 16),
                     _FilterTab(
                       text: t.journalFavorites, 
                       isSelected: _selectedIndex == 1,
                       onTap: () => _onTabTapped(1),
                     ),
                   ],
                 ),
               ),
             
             // Search Bar (hide in selection mode)
             if (!_isSelectionMode)
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0).copyWith(bottom: 10),
                 child: GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() => _searchQuery = val);
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                         icon: Icon(LucideIcons.search, color: Colors.white.withOpacity(0.5), size: 20),
                         hintText: t.journalSearchHint,
                         hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                         border: InputBorder.none,
                         isDense: true
                      ),
                    )
                 ),
               ),
             
             // Selection Bar (show in selection mode) - transparent, no box
             if (_isSelectionMode)
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0).copyWith(bottom: 10),
                 child: Row(
                   children: [
                     // Cancel button (X)
                     GestureDetector(
                       onTap: _exitSelectionMode,
                       child: Icon(LucideIcons.x, color: Colors.white.withOpacity(0.7), size: 22),
                     ),
                     const SizedBox(width: 16),
                     // Selected count
                     Expanded(
                       child: Text(
                         t.nSelected(_selectedDreamIds.length),
                         style: TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 17, fontWeight: FontWeight.w600),
                       ),
                     ),
                     // Delete button (outlined circle)
                     GestureDetector(
                       onTap: _deleteSelectedDreams,
                       child: Container(
                         padding: const EdgeInsets.all(10),
                         decoration: BoxDecoration(
                           shape: BoxShape.circle,
                           border: Border.all(color: Colors.redAccent.withOpacity(0.5), width: 1.5),
                         ),
                         child: Icon(LucideIcons.trash2, color: Colors.redAccent.withOpacity(0.8), size: 18),
                       ),
                     ),
                   ],
                 ),
               ),
             
             // Content PageView
             Expanded(
               child: PageView(
                 controller: _pageController,
                 onPageChanged: _onPageChanged,
                 children: [
                    _buildDreamList(allDreams, t.journalNoDreams, t),
                    _buildDreamList(favoriteDreams, t.journalNoFavorites, t),
                 ],
               ),
             ),
             

          ],
        ),
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTab({required this.text, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2E2B52) : const Color(0xFF0F0F23).withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFFA78BFA) : Colors.transparent,
              width: 1.5
            )
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white60,
              fontWeight: FontWeight.bold,
              fontSize: 15
            ),
          ),
        ),
      ),
    );
  }
}

class _DreamCard extends StatelessWidget {
  final DreamEntry dream;
  final AppLocalizations t;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onLongPress;
  final VoidCallback onToggleFavorite;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const _DreamCard({
    super.key,
    required this.dream, 
    required this.t, 
    this.isSelectionMode = false,
    this.isSelected = false,
    required this.onLongPress,
    required this.onToggleFavorite, 
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final date = dream.date;
    final locale = Localizations.localeOf(context).languageCode;
    final dayStr = date.day.toString().padLeft(2, '0');
    final monthStr = DateFormat.MMM(locale).format(date).toUpperCase();
    final yearStr = date.year.toString();
    final timeStr = DateFormat.Hm(locale).format(date);

    // Mood mapping (Pastel / Misty colors)
    final moodMap = {
      'love': {'icon': LucideIcons.heart, 'color': const Color(0xFFD48CB3)}, // Muted Pink
      'happy': {'icon': LucideIcons.smile, 'color': const Color(0xFFD4C08C)}, // Muted Yellow
      'sad': {'icon': LucideIcons.cloudRain, 'color': const Color(0xFF8CA4D4)}, // Muted Blue
      'scared': {'icon': LucideIcons.ghost, 'color': const Color(0xFFA48CD4)}, // Muted Purple
      'anger': {'icon': LucideIcons.flame, 'color': const Color(0xFFD48C8C)}, // Muted Red
      'neutral': {'icon': LucideIcons.meh, 'color': const Color(0xFFA0A0A0)}, // Muted Gray
    };
    
    final moodData = moodMap[dream.mood] ?? moodMap['neutral']!;
    final moodColor = moodData['color'] as Color;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left: Date Column with Timeline
          SizedBox(
            width: 50,
            child: Column(
              children: [
                // Date Info
                Text(
                  dayStr,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.95),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                  ),
                ),
                Text(
                  monthStr,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  yearStr,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 8),
                // Timeline Node (circle)
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                  ),
                ),
                // Timeline Line
                Expanded(
                  child: Container(
                    width: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.2),
                          Colors.white.withOpacity(0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Right: Dream Card
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              onLongPress: onLongPress,
              child: Stack(
                children: [
                  // Main Card with neon glow when selected
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF13132B).withOpacity(0.95),
                          const Color(0xFF0F0F23).withOpacity(0.95),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected 
                          ? const Color(0xFFA78BFA).withOpacity(0.6)
                          : Colors.white.withOpacity(0.08),
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                        // Neon glow when selected
                        if (isSelected)
                          BoxShadow(
                            color: const Color(0xFFA78BFA).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                      ],
                    ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Mood Indicator Bar (Vertical Line - Thin & Misty)
                      Container(
                        width: 3, 
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              moodColor.withOpacity(0.6),
                              moodColor.withOpacity(0.1),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: moodColor.withOpacity(0.2),
                              blurRadius: 6,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                      ),
                      
                      // Content
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header Row (Separate Time & Mood)
                              Row(
                                children: [
                                  // Mood Icon
                                  Icon(moodData['icon'] as IconData, size: 16, color: moodColor),
                                  
                                  const Spacer(),
                                  
                                  // Actions (hide in selection mode)
                                  if (!isSelectionMode) ...[
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: onToggleFavorite,
                                        borderRadius: BorderRadius.circular(20),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Icon(
                                            dream.isFavorite ? LucideIcons.heart : LucideIcons.heart,
                                            size: 20,
                                            color: dream.isFavorite ? Colors.redAccent : Colors.white38,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: onDelete,
                                        borderRadius: BorderRadius.circular(20),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Icon(LucideIcons.trash2, size: 20, color: Colors.white38),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              
                              const SizedBox(height: 12),
                              
                              // Dream Text (Expandable)
                              // Dream Text (Expandable)
                              _ExpandableDreamText(text: dream.text),
                              
                              const SizedBox(height: 12),
                              
                              // Interpretation (Collapsible)
                              if (dream.interpretation.isNotEmpty)
                                 _CollapsibleInterpretation(text: dream.interpretation),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Selection indicator (top-right corner)
              if (isSelectionMode)
                Positioned(
                  top: 8,
                  right: 8,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected 
                        ? const Color(0xFFA78BFA)
                        : Colors.white.withOpacity(0.1),
                      border: Border.all(
                        color: isSelected 
                          ? const Color(0xFFA78BFA)
                          : Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: isSelected 
                      ? const Icon(LucideIcons.check, size: 14, color: Colors.white)
                      : null,
                  ),
                ),
            ],
          ),
        ),
      ),
    ],
  ),
);
  }
}

class _CollapsibleInterpretation extends StatelessWidget {
  final String text;
  const _CollapsibleInterpretation({required this.text});

  @override
  Widget build(BuildContext context) {
      return Container(
           padding: const EdgeInsets.all(16),
           decoration: BoxDecoration(
             color: const Color(0xFF1E1B35).withOpacity(0.5),
             borderRadius: BorderRadius.circular(12),
             border: Border.all(color: const Color(0xFFA78BFA).withOpacity(0.2)),
           ),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               // Header (no arrow)
               Text(
                  AppLocalizations.of(context)!.dreamInterpretationTitle,
                  style: TextStyle(color: Color(0xFFA78BFA), fontSize: 13, fontWeight: FontWeight.bold)
               ),
               
               const SizedBox(height: 8),
               
               // Preview text (2 lines)
               Text(
                 text,
                 maxLines: 2,
                 overflow: TextOverflow.ellipsis,
                 style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13, height: 1.5),
               ),
               
               const SizedBox(height: 8),
               
               // Hint to tap for details (centered)
               Center(
                 child: Text(
                    AppLocalizations.of(context)!.tapForDetails, 
                    style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10, fontStyle: FontStyle.italic)
                 ),
               )
             ],
           ),
      );
  }
}

// Action Button for Dream Detail Modal
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80, // Fixed width for consistent layout
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Icon(icon, color: iconColor ?? Colors.white.withOpacity(0.9), size: 24),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 32, // Fixed height for 2 lines of text
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandableDreamText extends StatefulWidget {
  final String text;

  const _ExpandableDreamText({required this.text});

  @override
  State<_ExpandableDreamText> createState() => _ExpandableDreamTextState();
}

class _ExpandableDreamTextState extends State<_ExpandableDreamText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder crashes inside IntrinsicHeight, so we use a heuristic based on char length
    // Assuming roughly 40-50 chars per line, 5 lines is ~200-250 chars.
    final isLongText = widget.text.length > 200;

    if (!isLongText) {
      return Text(widget.text, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 15, height: 1.5));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: Text(widget.text, maxLines: 5, overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 15, height: 1.5)),
          secondChild: Text(widget.text,
            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 15, height: 1.5)),
          crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
           if (!_isExpanded)
             GestureDetector(
               onTap: () => setState(() => _isExpanded = true),
               child: Padding(
                 padding: const EdgeInsets.only(top: 8.0),
                 child: Center(
                   child: Text(
                      AppLocalizations.of(context)!.readMore,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                   ),
                 ),
               ),
             )
      ]
    );
  }
}
