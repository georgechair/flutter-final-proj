import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:georgeschaer_project/List_Product.dart';
import 'package:http/http.dart' as http;

import 'HomePage.dart';

class DeleteProduct extends StatefulWidget {
  @override
  _DeleteProductState createState() => _DeleteProductState();
}

class _DeleteProductState extends State<DeleteProduct> {
  List<List_Product> productList = [];
  List_Product? selectedProduct;

  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadProductData();
  }

  Future<void> loadProductData() async {
    String url = "http://localhost/georges%20shaer%20api/Listproduct.php";

    try {
      var response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        String res = response.body;
        productList = [];

        for (var row in jsonDecode(res)) {
          var product = List_Product(
            int.parse(row["id"]),
            row["name"],
            row["price"],
            int.parse(row["quantity"]),
          );
          productList.add(product);
        }

        // Set the default selectedProduct if the list is not empty
        if (productList.isNotEmpty) {
          selectedProduct = productList.first;
        }
      } else {
        print("Failed to load data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        // Update the UI
      });
    }
  }

  Future<void> deleteProductData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      var response = await http.post(
        Uri.parse("http://localhost/georges%20shaer%20api/Deleteproduct.php"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "name": selectedProduct!.name,
        }),
      );

      if (response.statusCode == 200) {
        print("Product deleted successfully");
        // Set the result to true to indicate a successful deletion
        Navigator.pop(context, true);

        // Navigate back to the home page and refresh
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );

      } else {
        print("Failed to delete product. Status code: ${response.statusCode}");
      }
    } catch (e) {
      errorMessage = 'Failed to delete data. $e';
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delete Product"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // DropdownButtonFormField for product selection
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              height: 55,
              child: DropdownButtonFormField<List_Product>(
                value: selectedProduct,
                items: productList.map((List_Product product) {
                  return DropdownMenuItem<List_Product>(
                    value: product,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        product.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (List_Product? newValue) {
                  setState(() {
                    selectedProduct = newValue!;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blue,
                  hintText: 'Select a product to delete',
                  hintStyle: const TextStyle(color: Colors.black87),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                dropdownColor: Colors.blue,
                style: const TextStyle(color: Colors.white),
                icon: const Icon(Icons.arrow_drop_down),
                isExpanded: true,
                alignment: Alignment.center,
                selectedItemBuilder: (BuildContext context) {
                  return productList.map<Widget>((List_Product? item) {
                    return Text(
                      item?.name ?? "",
                      style: const TextStyle(color: Colors.white),
                    );
                  }).toList();
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                if (selectedProduct != null) {
                  await deleteProductData();
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: isLoading
                    ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : const Text(
                  'Delete Product',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
