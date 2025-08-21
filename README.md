# Demato

- Demo + Zomato = Demato.
- A mini Zomato Platform based Flutter with BLoC state management.
- This project is intended for learning purpose only and was made as a part of Flutter assessment test.

---

## Architecture Overview

Following flowchart shows the base architecture for this project using BLoC.

```
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   │   └── exceptions.dart
│   └── utils/
│       ├── auth_guard.dart
│       └── validators.dart
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── cart_item_model.dart
│   │   ├── restaurant_model.dart
│   │   ├── menu_item_model.dart
│   │   └── order_model.dart
│   ├── repositories/
│   └── datasources/
│       ├── local/
│       │   ├── user_storage.dart
│       │   └── order_storage.dart
│       └── remote/
│           └── mock_data_source.dart
├── domain/
│   ├── entities/
│   │   ├── user.dart
│   │   ├── restaurant.dart
│   │   ├── menu_item.dart
│   │   └── order.dart
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── bloc/
│   │   ├── auth/
│   │   ├── restaurant/
│   │   ├── history/
│   │   ├── menu/
│   │   ├── cart/
│   │   └── order/
│   ├── pages/
│   │   ├── auth/
│   │   ├── home/
│   │   ├── history/
│   │   ├── menu/
│   │   ├── cart/
│   │   └── order/
│   └── widgets/
│       ├── cart_item_widget.dart
│       ├── menu_item_widget.dart
│       ├── order_card.dart
│       ├── restaurant_card.dart
│       └── search_bar.dart
└── main.dart
```
---

## Getting Started

For setting up this project on windows follow the following steps - 
- Step 1 - Clone this repository to your local directory
  ```
  $ git clone https://github.com/maiHydrogen/demato.git
  ```
- Step 2 - open the project with any Text Editor i.e. VS Code or Android Studio and run the following commands in Terminal 
  ```
  $ flutter pub get
  $ flutter run
  ```
- Voila!!! You are good to go with the Setup.

- Flutter Setup -
  Follow the instructions given [here](https://docs.flutter.dev/get-started/install)

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
