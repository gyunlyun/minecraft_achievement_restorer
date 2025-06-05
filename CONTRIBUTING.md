# Contributing to Minecraft Achievement Restorer

Thank you for your interest in contributing to this project! We welcome contributions from everyone.

## Getting Started

### Prerequisites

- Flutter SDK (3.32.1 or later)
- Windows 10/11 for testing
- Git
- A code editor (VS Code, Android Studio, or IntelliJ IDEA recommended)

### Setting up the development environment

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/minecraft-achievement-restorer.git
   cd minecraft-achievement-restorer
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate localization files**
   ```bash
   flutter gen-l10n
   ```

4. **Run the app**
   ```bash
   flutter run -d windows
   ```

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in [Issues](https://github.com/yourusername/minecraft-achievement-restorer/issues)
2. If not, create a new issue with:
   - Clear description of the bug
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots if applicable
   - System information (Windows version, Flutter version)

### Suggesting Features

1. Check existing [Issues](https://github.com/yourusername/minecraft-achievement-restorer/issues) for similar suggestions
2. Create a new issue with:
   - Clear description of the feature
   - Use case and benefits
   - Possible implementation approach

### Code Contributions

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes**
4. **Test your changes**
   ```bash
   flutter test
   flutter build windows --release
   ```
5. **Commit your changes**
   ```bash
   git commit -m "Add: your feature description"
   ```
6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```
7. **Create a Pull Request**

### Code Style

- Follow Dart/Flutter conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Ensure code is properly formatted (`flutter format .`)
- Run `flutter analyze` to check for issues

### Localization

If you want to add support for a new language:

1. Add the language code to `l10n.yaml`
2. Create `lib/l10n/app_[language_code].arb` file
3. Translate all strings from `app_en.arb`
4. Test the localization in the app

## Development Guidelines

### Project Structure

```
lib/
├── l10n/           # Localization files
├── models/         # Data models
├── screens/        # UI screens
├── services/       # Business logic
├── widgets/        # Reusable UI components
└── main.dart       # App entry point
```

### Testing

- Write unit tests for business logic
- Test UI components when possible
- Ensure all tests pass before submitting PR

### Commit Messages

Use clear, descriptive commit messages:
- `Add: new feature description`
- `Fix: bug description`
- `Update: what was updated`
- `Remove: what was removed`

## Questions?

If you have questions about contributing, feel free to:
- Open an issue with the "question" label
- Contact the maintainers

Thank you for contributing! 🎉
