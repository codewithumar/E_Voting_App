import 'package:flutter/material.dart';
import 'package:e_voting/utils/constants.dart';

enum AdminButton { party, election }

class ElectionTiles extends StatelessWidget {
  const ElectionTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
              blurStyle: BlurStyle.solid,
            ),
          ],
          color: Constants.adminScreenButtonColor,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        height: (MediaQuery.of(context).orientation == Orientation.portrait)
            ? MediaQuery.of(context).size.height * .15
            : (MediaQuery.of(context).orientation == Orientation.portrait)
                ? MediaQuery.of(context).size.height * .15
                : null,
        width: (MediaQuery.of(context).orientation == Orientation.portrait)
            ? MediaQuery.of(context).size.width * .9
            : (MediaQuery.of(context).orientation == Orientation.portrait)
                ? MediaQuery.of(context).size.width * .9
                : null,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 14, 10, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Presidential Elections",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  PopupMenuButton(
                    elevation: 4,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    itemBuilder: (BuildContext context) => const [
                      PopupMenuItem(
                        height: 26.5,
                        child: Center(
                          child: Text("Edit",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              )),
                        ),
                      ),
                      PopupMenuItem(
                        height: 26.5,
                        child: Center(
                          child: Text(
                            "Delete",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    fit: StackFit.loose,
                    children: const [
                      Positioned(
                        child: Image(
                          image:
                              AssetImage("assets/images/partiesimage/pmln.png"),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    "60/120",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}