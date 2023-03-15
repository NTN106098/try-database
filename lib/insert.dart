import 'package:connect_mongodb/dbHelper/mongo_db.dart';
import 'package:connect_mongodb/models/mongoDb_model.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

class MongoDbInsert extends StatefulWidget {
  const MongoDbInsert({Key? key}) : super(key: key);

  @override
  State<MongoDbInsert> createState() => _MongoDbInsertState();
}

class _MongoDbInsertState extends State<MongoDbInsert> {
  var fnameController = TextEditingController();
  var lnameController = TextEditingController();
  var addressController = TextEditingController();

  var _checkInsertUpdate = "Insert";

  @override
  Widget build(BuildContext context) {
    MongoDbModel data =
        ModalRoute.of(context)!.settings.arguments as MongoDbModel;
    if (data != null) {
      fnameController.text = data.firstname;
      lnameController.text = data.lastname;
      addressController.text = data.address;
      _checkInsertUpdate = "Update";
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _checkInsertUpdate,
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(
                height: 50,
              ),
              TextField(
                controller: fnameController,
                decoration: InputDecoration(labelText: "First Name"),
              ),
              TextField(
                controller: lnameController,
                decoration: InputDecoration(labelText: "Last Name"),
              ),
              TextField(
                controller: addressController,
                maxLines: 5,
                minLines: 3,
                decoration: InputDecoration(labelText: "Address Name"),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        _fakeData();
                      },
                      child: Text("Generate Data")),
                  ElevatedButton(
                      onPressed: () {
                        if (_checkInsertUpdate == "Update") {
                          _updateData(data.id, fnameController.text,
                              lnameController.text, addressController.text);
                        } else {
                          _insertData(fnameController.text,
                              lnameController.text, addressController.text);
                        }
                      },
                      child: Text(_checkInsertUpdate))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateData(
      var id, String fName, String lName, String address) async {
    final updateDate = MongoDbModel(
        id: id, firstname: fName, lastname: lName, address: address);
    await MongoDatabase.update(updateDate)
        .whenComplete(() => Navigator.pop(context));
  }

  Future<void> _insertData(String fName, String lName, String address) async {
    var _id = M.ObjectId(); //! This will use for inique
    final data = MongoDbModel(
        id: _id, firstname: fName, lastname: lName, address: address);
    var result = await MongoDatabase.insert(data);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Inserted ID" + _id.$oid)));
    _cleanAll();
  }

  void _cleanAll() {
    fnameController.text = "";
    lnameController.text = "";
    addressController.text = "";
  }

  void _fakeData() {
    setState(() {
      fnameController.text = faker.person.firstName();
      lnameController.text = faker.person.lastName();
      addressController.text =
          faker.address.streetAddress() + "\n" + faker.address.streetAddress();
    });
  }
}
