String? validateEmail(String? email) {
  if (email?.isEmpty ?? true) {
    return 'Email is required';
  } else if (email != null &&
      !RegExp(r"[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.[a-zA-Z]{2,}")
          .hasMatch(email)) {
    return 'Invalid email format';
  } else if (email!.length > 254) {
    // Additional check: Email length limit
    return 'Email address is too long (limit: 254 characters)';
  }
  return null; // No error
}

String? validateFirstName(String? firstName) {
  if (firstName?.isEmpty ?? true) {
    return 'Field is required';
  } else if (firstName!.trim().length < 2) {
    return 'Field must be at least 2 characters';
  } else if (firstName.length > 50) {
    // Additional check: First name length limit
    return 'Field is too long (limit: 50 characters)';
  } else if (!RegExp(r"^[a-zA-Z '-]+$").hasMatch(firstName)) {
    // Additional check: Allowed characters in first name
    return 'Field can only contain letters, spaces, hyphens, and apostrophes';
  }
  return null; // No error
}

String? validateLastName(String? lastName) {
  // Similar logic as validateFirstName with potential adjustments
  return validateFirstName(lastName); // Reuse logic if applicable
}

String? validatePassword(String? password) {
  if (password?.isEmpty ?? true) {
    return 'Password is required';
  } else if (password != null &&
      !RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$")
          .hasMatch(password)) {
    return 'Password must be at least 8 characters and include uppercase, lowercase, number, and symbol';
  } else if (password!.length > 128) {
    // Additional check: Password length limit
    return 'Password is too long (limit: 128 characters)';
  }
  return null; // No error
}

String? validateConfirmPassword(String? confirmPassword, String? password) {
  if (confirmPassword?.isEmpty ?? true) {
    return 'Confirm password is required';
  } else if (confirmPassword != password) {
    return 'Passwords do not match';
  }
  return null; // No error
}
