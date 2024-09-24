import 'package:shimmer/shimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split/model/user_model.dart';
import 'package:split/presentation/controllers/login_page/new_user_login_controller.dart';
import 'package:split/presentation/pages/add_expense_screen/add_expense.dart';
import 'package:split/presentation/pages/add_people_screen/add_people.dart';
import 'package:split/presentation/pages/detail_screen/detail_screen.dart';
import 'package:split/presentation/pages/login_page/login_page.dart';
import 'package:split/presentation/widgets/detail_screen/floating_add_expense.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: firestore
              .collection('friends')
              .doc(FirebaseAuth.instance.currentUser!.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return shimmerHomePageforStream();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error fetching friends'));
            }

            var data = snapshot.data?.data();
            List<dynamic>? emailList = data?['email'];

            if (emailList != null && emailList.isNotEmpty) {
              return homePageList(emailList: emailList, context: context);
            } else {
              return homePageNoUserFound();
            }
          },
        ),
      ),
      floatingActionButton: floatingAddExpense(),
    );
  }
}

Widget homePageNoUserFound() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'No friends found.',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Get.to(() => const AddPeople());
          },
          style: ElevatedButton.styleFrom(
            elevation: 4,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('Add people'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Get.to(() => LoginPage());
          },
          style: ElevatedButton.styleFrom(
            elevation: 4,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('Sign out'),
        ),
      ],
    ),
  );
}

Widget homePageList({required emailList, required context}) {
  return ListView(
    children: [
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: emailList.length,
        itemBuilder: (context, index) {
          return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: firestore.collection('users').doc(emailList[index]).get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return shimmerHomePageforStreamMoney();
              }

              if (userSnapshot.hasError) {
                return const Center(child: Text('Error fetching user details'));
              }

              return homePageListOwes(
                  userSnapshot: userSnapshot, index: index, context: context);
            },
          );
        },
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddPeople(),
          ));
        },
        style: ElevatedButton.styleFrom(
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: const Text('Add people'),
      ),
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
          Get.to(() => LoginPage());
        },
        style: ElevatedButton.styleFrom(
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: const Text('Sign out'),
      ),
    ],
  );
}

Widget homePageListOwes({
  required userSnapshot,
  required int index,
  required BuildContext context,
}) {
  var userData = userSnapshot.data?.data();

  if (userData == null) {
    return const ListTile(
      title: Text('User not found'),
    );
  }

  UserModel userDetail = UserModel(
    name: userData['name'] ?? 'Unknown',
    email: userData['email'] ?? 'Unknown',
    phone: userData['phone'] ?? 'Unknown',
  );

  return Dismissible(
    background: Container(
      color: Colors.red,
      child: const Icon(Icons.delete),
    ),
    key: ValueKey<int>(index),
    onDismissed: (direction) {},
    child: Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailScreen(
              user: userDetail,
            ),
          ));
        },
        leading: CircleAvatar(
          backgroundColor: Colors.red.shade100,
          child: Text(userDetail.name[0].toUpperCase()),
        ),
        title: Text(
          userDetail.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(userDetail.email),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            StreamBuilder(
              stream: firestore
                  .collection('total')
                  .doc(useremail)
                  .collection(userDetail.email)
                  .doc('total')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('0');
                } else if (snapshot.hasError) {
                  return const Text('0');
                }

                var total = snapshot.data?.data();
                num data = total == null ? 0 : total['total'];
                return amountText(
                    data: data.toString(), amount: data, isPage: '');
              },
            ),
          ],
        ),
      ),
    ),
  );
}

Widget shimmerHomePageforStreamMoney() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[200]!,
    child: Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Container(
          height: 10.0,
          color: Colors.white,
        ),
        subtitle: Container(
          height: 10.0,
          color: Colors.white,
        ),
      ),
    ),
  );
}

Widget shimmerHomePageforStream() {
  return Shimmer.fromColors(
    baseColor: Colors.black12,
    highlightColor: Colors.white10,
    child: ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Container(
              height: 10.0,
              color: Colors.white,
            ),
            subtitle: Container(
              height: 10.0,
              color: Colors.white,
            ),
          ),
        );
      },
    ),
  );
}
