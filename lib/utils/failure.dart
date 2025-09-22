import 'package:supabase_flutter/supabase_flutter.dart';

/// A generic failure model for handling errors consistently
class Failure implements Exception {
  final String message; // clean error for UI
  final String? code; // Supabase error code

  Failure(this.message, {this.code});

  @override
  String toString() => 'Failure(code: $code, message: $message)';
}

/// A helper class to convert Supabase errors into [Failure] objects
class SupabaseExceptionHandler {
  /// Convert any exception into a user-friendly [Failure]
  static Failure handle(dynamic error) {
    if (error is AuthException) {
      return _mapAuthError(error);
    } else if (error is PostgrestException) {
      return Failure(_friendlyMessage(error.message), code: error.code);
    } else if (error is StorageException) {
      return Failure(
        "File storage error, please retry.",
        code: "STORAGE_ERROR",
      );
    } else if (error is Exception) {
      return Failure(
        "Something went wrong. Please try again.",
        code: "UNKNOWN_EXCEPTION",
      );
    } else {
      return Failure("Unexpected error occurred.", code: "UNKNOWN");
    }
  }

  /// Map authentication errors into clean messages
  static Failure _mapAuthError(AuthException error) {
    final code = error.statusCode?.toString();
    final message = error.message.toLowerCase();

    if (message.contains("invalid login credentials")) {
      return Failure("Incorrect email or password.", code: code);
    } else if (message.contains("email not confirmed")) {
      return Failure("Please verify your email before logging in.", code: code);
    } else if (message.contains("user not found")) {
      return Failure("No account found with this email.", code: code);
    } else if (message.contains("network")) {
      return Failure("Network error. Check your connection.", code: code);
    }
    return Failure("Authentication failed. Please try again.", code: code);
  }

  /// General mapping for other errors
  static String _friendlyMessage(String rawMessage) {
    if (rawMessage.toLowerCase().contains("duplicate key")) {
      return "This record already exists.";
    }
    if (rawMessage.toLowerCase().contains("not null")) {
      return "Some required fields are missing.";
    }
    return "An error occurred. Please try again.";
  }
}
