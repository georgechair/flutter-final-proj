import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:georgeschaer_project/List_Product.dart';
import 'package:http/http.dart' as http;
import 'DetailsPage.dart';
import 'LoginPage.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  _UserHomePageState createState() {
    return _UserHomePageState();
  }
}

class _UserHomePageState extends State<UserHomePage> {
  List<List_Product> ProductList = [];
  List_Product? selectedProduct;

  @override
  void initState() {
    super.initState();
    loadEmergency();
  }

  Future<void> loadEmergency() async {
    String url = "http://localhost/georges%20shaer%20api/Listproduct.php";

    try {
      var response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));

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
                    return ProductList.map<Widget>((List_Product ? item) {
                      return Text(
                        item?.toString() ?? "",
                        style: const TextStyle(color: Colors.white),
                      );
                    }).toList();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
