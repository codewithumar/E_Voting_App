import 'package:e_voting/screens/create_party_screen.dart';
import 'package:flutter/material.dart';

import 'package:e_voting/widgets/partytiles.dart';
import 'package:e_voting/utils/constants.dart';

class PartiesScreen extends StatelessWidget {
  const PartiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Parties"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: Constants.colors,
            ),
          ),
        ),
        actions: <Widget>[
          MaterialButton(
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreatePartyScreen(),
                ),
              );
            },
            shape: const CircleBorder(
              side: BorderSide(
                color: Colors.transparent,
              ),
            ),
            child: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              PartiesTiles(),
              PartiesTiles(),
              PartiesTiles(),
              PartiesTiles(),
              PartiesTiles(),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
