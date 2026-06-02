import 'package:flutter/material.dart';

void main() {
  runApp(const PaymentTrackerApp());
}

class PaymentTrackerApp extends StatelessWidget {
  const PaymentTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
      },
    );
  }
}

class Payment {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String status;
  final String department;

  Payment({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.status,
    required this.department,
  });
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Payment> _payments = [
    Payment(id: '1', title: 'Office Supplies', amount: 250.0, date: DateTime.now().subtract(const Duration(days: 1)), status: 'Completed', department: 'Admin'),
    Payment(id: '2', title: 'Software Licenses', amount: 1200.0, date: DateTime.now().subtract(const Duration(days: 2)), status: 'Pending', department: 'IT'),
    Payment(id: '3', title: 'Marketing Campaign', amount: 3500.0, date: DateTime.now().subtract(const Duration(days: 5)), status: 'Approved', department: 'Marketing'),
    Payment(id: '4', title: 'Consulting Fees', amount: 800.0, date: DateTime.now().subtract(const Duration(days: 10)), status: 'Completed', department: 'HR'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Org Payment Tracker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return _buildDesktopLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new payment logic
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add Payment feature coming soon!')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Column(
          children: [
            _buildSummaryCards(),
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    DataTable(
                      columns: const [
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Title')),
                        DataColumn(label: Text('Department')),
                        DataColumn(label: Text('Amount')),
                        DataColumn(label: Text('Status')),
                      ],
                      rows: _payments.map((payment) => DataRow(
                        cells: [
                          DataCell(Text('${payment.date.year}-${payment.date.month.toString().padLeft(2, '0')}-${payment.date.day.toString().padLeft(2, '0')}')),
                          DataCell(Text(payment.title)),
                          DataCell(Text(payment.department)),
                          DataCell(Text('\$${payment.amount.toStringAsFixed(2)}')),
                          DataCell(_buildStatusChip(payment.status)),
                        ],
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildSummaryCards(),
        Expanded(
          child: ListView.builder(
            itemCount: _payments.length,
            itemBuilder: (context, index) {
              final payment = _payments[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ListTile(
                  title: Text(payment.title),
                  subtitle: Text('${payment.department} • ${payment.date.year}-${payment.date.month.toString().padLeft(2, '0')}-${payment.date.day.toString().padLeft(2, '0')}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('\$${payment.amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      _buildStatusChip(payment.status),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    double total = _payments.fold(0, (sum, item) => sum + item.amount);
    int pending = _payments.where((p) => p.status == 'Pending').length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 16.0,
        runSpacing: 16.0,
        alignment: WrapAlignment.center,
        children: [
          _buildSummaryCard('Total Expenses', '\$${total.toStringAsFixed(2)}', Icons.account_balance_wallet, Colors.blue),
          _buildSummaryCard('Pending Requests', '$pending', Icons.pending_actions, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Completed':
        color = Colors.green;
        break;
      case 'Pending':
        color = Colors.orange;
        break;
      case 'Approved':
        color = Colors.blue;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
