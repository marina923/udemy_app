import 'package:flutter/material.dart';

import 'package:udemy_app/models/users/userModel.dart';

class usersScreen extends StatelessWidget {
  List<userModel> users = [
    userModel(id: 1, name: 'marina', phone: 3456789),
    userModel(id: 2, name: 'madonna', phone: 3456789),
    userModel(id: 3, name: 'fady', phone: 3456789),
    userModel(id: 4, name: 'lorna', phone: 3456789),
    userModel(id: 5, name: 'boles', phone: 3456789),
    userModel(id: 6, name: 'mazen', phone: 3456789),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) => buildUserId(users[index]),
          separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsetsDirectional.only(start: 20.0),
                child: Container(
                  width: double.infinity,
                  color: Colors.grey[300],
                  height: 1.0,
                ),
              ),
          itemCount: users.length),
    );
  }

  Widget buildUserId(userModel user) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25.0,
              child: Text(
                '${user.id}',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.name}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  ),
                ),
                Text(
                  '${user.phone}',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
