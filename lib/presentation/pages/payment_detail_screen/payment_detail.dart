import 'package:flutter/material.dart';
import 'package:split/model/expense_model.dart';
import 'package:split/model/user_model.dart';
import 'package:split/presentation/pages/detail_screen/detail_screen.dart';

class PaymentDetail extends StatelessWidget {
  PaymentDetail(
      {super.key, required this.expenseModel, required this.userModel});
  UserModel userModel;
  ExpenseModel expenseModel;

  @override
  Widget build(BuildContext context) {
    print(expenseModel.amount);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Top background section
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              // bottom: 10,
              child: Container(
                color: Colors.green.shade400,
                height: 250,
                child: Center(
                  child: Text(
                    'Payment Summary',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // Main content section
            Container(
              margin: const EdgeInsets.only(
                  top: 180, left: 20, right: 20, bottom: 100),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _textForPaymentPage('Description',
                      fontWeight: FontWeight.w500),
                  _textForPaymentPage('${expenseModel.description}'),
                  Divider(),

                  const SizedBox(height: 15),

                  _textForPaymentPage('Amount', fontWeight: FontWeight.w500),
                  _textForPaymentPage('\$${expenseModel.amount}'),
                  Divider(),

                  const SizedBox(height: 15),

                  _textForPaymentPage('Paid', fontWeight: FontWeight.w500),
                  _textForPaymentPage(padiByString(
                      paid: expenseModel.paid, name: '${userModel.name}')),
                  Divider(),

                  const Spacer(),

                  expenseModel.amount <= 0
                      ? Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 30),
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child:
                                textForElevatedButtonPaymentPage(data: 'Pay'),
                          ),
                        )
                      : SizedBox(),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                        onPressed: () {},
                        child: textForElevatedButtonPaymentPage(
                            data: 'Decline', color: Colors.red)),
                  ),
                  // Buttons for Pay and Decline
                  // ElevatedButton(
                  //   onPressed: () {},
                  //   style: ElevatedButton.styleFrom(
                  //     padding: const EdgeInsets.symmetric(
                  //         vertical: 12, horizontal: 30),
                  //     backgroundColor: Colors.redAccent,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //   ),
                  //   child: textForElevatedButtonPaymentPage(data: 'Decline'),
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //   ],
                  // ),
                  expenseModel.amount >= 0
                      ? SizedBox(
                          height: 100,
                        )
                      : const SizedBox(height: 30),
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios)),
          ],
        ),
      ),
    );
  }

  // Widget to display text on the Payment page
  Widget _textForPaymentPage(String data,
      {FontWeight fontWeight = FontWeight.normal}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        data,
        style: TextStyle(
          fontSize: 22,
          color: Colors.black87,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}

Widget textForElevatedButtonPaymentPage(
    {required String data, Color color = Colors.white}) {
  bool condition = color == Colors.white;
  return Text(
    data,
    style: TextStyle(
        fontSize: condition ? 19 : 17,
        decorationThickness: 2,
        decorationColor: Colors.red,
        decoration: condition ? null : TextDecoration.underline,
        color: color),
  );
}
