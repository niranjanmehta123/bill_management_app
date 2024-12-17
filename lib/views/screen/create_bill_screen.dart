import 'package:flutter/material.dart';

class BillScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  BillScreen({required this.onSave});

  @override
  _BillScreenState createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {

  final customerFormKey = GlobalKey<FormState>();
  final itemFormKey = GlobalKey<FormState>();

  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerContactController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController unitPriceController = TextEditingController();

  List<Map<String, dynamic>> items = [];
  double totalAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text('Create Bill Screen', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: customerFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: height * 0.01, horizontal: 8),
                    child: Text(
                      'Add Customer:',
                      style: TextStyle(
                          fontSize: height * 0.025, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: TextFormField(
                      controller: customerNameController,
                      decoration: InputDecoration(labelText: 'Customer Name'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Customer name is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: TextFormField(
                      controller: customerContactController,
                      decoration: InputDecoration(labelText: 'Contact Number'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Contact number is required';
                        } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return 'Enter a valid 10-digit number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.03),
            Form(
              key: itemFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Add Item:',
                      style: TextStyle(
                          fontSize: height * 0.025, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: TextFormField(
                      controller: itemNameController,
                      decoration: InputDecoration(labelText: 'Item Name'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Item name is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: TextFormField(
                      controller: quantityController,
                      decoration: InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || int.tryParse(value) == null || int.parse(value) <= 0) {
                          return 'Enter a valid quantity';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: TextFormField(
                      controller: unitPriceController,
                      decoration: InputDecoration(labelText: 'Unit Price'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || double.tryParse(value) == null || double.parse(value) <= 0) {
                          return 'Enter a valid unit price';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        fixedSize: Size(width * 0.4, height * 0.05),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                      ),
                      onPressed: _addItem,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Add Item',
                          style: TextStyle(
                              color: Colors.white, fontSize: height * 0.02),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.03),
            Text(
              'Items:',
              style: TextStyle(
                  fontSize: height * 0.02, fontWeight: FontWeight.bold),
            ),
            ...items.map((item) => ListTile(
              title: Text(item['itemName']),
              subtitle: Text(
                  'Quantity: ${item['quantity']} | Unit Price: ₹${item['unitPrice'].toStringAsFixed(2)}'),
              trailing: Text('₹${item['totalPrice'].toStringAsFixed(2)}'),
            )),
            if (items.isEmpty)
              Center(
                child: Text(
                  'No items added yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            SizedBox(height: height * 0.03),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(
                'Total Amount: ₹${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                    fontSize: height * 0.02, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  fixedSize: Size(width, height * 0.06),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero),
                ),
                onPressed: _saveBill,
                child: Text(
                  'Save The Bill',
                  style: TextStyle(
                      color: Colors.white, fontSize: height * 0.02),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addItem() {
    if (!itemFormKey.currentState!.validate()) {
      return;
    }

    final String itemName = itemNameController.text.trim();
    final int quantity = int.parse(quantityController.text.trim());
    final double unitPrice = double.parse(unitPriceController.text.trim());

    setState(() {
      items.add({
        'itemName': itemName,
        'quantity': quantity,
        'unitPrice': unitPrice,
        'totalPrice': quantity * unitPrice,
      });
      _calculateTotalAmount();

      // Clear input fields
      itemNameController.clear();
      quantityController.clear();
      unitPriceController.clear();
    });
  }

  void _calculateTotalAmount() {
    totalAmount = items.fold(0.0, (sum, item) => sum + item['totalPrice']);
  }

  void _saveBill() {
    if (!customerFormKey.currentState!.validate()) {
      return;
    }

    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Add at least one item before saving the bill')),
      );
      return;
    }

    final billData = {
      'customerName': customerNameController.text.trim(),
      'customerContact': customerContactController.text.trim(),
      'items': items,
      'totalAmount': totalAmount,
      'date': DateTime.now().toString(),
      'status': 'Unpaid',
    };

    widget.onSave(billData);
    Navigator.of(context).pop();
  }
}
