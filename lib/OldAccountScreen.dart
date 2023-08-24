import 'package:flutter/material.dart';

class AccountTab extends StatefulWidget {
  @override
  _AccountTabState createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  bool _isPersonalInformationExpanded = false;
  bool _isSecurityExpanded = false;
  bool _isAccountExpanded=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile.png'),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Bio: Full-stack developer passionate about Flutter',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            _buildDropdown(
              title: 'Personal Information',
              isExpanded: _isPersonalInformationExpanded,
              onTap: () {
                setState(() {
                  _isPersonalInformationExpanded =
                      !_isPersonalInformationExpanded;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(title: 'Name', value: 'John Doe'),
                  _buildDetailRow(title: 'Email', value: 'johndoe@example.com'),
                  _buildDetailRow(title: 'Contact', value: '8688379479'),
                ],
              ),
            ),
            Divider(),
            _buildDropdown(
              title: 'Security',
              isExpanded: _isSecurityExpanded,
              onTap: () {
                setState(() {
                  _isSecurityExpanded = !_isSecurityExpanded;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  _buildDetailRow(title: 'Change Password',value: 'Change'),
                ],
              ),
            ),
            Divider(),
            _buildDropdown(
                title: 'Account',
                isExpanded: _isAccountExpanded,
                onTap: (){
                  setState(() {
                    _isAccountExpanded=!_isAccountExpanded;
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    _buildDetailRow(title: 'Delete Account',value: 'Delete'),
                    SizedBox(
                      height: 15,
                    ),
                    _buildDetailRow(title: 'Logout',value: 'Logout'),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            ],
          ),
        ),
        if (isExpanded) child,
      ],
    );
  }

  Widget _buildDetailRow({required String title, String? value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16),
        ),
        if (value != null)
          ElevatedButton(
            onPressed: () {
              // Handle editing
            },
            child: Text(value),
          ),
      ],
    );
  }
}
