import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'transaction.dart';

class HomePage extends StatefulWidget {
  final List<Transaction> transactions;

  HomePage({required this.transactions});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _addTransaction(String title, double amount, DateTime date) {
    final newTx = Transaction(
      title: title,
      amount: amount,
      date: date,
    );
    setState(() {
      widget.transactions.add(newTx);
    });
  }

  void _editTransaction(int index, String title, double amount, DateTime date) {
    setState(() {
      widget.transactions[index].title = title;
      widget.transactions[index].amount = amount;
      widget.transactions[index].date = date;
    });
  }

  void _deleteTransaction(int index) {
    setState(() {
      widget.transactions.removeAt(index);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: TransactionInput(_addTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _startEditTransaction(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: TransactionInput((title, amount, date) {
            _editTransaction(index, title, amount, date);
          }, transaction: widget.transactions[index]),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.transactions.sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Transaksi'),
        centerTitle: true,
      ),
      body: widget.transactions.isEmpty
          ? Center(child: Text('Tidak ada transaksi.'))
          : ListView.builder(
              itemCount: widget.transactions.length,
              itemBuilder: (context, index) {
                final transaction = widget.transactions[index];
                final formattedDate = DateFormat('dd MMM yyyy').format(transaction.date);

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  child: ListTile(
                    title: Text(transaction.title),
                    subtitle: Text(formattedDate),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _startEditTransaction(context, index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteTransaction(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddNewTransaction(context),
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Statistik'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacementNamed(
              context,
              '/statistics',
              arguments: widget.transactions,
            );
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
      ),
    );
  }
}

class TransactionInput extends StatefulWidget {
  final Function(String, double, DateTime) onSubmit;
  final Transaction? transaction;

  TransactionInput(this.onSubmit, {this.transaction});

  @override
  _TransactionInputState createState() => _TransactionInputState();
}

class _TransactionInputState extends State<TransactionInput> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _titleController.text = widget.transaction!.title;
      _amountController.text = widget.transaction!.amount.toString();
      _selectedDate = widget.transaction!.date;
    }
  }

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }

    widget.onSubmit(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Judul'),
          ),
          TextField(
            controller: _amountController,
            decoration: InputDecoration(labelText: 'Jumlah'),
            keyboardType: TextInputType.number,
            onSubmitted: (_) => _submitData(),
          ),
          Container(
            height: 70,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Tanggal Dipilih: ${DateFormat.yMd().format(_selectedDate)}',
                  ),
                ),
                TextButton(
                  onPressed: _presentDatePicker,
                  child: Text(
                    'Pilih Tanggal',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _submitData,
            child: Text('Tambahkan Transaksi'),
          ),
        ],
      ),
    );
  }
}
