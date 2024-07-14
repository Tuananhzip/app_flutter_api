import 'package:app_api/app/config/const.dart';
import 'package:app_api/app/model/bill.dart';
import 'package:app_api/app/page/detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryDetail extends StatelessWidget {
  final List<BillDetailModel> bill;
  final String idBill;
  final String dateCreated;

  const HistoryDetail(
      {super.key,
      required this.bill,
      required this.idBill,
      required this.dateCreated});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bill ID: $idBill',
          style: styleVerySmall(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.grey[200],
            child: Column(
              children: [
                Text(
                  'Created date: $dateCreated',
                  textAlign: TextAlign.center,
                  style: styleSmall(color: Colors.black),
                ),
                Text(
                  'Total: ${NumberFormat('#,##0').format(bill.fold(0, (previousValue, element) => previousValue + element.total))} VND',
                  style: styleMedium(color: Colors.red),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: bill.length,
              itemBuilder: (context, index) {
                var data = bill[index];
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  color: Colors.grey[200],
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(8.0),
                            height: 200,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                data.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              data.productName,
                              style: styleMedium(),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Price: ${NumberFormat('#,##0').format(data.total / data.count)} VND',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Quantity: ${data.count.toString()}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          spaceHeight(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Total: ',
                                style: styleMedium(color: Colors.red),
                              ),
                              Text(
                                  '${NumberFormat('#,##0').format(data.total)} VND',
                                  style: styleMedium(color: Colors.red)),
                            ],
                          ),
                        ],
                      ),
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
