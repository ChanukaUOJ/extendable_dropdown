# ExtendableDropdown

## A Versatile Flutter Package for Dynamic, Generic Dropdown Menus (v1.0.4)

Introducing **ExtendableDropdown**, a production-ready Flutter package that empowers you to create dynamic and expandable multiple dropdown menus with full support for generic data types.

## 🚀 Key Features

- **Generic Type Support**: Handle any data type (`T`) with full type safety. No longer restricted to strings!
- **Dynamic Slot Management**: Add or remove dropdown slots on the fly with a simple, intuitive UI.
- **Dismissible Interaction**: Swipe-to-dismiss functionality for removing selections with item return logic.
- **`labelBuilder` API**: Complete control over how your custom objects are rendered as text in the dropdown.
- **Configurable UI Fragments**: Pass your own **Widgets** for the Add Button and custom callbacks for message handling.
- **Fully Mutable-Safe**: Built with immutability in mind, following Flutter's best practices for widget design.

## 📦 Installation

Add `extendable_dropdown` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  extendable_dropdown: ^1.0.4
```

Import the package in your Flutter code:

```dart
import 'package:extendable_dropdown/extendable_dropdown.dart';
```

## 🛠 Usage

### Simple Usage (Strings)

```dart
List<String> cities = ['Colombo', 'Kandy', 'Galle', 'Jaffna'];

ExtendableDropdown<String>(
  list: cities,
  onSendListChanged: (selectedItems) {
    print('Selected cities: $selectedItems');
  },
)
```

### Advanced Usage (Custom Objects & UI)

You can use any custom model and fully override the UI.

```dart
ExtendableDropdown<Location>(
  list: myLocationList,
  onSendListChanged: (selected) => print(selected),
  labelBuilder: (location) => location.name,
  // Completely custom add button
  addButton: ElevatedButton.icon(
    onPressed: null, // Logic is handled internally
    icon: Icon(Icons.add),
    label: Text("Add Location"),
  ),
  // Custom notification logic
  onMessage: (context, message) {
    MyCustomToast.show(message);
  },
)
```

## 🎨 Professional Customization

ExtendableDropdown comes with a wide range of styling options:

| Property | Description | Default |
|----------|-------------|---------|
| `list` | The initial list of items to choose from. | Required |
| `onSendListChanged` | Callback triggered when the selection changes. | Required |
| `labelBuilder` | Function to map generic items to strings. | `item.toString()` |
| `addButton` | **Widget**: Custom widget for the add button. | Styled default button |
| `onMessage` | **Callback**: Handle custom alerts/notifications. | Default SnackBar |
| `dismissibleBackgroundColor` | Color shown when swiping to delete. | `Colors.red` |
| `selectedIcon` | Icon shown for a selected slot. | `Icons.radio_button_checked` |
| `nonSelectedIcon` | Icon shown for an empty slot. | `Icons.location_on_outlined` |
| `dropdownBorderRadius` | Border radius of the dropdown container. | `10.0` |

### Check out the [example](file:///Users/mymac/Documents/MyProjects/extendable_dropdown/example/lib/main.dart) folder for a full implementation!

## 🚧 Roadmap

- [x] Generic data type support (Completed)
- [x] Improved state management and immutability (Completed)
- [ ] Searchable dropdown options
- [ ] Multi-select within a single dropdown slot
- [ ] Custom animation support for slot addition

## 🤝 Contributing

We welcome your feedback and contributions! Please feel free to open issues or submit pull requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](file:///Users/mymac/Documents/MyProjects/extendable_dropdown/LICENSE) file for details.

---
Made with ❤️ by [Chanuka Ranathunga](https://github.com/ChanukaUOJ)
