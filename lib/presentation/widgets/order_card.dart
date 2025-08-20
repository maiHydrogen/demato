import 'package:flutter/material.dart';
import '../../data/model/order_model.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.restaurant.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStatusChip(order.status),
              ],
            ),

            SizedBox(height: 8),

            // Order Date
            Text(
              _formatDateTime(order.createdAt),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),

            SizedBox(height: 12),

            // Order Items
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: order.items.map((item) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${item.quantity}x ${item.menuItem.name}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Text(
                        '\$${item.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            Divider(height: 20),

            // Order Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${order.total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            if (order.deliveryAddress != null) ...[
              SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      order.deliveryAddress!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    Color backgroundColor;
    Color textColor;
    String statusText;

    switch (status) {
      case OrderStatus.pending:
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange;
        statusText = 'Pending';
        break;
      case OrderStatus.confirmed:
        backgroundColor = Colors.blue;
        textColor = Colors.blue;
        statusText = 'Confirmed';
        break;
      case OrderStatus.preparing:
        backgroundColor = Colors.purple;
        textColor = Colors.purple;
        statusText = 'Preparing';
        break;
      case OrderStatus.ready:
        backgroundColor = Colors.amber;
        textColor = Colors.amber;
        statusText = 'Ready';
        break;
      case OrderStatus.pickedUp:
        backgroundColor = Colors.indigo;
        textColor = Colors.indigo;
        statusText = 'Picked Up';
        break;
      case OrderStatus.delivered:
        backgroundColor = Colors.green;
        textColor = Colors.green;
        statusText = 'Delivered';
        break;
      case OrderStatus.cancelled:
        backgroundColor = Colors.red;
        textColor = Colors.red;
        statusText = 'Cancelled';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
