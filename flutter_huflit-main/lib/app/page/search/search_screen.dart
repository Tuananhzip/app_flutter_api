import 'package:app_api/app/config/const.dart';
import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/model/product.dart';
import 'package:app_api/app/page/product/product_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _listProduct = [];
  List<ProductModel> _filteredProduct = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProducts();
  }

  Future<void> _getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _listProduct = await APIRepository().getProduct(
        prefs.getString('accountID').toString(),
        prefs.getString('token').toString());
    if (mounted) {
      setState(() {
        _filteredProduct = _listProduct;
      });
    }
  }

  void _searchProduct(String query) {
    var filteredProduct = _listProduct.where((element) {
      bool matchesName =
          element.name.toLowerCase().contains(query.toLowerCase());
      bool matchesPrice = element.price.toString().contains(query);
      return matchesName || matchesPrice;
    }).toList();
    if (mounted) {
      setState(() {
        _filteredProduct = filteredProduct;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _searchProduct(value),
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          if (_filteredProduct.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _filteredProduct.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductDetail(
                                productModel: _filteredProduct[index]))),
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              _filteredProduct[index].imageUrl,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_filteredProduct[index].name),
                                Text(
                                  '${NumberFormat('#,##0').format(_filteredProduct[index].price)} VND',
                                  style: styleMedium(size: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
