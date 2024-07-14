import 'dart:convert';
import 'package:app_api/app/bloc/mainpage/mainpage_bloc.dart';
import 'package:app_api/app/config/const.dart';
import 'package:app_api/app/data/sqlite.dart';
import 'package:app_api/app/model/cart.dart';
import 'package:app_api/app/model/user.dart';
import 'package:app_api/app/page/cart/cart_screen.dart';
import 'package:app_api/app/page/category/category_list.dart';
import 'package:app_api/app/page/detail.dart';
import 'package:app_api/app/page/history/history_screen.dart';
import 'package:app_api/app/page/home/home_screen.dart';
import 'package:app_api/app/page/product/product_list.dart';
import 'package:app_api/app/route/page3.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'app/page/defaultwidget.dart';
import 'app/data/sharepre.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key, required this.index});
  final int index;

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  User user = User.userEmpty();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
    _getProducts();
  }

  Future<List<Cart>> _getProducts() async {
    return await _databaseHelper.products();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _loadWidget(int index) {
    var nameWidgets = "Home";
    switch (index) {
      case 0:
        {
          return const HomeBuilder();
        }
      case 1:
        {
          return const HistoryScreen();
        }
      case 2:
        {
          return const CartScreen();
        }
      case 3:
        {
          return const Detail();
        }
      default:
        nameWidgets = "None";
        break;
    }
    return DefaultWidget(title: nameWidgets);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainpageBloc()..add(LoadUserEvent()),
      child: Scaffold(
        drawerEnableOpenDragGesture: true,
        appBar: AppBar(
          title: const Text("HL Mobile"),
        ),
        drawer: Drawer(
          child: BlocBuilder<MainpageBloc, MainpageState>(
            builder: (context, state) {
              return ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  if (state is MainpageSuccess) ...[
                    DrawerHeader(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(urlBackgroundProfile),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(
                                state.user.imageURL ?? urlUserDefault,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            '${state.user.fullName}',
                            style: styleMedium(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.home_outlined),
                      title: const Text('Home'),
                      onTap: () {
                        Navigator.pop(context);
                        _selectedIndex = 0;
                        setState(() {});
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.history_outlined),
                      title: const Text('History'),
                      onTap: () {
                        Navigator.pop(context);
                        _selectedIndex = 1;
                        setState(() {});
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.contact_mail_outlined),
                      title: const Text('Cart'),
                      onTap: () {
                        Navigator.pop(context);
                        _selectedIndex = 2;
                        setState(() {});
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.category_outlined),
                      title: const Text('Category'),
                      onTap: () {
                        Navigator.pop(context);
                        _selectedIndex = 0;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CategoryList()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.shopping_basket_outlined),
                      title: const Text('Product'),
                      onTap: () {
                        Navigator.pop(context);
                        _selectedIndex = 0;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProductList()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.pages_outlined),
                      title: const Text('Page3'),
                      onTap: () {
                        Navigator.pop(context);
                        _selectedIndex = 0;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Page3()));
                      },
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
                    state.user.accountId == ''
                        ? const SizedBox()
                        : ListTile(
                            leading: const Icon(Icons.exit_to_app),
                            title: const Text('Logout'),
                            onTap: () {
                              logOut(context);
                            },
                          ),
                  ] else if (state is MainpageLoading) ...[
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  ] else ...[
                    const SizedBox(),
                  ]
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: BlocBuilder<MainpageBloc, MainpageState>(
                builder: (context, state) {
                  int itemCount = 0;
                  if (state is MainpageSuccess) {
                    itemCount = state.itemCountCart;
                  }
                  return Stack(
                    children: [
                      const Icon(Icons.shop),
                      if (itemCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            child: Center(
                              child: Text(
                                '$itemCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'User',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
        body: _loadWidget(_selectedIndex),
      ),
    );
  }
}
