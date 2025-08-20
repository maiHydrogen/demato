import 'package:demato/presentation/pages/restaurant/restaurant_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/cart/cart_bloc.dart';
import '../../bloc/restaurant/restaurant_list_bloc.dart';
import '../../widgets/restaurant_card.dart';
import '../../widgets/search_bar.dart';
import '../cart/cart_page.dart';
import '../history/order_history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load restaurants when page loads
    context.read<RestaurantListBloc>().add(LoadRestaurants());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mini Zomato'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          // Cart Icon with Badge
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
          // Profile Menu
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'orders':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderHistoryPage()),
                  );
                  break;
                case 'profile':
                  _showProfileDialog(context);
                  break;
                case 'logout':
                  _showLogoutDialog(context);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'orders',
                child: Row(
                  children: [
                    Icon(Icons.history, color: Colors.grey[700]),
                    SizedBox(width: 8),
                    Text('My Orders'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.grey[700]),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.grey[700]),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(16),
            child: SearchBarWidget(
              controller: _searchController,
              onChanged: (query) {
                context.read<RestaurantListBloc>().add(
                  SearchRestaurants(query: query),
                );
              },
            ),
          ),

          // Welcome Message
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              if (authState is AuthAuthenticated) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Hello ${authState.userName}! 👋',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),

          // Restaurant List
          Expanded(
            child: BlocBuilder<RestaurantListBloc, RestaurantListState>(
              builder: (context, state) {
                if (state is RestaurantListLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  );
                } else if (state is RestaurantListLoaded) {
                  if (state.filteredRestaurants.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    color: Colors.red,
                    onRefresh: () async {
                      context.read<RestaurantListBloc>().add(LoadRestaurants());
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: state.filteredRestaurants.length,
                      itemBuilder: (context, index) {
                        final restaurant = state.filteredRestaurants[index];
                        return RestaurantCard(
                          restaurant: restaurant,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RestaurantDetailPage(
                                  restaurant: restaurant,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                } else if (state is RestaurantListError) {
                  return _buildErrorState(state.message);
                }

                return Center(
                  child: Text('Welcome! Pull to refresh to load restaurants.'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No restaurants found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try searching for something else',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
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
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[300],
          ),
          SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<RestaurantListBloc>().add(LoadRestaurants());
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

  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is AuthAuthenticated) {
              return AlertDialog(
                title: Text('Profile'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${authState.userName}'),
                    SizedBox(height: 8),
                    Text('User ID: ${authState.userId}'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Close'),
                  ),
                ],
              );
            }
            return SizedBox.shrink();
          },
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(LogoutRequested());
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
