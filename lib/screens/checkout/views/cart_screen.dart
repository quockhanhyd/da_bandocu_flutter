import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/cart_model.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/service/views/cart_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final param = {"currentPage": 1, "pageSize": 20, "textSearch": ""};
  Future<List<CartModel>>? _carts;

  @override
  void initState() {
    super.initState();
    _loadCarts();
  }

  void _loadCarts() {
    setState(() {
      _carts = CartService().getList(param);
    });
  }

  void _deleteCart(int cartId) async {
    await CartService().deleteCart(cartId);
    _loadCarts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CartModel>>(
        future: _carts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No cart found'));
          } else {
            final carts = snapshot.data!;
            final total = carts.fold(
                0, (sum, item) => sum + (item.price! * item.quantity!));
            return Scaffold(
              appBar: AppBar(
                title: const Text('Giỏ hàng'),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),
              body: ListView.builder(
                itemCount: carts.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(defaultPadding / 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 248, 231, 177)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.only(left: defaultPadding / 2),
                          child: Image.network(
                            carts[index].imageUrl?.split(",")[0] ?? "",
                            width: 100,
                            height: 100,
                          ),
                        ),
                        const SizedBox(width: defaultPadding / 4),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              carts[index].productName ?? "",
                              style: const TextStyle(color: Colors.black),
                            ),
                            Text('Số lượng: ${carts[index].quantity}'),
                            Text(
                                '\$${carts[index].price! * carts[index].quantity!}')
                          ],
                        )),
                        Container(
                          padding:
                              const EdgeInsets.only(right: defaultPadding / 2),
                          child: TextButton(
                              onPressed: () {
                                _deleteCart(carts[index].cartId ?? 0);
                              },
                              child: const Text("Xóa")),
                        )
                      ],
                    ),
                  );
                },
              ),
              bottomNavigationBar: Container(
                color: const Color.fromARGB(255, 255, 245, 213),
                height: 80,
                child: Row(
                  children: [
                    const SizedBox(width: defaultPadding),
                    Expanded(
                        child: Text(
                      'Tổng tiền: \$$total',
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                    )),
                    TextButton(
                      onPressed: () async {
                        String orderCode = await CartService().order("1");
                        Navigator.pushNamed(context, ordersScreenRoute,
                            arguments: orderCode);
                      },
                      child: const Text("Đặt hàng",
                          style: TextStyle(
                              color: Color.fromARGB(255, 231, 34, 34),
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: defaultPadding),
                  ],
                ),
              ),
            );
          }
        });
  }
}
