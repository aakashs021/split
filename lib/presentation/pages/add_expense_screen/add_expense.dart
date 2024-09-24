import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split/model/user_model.dart';
import 'package:split/presentation/controllers/expense_split/expense_split_getx.dart';
import 'package:split/presentation/controllers/login_page/new_user_login_controller.dart';
import 'package:split/presentation/pages/expense_split_screen/expense_split.dart';

String useremail = FirebaseAuth.instance.currentUser!.email!;

class AddExpense extends StatelessWidget {
  AddExpense({super.key, this.usermodel});
  UserModel? usermodel;
  final expensesplit = Get.put(ExpenseSplitGetx());
  final TextEditingController descriptioncontroller = TextEditingController();
  final TextEditingController amountcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(usermodel?.name);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add expense'),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 200,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('You  with  '),
                usermodel != null ? Text(usermodel!.name) : const Text('no')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt,
                  size: 75,
                  color: Colors.grey.shade500,
                ),
                SizedBox(
                    width: 200,
                    child: TextField(
                      controller: descriptioncontroller,
                      decoration:
                          const InputDecoration(hintText: 'Description'),
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.currency_bitcoin,
                  size: 75,
                  color: Colors.grey.shade500,
                ),
                SizedBox(
                    width: 200,
                    child: TextField(
                      controller: amountcontroller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: 'Amount'),
                    )),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('Select the split options :'),
            GetBuilder<ExpenseSplitGetx>(
              builder: (controller) {
                return ElevatedButton(
                    onPressed: () {
                      Get.to(
                          () => ExpenseSplit(paid: paidBy[controller.index]));
                    },
                    child: Text(paidBy[controller.index]));
              },
            ),
            const Expanded(child: SizedBox()),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      // Validate input before proceeding
                      if (descriptioncontroller.text.isEmpty &&
                          amountcontroller.text.isEmpty) {
                        _showSnackBar(
                            context, 'Description and amount cannot be empty!');
                        return;
                      } else if (descriptioncontroller.text.isEmpty) {
                        _showSnackBar(context, 'Description cannot be empty!');
                        return;
                      } else if (amountcontroller.text.isEmpty) {
                        _showSnackBar(context, 'Amount cannot be empty!');
                        return;
                      }

                      num? amount = num.tryParse(amountcontroller.text);
                      if (amount == null) {
                        _showSnackBar(
                            context, 'Please enter a valid numeric amount!');
                        return;
                      }

                      int split = Get.find<ExpenseSplitGetx>().index;
                      if (split == 2) {
                        amount = amount / 2;
                      } else if (split == 1) {
                        amount = -amount;
                      }

                      Map<String, dynamic> data = {
                        'paid': split,
                        'des': descriptioncontroller.text,
                        'amount': amount,
                      };
                      String dateTime =
                          DateTime.now().microsecondsSinceEpoch.toString();

                      // Save data for current user
                      await firestore
                          .collection('expense')
                          .doc(useremail)
                          .collection(usermodel!.email)
                          .doc(dateTime)
                          .set(data);
                      await firestore
                          .collection('total')
                          .doc(useremail)
                          .collection(usermodel!.email)
                          .doc('total')
                          .set(
      {'total': FieldValue.increment(amount)},
      SetOptions(merge: true), // Merges with existing data, or creates if it doesn't exist
    );
                      // Adjust amount and save for friend
                      int friendSplit = (split == 2) ? 2 : (split == 0 ? 1 : 0);
                      amount = -amount; // Flip amount for the friend
                      data['amount'] = amount;
                      data['paid'] = friendSplit;

                      await firestore
                          .collection('expense')
                          .doc(usermodel!.email)
                          .collection(useremail)
                          .doc(dateTime)
                          .set(data);

                           await firestore
    .collection('total')
    .doc(usermodel!.email)
    .collection(useremail)
    .doc('total')
    .set(
      {'total': FieldValue.increment(amount)},
      SetOptions(merge: true), // Merges with existing data, or creates if it doesn't exist
    );


                      Navigator.pop(context);
                    },
                    child: const Text('ADD'))),
            const SizedBox(
              height: 40,
            )
          ],
        ));
  }
}

// Method to show snackbar
void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: EdgeInsets.only(bottom: 650, left: 20, right: 20),
      behavior: SnackBarBehavior.floating,
      content: Center(child: Text(message)),
      backgroundColor: Colors.red,
    ),
  );
}
