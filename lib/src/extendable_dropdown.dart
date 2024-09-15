import 'package:flutter/material.dart';

/// A callback function used to handle changes to the list of selected items.
///
/// This function is called with the updated list of selected items whenever
/// the selection changes in the `ExtendableDropdown` widget.
///
/// The [sendList] parameter contains the updated list of selected items.
/// It allows you to perform actions based on the new selection, such as updating
/// the UI or storing the selected items.
///
/// Example:
/// ```dart
/// void _handleSendListChanged(List<dynamic> sendList) {
///   setState(() {
///     _selectedItems = sendList;
///   });
///   print('Selected items: $_selectedItems');
/// }
/// ```
///
/// See also:
/// * [ExtendableDropdown.onSendListChanged]

typedef SendListCallback = void Function(List<dynamic> sendList);

/// A customizable dropdown widget that supports multiple selections and expandable options.
///
/// The `ExtendableDropdown` widget allows users to create dynamic and expandable dropdown menus
/// with customizable appearance and behavior. It supports adding and removing dropdown options,
/// and provides flexibility in configuring its appearance and interaction.
// ignore: must_be_immutable
class ExtendableDropdown extends StatefulWidget {
  /// The background color of the dismissible icon (e.g., delete button) in the dropdown list.
  Color dismissibleBackgroundColor = Colors.red;

  /// The icon widget displayed for dismissible actions (e.g., delete button) in the dropdown list.
  Widget dismissibleIcon = const Icon(Icons.delete_outline_rounded);

  /// The icon displayed when an item is selected in the dropdown.
  IconData? selectedIcon = Icons.radio_button_checked_rounded;

  /// The color of the icon displayed when an item is selected.
  Color? selectedIconColor = Colors.green;

  /// The icon displayed when an item is not selected in the dropdown.
  IconData? nonSelectedIcon = Icons.location_on_outlined;

  /// The color of the icon displayed when an item is not selected.
  Color? nonSelectedIconColor = Colors.red;

  /// The icon displayed in the dropdown list.
  IconData? listIcon = Icons.location_on_outlined;

  /// The color of the icon displayed in the dropdown list.
  Color? listIconColor = Colors.red;

  /// The list of items to display in the dropdown.
  List<dynamic> list = [];

  /// A callback function that is called when the selected list changes.
  ///
  /// This function is called with the updated list of selected items.
  final SendListCallback onSendListChanged;

  /// The padding applied to the top of the dropdown.
  double paddingTop = 16.0;

  /// The padding applied to the bottom of the dropdown.
  double paddingBottom = 16.0;

  /// The padding applied to the left of the dropdown.
  double paddingLeft = 16.0;

  /// The padding applied to the right of the dropdown.
  double paddingRight = 16.0;

  /// The background color of the snackbar that appears for certain actions.
  Color? snackBarcolor = const Color.fromARGB(255, 142, 142, 158);

  /// The border radius of the snackbar
  double snakBarBorderRadius = 15.0;

  /// The margin around the snackbar.
  double snackBarMargin = 10.0;

  /// The text color of the snackbar.
  Color? snackBarTextcolor = Colors.white;

  /// The border radius of the dropdown's container.
  double dropdownBorderRadius = 10.0;

  /// Creates an instance of `ExtendableDropdown`.
  ///
  /// Requires [list] and [onSendListChanged] to be provided. Other parameters are optional
  /// and can be customized to fit the design requirements.
  ExtendableDropdown({
    super.key,
    required this.dismissibleBackgroundColor,
    required this.dismissibleIcon,
    this.selectedIcon,
    this.selectedIconColor,
    this.nonSelectedIcon,
    this.nonSelectedIconColor,
    this.listIcon,
    this.listIconColor,
    required this.list,
    required this.onSendListChanged,
    required this.paddingTop,
    required this.paddingBottom,
    required this.paddingLeft,
    required this.paddingRight,
    this.snackBarcolor,
    required this.snakBarBorderRadius,
    required this.snackBarMargin,
    this.snackBarTextcolor,
    required this.dropdownBorderRadius,
  });

  @override
  State<ExtendableDropdown> createState() => _ExtendableDropdownState();
}

class _ExtendableDropdownState extends State<ExtendableDropdown> {
  int dropDownCount = 1;

  late List<bool> isClicked = List.filled(widget.list.length, false);
  late List<dynamic> sendList = [];

  void _updateSendList() {
    widget.onSendListChanged(
        sendList); // Trigger the callback with the updated list
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
          top: widget.paddingTop,
          bottom: widget.paddingBottom,
          left: widget.paddingLeft,
          right: widget.paddingRight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: dropDownCount,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: ((context, index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
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
                          showMessage(context, "You can't remove this...");
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
                        // dropdownShowing.removeAt(index);
                        _updateSendList();
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (isClicked[index] == true)
                          widget.selectedIcon != null
                              ? Icon(
                                  widget.selectedIcon,
                                  color: widget.selectedIconColor,
                                )
                              : const SizedBox(),
                        if (isClicked[index] == false)
                          widget.nonSelectedIcon != null
                              ? Icon(
                                  widget.nonSelectedIcon,
                                  color: widget.nonSelectedIconColor,
                                )
                              : const SizedBox(),
                        widget.selectedIcon != null ||
                                widget.nonSelectedIcon != null
                            ? const SizedBox(
                                width: 10,
                              )
                            : const SizedBox(),
                        Expanded(
                          child: Container(
                            width: screenSize.width,
                            height: screenSize.width * 0.125,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black45, width: 1.5),
                              borderRadius: BorderRadius.circular(
                                  widget.dropdownBorderRadius),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<dynamic>(
                                  hint: Text(
                                    isClicked[index] == true
                                        ? sendList[index]
                                        : "Select an item",
                                    style:
                                        const TextStyle(color: Colors.black87),
                                  ),
                                  onChanged: (dynamic selectedValue) {
                                    setState(() {
                                      if (selectedValue != null) {
                                        if (isClicked[index] == true) {
                                          widget.list.remove(selectedValue);
                                          widget.list.add(sendList[index]);
                                          sendList[index] = selectedValue;
                                          // dropdownShowing[index] =
                                          //     selectedValue;
                                        } else if (isClicked[index] == false) {
                                          isClicked[index] = true;
                                          sendList.add(selectedValue);
                                          widget.list.remove(selectedValue);
                                        }

                                        _updateSendList();
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
                                          widget.listIcon != null
                                              ? Icon(
                                                  widget.listIcon,
                                                  color: widget.listIconColor ??
                                                      Colors.black,
                                                )
                                              : const SizedBox(),
                                          SizedBox(
                                              width: screenSize.width * 0.01),
                                          Text(
                                            item,
                                            style: const TextStyle(
                                                color: Colors.black87),
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
      ),
    );
  }

  void showMessage(BuildContext context, String message) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: widget.snackBarTextcolor,
            fontSize: 14.0,
          ),
        ),
        backgroundColor: widget.snackBarcolor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.snakBarBorderRadius),
        ),
        margin: EdgeInsets.all(widget.snackBarMargin),
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
      ),
    );
  }
}
