  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:firebase_database/firebase_database.dart';
  import 'package:flutter/material.dart';

  DatabaseReference dbref = FirebaseDatabase.instance.ref().child('users');
  final _auth = FirebaseAuth.instance;
  late String dbkey;
  class my_account extends StatefulWidget {
    @override
    _my_accountState createState() => _my_accountState();
  }

  class _my_accountState extends State<my_account> {
    // Sample user data

    void getData() async {
      final user = await _auth.currentUser;
      final snapshot = await dbref.get();
      if (snapshot.exists) {
        Map data = snapshot.value as Map;
        data.forEach((key, value) {
          if (value['email'] == user?.email) {
            dbkey=key;
            updateUi(value);
          }
        });
      } else {
        print('No data available.');
      }
    }
    String _username = '';
    String _bio = '';
    String _phone = '';
    void updateUi(Map value) {
      setState(() {
        _username = value['name'];
        _bio = value['bio'];
        _phone = value['phone'];
      });
    }

    // Edit mode flag
    bool _isEditMode = false;

    @override
    void initState() {
      super.initState();
      getData();
    }

    // Function to save the edited information
    void _saveChanges() async{
      Map<String, dynamic> updatedUser = {
        'name': _username,
        'bio': _bio,
        'phone': _phone,
      };
      await dbref.child(dbkey).update(updatedUser);
      setState(() {
        _isEditMode = false;
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Account Details'),
          actions: [
            if (_isEditMode)
              IconButton(
                onPressed: _saveChanges,
                icon: Icon(Icons.save),
              )
            else
              IconButton(
                onPressed: () {
                  setState(() {
                    _isEditMode = true;
                  });
                },
                icon: Icon(Icons.edit),
              ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Username:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              !_isEditMode
                  ? Text(
                _username,
                style: TextStyle(fontSize: 18,),
              )
                  : TextFormField(
                readOnly: !_isEditMode,
                initialValue: _username,
                style: TextStyle(fontSize: 18,),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'Enter your username',
                  contentPadding: EdgeInsets.all(12),
                ),
                onChanged: (value) {
                  setState(() {
                    _username = value;
                  });
                },
              ),
              SizedBox(height: 16),
              Text(
                'Bio:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              !_isEditMode
                  ? Text(
                _bio,
                style: TextStyle(fontSize: 18,),
              )
                  : TextFormField(
                readOnly: !_isEditMode,
                initialValue: _bio,
                style: TextStyle(fontSize: 18,),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'Enter your Bio',
                  contentPadding: EdgeInsets.all(12),
                ),
                onChanged: (value) {
                  setState(() {
                    _bio = value;
                  });
                },
              ),
              SizedBox(height: 16),
              Text(
                'Phone:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              !_isEditMode
                  ? Text(
                _phone,
                style: TextStyle(fontSize: 18,),
              )
                  : TextFormField(
                readOnly: !_isEditMode,
                initialValue: _phone,
                style: TextStyle(fontSize: 18,),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'Enter your phone number',
                  contentPadding: EdgeInsets.all(12),
                ),
                onChanged: (value) {
                  setState(() {
                    _phone = value;
                  });
                },
              ),
            ],
          ),
        ),
      );
    }
  }
