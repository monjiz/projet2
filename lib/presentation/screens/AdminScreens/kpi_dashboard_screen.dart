import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class KPIDashboardScreen extends StatefulWidget {
  const KPIDashboardScreen({Key? key}) : super(key: key);

  @override
  State<KPIDashboardScreen> createState() => _KPIDashboardScreenState();
}

class _KPIDashboardScreenState extends State<KPIDashboardScreen> {
  late TooltipBehavior _tooltipBehavior;
  int _selectedIndex = 0;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tableau de bord',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistiques',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            _buildChartSection(),
            const SizedBox(height: 24),
            Text(
              'Alertes',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            _buildAlertsSection(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Projets'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    final List<ChartData> data = [
      ChartData('Jan', 35),
      ChartData('Fév', 28),
      ChartData('Mar', 34),
      ChartData('Avr', 32),
      ChartData('Mai', 40),
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SfCartesianChart(
          tooltipBehavior: _tooltipBehavior,
          primaryXAxis: CategoryAxis(),
          title: ChartTitle(text: 'Évolution mensuelle'),
          series: <CartesianSeries<dynamic, dynamic>>[
            LineSeries<ChartData, String>(
              dataSource: data,
              xValueMapper: (ChartData sales, _) => sales.x,
              yValueMapper: (ChartData sales, _) => sales.y,
              name: 'Projets',
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsSection() {
    final alerts = [
      '2 projets sont en retard.',
      '5 tâches non assignées.',
      'Un utilisateur a signalé un problème.',
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: alerts
              .map(
                (alert) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.warning, color: Colors.red),
                  title: Text(alert, style: GoogleFonts.poppins(fontSize: 14)),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class ChartData {
  final String x;
  final num y;

  ChartData(this.x, this.y);
}
