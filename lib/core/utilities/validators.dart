class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    const emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    if (!RegExp(emailRegex).hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    if (value.length > 128) {
      return 'Password must be less than 128 characters';
    }

    return null;
  }

  // Strong password validation
  static String? validateStrongPassword(String? value) {
    final basicValidation = validatePassword(value);
    if (basicValidation != null) return basicValidation;

    if (value!.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    // Check for uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for lowercase letter
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for digit
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    // Check for special character
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters long';
    }

    if (value.length > 50) {
      return 'Name must be less than 50 characters';
    }

    // Check for valid name characters (letters, spaces, hyphens, apostrophes)
    const nameRegex = r"^[a-zA-Z\s\-\']+$";
    if (!RegExp(nameRegex).hasMatch(value)) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }

    return null;
  }

  // Phone number validation
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length < 10) {
      return 'Phone number must be at least 10 digits';
    }

    if (digitsOnly.length > 15) {
      return 'Phone number must be less than 15 digits';
    }

    return null;
  }

  // Address validation
  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }

    if (value.trim().length < 5) {
      return 'Address must be at least 5 characters long';
    }

    if (value.length > 200) {
      return 'Address must be less than 200 characters';
    }

    return null;
  }

  // Price validation
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    }

    final price = double.tryParse(value);
    if (price == null) {
      return 'Please enter a valid price';
    }

    if (price < 0) {
      return 'Price cannot be negative';
    }

    if (price > 9999.99) {
      return 'Price cannot exceed \$9999.99';
    }

    // Check for maximum 2 decimal places
    final decimalPlaces = value.split('.').length > 1 ? value.split('.')[1].length : 0;
    if (decimalPlaces > 2) {
      return 'Price can have maximum 2 decimal places';
    }

    return null;
  }

  // Quantity validation
  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Quantity is required';
    }

    final quantity = int.tryParse(value);
    if (quantity == null) {
      return 'Please enter a valid quantity';
    }

    if (quantity <= 0) {
      return 'Quantity must be greater than 0';
    }

    if (quantity > 99) {
      return 'Quantity cannot exceed 99';
    }

    return null;
  }

  // Credit card validation
  static String? validateCreditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Credit card number is required';
    }

    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length < 13 || digitsOnly.length > 19) {
      return 'Credit card number must be between 13-19 digits';
    }

    // Luhn algorithm validation
    if (!_isValidCreditCard(digitsOnly)) {
      return 'Invalid credit card number';
    }

    return null;
  }

  // CVV validation
  static String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }

    if (value.length < 3 || value.length > 4) {
      return 'CVV must be 3 or 4 digits';
    }

    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'CVV must contain only digits';
    }

    return null;
  }

  // Expiry date validation (MM/YY format)
  static String? validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }

    const expiryRegex = r'^(0[1-9]|1[0-2])\/([0-9]{2})$';
    if (!RegExp(expiryRegex).hasMatch(value)) {
      return 'Enter expiry date in MM/YY format';
    }

    final parts = value.split('/');
    final month = int.parse(parts[0]);
    final year = int.parse(parts[1]) + 2000; // Convert YY to YYYY

    final now = DateTime.now();
    final expiryDate = DateTime(year, month + 1, 0); // Last day of the month

    if (expiryDate.isBefore(now)) {
      return 'Credit card has expired';
    }

    return null;
  }

  // Restaurant name validation
  static String? validateRestaurantName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Restaurant name is required';
    }

    if (value.trim().length < 2) {
      return 'Restaurant name must be at least 2 characters long';
    }

    if (value.length > 100) {
      return 'Restaurant name must be less than 100 characters';
    }

    return null;
  }

  // Menu item description validation
  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Description is required';
    }

    if (value.trim().length < 10) {
      return 'Description must be at least 10 characters long';
    }

    if (value.length > 500) {
      return 'Description must be less than 500 characters';
    }

    return null;
  }

  // Generic required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Confirmation password validation
  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }

    if (password != confirmPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  // URL validation
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }

    const urlRegex = r'^https?:\/\/[^\s$.?#].[^\s]*$';
    if (!RegExp(urlRegex, caseSensitive: false).hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  // Helper method for Luhn algorithm (credit card validation)
  static bool _isValidCreditCard(String cardNumber) {
    int sum = 0;
    bool alternate = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return (sum % 10) == 0;
  }

  // Multi-field validation helper
  static Map<String, String?> validateLoginForm(String? email, String? password) {
    return {
      'email': validateEmail(email),
      'password': validatePassword(password),
    };
  }

  static Map<String, String?> validateSignupForm({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    String? phone,
  }) {
    return {
      'name': validateName(name),
      'email': validateEmail(email),
      'password': validatePassword(password),
      'confirmPassword': validateConfirmPassword(password, confirmPassword),
      'phone': validatePhone(phone),
    };
  }

  static Map<String, String?> validateMenuItemForm({
    String? name,
    String? description,
    String? price,
  }) {
    return {
      'name': validateRequired(name, 'Menu item name'),
      'description': validateDescription(description),
      'price': validatePrice(price),
    };
  }
}

// Extension for easier validation
extension StringValidation on String? {
  String? get emailValidation => Validators.validateEmail(this);
  String? get passwordValidation => Validators.validatePassword(this);
  String? get nameValidation => Validators.validateName(this);
  String? get phoneValidation => Validators.validatePhone(this);
  String? get addressValidation => Validators.validateAddress(this);
  String? get priceValidation => Validators.validatePrice(this);
  String? get quantityValidation => Validators.validateQuantity(this);
}
