import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/order_model.dart';


class OrderStorage {
  static const String _ordersKey = 'user_orders';

  static OrderStorage? _instance;
  static OrderStorage get instance => _instance ??= OrderStorage._();
  OrderStorage._();

  // In-memory storage for current session
  final List<OrderModel> _sessionOrders = [];

  // Add order to both session and persistent storage
  Future<void> addOrder(OrderModel order) async {
    _sessionOrders.add(order);
    await _saveOrdersToPersistentStorage();
  }

  // Get orders for a specific user
  Future<List<OrderModel>> getOrdersByUserId(String userId) async {
    // First load from persistent storage if session is empty
    if (_sessionOrders.isEmpty) {
      await _loadOrdersFromPersistentStorage();
    }

    return _sessionOrders
        .where((order) => order.userId == userId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Latest first
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    final orderIndex = _sessionOrders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      _sessionOrders[orderIndex] = _sessionOrders[orderIndex].copyWith(
        status: newStatus,
      );
      await _saveOrdersToPersistentStorage();
    }
  }

  // Clear all orders
  Future<void> clearOrders() async {
    _sessionOrders.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_ordersKey);
  }

  // Save orders to SharedPreferences
  Future<void> _saveOrdersToPersistentStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = _sessionOrders.map((order) => order.toJson()).toList();
      await prefs.setString(_ordersKey, jsonEncode(ordersJson));
    } catch (e) {
      print('Error saving orders: $e');
    }
  }

  // Load orders from SharedPreferences
  Future<void> _loadOrdersFromPersistentStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJsonString = prefs.getString(_ordersKey);

      if (ordersJsonString != null) {
        final ordersJsonList = jsonDecode(ordersJsonString) as List;
        _sessionOrders.clear();
        _sessionOrders.addAll(
          ordersJsonList.map((json) => OrderModel.fromJson(json)).toList(),
        );
      }
    } catch (e) {
      print('Error loading orders: $e');
    }
  }
}
