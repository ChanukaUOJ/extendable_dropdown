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
/// void _handleSendListChanged(List<String> sendList) {
///   setState(() {
///     _selectedItems = sendList;
///   });
///   print('Selected items: $_selectedItems');
/// }
/// ```
///
/// See also:
/// * [ExtendableDropdown.onSendListChanged]

typedef SendListCallback<T> = void Function(List<T> sendList);

/// A customizable dropdown widget that supports multiple selections and expandable options.
///
/// The `ExtendableDropdown` widget allows users to create dynamic and expandable dropdown menus
/// with customizable appearance and behavior. It supports adding and removing dropdown options,
/// and provides flexibility in configuring its appearance and interaction.
class ExtendableDropdown<T> extends StatefulWidget {
  /// The background color of the dismissible icon (e.g., delete button) in the dropdown list.
  final Color dismissibleBackgroundColor;

  /// The icon widget displayed for dismissible actions (e.g., delete button) in the dropdown list.
  final Widget dismissibleIcon;

  /// The icon displayed when an item is selected in the dropdown.
  final IconData? selectedIcon;

  /// The color of the icon displayed when an item is selected.
  final Color? selectedIconColor;

  /// The icon displayed when an item is not selected in the dropdown.
  final IconData? nonSelectedIcon;

  /// The color of the icon displayed when an item is not selected.
  final Color? nonSelectedIconColor;

  /// The icon displayed in the dropdown list.
  final IconData? listIcon;

  /// The color of the icon displayed in the dropdown list.
  final Color? listIconColor;

  /// The list of items to display in the dropdown.
  final List<T> list;

  /// A function that returns a string representation of the item.
  ///
  /// This is used to display the item in the dropdown and selection list.
  /// If not provided, `item.toString()` will be used.
  final String Function(T item)? labelBuilder;

  /// A callback function that is called when the selected list changes.
  ///
  /// This function is called with the updated list of selected items.
  final SendListCallback<T> onSendListChanged;

  /// The padding applied to the top of the dropdown.
  final double paddingTop;

  /// The padding applied to the bottom of the dropdown.
  final double paddingBottom;

  /// The padding applied to the left of the dropdown.
  final double paddingLeft;

  /// The padding applied to the right of the dropdown.
  final double paddingRight;

  /// The background color of the snackbar that appears for certain actions.
  final Color? snackBarcolor;

  /// The border radius of the snackbar
  final double snakBarBorderRadius;

  /// The margin around the snackbar.
  final double snackBarMargin;

  /// The text color of the snackbar.
  final Color? snackBarTextcolor;

  /// The border radius of the dropdown's container.
  final double dropdownBorderRadius;

  /// A custom widget to display as the "Add New Dropdown" button.
  ///
  /// If provided, this widget will be used for the button's appearance,
  /// while the package handles the logical integration (adding a new slot).
  final Widget? addButton;

  /// A callback to handle when a message needs to be shown.
  ///
  /// This allows users to use their own notification system or custom SnackBar.
  /// If not provided, a default SnackBar will be shown.
  final void Function(BuildContext context, String message)? onMessage;

  /// Creates an instance of `ExtendableDropdown`.
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// ExtendableDropdown<String>(
  ///   list: ['Option 1', 'Option 2'],
  ///   onSendListChanged: (selectedItems) => print(selectedItems),
  /// )
  /// ```
  /// {@end-tool}
  const ExtendableDropdown({
    super.key,
    required this.list,
    required this.onSendListChanged,
    this.dismissibleBackgroundColor = Colors.red,
    this.dismissibleIcon = const Icon(Icons.delete_outline_rounded),
    this.selectedIcon = Icons.radio_button_checked_rounded,
    this.selectedIconColor = Colors.green,
    this.nonSelectedIcon = Icons.location_on_outlined,
    this.nonSelectedIconColor = Colors.red,
    this.listIcon = Icons.location_on_outlined,
    this.listIconColor = Colors.red,
    this.labelBuilder,
    this.paddingTop = 16.0,
    this.paddingBottom = 16.0,
    this.paddingLeft = 16.0,
    this.paddingRight = 16.0,
    this.snackBarcolor,
    this.snakBarBorderRadius = 15.0,
    this.snackBarMargin = 10.0,
    this.snackBarTextcolor,
    this.dropdownBorderRadius = 10.0,
    this.addButton,
    this.onMessage,
  });

  @override
  State<ExtendableDropdown<T>> createState() => _ExtendableDropdownState<T>();
}

class _ExtendableDropdownState<T> extends State<ExtendableDropdown<T>> {
  /// The list of items currently available for selection.
  late List<T> _availableItems;

  /// The list of currently selected items (or null for empty slots).
  late List<T?> _selections;

  @override
  void initState() {
    super.initState();
    _availableItems = List.from(widget.list);
    _selections = [null];
  }

