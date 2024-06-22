import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ExtendableDropdown extends StatefulWidget {
  Color dismissibleBackgroundColor = Colors.red;
  Widget dismissibleIcon = const Icon(Icons.delete_outline_rounded);
  List<dynamic> list = [];
  List<String> dropdownShowing = [];
  ExtendableDropdown({
    super.key,
    required this.dismissibleBackgroundColor,
    required this.dismissibleIcon,
    required this.list,
    required this.dropdownShowing,
  });

  @override
  State<ExtendableDropdown> createState() => _ExtendableDropdownState();
}

class _ExtendableDropdownState extends State<ExtendableDropdown> {
  int dropDownCount = 1;

  late List<bool> isClicked = List.filled(widget.list.length, false);
  late List<dynamic> sendList = [];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 5,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: ((context, index) {
        return Column(
          children: [
            Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              background: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: widget.dismissibleBackgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: widget.dismissibleIcon,
              ),
              onDismissed: (DismissDirection direction) {
                setState(() {
                  if (dropDownCount == 1) {
                    showMessage(context, "You can't remove this");
                    return;
                  }
                  dropDownCount--;
                  isClicked[index] = false;

                  bool swapped;
                  for (int i = 0; i < isClicked.length - 1; i++) {
                    swapped = false;
                    for (int j = 0; j < isClicked.length - i - 1; j++) {
                      if (isClicked[j] == false && isClicked[j + 1] == true) {
                        bool temp = isClicked[j];
                        isClicked[j] = isClicked[j + 1];
                        isClicked[j + 1] = temp;
                        swapped = true;
                      }
                    }
                    if (!swapped) {
                      break;
                    }
                  }
                  widget.list.add(sendList[index]);
                  sendList.removeAt(index);
                  widget.dropdownShowing.removeAt(index);
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (isClicked[index] == true)
                    const Icon(
                      Icons.radio_button_checked_rounded,
                      color: Color.fromARGB(255, 86, 180, 95),
                    ),
                  if (isClicked[index] == false)
                    const Icon(
                      Icons.location_on_outlined,
                      color: Color.fromARGB(255, 235, 80, 80),
                    ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      width: screenSize.width / 1.3,
                      height: screenSize.width * 0.125,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 158, 158, 158),
                            width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<dynamic>(
                            hint: Text(isClicked[index] == true
                                ? widget.dropdownShowing[index]
                                : "Select a route point"),
                            value: null,
                            onChanged: (dynamic selectedValue) {
                              setState(() {
                                if (selectedValue != null) {
                                  if (isClicked[index] == true) {
                                    widget.list.remove(selectedValue);
                                    widget.list.add(sendList[index]);
                                    sendList[index] = selectedValue;
                                    widget.dropdownShowing[index] =
                                        selectedValue;
                                  } else if (isClicked[index] == false) {
                                    isClicked[index] = true;
                                    sendList.add(selectedValue);
                                    widget.list.remove(selectedValue);
                                    widget.dropdownShowing.add(selectedValue);
                                  }
                                }
                              });
                            },
                            items: widget.list
                                .map<DropdownMenuItem<dynamic>>((dynamic item) {
                              return DropdownMenuItem<dynamic>(
                                value: item,
                                child: Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined),
                                    SizedBox(width: screenSize.width * 0.015),
                                    Text(
                                      item,
                                      style:
                                          const TextStyle(color: Colors.blue),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        );
      }),
    );
  }

  void showMessage(BuildContext context, String message) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white, // Adjust text color as needed
            fontSize: 14.0, // Adjust text size as needed
          ),
        ),
        backgroundColor: const Color.fromARGB(
            255, 142, 142, 158), // Adjust background color as needed
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
      ),
    );
  }
}
