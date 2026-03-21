import 'package:flutter/material.dart';
import 'dart:math' as math;

class SimplePieChart extends StatelessWidget {
  final int aCount, bCount, cCount, dCount;
  const SimplePieChart(
      {super.key,
      required this.aCount,
      required this.bCount,
      required this.cCount,
      required this.dCount});

  @override
  Widget build(BuildContext context) {
    final total = aCount + bCount + cCount + dCount;
    final pct = (int v) =>
        total == 0 ? '0%' : '${((v / total) * 100).toStringAsFixed(0)}%';
        
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: CustomPaint(
            painter: _PieChartPainter(
              aCount: aCount,
              bCount: bCount,
              cCount: cCount,
              dCount: dCount,
            ),
            child: const SizedBox(
              height: 150,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _legendItem('A', aCount, pct(aCount), Colors.green),
              _legendItem('B', bCount, pct(bCount), Colors.blue),
              _legendItem('C', cCount, pct(cCount), Colors.orange),
              _legendItem('D', dCount, pct(dCount), Colors.red),
            ],
          ),
        )
      ],
    );
  }

  Widget _legendItem(String label, int count, String pct, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$label: $count ($pct)',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final int aCount, bCount, cCount, dCount;

  _PieChartPainter({
    required this.aCount,
    required this.bCount,
    required this.cCount,
    required this.dCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = aCount + bCount + cCount + dCount;
    
    final paint = Paint()..style = PaintingStyle.fill;
      
    final radius = math.min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: radius,
    );

    if (total == 0) {
      paint.color = Colors.grey.shade300;
      canvas.drawArc(rect, 0, 2 * math.pi, true, paint);
      return;
    }

    double startAngle = -math.pi / 2; // Start from top
    
    void drawSlice(int count, Color color) {
      if (count == 0) return;
      final sweepAngle = (count / total) * 2 * math.pi;
      paint.color = color;
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      startAngle += sweepAngle;
    }

    drawSlice(aCount, Colors.green);
    drawSlice(bCount, Colors.blue);
    drawSlice(cCount, Colors.orange);
    drawSlice(dCount, Colors.red);
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) {
    return aCount != oldDelegate.aCount ||
           bCount != oldDelegate.bCount ||
           cCount != oldDelegate.cCount ||
           dCount != oldDelegate.dCount;
  }
}
