import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewBillScreen extends StatefulWidget {
  final Map<String, dynamic> bill;

  const ViewBillScreen({super.key, required this.bill});

  @override
  _ViewBillScreenState createState() => _ViewBillScreenState();
}

class _ViewBillScreenState extends State<ViewBillScreen> {
  late String _status;

  @override
  void initState() {
    super.initState();
    _status = widget.bill['status'] ?? 'Unpaid';
  }

  Future<void> _toggleStatus() async {
    setState(() {
      _status = _status == 'Paid' ? 'Unpaid' : 'Paid';
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final billsData = prefs.getString('bills');

    if (billsData != null) {
      final List<Map<String, dynamic>> bills =
          List<Map<String, dynamic>>.from(jsonDecode(billsData));

      final int billIndex = bills.indexWhere((b) =>
          b['customerName'] == widget.bill['customerName'] &&
          b['date'] == widget.bill['date']);

      if (billIndex != -1) {
        bills[billIndex]['status'] = _status;
        await prefs.setString('bills', jsonEncode(bills));
      }
    }
  }

  Future<Uint8List> _generateBillPdf() async {
    final pdf = pw.Document();

    final items = widget.bill['items'] ?? [];

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text('Customer Bill',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 5),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text('Name: ${widget.bill['customerName']}',
                  style: pw.TextStyle(fontSize: 16)),
              pw.Text('Mobile: ${widget.bill['customerContact']}',
                  style: pw.TextStyle(fontSize: 16)),
              pw.Text('Date: ${widget.bill['date'] ?? ''}',
                  style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                context: context,
                border: pw.TableBorder.all(),
                cellAlignment: pw.Alignment.center,
                headers: ['Item', 'Quantity', 'Unit Price', 'Total'],
                data: List<List<dynamic>>.from(items.map((item) => [
                      item['itemName'],
                      item['quantity'].toString(),
                      '${item['unitPrice']}',
                      '${(item['quantity'] * item['unitPrice']).toStringAsFixed(2)}',
                    ])),
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                      'Total: ${widget.bill['totalAmount'].toStringAsFixed(2)}',
                      style: pw.TextStyle(
                          fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 10),
                  pw.Text('Status: $_status',
                      style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                          color: _status == 'Paid'
                              ? PdfColors.green
                              : PdfColors.red)),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  void _printBill() async {
    final Uint8List pdfData = await _generateBillPdf();
    await Printing.layoutPdf(onLayout: (format) async => pdfData);
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.bill['items'] ?? [];

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'View Bill Screen',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bill Items Card
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Name: ${widget.bill['customerName']}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Mob: ${widget.bill['customerContact']}',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        var item = items[index];
                        return ListTile(
                          title: Text(item['itemName'],
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              '${item['quantity']} x ₹${item['unitPrice']}'),
                          trailing: Text(
                            '₹${(item['quantity'] * item['unitPrice']).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    Center(
                      child: Text(
                        'Total: ₹${widget.bill['totalAmount'].toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            // Status Card with Button
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Align text and button vertically centered
                  children: [
                    IntrinsicHeight(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: _printBill,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            'Print Bill',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        VerticalDivider(),
                        SizedBox(
                          width: 28,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10), // Adjust button padding
                          ),
                          onPressed: () async {
                            await _toggleStatus();
                            Navigator.pop(
                                context, true); // Notify HomeScreen to refresh
                          },
                          child: Text(
                            _status == 'Paid'
                                ? 'Mark as Unpaid'
                                : 'Mark as Paid',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
