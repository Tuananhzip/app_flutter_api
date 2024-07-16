import 'package:app_api/app/bloc/mainpage/mainpage_bloc.dart';
import 'package:app_api/app/config/const.dart';
import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/data/sqlite.dart';
import 'package:app_api/app/model/cart.dart';
import 'package:app_api/mainpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/web.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  Future<List<Cart>> _futureGetProducts = Future.value([]);

  Future<List<Cart>> _getProducts() async {
    return await _databaseHelper.products();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futureGetProducts = _getProducts();
  }

  dynamic _calculateTotalPrice(List<Cart> products) {
    dynamic total = 0;
    for (var product in products) {
      total += product.price * product.count;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 11,
          child: FutureBuilder<List<Cart>>(
            future: _futureGetProducts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              Logger().i(snapshot.data);

              dynamic totalPrice = _calculateTotalPrice(snapshot.data ?? []);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final itemProduct = snapshot.data![index];
                          return _buildProduct(itemProduct, context);
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Price:',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${NumberFormat('#,##0').format(totalPrice)} VND',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                List<Cart> temp = await _databaseHelper.products();
                bool payment = await APIRepository()
                    .addBill(temp, pref.getString('token').toString());
                _databaseHelper.clear();
                if (payment) {
                  Fluttertoast.showToast(
                      msg: "Payment success",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  if (context.mounted) {
                    setState(() {});
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Mainpage(index: 1),
                        ));
                  }
                } else {
                  Fluttertoast.showToast(
                      msg: "Payment failed",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Payment"),
                  SizedBox(width: 8.0),
                  Icon(Icons.shopping_basket_outlined)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProduct(Cart pro, BuildContext context) {
    return Card(
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pro.name,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '${NumberFormat('#,##0').format(pro.price * pro.count)} VND',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  // const SizedBox(height: 4.0),
                  // Text('Category: ${pro.catId}'),
                  const SizedBox(height: 4.0),
                  Text(
                    'Count: ${pro.count}',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Description: ${pro.des}',
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: styleVerySmall(),
                  ),
                ],
              ),
            ),
            spaceWidth(x: 1),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    pro.img,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                spaceHeight(x: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        DatabaseHelper().minus(pro);
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.minimize,
                        color: Colors.yellow.shade800,
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          String nameProduct = pro.name;
                          await DatabaseHelper().deleteProduct(pro.productID);
                          if (context.mounted) {
                            context.read<MainpageBloc>().add(LoadUserEvent());
                          }
                          Fluttertoast.showToast(
                              msg: "Deleted cart $nameProduct",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          setState(() {
                            _futureGetProducts = _getProducts();
                          });
                        },
                        icon: const CircleAvatar(
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        )),
                    IconButton(
                      onPressed: () {
                        DatabaseHelper().add(pro);
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.yellow.shade800,
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
