import 'package:flutter/material.dart';

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
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      _dot('A', aCount, pct(aCount), Colors.green),
      _dot('B', bCount, pct(bCount), Colors.blue),
      _dot('C', cCount, pct(cCount), Colors.orange),
      _dot('D', dCount, pct(dCount), Colors.red),
    ]);
  }

  Widget _dot(String label, int count, String pct, Color color) {
    return Column(children: [
      CircleAvatar(radius: 16, backgroundColor: color),
      const SizedBox(height: 8),
      Text(label),
      Text('$count ($pct)')
    ]);
  }
}
