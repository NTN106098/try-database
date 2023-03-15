import 'package:connect_mongodb/dbHelper/mongo_db.dart';
import 'package:connect_mongodb/insert.dart';
import 'package:connect_mongodb/models/mongoDb_model.dart';
import 'package:flutter/material.dart';

class MongoDbUpdate extends StatefulWidget {
  const MongoDbUpdate({Key? key}) : super(key: key);

  @override
  State<MongoDbUpdate> createState() => _MongoDbUpdateState();
}

class _MongoDbUpdateState extends State<MongoDbUpdate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder(
        future: MongoDatabase.getData(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData) {
              var totalData = snapshot.data.length;
              print("Total Data" + totalData.toString());
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return displayCard(
                        MongoDbModel.fromJson(snapshot.data[index]));
                  });
              // return Text('data');
            } else {
              return Center(
                child: Text("No data Available"),
              );
            }
          }
        },
      )),
    );
  }

  Widget displayCard(MongoDbModel data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${data.id.$oid}"),
                SizedBox(
                  height: 5,
                ),
                Text("${data.firstname}"),
                SizedBox(
                  height: 5,
                ),
                Text("${data.lastname}"),
                SizedBox(
                  height: 5,
                ),
                Text("${data.address}")
              ],
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) {
                            return MongoDbInsert();
                          },
                          settings: RouteSettings(arguments: data)));
                },
                icon: Icon(Icons.edit))
          ],
        ),
      ),
    );
  }
}
