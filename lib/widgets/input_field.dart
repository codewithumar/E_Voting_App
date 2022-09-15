// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:e_voting/utils/constants.dart';
import 'package:pattern_formatter/date_formatter.dart';

class InputField extends StatefulWidget {
  const InputField(
      {Key? key,
      required this.label,
      required this.labelText,
      this.controller,
      this.errormessage,
      this.fieldmessage,
      this.readOnly})
      : super(key: key);
  final String label;
  final String labelText;
  final TextEditingController? controller;

  final bool? readOnly;
  final String? errormessage;
  final String? fieldmessage;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xff027314),
            ),
          ),
        ),
        Container(
          height: 65,
          margin: const EdgeInsets.symmetric(vertical: 2.0),
          child: TextFormField(
            keyboardType: (widget.fieldmessage == "Cnic" ||
                    widget.fieldmessage == "DOE" ||
                    widget.fieldmessage == "phone")
                ? TextInputType.number
                : TextInputType.text,
            controller: widget.controller,
            inputFormatters: (widget.fieldmessage == "Cnic" ||
                    widget.fieldmessage == "phone")
                ? [
                    LengthLimitingTextInputFormatter(13),
                  ]
                : (widget.fieldmessage == "DOE")
                    ? [
                        LengthLimitingTextInputFormatter(15),
                      ]
                    : [],
            readOnly: (widget.readOnly == true) ? true : false,
            decoration: InputDecoration(
              suffix: (widget.fieldmessage == "DOE")
                  ? IconButton(
                      icon: const Icon(
                        Icons.calendar_today,
                        color: Constants.lightGreen,
                      ),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2050),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            widget.controller!.text =
                                DateFormat('yyyy-MM').format(pickedDate);
                          });
                        }
                      })
                  : const Text(''),
              hintText: (widget.fieldmessage == "password")
                  ? "*********"
                  : widget.labelText,
              labelStyle: const TextStyle(
                fontSize: 14,
              ),
              alignLabelWithHint: true,
              prefixText: "  ",
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 2,
                  color: Constants.errorcolor,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 2,
                  color: Color.fromARGB(255, 203, 217, 205),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1,
                  color: Constants.errorcolor,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 2,
                  color: Colors.green,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              errorStyle: const TextStyle(
                color: Colors.redAccent,
                fontSize: 10,
              ),
            ),
            validator: (value) {
              if (widget.fieldmessage == null && value!.isEmpty) {
                log("1");
                return widget.errormessage;
              } else if (widget.fieldmessage == "Cnic" &&
                  value!.length < 13 &&
                  value.isEmpty) {
                log("2");
                return "Please enter correct 13 digit Cnic";
              } else if (widget.fieldmessage == "email" &&
                  !EmailValidator.validate(value!)) {
                log("3");
                return widget.errormessage;
              } else if (widget.fieldmessage == "DOE" &&
                  value!.isEmpty &&
                  value[2] == "/" &&
                  value.length != 5) {
                log("4");
                return widget.errormessage;
              }
              return null;
            },
          ),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}