import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'transaction.dart';

class StatisticPage extends StatelessWidget {
  final List<Transaction> transactions;

  StatisticPage(this.transactions);

  double get totalExpense {
    if (transactions.isEmpty) return 0;
    return transactions.fold(0.0, (sum, item) => sum + item.amount);
  }

  double get monthlyExpense {
    if (transactions.isEmpty) return 0;
    // Menghitung bulan unik dari transaksi
    final uniqueMonths = transactions.map((tx) => DateTime(tx.date.year, tx.date.month)).toSet();
    return totalExpense / uniqueMonths.length;
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
    final formattedMonthlyExpense = formatter.format(monthlyExpense);

    return Scaffold(
      appBar: AppBar(title: SizedBox.shrink(),),
      body: Center(
        child: Text('Rata-rata Pengeluaran Bulanan: $formattedMonthlyExpense'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Statistik'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
      ),
    );
  }
}
