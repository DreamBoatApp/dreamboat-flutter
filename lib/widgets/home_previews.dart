import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:math';

// 1. Real Calendar Grid (No months, just days)
class CalendarPreview extends StatelessWidget {
  const CalendarPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 52, 16, 4), // Balanced padding: Top 52 avoids title, Bottom 4 avoids overflow
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: "MTWTFSS".split("").map((d) => 
               Text(d, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 9, fontWeight: FontWeight.bold)) // Reduced font size slightly
            ).toList(),
          ),
          const SizedBox(height: 2), // Reduced spacing
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 2, // Reduced spacing
                crossAxisSpacing: 4,
              ),
              itemCount: 28, // 4 weeks
                itemBuilder: (context, index) {
                final day = index + 1;
                // Highlight specific days requested by user: 6, 7, 13, 14, 20, 21, 27, 28
                // Removed 5 (default), Added 6 (highlight)
                final isDreamDay = [6, 7, 13, 14, 20, 21, 27, 28].contains(day);
                // 18 is now default color, so isToday logic removed or set to false effectively
                final isToday = false; 
                
                return Container(
                  decoration: BoxDecoration(
                    color: isDreamDay ? const Color(0xFFA78BFA).withOpacity(0.6) : Colors.transparent,
                    shape: BoxShape.circle,
                    // Remove border for non-highlighted days to match "default" look request, or keep faint border?
                    // "make others default color" implies just text color 
                    border: null, 
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "$day",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 2. Real Pie Chart (Custom Painter to match image style)
class StatsPreview extends StatelessWidget {
  const StatsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Centered resize logic:
      // Target Center Y = 97.
      // New Size 102 (114 * 0.9). Top = 97 - 51 = 46.
      padding: const EdgeInsets.only(top: 46), 
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 102, 
          height: 102,
          // Use scaling and masking to "zoom in" on the outer ring and hide the inner one
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipOval( // Clip the scaled overflow to keep it circular
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const RadialGradient(
                      colors: [Colors.transparent, Colors.transparent, Colors.white, Colors.white],
                      stops: [0.0, 0.05, 0.4, 1.0], // Hole drastically reduced to 5%, smooth fade
                      radius: 0.6, 
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn, 
                  child: Transform.scale(
                    scale: 1.15, // Reduced scale to prevent overflow
                    child: Image.asset(
                      'assets/images/constellation_chart.png', 
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// 3. Temple Visual (Golden Icon)
class TempleVisual extends StatelessWidget {
  const TempleVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: const Color(0xFFFBBF24).withOpacity(0.2), blurRadius: 20, spreadRadius: 5),
              ],
              gradient: RadialGradient(
                colors: [const Color(0xFFFBBF24).withOpacity(0.1), Colors.transparent],
              )
            ),
            child: const Icon(LucideIcons.landmark, size: 48, color: Color(0xFFFBBF24)), // Landmark looks like a temple/bank
          ),
        ],
      ),
    );
  }
}
