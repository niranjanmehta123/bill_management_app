// import 'package:bill_management_app/views/screen/homeScreen.dart';
// import 'package:flutter/material.dart';
//
// void main() => runApp(BillManagementApp());
//
// class BillManagementApp extends StatelessWidget {
//   const BillManagementApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Bill Management',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: HomeScreen(),
//     );
//   }
// }



//billScreen

//
// import 'package:flutter/material.dart';
//
// class BillScreen extends StatefulWidget {
//   final Function(Map<String, dynamic>) onSave;
//
//   BillScreen({required this.onSave});
//
//   @override
//   _BillScreenState createState() => _BillScreenState();
// }
//
// class _BillScreenState extends State<BillScreen> {
//
//   final customerFormKey = GlobalKey<FormState>();
//   final itemFormKey = GlobalKey<FormState>();
//
//   TextEditingController customerNameController = TextEditingController();
//   TextEditingController customerContactController = TextEditingController();
//   TextEditingController itemNameController = TextEditingController();
//   TextEditingController quantityController = TextEditingController();
//   TextEditingController unitPriceController = TextEditingController();
//
//   List<Map<String, dynamic>> items = [];
//   double totalAmount = 0.0;
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final width = size.width;
//     final height = size.height;
//
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//         title: const Text('Create Bill Screen', style: TextStyle(color: Colors.white)),
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(width * 0.04),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Form(
//               key: customerFormKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.symmetric(vertical: height * 0.01, horizontal: 8),
//                     child: Text(
//                       'Add Customer:',
//                       style: TextStyle(
//                           fontSize: height * 0.025, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//                     child: TextFormField(
//                       controller: customerNameController,
//                       decoration: InputDecoration(labelText: 'Customer Name'),
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return 'Customer name is required';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//                     child: TextFormField(
//                       controller: customerContactController,
//                       decoration: InputDecoration(labelText: 'Contact Number'),
//                       keyboardType: TextInputType.phone,
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return 'Contact number is required';
//                         } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
//                           return 'Enter a valid 10-digit number';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: height * 0.03),
//             Form(
//               key: itemFormKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     child: Text(
//                       'Add Item:',
//                       style: TextStyle(
//                           fontSize: height * 0.025, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//                     child: TextFormField(
//                       controller: itemNameController,
//                       decoration: InputDecoration(labelText: 'Item Name'),
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return 'Item name is required';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//                     child: TextFormField(
//                       controller: quantityController,
//                       decoration: InputDecoration(labelText: 'Quantity'),
//                       keyboardType: TextInputType.number,
//                       validator: (value) {
//                         if (value == null || int.tryParse(value) == null || int.parse(value) <= 0) {
//                           return 'Enter a valid quantity';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//                     child: TextFormField(
//                       controller: unitPriceController,
//                       decoration: InputDecoration(labelText: 'Unit Price'),
//                       keyboardType: TextInputType.number,
//                       validator: (value) {
//                         if (value == null || double.tryParse(value) == null || double.parse(value) <= 0) {
//                           return 'Enter a valid unit price';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                   SizedBox(height: height * 0.03),
//                   Center(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         fixedSize: Size(width * 0.4, height * 0.05),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.zero),
//                       ),
//                       onPressed: _addItem,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8),
//                         child: Text(
//                           'Add Item',
//                           style: TextStyle(
//                               color: Colors.white, fontSize: height * 0.02),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: height * 0.03),
//             Text(
//               'Items:',
//               style: TextStyle(
//                   fontSize: height * 0.02, fontWeight: FontWeight.bold),
//             ),
//             ...items.map((item) => ListTile(
//               title: Text(item['itemName']),
//               subtitle: Text(
//                   'Quantity: ${item['quantity']} | Unit Price: ₹${item['unitPrice'].toStringAsFixed(2)}'),
//               trailing: Text('₹${item['totalPrice'].toStringAsFixed(2)}'),
//             )),
//             if (items.isEmpty)
//               Center(
//                 child: Text(
//                   'No items added yet.',
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               ),
//             SizedBox(height: height * 0.03),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               child: Text(
//                 'Total Amount: ₹${totalAmount.toStringAsFixed(2)}',
//                 style: TextStyle(
//                     fontSize: height * 0.02, fontWeight: FontWeight.bold),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   fixedSize: Size(width, height * 0.06),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.zero),
//                 ),
//                 onPressed: _saveBill,
//                 child: Text(
//                   'Save The Bill',
//                   style: TextStyle(
//                       color: Colors.white, fontSize: height * 0.02),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _addItem() {
//     if (!itemFormKey.currentState!.validate()) {
//       return;
//     }
//
//     final String itemName = itemNameController.text.trim();
//     final int quantity = int.parse(quantityController.text.trim());
//     final double unitPrice = double.parse(unitPriceController.text.trim());
//
//     setState(() {
//       items.add({
//         'itemName': itemName,
//         'quantity': quantity,
//         'unitPrice': unitPrice,
//         'totalPrice': quantity * unitPrice,
//       });
//       _calculateTotalAmount();
//
//       // Clear input fields
//       itemNameController.clear();
//       quantityController.clear();
//       unitPriceController.clear();
//     });
//   }
//
//   void _calculateTotalAmount() {
//     totalAmount = items.fold(0.0, (sum, item) => sum + item['totalPrice']);
//   }
//
//   void _saveBill() {
//     if (!customerFormKey.currentState!.validate()) {
//       return;
//     }
//
//     if (items.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Add at least one item before saving the bill')),
//       );
//       return;
//     }
//
//     final billData = {
//       'customerName': customerNameController.text.trim(),
//       'customerContact': customerContactController.text.trim(),
//       'items': items,
//       'totalAmount': totalAmount,
//       'date': DateTime.now().toString(),
//       'status': 'Unpaid',
//     };
//
//     widget.onSave(billData);
//     Navigator.of(context).pop();
//   }
// }


