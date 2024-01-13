import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'List_Product.dart';

class UpdateProduct extends StatefulWidget {
  final List_Product product;

  UpdateProduct({Key? key, required this.product}) : super(key: key);

  @override
  _UpdateProductState createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  late List_Product selectedProduct;

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productQuantityController = TextEditingController();

  bool isLoading = false;
  String errorMessage = '';

  List<List_Product> productList = [];
  List_Product? selectedDropdownProduct;

  @override
  void initState() {
    super.initState();
    loadProductData();
    selectedProduct = widget.product;

    _productNameController.text = selectedProduct.name;
    _productPriceController.text = selectedProduct.price;
    _productQuantityController.text = selectedProduct.quantity.toString();
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

        if (productList.isNotEmpty) {
          selectedDropdownProduct = productList.first;

          _productNameController.text = selectedDropdownProduct!.name;
          _productPriceController.text = selectedDropdownProduct!.price;
          _productQuantityController.text = selectedDropdownProduct!.quantity.toString();
        }
      } else {
        print("Failed to load data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {});
    }
  }

  Future<void> updateProductData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      var response = await http.post(
        Uri.parse("http://localhost/georges%20shaer%20api/Updateproduct.php"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "oldname": selectedProduct.name, // Pass the old name here
          "quantity": int.parse(_productQuantityController.text),
          "name": _productNameController.text,
          "price": _productPriceController.text,
        }),
      );

      if (response.statusCode == 200) {
        print("Product data updated successfully");
      } else {
        print("Failed to update Product data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      errorMessage = 'Failed to update data. $e';
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
        title: const Text("Update Product"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              height: 55,
              child: DropdownButtonFormField<List_Product>(
                value: selectedDropdownProduct,
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
                    selectedDropdownProduct = newValue!;
                    _productNameController.text = selectedDropdownProduct!.name;
                    _productPriceController.text = selectedDropdownProduct!.price;
                    _productQuantityController.text = selectedDropdownProduct!.quantity.toString();
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blue,
                  hintText: 'Select a Product ',
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
            TextFormField(
              controller: _productNameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _productPriceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _productQuantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                await updateProductData();
                Navigator.pop(context);
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
                  'Update Product Data',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
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
    home: UpdateProduct(product: List_Product(0, "Product Name", "Price", "Quantity" as int)),
  ));
}
