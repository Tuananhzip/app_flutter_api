// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'package:app_api/app/bloc/mainpage/mainpage_bloc.dart';
import 'package:app_api/app/config/const.dart';
import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/data/sqlite.dart';
import 'package:app_api/app/model/cart.dart';
import 'package:app_api/app/model/product.dart';
import 'package:app_api/app/page/product/product_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBuilder extends StatefulWidget {
  const HomeBuilder({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeBuilder> createState() => _HomeBuilderState();
}

class _HomeBuilderState extends State<HomeBuilder> {
  final DatabaseHelper _databaseService = DatabaseHelper();
  Future<List<ProductModel>> _futureGetProduct = Future.value([]);
  int buildCount = 0;

  @override
  void initState() {
    super.initState();
    _futureGetProduct = _getProducts();
  }

  Future<List<ProductModel>> _getProducts() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // return await APIRepository().getProductAdmin(
    //     prefs.getString('accountID').toString(),
    //     prefs.getString('token').toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository().getProduct(
        prefs.getString('accountID').toString(),
        prefs.getString('token').toString());
  }

  Future<void> _onSave(ProductModel pro, BuildContext context) async {
    await _databaseService.insertProduct(Cart(
      productID: pro.id,
      name: pro.name,
      des: pro.description,
      price: pro.price,
      img: pro.imageUrl,
      count: 1,
    ));
    if (context.mounted) {
      context.read<MainpageBloc>().add(LoadUserEvent());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: _futureGetProduct,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          List<ProductModel>? listProducts = snapshot.data;
          Map<String, List<ProductModel>> productsByCategory = {};
          listProducts?.forEach((product) {
            if (!productsByCategory.containsKey(product.categoryName)) {
              productsByCategory[product.categoryName] = [];
            }
            productsByCategory[product.categoryName]?.add(product);
          });

          List<Widget> brandListViews = [];
          productsByCategory.forEach((key, value) {
            brandListViews.add(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header cho mỗi thương hiệu
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      key,
                      style: styleMedium(),
                    ),
                  ),
                  SizedBox(
                    height: 425,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        final itemProduct = value[index];
                        return _buildProduct(itemProduct, context);
                      },
                    ),
                  ),
                ],
              ),
            );
          });
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CarouselSlider(
                    items: listImage.map((e) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          image: DecorationImage(
                            image: NetworkImage(e),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 250,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.3,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  Column(
                    children: brandListViews,
                  ),
                  // SizedBox(
                  //   height: 425,
                  //   child: ListView.builder(
                  //     scrollDirection: Axis.horizontal,
                  //     itemCount: snapshot.data?.length,
                  //     itemBuilder: (context, index) {
                  //       final itemProduct = snapshot.data?[index];
                  //       return _buildProduct(itemProduct, context);
                  //     },
                  //   ),
                  // )
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: Text('No data'),
          );
        }
      },
    );
  }

  Widget _buildProduct(ProductModel? pro, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return BlocProvider(
              create: (context) => MainpageBloc(),
              child: BlocListener<MainpageBloc, MainpageState>(
                listener: (context, state) {
                  if (state is MainpageSuccess) {
                    context.read<MainpageBloc>().add(LoadUserEvent());
                  }
                },
                child: ProductDetail(productModel: pro!),
              ),
            );
          },
        ),
      ),
      child: Container(
        width: 225,
        margin: const EdgeInsets.all(12.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: Colors.grey[200]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: SizedBox(
                height: 225,
                child: Image.network(
                  (pro?.imageUrl == '' ||
                          pro?.imageUrl == 'null' ||
                          pro!.imageUrl.isEmpty)
                      ? urlNoImage
                      : pro.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    Logger().e(pro?.imageUrl);
                    return Image.asset(
                      urlNoImage,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            Text(
              '${pro?.name}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    '${NumberFormat('#,##0').format(pro?.price)} VND',
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    _onSave(pro!, context);
                  },
                  icon: const CircleAvatar(
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 4.0),
            // Text('Category: ${pro.catId}'),
            Text(
              '${pro?.description}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: styleVerySmall(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
