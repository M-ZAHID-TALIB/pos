import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  Map<String, double> dailySales = {};
  double totalSales = 0;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('orders')
            .orderBy('timestamp', descending: true)
            .get();

    Map<String, double> salesMap = {};
    double total = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      if (data['timestamp'] == null) continue;

      final date = (data['timestamp'] as Timestamp).toDate();
      if ((startDate != null && date.isBefore(startDate!)) ||
          (endDate != null && date.isAfter(endDate!))) {
        continue;
      }

      final formattedDate = DateFormat('yyyy-MM-dd').format(date);

      final totalForOrder = (data['total'] ?? 0).toDouble();

      salesMap[formattedDate] = (salesMap[formattedDate] ?? 0) + totalForOrder;
      total += totalForOrder;
    }

    setState(() {
      dailySales = salesMap;
      totalSales = total;
    });
  }

  List<BarChartGroupData> _buildChartData() {
    List<String> sortedDates = dailySales.keys.toList()..sort();

    return List.generate(sortedDates.length, (index) {
      final date = sortedDates[index];
      final value = dailySales[date]!;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(toY: value, width: 14, color: Colors.blueAccent),
        ],
      );
    });
  }

  List<String> get dateLabels {
    List<String> sortedDates = dailySales.keys.toList()..sort();
    return sortedDates
        .map((d) => DateFormat.Md().format(DateTime.parse(d)))
        .toList();
  }

  Future<void> _exportCSV() async {
    List<List<String>> rows = [
      ["Date", "Total Sales"],
    ];

    dailySales.forEach((date, totalSales) {
      rows.add([date, totalSales.toStringAsFixed(2)]);
    });

    String csv = const ListToCsvConverter().convert(rows);

    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/sales_report.csv";
    final file = File(path);
    await file.writeAsString(csv);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("CSV Report exported to: $path")));
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final pickedStartDate = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedStartDate != null && pickedStartDate != startDate) {
      if (!mounted) return;
      final pickedEndDate = await showDatePicker(
        context: context,
        initialDate: endDate ?? DateTime.now(),
        firstDate: pickedStartDate,
        lastDate: DateTime.now(),
      );
      if (pickedEndDate != null) {
        setState(() {
          startDate = pickedStartDate;
          endDate = pickedEndDate;
        });
        fetchReports();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sales Report')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            dailySales.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Sales: \$${totalSales.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _selectDateRange(context),
                          child: const Text('Select Date Range'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index < 0 || index >= dateLabels.length) {
                                    return const SizedBox();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      dateLabels[index],
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          barGroups: _buildChartData(),
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: false),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _exportCSV,
                      child: const Text('Export to CSV'),
                    ),
                  ],
                ),
      ),
    );
  }
}