//home Screen


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'ViewBillScreen.dart';
// import 'create_bill_screen.dart';
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   List<Map<String, dynamic>> bills = [];
//
//   @override
//   void initState() {
//     super.initState();
//     loadBills();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Screen',
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//       ),
//       body: bills.isEmpty
//           ? Center(
//               child: Text(
//                 'No bills created yet.',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//               ),
//             )
//           : ListView.builder(
//               padding: EdgeInsets.all(10),
//               itemCount: bills.length,
//               itemBuilder: (context, index) {
//                 final bill = bills[index];
//                 return Card(
//                   elevation: 4,
//                   margin: EdgeInsets.symmetric(vertical: 8),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: InkWell(
//                     borderRadius: BorderRadius.circular(12),
//                     onTap: () => viewBill(bill),
//                     child: Padding(
//                       padding: EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "Total Amount: ₹${bill['totalAmount'].toStringAsFixed(2)}",
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 bill['status'] ?? 'Unpaid',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: bill['status'] == 'Paid'
//                                       ? Colors.green
//                                       : Colors.red,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             "Date: ${formatDate(bill['date'])}",
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.grey[700],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         shape: CircleBorder(),
//         backgroundColor: Colors.blue,
//         onPressed: createNewBill,
//         child: Icon(
//           Icons.add,
//           color: Colors.white,
//           size: 28,
//         ),
//       ),
//     );
//   }
//
//   String formatDate(String? date) {
//     if (date == null) return 'Unknown';
//
//     try {
//       final DateTime parsedDate = DateTime.parse(date);
//       final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
//
//       return dateFormat.format(parsedDate);
//     } catch (e) {
//       return 'Invalid date format';
//     }
//   }
//
//
//   Future<void> loadBills() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String? billsData = prefs.getString('bills');
//     if (billsData != null) {
//       setState(() {
//         bills = List<Map<String, dynamic>>.from(jsonDecode(billsData));
//       });
//     }
//   }
//
//   Future<void> saveBill(Map<String, dynamic> newBill) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       bills.add(newBill);
//     });
//     await prefs.setString('bills', jsonEncode(bills));
//   }
//
//   void createNewBill() {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => BillScreen(
//           onSave: (bill) {
//             saveBill(bill);
//           },
//         ),
//       ),
//     );
//   }
//
//   Future<void> viewBill(Map<String, dynamic> bill) async {
//     final bool? updated = await Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => ViewBillScreen(bill: bill),
//       ),
//     );
//
//     if (updated == true) {
//       loadBills();
//     }
//   }
// }



