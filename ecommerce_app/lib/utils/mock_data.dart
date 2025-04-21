import 'package:flutter_ecommerce/models/product.dart';

class MockData {
  static List<Product> products = [
    Product(
      id: 'p1',
      name: 'Premium Headphones',
      description: 'Wireless over-ear headphones with noise cancellation and premium sound quality. Comfortable for all-day wear with 30-hour battery life.',
      price: 299.99,
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      categories: ['Electronics', 'Audio'],
      rating: 4.8,
    ),
    Product(
      id: 'p2',
      name: 'Smart Watch',
      description: 'Track your fitness goals, receive notifications, and more with this elegant smartwatch. Water-resistant with a 5-day battery life.',
      price: 249.99,
      imageUrl: 'https://images.unsplash.com/photo-1546868871-7041f2a55e12?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1064&q=80',
      categories: ['Electronics', 'Wearables'],
      rating: 4.6,
    ),
    Product(
      id: 'p3',
      name: 'Leather Backpack',
      description: 'Handcrafted from premium leather with padded laptop compartment and multiple pockets for organization. Perfect for work or travel.',
      price: 179.99,
      imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1169&q=80',
      categories: ['Fashion', 'Bags'],
      rating: 4.9,
    ),
    Product(
      id: 'p4',
      name: 'Wireless Earbuds',
      description: 'True wireless earbuds with crystal clear sound, touch controls, and 24-hour battery life with charging case. IPX7 water resistance.',
      price: 129.99,
      imageUrl: 'https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      categories: ['Electronics', 'Audio'],
      rating: 4.5,
    ),
    Product(
      id: 'p5',
      name: 'Designer Sunglasses',
      description: 'Polarized UV protection lenses in a classic frame. Lightweight and durable with signature detailing on temples.',
      price: 159.99,
      imageUrl: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      categories: ['Fashion', 'Accessories'],
      rating: 4.7,
    ),
    Product(
      id: 'p6',
      name: 'Portable Speaker',
      description: 'Powerful sound in a compact, waterproof design. 20-hour battery life, built-in microphone for calls, and vibrant color options.',
      price: 89.99,
      imageUrl: 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      categories: ['Electronics', 'Audio'],
      rating: 4.4,
    ),
  ];
}