import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ViewBillScreen.dart';
import 'create_bill_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> bills = [];
  List<Map<String, dynamic>> filteredBills = [];
  String? filterStatus;

  @override
  void initState() {
    super.initState();
    loadBills();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(
              Icons.dashboard,
              color: Colors.white,
            ),
            onPressed: showDashboard,
          ),
          IconButton(
            icon: Icon(
              Icons.download,
              color: Colors.white,
            ),
            onPressed: exportBillsToCSV,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: filterStatus,
                    hint: Text('Filter by Status'),
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(
                        child: Text('Paid'),
                        value: 'Paid',
                      ),
                      DropdownMenuItem(
                        child: Text('Unpaid'),
                        value: 'Unpaid',
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        filterStatus = value;
                        applyFilters();
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                TextButton(
                  onPressed: clearFilters,
                  child: Text(
                    'Clear Filters',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredBills.isEmpty
                ? Center(
                    child: Text(
                      'No bills available.',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: filteredBills.length,
                    itemBuilder: (context, index) {
                      final bill = filteredBills[index];
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => viewBill(bill),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total Amount: ₹${bill['totalAmount'].toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      bill['status'] ?? 'Unpaid',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: bill['status'] == 'Paid'
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Date: ${formatDate(bill['date'])}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Colors.blue,
        onPressed: createNewBill,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  String formatDate(String? date) {
    if (date == null) return 'Unknown';

    try {
      final DateTime parsedDate = DateTime.parse(date);
      final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

      return dateFormat.format(parsedDate);
    } catch (e) {
      return 'Invalid date format';
    }
  }

  Future<void> loadBills() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? billsData = prefs.getString('bills');
    if (billsData != null) {
      setState(() {
        bills = List<Map<String, dynamic>>.from(jsonDecode(billsData));
        filteredBills = List.from(bills);
      });
    }
  }

  Future<void> saveBill(Map<String, dynamic> newBill) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bills.add(newBill);
      filteredBills.add(newBill);
    });
    await prefs.setString('bills', jsonEncode(bills));
  }

  void createNewBill() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BillScreen(
          onSave: (bill) {
            saveBill(bill);
          },
        ),
      ),
    );
  }

  Future<void> viewBill(Map<String, dynamic> bill) async {
    final bool? updated = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ViewBillScreen(bill: bill),
      ),
    );

    if (updated == true) {
      loadBills();
    }
  }

  void applyFilters() {
    setState(() {
      filteredBills = bills.where((bill) {
        if (filterStatus != null && filterStatus!.isNotEmpty) {
          return bill['status'] == filterStatus;
        }
        return true;
      }).toList();
    });
  }

  void clearFilters() {
    setState(() {
      filterStatus = null;
      filteredBills = List.from(bills);
    });
  }

  void showDashboard() {
    final int totalBills = bills.length;
    final double totalSales =
        bills.fold(0.0, (sum, bill) => sum + (bill['totalAmount'] ?? 0.0));
    final int unpaidBills =
        bills.where((bill) => bill['status'] == 'Unpaid').length;
    final double unpaidPercentage =
        totalBills > 0 ? (unpaidBills / totalBills) * 100 : 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Dashboard'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total Bills: $totalBills',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(
                height: 5,
              ),
              Text('Total Sales: ₹${totalSales.toStringAsFixed(2)}'),
              SizedBox(
                height: 5,
              ),
              Text(
                  'Unpaid Bills: $unpaidBills (${unpaidPercentage.toStringAsFixed(1)}%)'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> exportBillsToCSV() async {
    final List<List<dynamic>> rows = [
      ['Date', 'Total Amount', 'Status']
    ];

    for (var bill in bills) {
      rows.add([
        formatDate(bill['date']),
        bill['totalAmount'].toStringAsFixed(2),
        bill['status']
      ]);
    }

    String csvData = const ListToCsvConverter().convert(rows);
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/bills.csv';
    final file = File(path);

    await file.writeAsString(csvData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bills exported to $path')),
    );
  }
}