  @override
  void didUpdateWidget(covariant ExtendableDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.list != oldWidget.list) {
      setState(() {
        // Sync available items while preserving selections if they still exist in the new list.
        _availableItems = List.from(widget.list);
        for (var i = 0; i < _selections.length; i++) {
          final selection = _selections[i];
          if (selection != null) {
            if (widget.list.contains(selection)) {
              _availableItems.remove(selection);
            } else {
              _selections[i] = null;
            }
          }
        }
        _updateParent();
      });
    }
  }

  /// Returns the label for a given item.
  String _getItemLabel(T item) {
    if (widget.labelBuilder != null) {
      return widget.labelBuilder!(item);
    }
    return item.toString();
  }

  /// Triggers the callback with the current list of non-null selections.
  void _updateParent() {
    final selected = _selections.whereType<T>().toList();
    widget.onSendListChanged(selected);
  }

  /// Adds a new empty dropdown slot if criteria are met.
  void _addNewSlot() {
    if (_availableItems.isEmpty) {
      _showMessage(context, 'No more items available!');
      return;
    }
    if (_selections.any((element) => element == null)) {
      _showMessage(context, 'Fill the existing slots first!');
      return;
    }
    setState(() {
      _selections.add(null);
    });
  }

  /// Removes a dropdown slot at the given index.
  void _removeSlot(int index) {
    if (_selections.length <= 1) {
      _showMessage(context, "At least one dropdown must remain.");
      return;
    }

    setState(() {
      final removedItem = _selections[index];
      if (removedItem != null) {
        _availableItems.add(removedItem);
      }
      _selections.removeAt(index);
      _updateParent();
    });
  }

  /// Handles selection changes for a specific slot.
  void _onChanged(int index, T? newValue) {
    if (newValue == null) return;

    setState(() {
      final oldValue = _selections[index];
      if (oldValue != null) {
        _availableItems.add(oldValue);
      }
      _selections[index] = newValue;
      _availableItems.remove(newValue);
      _updateParent();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        top: widget.paddingTop,
        bottom: widget.paddingBottom,
        left: widget.paddingLeft,
        right: widget.paddingRight,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.separated(
            shrinkWrap: true,
            itemCount: _selections.length,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _buildDropdownSlot(index, theme);
            },
          ),
          const SizedBox(height: 16),
          _buildAddButton(theme),
        ],
      ),
    );
  }

  Widget _buildDropdownSlot(int index, ThemeData theme) {
    final selection = _selections[index];
    final isSelected = selection != null;

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _removeSlot(index),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: widget.dismissibleBackgroundColor,
          borderRadius: BorderRadius.circular(widget.dropdownBorderRadius),
        ),
        child: widget.dismissibleIcon,
      ),
      child: Row(
        children: [
          _buildLeadingIcon(isSelected),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? theme.primaryColor : theme.dividerColor,
                  width: isSelected ? 2 : 1.5,
                ),
                borderRadius: BorderRadius.circular(widget.dropdownBorderRadius),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T>(
                  isExpanded: true,
                  hint: Text(
                    isSelected ? _getItemLabel(selection!) : "Select an item",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isSelected ? theme.textTheme.bodyLarge?.color : theme.hintColor,
                    ),
                  ),
                  items: _availableItems.map((item) {
                    return DropdownMenuItem<T>(
                      value: item,
                      child: Row(
                        children: [
                          if (widget.listIcon != null) ...[
                            Icon(
                              widget.listIcon,
                              size: 18,
                              color: widget.listIconColor ?? theme.iconTheme.color,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(_getItemLabel(item)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) => _onChanged(index, value),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadingIcon(bool isSelected) {
    final iconData = isSelected ? widget.selectedIcon : widget.nonSelectedIcon;
    final color = isSelected ? widget.selectedIconColor : widget.nonSelectedIconColor;

    if (iconData == null) return const SizedBox.shrink();

    return Icon(
      iconData,
      color: color,
    );
  }

  Widget _buildAddButton(ThemeData theme) {
    final defaultButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.add_circle_outline_rounded,
            color: theme.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Add New Dropdown',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

    return InkWell(
      onTap: _addNewSlot,
      borderRadius: BorderRadius.circular(8),
      child: widget.addButton ?? defaultButton,
    );
  }

  void _showMessage(BuildContext context, String message) {
    if (widget.onMessage != null) {
      widget.onMessage!(context, message);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: widget.snackBarTextcolor ?? Colors.white,
            fontSize: 14.0,
          ),
        ),
        backgroundColor: widget.snackBarcolor ?? Theme.of(context).snackBarTheme.backgroundColor ?? Colors.grey[800],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.snakBarBorderRadius),
        ),
        margin: EdgeInsets.all(widget.snackBarMargin),
      ),
    );
  }
}
