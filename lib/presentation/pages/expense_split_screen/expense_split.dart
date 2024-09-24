import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split/presentation/controllers/expense_split/expense_split_getx.dart';

class ExpenseSplit extends StatelessWidget {
  const ExpenseSplit({super.key, required this.paid});
  final String paid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How was the expense split?'),
      ),
      body: Column(
        children: [
          Text('With you and George'),
          ListView.builder(
            shrinkWrap: true,
            itemCount: paidBy.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Get.find<ExpenseSplitGetx>().ontap(index: index);
                  Get.back();
                },
                title: Text(paidBy[index]),
                trailing: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          // paid == paidBy[index] ? Colors.white :
                          Colors.black,
                      width: 0.5,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor:
                        paid == paidBy[index] ? Colors.blue : Colors.white,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

const List<String> paidBy = [
  'Full amount paid by you',
  'Full amount paid by him',
  'Split'
];
