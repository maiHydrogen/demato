import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/restaurant_model.dart';
import '../../bloc/cart/cart_bloc.dart';
import '../../bloc/menu/menu_bloc.dart';
import '../../widgets/menu_item_widget.dart';
import '../cart/cart_page.dart';

class RestaurantDetailPage extends StatefulWidget {
  final RestaurantModel restaurant;

  const RestaurantDetailPage({super.key, required this.restaurant});

  @override
  RestaurantDetailPageState createState() => RestaurantDetailPageState();
}

class RestaurantDetailPageState extends State<RestaurantDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<MenuBloc>().add(LoadMenu(restaurantId: widget.restaurant.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            actions: [
              BlocBuilder<CartBloc, CartState>(
                builder: (context, cartState) {
                  int itemCount = 0;
                  if (cartState is CartLoaded) {
                    itemCount = cartState.items.fold<int>(
                        0, (sum, item) => sum + item.quantity
                    );
                  }

                  return Stack(
                    children: [
                      IconButton(
                        icon: Icon(Icons.shopping_cart),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CartPage()),
                          );
                        },
                      ),
                      if (itemCount > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '$itemCount',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.restaurant.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              background: Container(
                color: Colors.grey[300],
                child: widget.restaurant.image.startsWith('http')
                    ? Image.network(
                  widget.restaurant.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholderImage();
                  },
                )
                    : _buildPlaceholderImage(),
              ),
            ),
          ),

          // Restaurant Info
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating and Delivery Info
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text(
                              '${widget.restaurant.rating}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text('${widget.restaurant.deliveryTime} mins'),
                      SizedBox(width: 16),
                      Icon(Icons.delivery_dining, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text('\$${widget.restaurant.deliveryFee.toStringAsFixed(2)}'),
                    ],
                  ),

                  SizedBox(height: 12),

                  // Cuisine
                  Text(
                    widget.restaurant.cuisine,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),

                  SizedBox(height: 16),

                  // Categories
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.restaurant.categories.map((category) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 24),

                  // Menu Header
                  Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Menu Items
          BlocBuilder<MenuBloc, MenuState>(
            builder: (context, state) {
              if (state is MenuLoading) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(color: Colors.red),
                    ),
                  ),
                );
              } else if (state is MenuLoaded) {
                if (state.menuItems.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('No menu items available'),
                      ),
                    ),
                  );
                }

                // Group menu items by category
                Map<String, List<dynamic>> groupedItems = {};
                for (var item in state.menuItems) {
                  if (!groupedItems.containsKey(item.category)) {
                    groupedItems[item.category] = [];
                  }
                  groupedItems[item.category]!.add(item);
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final categories = groupedItems.keys.toList();
                      final category = categories[index];
                      final items = groupedItems[category]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category Header
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text(
                              category,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),

                          // Category Items
                          ...items.map((menuItem) {
                            return MenuItemWidget(
                              menuItem: menuItem,
                              onAddToCart: (quantity) {
                                context.read<CartBloc>().add(
                                  AddToCart(
                                    menuItem: menuItem,
                                    quantity: quantity,
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${menuItem.name} added to cart'),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                            );
                          }).toList(),

                          SizedBox(height: 16),
                        ],
                      );
                    },
                    childCount: groupedItems.keys.length,
                  ),
                );
              } else if (state is MenuError) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(Icons.error_outline, size: 64, color: Colors.red),
                          SizedBox(height: 16),
                          Text('Error loading menu'),
                          SizedBox(height: 8),
                          Text(state.message),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant, size: 50, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            widget.restaurant.name,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