//viewbillScreen


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ViewBillScreen extends StatefulWidget {
//   final Map<String, dynamic> bill;
//
//   const ViewBillScreen({super.key, required this.bill});
//
//   @override
//   _ViewBillScreenState createState() => _ViewBillScreenState();
// }
//
// class _ViewBillScreenState extends State<ViewBillScreen> {
//   late String status;
//
//   @override
//   void initState() {
//     super.initState();
//     status = widget.bill['status'] ?? 'Unpaid';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final items = widget.bill['items'] ?? [];
//
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.white),
//         backgroundColor: Colors.blue,
//         centerTitle: true,
//         title: const Text(
//           'View Bill Screen',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               elevation: 4,
//               margin: EdgeInsets.symmetric(vertical: 8),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)
//                ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             'Name: ${widget.bill['customerName']}',
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                         Expanded(
//                           child: Text(
//                             'Mob: ${widget.bill['customerContact']}',
//                             style: TextStyle(
//                                 fontSize: 16, color: Colors.grey[700]),
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Divider(),
//                     ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: items.length,
//                       itemBuilder: (context, index) {
//                         var item = items[index];
//                         return ListTile(
//                           title: Text(item['itemName'],
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                           subtitle: Text(
//                               '${item['quantity']} x ₹${item['unitPrice']}'),
//                           trailing: Text(
//                             '₹${(item['quantity'] * item['unitPrice']).toStringAsFixed(2)}',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.blue,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     const Divider(),
//                     Center(
//                       child: Text(
//                         'Total: ₹${widget.bill['totalAmount'].toStringAsFixed(2)}',
//                         style: TextStyle(
//                             fontSize: 15, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Spacer(),
//             Card(
//               elevation: 4,
//               margin: EdgeInsets.symmetric(vertical: 8),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     IntrinsicHeight(
//                         child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         Text(
//                           'Status: $status',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: status == 'Paid' ? Colors.green : Colors.red,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 1,
//                         ),
//                         SizedBox(
//                           width: 33,
//                         ),
//                         VerticalDivider(),
//                         SizedBox(
//                           width: 32,
//                         ),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 10),
//                           ),
//                           onPressed: () async {
//                             await toggleStatus();
//                             Navigator.pop(context, true);
//                           },
//                           child: Text(
//                             status == 'Paid'
//                                 ? 'Mark as Unpaid'
//                                 : 'Mark as Paid',
//                             style: TextStyle(fontSize: 14, color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ))
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> toggleStatus() async {
//     setState(() {
//       status = status == 'Paid' ? 'Unpaid' : 'Paid';
//     });
//
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final billsData = prefs.getString('bills');
//
//     if (billsData != null) {
//       final List<Map<String, dynamic>> bills =
//           List<Map<String, dynamic>>.from(jsonDecode(billsData));
//       final int billIndex = bills.indexWhere((b) =>
//           b['customerName'] == widget.bill['customerName'] &&
//           b['date'] == widget.bill['date']);
//
//       if (billIndex != -1) {
//         bills[billIndex]['status'] = status;
//
//         // Update the status
//
//         await prefs.setString('bills', jsonEncode(bills));
//       }
//     }
//   }
// }
