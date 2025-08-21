import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/cart_item_model.dart';
import '../../../data/model/restaurant_model.dart';
import '../../bloc/cart/cart_bloc.dart';
import '../../widgets/cart_item_widget.dart';
import '../order/order_confirmation_page.dart';
import '../../bloc/order/order_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';


class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoaded && state.items.isNotEmpty) {
                return TextButton(
                  onPressed: () {
                    _showClearCartDialog(context);
                  },
                  child: Text(
                    'Clear',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          // Listen to OrderBloc for order placement
          BlocListener<OrderBloc, OrderState>(
            listener: (context, state) {
              if (state is OrderPlaced) {
                // Navigate to order confirmation
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderConfirmationPage(
                      order: state.order,
                    ),
                  ),
                );
              } else if (state is OrderError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return Center(child: CircularProgressIndicator(color: Colors.red));
            } else if (state is CartLoaded) {
              if (state.items.isEmpty) {
                return _buildEmptyCart();
              }

              return Column(
                children: [
                  // Cart Items List
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final cartItem = state.items[index];
                        return CartItemWidget(
                          cartItem: cartItem,
                          onQuantityChanged: (newQuantity) {
                            context.read<CartBloc>().add(
                              UpdateCartItemQuantity(
                                menuItemId: cartItem.menuItem.id,
                                quantity: newQuantity,
                              ),
                            );
                          },
                          onRemove: () {
                            context.read<CartBloc>().add(
                              RemoveFromCart(menuItemId: cartItem.menuItem.id),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  // Order Summary
                  _buildOrderSummary(context, state),
                ],
              );
            } else if (state is CartError) {
              return _buildErrorState(state.message);
            }

            return Center(child: Text('Loading cart...'));
          },
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, CartLoaded state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),

          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal'),
              Text('\$${state.subtotal.toStringAsFixed(2)}'),
            ],
          ),
          SizedBox(height: 8),

          // Delivery Fee
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Delivery Fee'),
              Text('\$${state.deliveryFee.toStringAsFixed(2)}'),
            ],
          ),

          Divider(height: 24),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${state.total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Checkout Button
          SizedBox(
            width: double.infinity,
            child: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, orderState) {
                return ElevatedButton(
                  onPressed: orderState is OrderPlacing
                      ? null
                      : () => _placeOrder(context, state),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    //fontSize: 16,
                    //fontWeight: FontWeight.bold,
                  ),
                  child: orderState is OrderPlacing
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text('Placing Order...'),
                    ],
                  )
                      : Text('Place Order'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _placeOrder(BuildContext context, CartLoaded cartState) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      // Get the restaurant from the first cart item
      // In a real app, you'd ensure all items are from the same restaurant
      if (cartState.items.isNotEmpty) {
        // For demo purposes, create a restaurant model from cart items
        // In reality, you'd track which restaurant the cart belongs to
        final restaurant = _createRestaurantFromCartItems(cartState.items);

        context.read<OrderBloc>().add(
          PlaceOrder(
            userId: authState.userId,
            restaurant: restaurant,
            cartItems: cartState.items,
            subtotal: cartState.subtotal,
            deliveryFee: cartState.deliveryFee,
            total: cartState.total,
            deliveryAddress: '123 Main St, City, State', // In real app, get from user
          ),
        );
      }
    }
  }

  // Helper method to create restaurant from cart items
  RestaurantModel _createRestaurantFromCartItems(List<CartItemModel> items) {
    // This is a workaround - in a real app, you'd store restaurant info with cart
    return RestaurantModel(
      id: '1',
      name: 'Restaurant',
      image: '',
      cuisine: 'Various',
      rating: 4.0,
      deliveryTime: 30,
      deliveryFee: 2.99,
      categories: [],
    );
  }

  // Other methods remain the same...
  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Add some delicious food to get started',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop,
            icon: Icon(Icons.restaurant_menu),
            label: Text('Browse Restaurants'),
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
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Error loading cart',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(message),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clear Cart'),
          content: Text('Are you sure you want to remove all items from your cart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<CartBloc>().add(ClearCart());
              },
              child: Text('Clear', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
