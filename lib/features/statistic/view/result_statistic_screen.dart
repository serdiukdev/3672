import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:itd_2/core/services/app_navigator.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/constants/app_text.dart';
import '../../../shared/components/nav_bar.dart';
import '../../settings/view/settings_screen.dart';
import '../bloc/statistic/bloc.dart';
import '../bloc/statistic/state.dart';
import 'choose_period_screen.dart';

class ResultStatisticScreen extends StatefulWidget {
  static const routeName = 'resultStatistic';

  const ResultStatisticScreen({super.key});

  @override
  State<ResultStatisticScreen> createState() => _ResultStatisticScreenState();
}

class _ResultStatisticScreenState extends State<ResultStatisticScreen> {
  int _tab = 4;
  final _bloc = StatisticBloc();
  List<CategoryStat> _stats = const [];
  double _total = 0;
  SelectedPeriod? _period;
  Timer? _timer;

  String _monthName(int m) => const [
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
  ][m - 1];

  String _formatPeriod(SelectedPeriod p) {
    final start = p.startDate;
    final end = p.endDate;
    if (start == null || end == null) {
      return '${_monthName(p.month)}, ${p.year}';
    }
    if (start.year == end.year && start.month == end.month) {
      return '${_monthName(start.month)} ${start.day}–${end.day}, ${start.year}';
    }
    return '${_monthName(start.month)} ${start.day}, ${start.year} – ${_monthName(end.month)} ${end.day}, ${end.year}';
  }

  Future<void> _refresh() async {
    final p = await _bloc.getSelectedPeriod();
    await _bloc.loadStatistics();
    setState(() {
      _period = p;
      _stats = _bloc.state.categories;
      _total = _bloc.state.total;
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _refresh());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bloc.close();
    super.dispose();
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
        leading: IconButton(
          onPressed: () =>
              context.pushNamedAndRemoveUntil(ChoosePeriodScreen.routeName),
          icon: Image.asset('assets/general_buttons/back_icon.webp'),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                context.pushNamedAndRemoveUntil(SettingsScreen.routeName),
            icon: Image.asset('assets/general_buttons/setting_icon.webp'),
          ),
        ],
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
            child: Container(color: Colors.black.withOpacity(0.2)),
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
                          AppTexts.noDataInPeriod,
                          style: AppStyles.yellowText.copyWith(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else ...[
                    if (_period != null) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _formatPeriod(_period!),
                          style: AppStyles.categoryItem,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
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
  final List<double> percents;

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

    if (total <= 0) {
      final bg = Paint()..color = Colors.white24;
      canvas.drawCircle(center, radius, bg);
      final outer = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = AppColors.chartBorder;
      canvas.drawCircle(center, radius, outer);
      return;
    }

    double startAngle = -pi / 2;
    final arcRect = Rect.fromCircle(center: center, radius: radius);
    for (int i = 0; i < values.length; i++) {
      final sweep = (values[i] / total) * 2 * pi;
      final fill = Paint()
        ..style = PaintingStyle.fill
        ..color = colors[i % colors.length];
      canvas.drawArc(arcRect, startAngle, sweep, true, fill);

      final arcStroke = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.chartBorder;
      canvas.drawArc(arcRect, startAngle, sweep, false, arcStroke);

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

      final mid = startAngle + sweep / 2;
      final labelRadius = radius * 0.58;
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
