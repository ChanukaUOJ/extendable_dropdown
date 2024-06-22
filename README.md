# extendable_dropdown

# ExtendableDropdown - A Flutter Package for Flexible Dropdowns (v0.1.0)

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
  extendable_dropdown: ^0.1.0
```

Import
Import the package in your Flutter code:

```dart
import 'package:extendable_dropdown/extendable_dropdown.dart';
```

Usage
Create an ExtendableDropdown instance, specifying the desired options and configurations:

```dart
ExtendableDropdown(
  dismissibleBackgroundColor: Colors.red,
  dismissibleIcon: const Icon(Icons.delete_outline_rounded),
  selectedIcon: Icons.check_circle_outline,
  selectedIconColor: Colors.green,
  list: ["Option 1", "Option 2", "Option 3"],
)
```

Roadmap
State management integration: Explore options like Provider or BLoC for improved state handling.
Advanced customization: Add features like searching within dropdown options or setting custom icons for different options.
Accessibility enhancements: Implement screen reader support and other accessibility features for a more inclusive experience.
Stay tuned for future updates! We welcome your feedback and contributions to make ExtendableDropdown even more powerful.

Contributing
We appreciate any contributions to the project. Please feel free to open issues, submit pull requests, or provide feedback.

License
This project is licensed under the MIT License - see the LICENSE file for details.

Made with ❤️ by Chanuka Ranathunga




