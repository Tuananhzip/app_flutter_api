import 'package:app_api/app/bloc/mainpage/mainpage_bloc.dart';
import 'package:app_api/app/config/const.dart';
import 'package:app_api/app/data/sqlite.dart';
import 'package:app_api/app/model/cart.dart';
import 'package:app_api/app/model/product.dart';
import 'package:app_api/mainpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key, required this.productModel});
  final ProductModel productModel;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  Future<void> _onSave(ProductModel pro, BuildContext context) async {
    await DatabaseHelper().insertProduct(Cart(
      productID: pro.id,
      name: pro.name,
      des: pro.description,
      price: pro.price,
      img: pro.imageUrl,
      count: 1,
    ));
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Mainpage(
            index: 0,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.productModel.name,
          style: styleVerySmall(),
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: 250,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(widget.productModel.imageUrl),
                ),
              ),
            ],
          ),
          Text(
            widget.productModel.name,
            style: styleMedium(),
          ),
          Container(
            margin: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blueAccent,
                    ),
                  ),
                  child: Text(
                    '${NumberFormat('#,##0').format(widget.productModel.price)} VND',
                    style: styleMedium(size: 20),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _onSave(widget.productModel, context),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        const Text('Add to cart'),
                        spaceWidth(),
                        const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Hãng: ${widget.productModel.categoryName}',
              style: styleMedium(color: Colors.blue, size: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.productModel.description,
              style: styleMedium(color: Colors.black54, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
