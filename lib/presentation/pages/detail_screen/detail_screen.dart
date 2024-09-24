import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split/model/expense_model.dart';
import 'package:split/model/user_model.dart';
import 'package:split/presentation/controllers/login_page/new_user_login_controller.dart';
import 'package:split/presentation/pages/payment_detail_screen/payment_detail.dart';
import 'package:split/presentation/widgets/detail_screen/floating_add_expense.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({super.key, required this.user});
  UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey.shade100, // Light background for the whole screen
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        backgroundColor: Colors.blue.shade200, // Primary color for the app bar
        title: Column(
          children: [
            Text(user.name, style: TextStyle(color: Colors.white)),
          ],
        ),

        bottom: PreferredSize(
            preferredSize: Size(double.infinity, 80),
            child: Column(
              children: [
                Text(user.email),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green.shade300, // Accent color for the button
                    elevation: 0,
                  ),
                  child: Text('Settle', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            )),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade200, // Use white for the container
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            ),
            child: Column(
              children: [
                Expanded(
                  child: detailPageStreamBuilder(usermodel: user),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: floatingAddExpense(usermodel: user),
    );
  }
}

Widget detailPageStreamBuilder({required UserModel usermodel}) {
  String useremail = FirebaseAuth.instance.currentUser!.email!;
  return StreamBuilder(
    stream: firestore
        .collection('expense')
        .doc(useremail)
        .collection(usermodel.email)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(), // Loading indicator
        );
      }
      if (snapshot.hasError) {
        return const Center(
          child:
              Text('Snapshot has error', style: TextStyle(color: Colors.red)),
        );
      }

      var entireExpense = snapshot.data!.docs;
      List<ExpenseModel> expenseList = [];

      // Group the expenses by date
      Map<String, List<ExpenseModel>> groupedUserModelList = {};
      for (var d in entireExpense) {
        Map<String, dynamic> expense_map = d.data();
        DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(
            int.parse(d.id)); // Your ID is in microseconds
        ExpenseModel expenseModel = ExpenseModel(
          description: expense_map['des'],
          paid: expense_map['paid'],
          amount: expense_map['amount'],
          dateTime: dateTime,
        );
        expenseList.add(expenseModel);

        String datetimeString =
            "${dateTime.day}/${dateTime.month}/${dateTime.year}";
        if (groupedUserModelList.containsKey(datetimeString)) {
          groupedUserModelList[datetimeString]!.add(expenseModel);
        } else {
          groupedUserModelList[datetimeString] = [expenseModel];
        }
      }

      // Sort dates in descending order based on dateTime
      List<String> sortedDates = groupedUserModelList.keys.toList()
        ..sort((a, b) {
          // Parse the date string in "day/month/year" format
          List<String> dateAParts = a.split('/');
          DateTime dateA = DateTime(
            int.parse(dateAParts[2]), // Year
            int.parse(dateAParts[1]), // Month
            int.parse(dateAParts[0]), // Day
          );

          List<String> dateBParts = b.split('/');
          DateTime dateB = DateTime(
            int.parse(dateBParts[2]), // Year
            int.parse(dateBParts[1]), // Month
            int.parse(dateBParts[0]), // Day
          );

          return dateB.compareTo(dateA); // Sorts from recent to oldest
        });

      // Main ListView to display grouped expenses by date
      return Column(
        children: [
          SizedBox(height: 10), // Added spacing
          Icon(Icons.horizontal_rule_rounded, color: Colors.blue),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8.0), // Adjusted padding
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(
                    thickness: 1,
                    color: Colors.grey.shade300, // Subtle divider color
                  );
                },
                itemCount: sortedDates.length,
                itemBuilder: (context, index) {
                  String date = sortedDates[index];
                  List<ExpenseModel> expensesForDate =
                      groupedUserModelList[date]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Display date
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          date,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Display expenses for each date
                      ...expensesForDate.map((expenseModel) {
                        return innerDetailingWidget(
                            usermodel: usermodel, expenseModel: expenseModel);
                      }),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget innerDetailingWidget({
  required UserModel usermodel,
  required ExpenseModel expenseModel,
}) {
  return Card(
    color: Colors.grey.shade300,
    // Use Card to add elevation and styling
    elevation: 4, // Adjust elevation for shadow effect
    margin: const EdgeInsets.symmetric(
        vertical: 8, horizontal: 16), // Margin around the card
    shape: RoundedRectangleBorder(
      // Optional: Round the corners of the card
      borderRadius: BorderRadius.circular(10),
    ),
    child: ListTile(
      onTap: () {
        print(usermodel.name);
        Get.to(() => PaymentDetail(
              userModel: usermodel,
              expenseModel: expenseModel,
            ));
      },
      leading: const Icon(Icons.receipt,
          size: 30), // Larger icon for better visibility
      title: Text(
        expenseModel.description,
        style: const TextStyle(fontWeight: FontWeight.bold), // Bold title
      ),
      subtitle: paidByTextWidget(paid: expenseModel.paid, name: usermodel.name),
      trailing: amountText(
        data: expenseModel.amount.toString(),
        amount: expenseModel.amount,
      ),
    ),
  );
}

Widget paidByTextWidget({required int paid, required String name}) {
  return Container(
    // width: 50,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Paid: '),
        Container(
          width: 120,
          child: Text(
            maxLines: 1,
            padiByString(paid: paid, name: name),
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        // Text('slkdfjosfdoisdfsdjdjiodioj')
      ],
    ),
  );
}

String padiByString({required int paid, required String name}) {
  if (paid == 2) {
    return 'Split';
  } else if (paid == 1) {
    return 'paid by $name';
  } else {
    return 'paid by you';
  }
}

Widget amountText({required String data, required num amount,String isPage='detail'}) {
  return Container(
    width: 90,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(isPage=='detail'?
          'Amount':'owes',
          style: TextStyle(fontSize: 16), // Adjust as needed
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$data',
                style: TextStyle(
                    fontSize: 17,
                    color: amount >= 0 ? Colors.green : Colors.red),
              ),
              TextSpan(
                text: '\$', // Dollar sign as a separate span
                style: TextStyle(
                  fontSize: 17,
                  color: amount >= 0 ? Colors.green : Colors.red,
                  // baseline: TextBaseline.alphabetic,
                ),
              ),
            ],
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    ),
  );
}

//  Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(10),
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Button action
//                 },
//                 style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.vertical(
//                       bottom: Radius.circular(50),
//                     ),
//                   ),
//                 ),
//                 child: const Text('Settle up'),
//               ),
//             ),