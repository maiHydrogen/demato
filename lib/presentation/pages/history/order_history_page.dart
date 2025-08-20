import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/history/order_history_bloc.dart';
import '../../widgets/order_card.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  OrderHistoryPageState createState() => OrderHistoryPageState();
}

class OrderHistoryPageState extends State<OrderHistoryPage> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<OrderHistoryBloc>().add(
        LoadOrderHistory(userId: authState.userId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
        builder: (context, state) {
          if (state is OrderHistoryLoading) {
            return Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          } else if (state is OrderHistoryLoaded) {
            if (state.orders.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              color: Colors.red,
              onRefresh: () async {
                final authState = context.read<AuthBloc>().state;
                if (authState is AuthAuthenticated) {
                  context.read<OrderHistoryBloc>().add(
                    LoadOrderHistory(userId: authState.userId),
                  );
                }
              },
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return OrderCard(order: order);
                },
              ),
            );
          } else if (state is OrderHistoryError) {
            return _buildErrorState(state.message);
          }

          return Center(child: Text('Loading orders...'));
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 100,
            color: Colors.grey[400],
          ),
          SizedBox(height: 24),
          Text(
            'No orders yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Your order history will appear here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.restaurant_menu),
            label: Text('Start Ordering'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Error loading orders',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final authState = context.read<AuthBloc>().state;
              if (authState is AuthAuthenticated) {
                context.read<OrderHistoryBloc>().add(
                  LoadOrderHistory(userId: authState.userId),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
