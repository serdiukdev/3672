import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:itd_2/core/services/app_navigator.dart';
import 'package:itd_2/features/statistic/view/choose_month_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/constants/app_text.dart';
import '../../../shared/components/nav_bar.dart';
import '../../main/view/main_screen.dart';

class StatisticScreen extends StatefulWidget {
  static const routeName = 'statistic';

  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _CategoryStat {
  final String name;
  final double amount;
  final double percent;

  _CategoryStat(this.name, this.amount, this.percent);
}

class _StatisticScreenState extends State<StatisticScreen> {
  int _tab = 4;
  List<_CategoryStat> _stats = [];
  double _total = 0;
  Timer? _timer;

  String _formatMonthYear(DateTime dt) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[dt.month - 1]}, ${dt.year}';
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _loadData());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList('expense_entries') ?? <String>[];
    final now = DateTime.now();
    final Map<String, double> byCategory = {};

    for (final s in raw) {
      try {
        final m = jsonDecode(s) as Map<String, dynamic>;
        final dateStr = (m['date'] as String?) ?? '';
        final parts = dateStr.split('-');
        if (parts.length != 3) continue;
        final d = int.tryParse(parts[0]) ?? 1;
        final mo = int.tryParse(parts[1]) ?? 1;
        final y = int.tryParse(parts[2]) ?? 1970;
        final dt = DateTime(y, mo, d);
        if (dt.year != now.year || dt.month != now.month) continue;

        final name = (m['subCategory'] as String?)?.trim();
        if (name == null || name.isEmpty) continue;
        final v = (m['amount'] as num?)?.toDouble() ?? 0;
        if (v <= 0) continue;
        byCategory.update(name, (p) => p + v, ifAbsent: () => v);
      } catch (_) {}
    }

    final total = byCategory.values.fold<double>(0, (a, b) => a + b);
    final list =
        byCategory.entries
            .map(
              (e) => _CategoryStat(
                e.key,
                e.value,
                total == 0 ? 0 : (e.value / total),
              ),
            )
            .toList()
          ..sort((a, b) => b.amount.compareTo(a.amount));

    if (!mounted) return;
    setState(() {
      _stats = list;
      _total = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final chartSize = min(size.width, size.height) * 0.76;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(AppTexts.statistic, style: AppStyles.achievementTitle),
        actions: [
          IconButton(
            onPressed: () =>
                context.pushNamedAndRemoveUntil(ChooseMonthScreen.routeName),
            icon: Image.asset('assets/general_buttons/calendar_icon.webp'),
          ),
        ],
        leading: IconButton(
          onPressed: () =>
              context.pushNamedAndRemoveUntil(MainScreen.routeName),
          icon: Image.asset('assets/general_buttons/back_icon.webp'),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _tab,
        onTap: (index) => setState(() => _tab = index),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_in_game/bg_3.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: Container(color: AppColors.mainBlack.withOpacity(0.3)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  if (_total <= 0)
                    Expanded(
                      child: Center(
                        child: Text(
                          AppTexts.noData,
                          style: AppStyles.yellowText.copyWith(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else ...[
                    Container(
                      width: double.infinity,
                      child: Text(
                        _formatMonthYear(DateTime.now()),
                        style: AppStyles.categoryItem,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        width: chartSize,
                        height: chartSize,
                        child: CustomPaint(
                          painter: _PieChartPainter(
                            values: _stats.map((e) => e.amount).toList(),
                            colors: _paletteFor(_stats.length),
                            labels: _stats.map((e) => e.name).toList(),
                            percents: _stats.map((e) => e.percent).toList(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(16, 5, 16, 10),
                        height: size.height * 0.25,
                        width: size.width * 0.75,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/bg_components/statistic_bg.webp',
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: ListView.separated(
                          //   padding: EdgeInsets.fromLTRB(16, 12, 16, 25),
                          itemCount: _stats.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final item = _stats[index];
                            final color = _paletteFor(
                              _stats.length,
                            )[index % _palette.length];
                            final percent = (item.percent * 100)
                                .clamp(0, 100)
                                .toStringAsFixed(0);
                            return Container(
                              height: size.height * 0.03,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),

                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.mainWhite.withOpacity(
                                          0.8,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      item.name,
                                      style: AppStyles.statList,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text('$percent%', style: AppStyles.statList),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const List<Color> _palette = <Color>[
  Color(0xFFE57373),
  Color(0xFF64B5F6),
  Color(0xFF81C784),
  Color(0xFFFFB74D),
  Color(0xFFBA68C8),
  Color(0xFF4DD0E1),
  Color(0xFFA1887F),
  Color(0xFFFF8A65),
  Color(0xFF90A4AE),
];

List<Color> _paletteFor(int n) {
  if (n <= _palette.length) return _palette.sublist(0, n);
  return List<Color>.generate(n, (i) => _palette[i % _palette.length]);
}

class _PieChartPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;
  final List<String> labels;
  final List<double> percents; // 0..1
  _PieChartPainter({
    required this.values,
    required this.colors,
    required this.labels,
    required this.percents,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold<double>(0, (a, b) => a + b);
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = min(size.width, size.height) / 2;

    // Background circle (optional subtle backdrop when no data)
    if (total <= 0) {
      final bg = Paint()..color = Colors.white24;
      canvas.drawCircle(center, radius, bg);
      // Outer border even when empty
      final outer = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = AppColors.chartBorder;
      canvas.drawCircle(center, radius, outer);
      return;
    }

    // Draw sectors
    double startAngle = -pi / 2;
    final arcRect = Rect.fromCircle(center: center, radius: radius);
    for (int i = 0; i < values.length; i++) {
      final sweep = (values[i] / total) * 2 * pi;
      final fill = Paint()
        ..style = PaintingStyle.fill
        ..color = colors[i % colors.length];
      // Fill sector
      canvas.drawArc(arcRect, startAngle, sweep, true, fill);

      // Sector border (outer arc)
      final arcStroke = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.chartBorder;
      canvas.drawArc(arcRect, startAngle, sweep, false, arcStroke);

      // Sector border (radial lines)
      final line = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.chartBorder;
      final startLine = Offset(
        center.dx + cos(startAngle) * radius,
        center.dy + sin(startAngle) * radius,
      );
      final endLine = Offset(
        center.dx + cos(startAngle + sweep) * radius,
        center.dy + sin(startAngle + sweep) * radius,
      );
      canvas.drawLine(center, startLine, line);
      canvas.drawLine(center, endLine, line);

      // Label inside sector
      final mid = startAngle + sweep / 2;
      final labelRadius = radius * 0.58; // place labels comfortably inside
      final labelPos = Offset(
        center.dx + cos(mid) * labelRadius,
        center.dy + sin(mid) * labelRadius,
      );
      final percentText = (percents[i] * 100).toStringAsFixed(0) + '%';
      final textStyle = AppStyles.chartDescription;
      final span = TextSpan(
        text: labels[i] + '\n' + percentText,
        style: textStyle,
      );
      final tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        maxLines: 2,
      );
      tp.layout(maxWidth: radius * 0.9);
      final offset = labelPos - Offset(tp.width / 2, tp.height / 2);
      tp.paint(canvas, offset);

      startAngle += sweep;
    }

    // Outer border around entire chart
    final outer = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..color = AppColors.chartBorder;
    canvas.drawCircle(center, radius, outer);
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) {
    if (identical(this, oldDelegate)) return false;
    if (values.length != oldDelegate.values.length) return true;
    for (int i = 0; i < values.length; i++) {
      if (values[i] != oldDelegate.values[i]) return true;
      if (labels[i] != oldDelegate.labels[i]) return true;
      if (percents[i] != oldDelegate.percents[i]) return true;
    }
    return false;
  }
}
