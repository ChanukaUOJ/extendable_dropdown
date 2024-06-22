import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ExtendableDropdown extends StatefulWidget {
  Color dismissibleBackgroundColor = Colors.red;
  Widget dismissibleIcon = const Icon(Icons.delete_outline_rounded);
  IconData? selectedIcon = Icons.radio_button_checked_rounded;
  Color? selectedIconColor = Colors.green;
  IconData? nonSelectedIcon = Icons.location_on_outlined;
  Color? nonSelectedIconColor = Colors.red;
  List<dynamic> list = [];
  List<String> dropdownShowing = [];
  ExtendableDropdown({
    super.key,
    required this.dismissibleBackgroundColor,
    required this.dismissibleIcon,
    this.selectedIcon,
    this.selectedIconColor,
    this.nonSelectedIcon,
    this.nonSelectedIconColor,
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
  final List<String> dropdownShowing = [];

  @override
  void initState() {
    super.initState();
    dropdownShowing.addAll(widget.list
        .map((item) => item.toString())
        .toList()); // Assuming string representation
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: dropDownCount,
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
                          if (isClicked[j] == false &&
                              isClicked[j + 1] == true) {
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
                        Icon(
                          widget.selectedIcon,
                          color: widget.selectedIconColor,
                        ),
                      if (isClicked[index] == false)
                        Icon(
                          widget.nonSelectedIcon,
                          color: widget.nonSelectedIconColor,
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
                                    : "Select an item"),
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
                                        widget.dropdownShowing
                                            .add(selectedValue);
                                      }
                                    }
                                  });
                                },
                                items: widget.list
                                    .map<DropdownMenuItem<dynamic>>(
                                        (dynamic item) {
                                  return DropdownMenuItem<dynamic>(
                                    value: item,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.location_on_outlined),
                                        SizedBox(
                                            width: screenSize.width * 0.015),
                                        Text(
                                          item,
                                          style: const TextStyle(
                                              color: Colors.black),
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
        ),
        const SizedBox(
          height: 15,
        ),
        InkWell(
          focusColor: Colors.red,
          onTap: () {
            if (widget.list.isEmpty) {
              showMessage(context, 'No item to select');
            } else if (sendList.length + 1 == dropDownCount) {
              showMessage(context, 'Fill the previous dropdown');
            } else if (sendList.isNotEmpty) {
              setState(() {
                dropDownCount++;
              });
            } else if (sendList.length < dropDownCount) {
              showMessage(context, 'Choose an item!');
            } else if (widget.list.length == dropDownCount - 1) {
              showMessage(context, "No more items available!");
            }
          },
          child: const Row(
            children: [
              Icon(Icons.add_circle_outline_rounded),
              SizedBox(
                width: 5,
              ),
              Text('Add New Dropdown'),
            ],
          ),
        ),
      ],
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
