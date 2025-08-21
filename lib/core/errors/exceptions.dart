// Base exception class
abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException({
    required this.message,
    this.code,
  });

  @override
  String toString() {
    return 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}

// Server-related exceptions
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.code,
  });
}

class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
  });
}

class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Request timeout',
    super.code = 'TIMEOUT',
  });
}

// Authentication exceptions
class AuthenticationException extends AppException {
  const AuthenticationException({
    required super.message,
    super.code,
  });
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Unauthorized access',
    super.code = 'UNAUTHORIZED',
  });
}

// Data exceptions
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code = 'CACHE_ERROR',
  });
}

class DataParsingException extends AppException {
  const DataParsingException({
    required super.message,
    super.code = 'PARSING_ERROR',
  });
}

// Business logic exceptions
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    this.fieldErrors,
    super.code = 'VALIDATION_ERROR',
  });

  @override
  String toString() {
    String baseString = super.toString();
    if (fieldErrors != null && fieldErrors!.isNotEmpty) {
      String fieldErrorString = fieldErrors!.entries
          .map((e) => '${e.key}: ${e.value}')
          .join(', ');
      return '$baseString - Field Errors: {$fieldErrorString}';
    }
    return baseString;
  }
}

class BusinessLogicException extends AppException {
  const BusinessLogicException({
    required super.message,
    super.code = 'BUSINESS_LOGIC_ERROR',
  });
}

// Cart and Order exceptions
class CartException extends AppException {
  const CartException({
    required super.message,
    super.code = 'CART_ERROR',
  });
}

class OrderException extends AppException {
  const OrderException({
    required super.message,
    super.code = 'ORDER_ERROR',
  });
}

class PaymentException extends AppException {
  const PaymentException({
    required super.message,
    super.code = 'PAYMENT_ERROR',
  });
}

// Restaurant and Menu exceptions
class RestaurantException extends AppException {
  const RestaurantException({
    required super.message,
    super.code = 'RESTAURANT_ERROR',
  });
}

class MenuException extends AppException {
  const MenuException({
    required super.message,
    super.code = 'MENU_ERROR',
  });
}

// Location exceptions
class LocationException extends AppException {
  const LocationException({
    required super.message,
    super.code = 'LOCATION_ERROR',
  });
}

// File operations exceptions
class FileException extends AppException {
  const FileException({
    required super.message,
    super.code = 'FILE_ERROR',
  });
}

// Custom exceptions with specific use cases
class ItemNotFoundException extends AppException {
  const ItemNotFoundException({
    required super.message,
    super.code = 'ITEM_NOT_FOUND',
  });
}

class ItemUnavailableException extends AppException {
  const ItemUnavailableException({
    required super.message,
    super.code = 'ITEM_UNAVAILABLE',
  });
}

class InsufficientBalanceException extends AppException {
  const InsufficientBalanceException({
    super.message = 'Insufficient balance',
    super.code = 'INSUFFICIENT_BALANCE',
  });
}

class OutOfServiceAreaException extends AppException {
  const OutOfServiceAreaException({
    super.message = 'Service not available in this area',
    super.code = 'OUT_OF_SERVICE_AREA',
  });
}

// Exception factory methods
class AppExceptionFactory {
  static AppException fromHttpStatusCode(int statusCode, String message) {
    switch (statusCode) {
      case 400:
        return ValidationException(message: message, code: 'BAD_REQUEST');
      case 401:
        return UnauthorizedException(message: message);
      case 403:
        return AuthenticationException(message: message, code: 'FORBIDDEN');
      case 404:
        return ItemNotFoundException(message: message);
      case 408:
        return TimeoutException(message: message);
      case 500:
        return ServerException(message: message, code: 'INTERNAL_SERVER_ERROR');
      case 502:
        return ServerException(message: message, code: 'BAD_GATEWAY');
      case 503:
        return ServerException(message: message, code: 'SERVICE_UNAVAILABLE');
      default:
        return ServerException(
          message: message,
          code: 'HTTP_$statusCode',
        );
    }
  }

  static AppException fromNetworkError(String message) {
    return NetworkException(message: message);
  }

  static AppException fromParsingError(String message) {
    return DataParsingException(message: message);
  }
}
