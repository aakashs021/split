import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split/model/user_model.dart';
import 'package:split/presentation/controllers/add_people/search_list_getx.dart';
import 'package:split/presentation/controllers/login_page/new_user_login_controller.dart';
import 'package:split/presentation/widgets/add_people/loading_state_peoplelist.dart';
import 'package:split/presentation/widgets/add_people/no_user_found_peoplelist.dart';
import 'package:split/presentation/widgets/add_people/user_found_peoplelist.dart';

class AddPeople extends StatelessWidget {
  const AddPeople({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add people'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              onChanged: (value) {
                Get.find<SearchListGetx>().onSearchChanged(value);
              },
              decoration: InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: firestore.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return loadingStatePeopleList();
                } else if (!snapshot.hasData) {
                  return noUserFoundPeopleList();
                } else {
                  return userFoundPeoplelist(snapshot: snapshot);
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade200,
        onPressed: () async {
          List<UserModel> list = Get.find<SearchListGetx>().filterlist;
          List<String> email = [];
          for (UserModel user in list) {
            if (user.friend != null && user.friend!) {
              email.add(user.email);
            }
          }
          await firestore
              .collection('friends')
              .doc(FirebaseAuth.instance.currentUser!.email)
              .set({'email': FieldValue.arrayUnion(email)},
                  SetOptions(merge: true));

          List databasefriends = [];

          var friend = await firestore.collection('friends').get();
          for (var d in friend.docs) {
            databasefriends.add(d.id);
          }
          for (var d in email) {
            // if(!databasefriends.contains(d)){
            await firestore.collection('friends').doc(d).set({
              'email': FieldValue.arrayUnion(
                  [FirebaseAuth.instance.currentUser!.email])
            }, SetOptions(merge: true));
          }
          Get.back();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
