# extendable_dropdown

# ExtendableDropdown - A Flutter Package for Flexible Dropdowns (v1.0.0)

Introducing **ExtendableDropdown**, a customizable Flutter package that empowers you to create dynamic and expandable multiple dropdown menus in your applications.

## Key Features

- **Expandable functionality**: Add or remove dropdown options on the fly, providing a user-friendly experience for managing multiple selections.
- **Dismissible options**: Allow users to easily remove unwanted options from the dropdown list.
- **Customization options**: Personalize the appearance of your dropdowns with configurable colors for the dismissible background, selected/non-selected icons, and container borders.
- **Intuitive usage**: Integrate ExtendableDropdown seamlessly into your Flutter codebase with clear APIs and well-structured components.

## Benefits

- **Improved user experience**: Enhanced flexibility and control over dropdown menus, leading to a more interactive and efficient interaction for your users.
- **Simplified development**: Streamline the creation of complex dropdown functionalities with a reusable and well-designed widget.
- **Increased code maintainability**: Keep your code organized and modular by encapsulating dropdown logic within ExtendableDropdown.

## Getting Started

### Installation

Add `extendable_dropdown` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  extendable_dropdown: ^1.0.0
```

Import
Import the package in your Flutter code:

```dart
import 'package:extendable_dropdown/extendable_dropdown.dart';
```

Usage
Create an ExtendableDropdown instance, specifying the desired options and configurations:

```dart

List<String> stringList = [
  'Colombo',
  'Kandy',
  'Galle',
  'Jaffna',
  'Matara',
  'Trincomalee',
];

List<dynamic> _selectedItems = [];

void _handleSendListChanged(List<dynamic> sendList) {
  setState(() {
    _selectedItems = sendList;
  });
  print('Selected items: $_selectedItems');
}

ExtendableDropdown(
  dropdownBorderRadius: 10.0,
  snackBarMargin: 10.0,
  snakBarBorderRadius: 5.0,
  paddingLeft: 16.0,
  paddingBottom: 16.0,
  paddingRight: 16.0,
  paddingTop: 16.0,
  dismissibleBackgroundColor: Colors.red,
  snackBarcolor: Colors.blue[500],
  nonSelectedIcon: Icons.radio_button_checked_rounded,
  selectedIcon: Icons.location_on_outlined,
  selectedIconColor: Colors.green,
  nonSelectedIconColor: Colors.red,
  listIcon: Icons.location_on_outlined,
  listIconColor: Colors.black87,
  list: stringList,
  dismissibleIcon: const Icon(
    Icons.delete,
    color: Colors.black45,
  ),
  onSendListChanged: _handleSendListChanged,
),

```
FOR MORE INFORMATION HEAD ONTO EXAMPLE 😊

👉 Roadmap
Advanced customization: Add features like searching within dropdown options or setting custom icons for different options.
Extend the package to allow working with different data types rather than string lists.
Accessibility enhancements: Implement screen reader support and other accessibility features for a more inclusive experience.
Stay tuned for future updates! We welcome your feedback and contributions to make ExtendableDropdown even more powerful.

👉 Contributing
We appreciate any contributions to the project. Please feel free to open issues, submit pull requests, or provide feedback.

👉 License
This project is licensed under the MIT License - see the LICENSE file for details.

Made with ❤️ by Chanuka Ranathunga
