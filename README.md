# Quizzy (Flutter Project)

## Overview

This is a quiz and leaderboard web application built using **Flutter** and **Firebase**. The app features user authentication, quiz creation and participation, a leaderboard system, wallet functionality, and a user profile—all organized with a polished multi-page UI. It demonstrates integration of Firebase backend services with modern Flutter UI development.

## Features

- **User Authentication:** Secure login, signup, and password reset, with support for social login providers.
- **Quiz Creation & Participation:** Users can create quizzes, preview, and take live quizzes.
- **Leaderboard:** Tracks and displays scores and rankings across users.
- **Profile Management:** Each user has a customizable profile section.
- **Wallet Page:** Displays rewards or tokens earned through quizzes.
- **Responsive Design:** Works on both web and mobile platforms.
- **Themed UI:** Includes light and dark themes for modern appearance.

## Tech Stack

| Technology           | Purpose                                   |
|----------------------|-------------------------------------------|
| Flutter              | Cross-platform app development            |
| Firebase             | Backend (authentication, data, hosting)   |
| Dart                 | Programming language for Flutter          |
| Google Sign-In       | Social authentication integration         |
| Material Design      | Consistent UI/UX elements                 |

## Getting Started

### Prerequisites

- Flutter SDK installed
- Dart
- Firebase account and project configuration

### Installation

1. **Clone the repository:**
    ```
    git clone https://github.com/devansh19020/Flutter_Project.git
    cd Flutter_Project
    ```

2. **Install dependencies:**
    ```
    flutter pub get
    ```

3. **Set up Firebase:**
    - Register your app in the Firebase Console (for web, Android, or iOS as required).
    - Download the configuration file (`google-services.json` for Android, `GoogleService-Info.plist` for iOS, or web config for web) and place it in the correct directory.
    - Update Firebase rules and dependencies as required.

4. **Run the application:**
    ```
    flutter run
    ```
    Or for web:
    ```
    flutter run -d chrome
    ```

## Folder Structure

<pre>
Flutter_Project/
├── lib/
│ ├── BottomNavBar.dart
│ ├── CreateQuiz.dart
│ ├── ForgotPassword.dart
│ ├── HomePage.dart
│ ├── Leaderboard.dart
│ ├── LiveQuizPreview.dart
│ ├── LobbyScreen.dart
│ ├── LoginPage.dart
│ ├── ProfilePage.dart
│ ├── QuizAttempt.dart
│ ├── QuizPreview.dart
│ ├── QuizResult.dart
│ ├── SettingPage.dart
│ ├── SignUpPage.dart
│ ├── SplashScreen.dart
│ ├── WalletPage.dart
│ ├── main.dart
│ └── themes/
├── pubspec.yaml
├── README.md
└── ...
</pre>

## Usage

1. **Sign Up / Login:** Create a new account or log in using email/password or supported social login.
2. **Create Quizzes:** Navigate to the quiz creation page to add new quizzes.
3. **Join Quizzes:** Participate in live quizzes and track your progress and results.
4. **View Leaderboard:** Check rankings and competition among users.
5. **Check Profile & Wallet:** View or update your profile; track wallet earnings.

## Contributing

Open to contributions! Fork the repo, create a branch, and submit a pull request with your improvements or bug fixes.

## License

This project is open source and free to use for learning or personal projects.

## Links

- [GitHub Repository](https://github.com/devansh19020/Flutter_Project)
