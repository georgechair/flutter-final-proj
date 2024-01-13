import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InsertProduct extends StatefulWidget {
  InsertProduct({Key? key}) : super(key: key);

  @override
  _InsertProductState createState() {
    return _InsertProductState();
  }
}

class _InsertProductState extends State<InsertProduct> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productpriceController = TextEditingController();
  final _productquantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Insert Product"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              "https://png.pngtree.com/thumb_back/fh260/background/20230525/pngtree-this-is-an-animation-showing-a-grocery-store-image_2617237.jpg",
            ),
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _productNameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.blue.withOpacity(0.7),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Product Name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _productpriceController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Price per Piece',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.blue.withOpacity(0.7),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _productquantityController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.blue.withOpacity(0.7),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Quantity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Form is valid, proceed to submit
                    await submitForm();
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Insert Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitForm() async {
    // Construct JSON payload
    Map<String, dynamic> payload = {
      "name": _productNameController.text,
      "price": _productpriceController.text,
      "quantity": _productquantityController.text,
    };

    // Convert payload to JSON
    String jsonData = jsonEncode(payload);

    String apiUrl = "http://localhost/georges%20shaer%20api/Insertproduct.php";
    var response = await http.post(Uri.parse(apiUrl), body: jsonData);

    // Check the response status
    if (response.statusCode == 200) {
      print("Insert successful");

      // Optionally, you can handle the success scenario here

      // Navigate back to the Home Page
      Navigator.pop(context);
    } else {
      print("Failed to insert data. Status code: ${response.statusCode}");
      // Optionally, you can handle the failure scenario here
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: InsertProduct(),
  ));
}
