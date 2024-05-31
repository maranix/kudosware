# kudosware

A Flutter application for managing student entries using `flutter_bloc`, `equatable`, `firebase_core`, `firebase_auth`, and `cloud_firestore`.

## Features

- User authentication with Firebase Authentication
- Manage student entries (create, read, update, delete)
- Teacher-specific data access
- State management with `flutter_bloc` and `equatable`

## Screenshots

<!-- Insert your screenshot images here -->
![Home Screen](screenshots/home_screen.png)
![Student List](screenshots/student_list.png)
![Add Student](screenshots/add_student.png)

## Demo Video

<!-- Insert your demo video link here -->
[Watch the demo video](https://example.com/demo_video)

## Setup Instructions

### Prerequisites

- Flutter installed on your machine. Follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install).
- Firebase project set up. Follow the instructions below to set up Firebase in the cloud and your application.

It's better to follow the [official Firebase installation instructions guide](https://firebase.google.com/docs/flutter/setup)

### Firebase Setup

1. **Create a Firebase Project**

    - Go to the [Firebase Console](https://console.firebase.google.com/).
    - Click on "Add project" and follow the on-screen instructions.

2. **Register Your App with Firebase**

    - In the Firebase Console, click on your project.
    - Click on the Android icon to add an Android app to your project.
    - Follow the on-screen instructions to download the `google-services.json` file.

    - Similarly, click on the iOS icon to add an iOS app to your project.
    - Follow the on-screen instructions to download the `GoogleService-Info.plist` file.

3. **Enable Firebase Authentication**

    - In the Firebase Console, go to "Authentication" and enable the sign-in methods you need (e.g., Email/Password).

4. **Set Up Firestore**

    - In the Firebase Console, go to "Firestore Database".
    - Click on "Create database" and follow the on-screen instructions to set up Firestore in production mode or test mode.

### FlutterFire CLI Setup

1. **Install FlutterFire CLI**

    ```bash
    dart pub global activate flutterfire_cli
    ```

2. **Configure Your App with Firebase**

    Navigate to the root of your Flutter project and run:

    ```bash
    flutterfire configure
    ```

    Follow the on-screen instructions to select your Firebase project and platforms.

### Project Setup

1. **Clone the Repository**

    ```bash
    git clone https://github.com/maranix/kudosware.git
    cd flutter_firebase_student_management
    ```

2. **Install Dependencies**

    ```bash
    flutter pub get
    ```

3. **Add Firebase Configuration Files**

    You don't need to do this if you have added the support using `flutterfire_cli`.
    - Place the `google-services.json` file in the `android/app` directory.
    - Place the `GoogleService-Info.plist` file in the `ios/Runner` directory.

### Running the App

    ```bash
    flutter run
    ```

## License

```
Copyright (c) 2021 Raman Verma


Permission is hereby granted, free of charge, to any
person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the
Software without restriction, including without
limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software
is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice
shall be included in all copies or substantial portions
of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF
ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT
SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
```
