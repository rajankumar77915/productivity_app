import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app/model/task.dart';

class TaskStatusChart extends StatefulWidget {
  final List<TaskData> taskDataList;

  TaskStatusChart({required this.taskDataList});

  @override
  _TaskStatusChartState createState() => _TaskStatusChartState();
}

class _TaskStatusChartState extends State<TaskStatusChart> {
  int touchedIndex = -1;
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Material(child: AspectRatio(
      aspectRatio: 1,
      child: Column(
        children: <Widget>[
          const Text(
            'Weekly',
            style: TextStyle(
              color: Colors.green,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Task Completion Chart',
            style: TextStyle(
              color: Colors.green.shade700,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 38),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: BarChart(
                isPlaying ? randomData() : mainBarData(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.green,
              ),
              onPressed: () {
                setState(() {
                  isPlaying = !isPlaying;
                  if (isPlaying) {
                    refreshState();
                  }
                });
              },
            ),
          ),
        ],
      ),
    ),);
  }

  BarChartGroupData makeGroupData(
      int x, double y, bool isTouched, double width, List<int> showTooltips) {
    final barColor = Colors.white;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? Colors.green : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.green.shade700.withOpacity(0.8))
              : BorderSide.none,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: Colors.grey.withOpacity(0.3),
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }
  final List<num>yValues = [5, 6.5, 5, 7.5, 9, 11.5, 6.5];
  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {

    return makeGroupData(i, i+5, i == touchedIndex, 22, []);
  });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
            return BarTooltipItem(
              '${days[group.x]}\n',
              TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - 1).toString(),
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(
        days[value.toInt()],
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(enabled: false),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      barGroups: List.generate(7, (i) {
        final randomValue = Random().nextInt(15).toDouble() + 6;
        return makeGroupData(i, randomValue, false, 22, []);
      }),
      gridData: FlGridData(show: false),
    );
  }

  Future<void> refreshState() async {
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 300) + const Duration(milliseconds: 50));
    if (isPlaying) {
      await refreshState();
    }
  }
}
