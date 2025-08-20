

import '../../model/cart_item_model.dart';
import '../../model/menu_item_model.dart';
import '../../model/order_model.dart';
import '../../model/restaurant_model.dart';

class MockDataSource {
  static List<RestaurantModel> getRestaurants() {
    return [
      RestaurantModel(
        id: '1',
        name: 'Pizza Palace',
        image: 'https://via.placeholder.com/300x200?text=Pizza+Palace',
        cuisine: 'Italian',
        rating: 4.5,
        deliveryTime: 30,
        deliveryFee: 2.99,
        categories: ['Pizza', 'Pasta', 'Desserts'],
      ),
      RestaurantModel(
        id: '2',
        name: 'Burger Barn',
        image: 'https://via.placeholder.com/300x200?text=Burger+Barn',
        cuisine: 'American',
        rating: 4.2,
        deliveryTime: 25,
        deliveryFee: 1.99,
        categories: ['Burgers', 'Fries', 'Shakes'],
      ),
      RestaurantModel(
        id: '3',
        name: 'Sushi Star',
        image: 'https://via.placeholder.com/300x200?text=Sushi+Star',
        cuisine: 'Japanese',
        rating: 4.8,
        deliveryTime: 45,
        deliveryFee: 3.99,
        categories: ['Sushi', 'Ramen', 'Appetizers'],
      ),
      RestaurantModel(
        id: '4',
        name: 'Indian Spice',
        image: 'https://via.placeholder.com/300x200?text=Indian+Spice',
        cuisine: 'Indian',
        rating: 4.3,
        deliveryTime: 35,
        deliveryFee: 2.49,
        categories: ['Curry', 'Biryani', 'Tandoor'],
      ),
      RestaurantModel(
        id: '5',
        name: 'Taco Town',
        image: 'https://via.placeholder.com/300x200?text=Taco+Town',
        cuisine: 'Mexican',
        rating: 4.1,
        deliveryTime: 20,
        deliveryFee: 1.49,
        categories: ['Tacos', 'Burritos', 'Quesadillas'],
      ),
    ];
  }

  static List<MenuItemModel> getMenuItems(String restaurantId) {
    switch (restaurantId) {
      case '1': // Pizza Palace
        return [
          MenuItemModel(
            id: '1',
            name: 'Margherita Pizza',
            description: 'Classic pizza with tomato sauce, mozzarella, and basil',
            price: 12.99,
            image: 'https://via.placeholder.com/200x150?text=Margherita',
            category: 'Pizza',
            isVeg: true,
          ),
          MenuItemModel(
            id: '2',
            name: 'Pepperoni Pizza',
            description: 'Pizza with pepperoni and mozzarella cheese',
            price: 14.99,
            image: 'https://via.placeholder.com/200x150?text=Pepperoni',
            category: 'Pizza',
            isVeg: false,
          ),
          MenuItemModel(
            id: '3',
            name: 'Chicken Alfredo Pasta',
            description: 'Creamy alfredo pasta with grilled chicken',
            price: 16.99,
            image: 'https://via.placeholder.com/200x150?text=Alfredo',
            category: 'Pasta',
            isVeg: false,
          ),
          MenuItemModel(
            id: '4',
            name: 'Tiramisu',
            description: 'Classic Italian dessert with coffee and mascarpone',
            price: 6.99,
            image: 'https://via.placeholder.com/200x150?text=Tiramisu',
            category: 'Desserts',
            isVeg: true,
          ),
        ];
      case '2': // Burger Barn
        return [
          MenuItemModel(
            id: '5',
            name: 'Classic Burger',
            description: 'Beef patty with lettuce, tomato, onion, and special sauce',
            price: 8.99,
            image: 'https://via.placeholder.com/200x150?text=Classic+Burger',
            category: 'Burgers',
            isVeg: false,
          ),
          MenuItemModel(
            id: '6',
            name: 'Veggie Burger',
            description: 'Plant-based patty with fresh vegetables',
            price: 9.99,
            image: 'https://via.placeholder.com/200x150?text=Veggie+Burger',
            category: 'Burgers',
            isVeg: true,
          ),
          MenuItemModel(
            id: '7',
            name: 'Loaded Fries',
            description: 'Crispy fries with cheese, bacon, and green onions',
            price: 5.99,
            image: 'https://via.placeholder.com/200x150?text=Loaded+Fries',
            category: 'Fries',
            isVeg: false,
          ),
          MenuItemModel(
            id: '8',
            name: 'Chocolate Shake',
            description: 'Rich chocolate milkshake with whipped cream',
            price: 4.99,
            image: 'https://via.placeholder.com/200x150?text=Chocolate+Shake',
            category: 'Shakes',
            isVeg: true,
          ),
        ];
      case '3': // Sushi Star
        return [
          MenuItemModel(
            id: '9',
            name: 'California Roll',
            description: 'Crab, avocado, and cucumber roll',
            price: 7.99,
            image: 'https://via.placeholder.com/200x150?text=California+Roll',
            category: 'Sushi',
            isVeg: false,
          ),
          MenuItemModel(
            id: '10',
            name: 'Vegetable Roll',
            description: 'Fresh vegetables wrapped in nori',
            price: 6.99,
            image: 'https://via.placeholder.com/200x150?text=Veg+Roll',
            category: 'Sushi',
            isVeg: true,
          ),
        ];
      default:
        return [];
    }
  }

  static List<OrderModel> getMockOrders(String userId) {
    final restaurants = getRestaurants();
    final pizzaMenuItems = getMenuItems('1'); // Get Pizza Palace menu items
    final burgerMenuItems = getMenuItems('2'); // Get Burger Barn menu items

    return [
      OrderModel(
        id: 'order_1',
        userId: userId,
        restaurant: restaurants[0], // Pizza Palace
        items: [
          CartItemModel.fromMenuItem(pizzaMenuItems as MenuItemModel, 2), // Margherita Pizza x2
          CartItemModel.fromMenuItem(pizzaMenuItems[1], 1), // Pepperoni Pizza x1
        ],
        subtotal: 40.97,
        deliveryFee: 2.99,
        total: 43.96,
        status: OrderStatus.delivered,
        createdAt: DateTime.now().subtract(Duration(days: 2)),
        deliveryAddress: '123 Main St, City, State',
      ),
      OrderModel(
        id: 'order_2',
        userId: userId,
        restaurant: restaurants[1], // Burger Barn
        items: [
          CartItemModel.fromMenuItem(burgerMenuItems as MenuItemModel, 1), // Classic Burger x1
        ],
        subtotal: 8.99,
        deliveryFee: 1.99,
        total: 10.98,
        status: OrderStatus.preparing,
        createdAt: DateTime.now().subtract(Duration(hours: 1)),
        deliveryAddress: '123 Main St, City, State',
      ),
    ];
  }
}
