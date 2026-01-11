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

import 'package:provider/provider.dart';
import 'package:dream_boat_mobile/providers/subscription_provider.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  // 0: All, 1: Favorites
  int _selectedIndex = 0; 
  late PageController _pageController;

  
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

  Future<void> _deleteDream(String id) async {
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

    if (confirm != true) return;

    await DreamService().deleteDream(id);
    _loadDreams();
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

  Widget _buildDreamList(List<DreamEntry> dreams, String emptyMsg, AppLocalizations t) {
      final filtered = _filterDreams(dreams);
      
      if (_isLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFA78BFA)));
      }
      
      if (filtered.isEmpty) {
          return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Icon(LucideIcons.cloud, size: 48, color: Colors.white.withOpacity(0.2)),
                      const SizedBox(height: 16),
                      Text(emptyMsg, style: TextStyle(color: Colors.white.withOpacity(0.4))),
                  ]
              )
          );
      }

      return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          itemCount: filtered.length, // +1 for padding at bottom if needed
          itemBuilder: (context, index) {
              final dream = filtered[index];
              return AnimatedListItem(
                  index: index,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _DreamCard(
                        dream: dream,
                        t: t,
                        onToggleFavorite: () => _toggleFavorite(dream),
                        onDelete: () => _deleteDream(dream.id),
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
          title: GradientText(
            t.journalTitle,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            gradient: const LinearGradient(
              colors: [Colors.white, Color(0xFFA78BFA)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        body: Column(
          children: [
             // Filter Tabs
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
             
             // Search Bar
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
  final VoidCallback onToggleFavorite;
  final VoidCallback onDelete;

  const _DreamCard({
    super.key,
    required this.dream, 
    required this.t, 
    required this.onToggleFavorite, 
    required this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    final date = dream.date;
    // Short month names
    final months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
    // Turkish Override
    final monthsTr = ["Oca", "Şub", "Mar", "Nis", "May", "Haz", "Tem", "Ağu", "Eyl", "Eki", "Kas", "Ara"];
    
    final isTr = Localizations.localeOf(context).languageCode == 'tr';
    final monthStr = isTr ? monthsTr[date.month - 1] : months[date.month - 1];
    final dayStr = date.day.toString();
    final timeStr = "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

    // Mood mapping
    final moodMap = {
      'love': {'icon': LucideIcons.heart, 'color': const Color(0xFFEC4899)},
      'happy': {'icon': LucideIcons.smile, 'color': const Color(0xFFFBBF24)},
      'sad': {'icon': LucideIcons.cloudRain, 'color': const Color(0xFF60A5FA)},
      'scared': {'icon': LucideIcons.ghost, 'color': const Color(0xFF8B5CF6)},
      'anger': {'icon': LucideIcons.flame, 'color': const Color(0xFFEF4444)},
      'neutral': {'icon': LucideIcons.meh, 'color': const Color(0xFF9CA3AF)},
    };
    
    final moodData = moodMap[dream.mood] ?? moodMap['neutral']!;

    return Stack(
      children: [
        GlassCard(
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Date Column (Magazine Style)
                Column(
                  children: [
                    Text(
                      dayStr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                    Text(
                      monthStr.toUpperCase(),
                      style: const TextStyle(
                         color: Color(0xFFA78BFA),
                         fontSize: 14,
                         fontWeight: FontWeight.w600,
                         letterSpacing: 1.0
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 2,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFA78BFA).withOpacity(0.5),
                            const Color(0xFFA78BFA).withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter
                        )
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 20),
                
                // 2. Content Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              // Mood Badge 
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: (moodData['color'] as Color).withOpacity(0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: (moodData['color'] as Color).withOpacity(0.5))
                                ),
                                child: Icon(moodData['icon'] as IconData, size: 12, color: moodData['color'] as Color),
                              ),
                              const SizedBox(width: 8),
                              Icon(LucideIcons.clock, size: 14, color: AppTheme.textMuted),
                              const SizedBox(width: 4),
                              Text(timeStr, style: TextStyle(color: AppTheme.textMuted, fontSize: 13, fontWeight: FontWeight.w500)),
                            ],
                          ),
                          // Actions
                          Row(
                            children: [
                              GestureDetector(
                                onTap: onToggleFavorite,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: dream.isFavorite ? Colors.redAccent.withOpacity(0.2) : Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    dream.isFavorite ? LucideIcons.heart : LucideIcons.heart, 
                                    size: 18, 
                                    color: dream.isFavorite ? Colors.redAccent : Colors.white24
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: onDelete,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  child: const Icon(LucideIcons.trash2, size: 18, color: Colors.white24)
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Dream Text
                      Text(
                        dream.text,
                        style: const TextStyle(
                          color: Colors.white, 
                          fontSize: 15, 
                          height: 1.6,
                          letterSpacing: 0.2
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Interpretation (Collapsible)
                      if (dream.interpretation.isNotEmpty)
                         _CollapsibleInterpretation(text: dream.interpretation),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CollapsibleInterpretation extends StatefulWidget {
  final String text;
  const _CollapsibleInterpretation({required this.text});

  @override
  State<_CollapsibleInterpretation> createState() => _CollapsibleInterpretationState();
}

class _CollapsibleInterpretationState extends State<_CollapsibleInterpretation> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
      return GestureDetector(
        onTap: () {
            setState(() {
                _isExpanded = !_isExpanded;
            });
        },
        child: AnimatedContainer(
           duration: const Duration(milliseconds: 300),
           curve: Curves.easeInOut,
           padding: const EdgeInsets.all(16),
           decoration: BoxDecoration(
             color: const Color(0xFF1E1B35).withOpacity(0.5),
             borderRadius: BorderRadius.circular(12),
             border: Border.all(color: const Color(0xFFA78BFA).withOpacity(0.2)),
           ),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Row(
                   children: [
                       Icon(LucideIcons.sparkles, size: 16, color: const Color(0xFFA78BFA)),
                       const SizedBox(width: 8),
                       Text(
                          AppLocalizations.of(context)!.dreamInterpretationTitle,
                          style: TextStyle(color: Color(0xFFA78BFA), fontSize: 13, fontWeight: FontWeight.bold)
                        ),
                       const Spacer(),
                       Icon(
                           _isExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                           size: 16,
                           color: const Color(0xFFA78BFA).withOpacity(0.7)
                       )
                   ]
               ),
               
               if (_isExpanded) const SizedBox(height: 12),
               
               AnimatedCrossFade(
                   firstChild: Text(
                     widget.text,
                     maxLines: 2, // Preview 2 lines
                     overflow: TextOverflow.ellipsis,
                     style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13, height: 1.5),
                   ),
                   secondChild: Text(
                     widget.text,
                     style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, height: 1.6),
                   ),
                   crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                   duration: const Duration(milliseconds: 300),
               ),
               
               // "Read More" hint when collapsed
               if (!_isExpanded) ...[
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                       AppLocalizations.of(context)!.dreamInterpretationReadMore, 
                       style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10, fontStyle: FontStyle.italic)
                    ),
                  )
               ]
             ],
           ),
         ),
      );
  }
}
