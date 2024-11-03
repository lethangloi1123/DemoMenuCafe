import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shop_cafe/services/auth_service.dart';

class MenuCafe extends StatefulWidget {
  const MenuCafe({super.key});

  @override
  State<MenuCafe> createState() => _MenuCafeState();
}

class _MenuCafeState extends State<MenuCafe> {
  List<dynamic> drinks = [];
  List<dynamic> filteredDrinks = []; // Danh sách lọc để hiển thị kết quả tìm kiếm
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDrinks(); // Gọi API khi màn hình được khởi tạo
    searchController.addListener(_filterDrinks); // Lắng nghe thay đổi trong thanh tìm kiếm
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchDrinks() async {
    final url = Uri.parse('http://10.0.2.2:5296/api/drinks');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          drinks = json.decode(response.body);
          filteredDrinks = drinks; // Hiển thị tất cả thức uống ban đầu
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load drinks');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterDrinks() {
    final query = searchController.text.toLowerCase();
    setState(() {
      // Lọc danh sách `drinks` dựa trên từ khóa trong `query`
      filteredDrinks = drinks.where((drink) {
        final name = drink['name'].toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu Cafe"),
        backgroundColor: Colors.brown,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Tìm kiếm thức uống...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: filteredDrinks.isEmpty
                      ? const Center(child: Text('Không có thức uống nào.'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: filteredDrinks.length,
                          itemBuilder: (context, index) {
                            final drink = filteredDrinks[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: _buildDrinkItem(
                                drink['name'],
                                drink['description'],
                                drink['price'].toDouble(),
                                drink['imageURL'],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildDrinkItem(
      String name, String description, double price, String imageUrl) {
    int quantity = 0;

    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: SizedBox(
                height: 150,
                width: double.infinity,
                child: Image.network(
                  imageUrl.replaceFirst('localhost', '10.0.2.2'),
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      size: 100,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${price.toStringAsFixed(0)} VND',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        if (quantity > 0) setState(() => quantity--);
                      },
                    ),
                    Text('$quantity', style: const TextStyle(fontSize: 16)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => setState(() => quantity++),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
