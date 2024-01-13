import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:georgeschaer_project/List_Product.dart';
import 'DeleteProduct.dart';
import 'DetailsPage.dart';
import 'InsertProduct.dart';
import 'package:http/http.dart' as http;
import 'LoginPage.dart';
import 'UpdateProduct.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<List_Product> ProductList = [];
  List_Product? selectedProduct;

  @override
  void initState() {
    super.initState();
    loadProduct();
  }

  Future<void> loadProduct() async {
    String url = "http://localhost/georges%20shaer%20api/Listproduct.php";

    try {
      var response =
      await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        String res = response.body;
        ProductList = [];

        for (var row in jsonDecode(res)) {
          var product = List_Product(
            int.parse(row["id"]),
            row["name"],
            row["price"],
            int.parse(row["quantity"]),
          );
          ProductList.add(product);
        }

        // Set the default selectedEmergency if the list is not empty
        if (ProductList.isNotEmpty) {
          selectedProduct = ProductList.first;
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

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> navigateToUpdateProduct() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProduct(product: selectedProduct!),
      ),
    );

    await loadProduct();
  }

  Future<void> navigateToInsertProduct() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InsertProduct()),
    );

    await loadProduct();
  }

  Future<void> navigateToDeleteProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeleteProduct(),
      ),
    );

    if (result == true) {
      await loadProduct();
    }
  }

  void logout() {
    // Navigate back to the LoginPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select a Product",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                "https://png.pngtree.com/thumb_back/fh260/background/20230525/pngtree-this-is-an-animation-showing-a-grocery-store-image_2617237.jpg",
              ),
            ),
          ),
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
                  value: selectedProduct,
                  items: ProductList.map((List_Product product) {
                    return DropdownMenuItem<List_Product>(
                      value: product,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          product.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (List_Product? newValue) {
                    setState(() {
                      selectedProduct = newValue!;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(selectedProduct!),
                      ),
                    );
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.blue,
                    hintText: 'Ex: Soda',
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
                    return ProductList.map<Widget>((List_Product? item) {
                      return Text(
                        item?.toString() ?? "",
                        style: const TextStyle(color: Colors.white),
                      );
                    }).toList();
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: selectedProduct == null
                    ? () {
                  showSnackBar(
                      "Please select a Product to be updated");
                }
                    : navigateToUpdateProduct,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Update Product',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: navigateToInsertProduct,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Insert A New Product',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  navigateToDeleteProduct();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeleteProduct(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Delete Product',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
