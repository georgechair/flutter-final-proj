import 'package:flutter/material.dart';
import 'List_Product.dart';

class DetailsPage extends StatefulWidget {
  final List_Product selectedProduct;

  DetailsPage(this.selectedProduct);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.selectedProduct.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10), // Adjusted the SizedBox height
              Text(
                " ${widget.selectedProduct.name} Price: ${widget.selectedProduct.price}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16, // Increased the font size
                  backgroundColor: Colors.blue,
                ),
              ),
              const SizedBox(height: 10), // Adjusted the SizedBox height
              Text(
                "Available  ${widget.selectedProduct.quantity} pieces",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16, // Increased the font size
                  backgroundColor: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
