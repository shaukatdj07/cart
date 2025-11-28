import 'package:cart/cart_model.dart';
import 'package:cart/cart_provider.dart';
import 'package:cart/cart_screen.dart';
import 'package:cart/db_helper.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  DBHelper? dbHelper = DBHelper();
  List<String> productName = [
    'Mango',
    'Banana',
    'Orange',
    'Grapes',
    'Apple',
    'Cherry',
    'Peach',
  ];

  List<String> productUnit = ['KG', 'Dozen', 'Dozen', 'KG', 'KG', 'KG', 'KG'];

  List<int> productPrice = [10, 20, 30, 40, 50, 60, 70];

  List<String> productImage = [
    'https://images.pexels.com/photos/31757889/pexels-photo-31757889.jpeg', //Mango
    'https://images.pexels.com/photos/1093038/pexels-photo-1093038.jpeg', //Banana
    'https://images.pexels.com/photos/2294477/pexels-photo-2294477.jpeg', //Orange
    'https://images.pexels.com/photos/18207286/pexels-photo-18207286.jpeg', //Grapes
    'https://images.pexels.com/photos/1131079/pexels-photo-1131079.jpeg', //Apple
    'https://images.pexels.com/photos/966416/pexels-photo-966416.jpeg', //Cherry
    'https://images.pexels.com/photos/6157032/pexels-photo-6157032.jpeg', //Peach
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> CartScreen()));
            },
            child: Center(
              child: Badge(
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value, child) {
                    return Text(value.getCounter().toString(), style: TextStyle(color: Colors.white));
                  },
                ),
                child: Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
          SizedBox(width: 20),
        ],
        centerTitle: true,
        title: Text('Product List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: productName.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image(
                              height: 100,
                              width: 100,
                              image: NetworkImage(
                                productImage[index].toString(),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productName[index].toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(productUnit[index].toString() + " " + r"$" +
                                        productPrice[index].toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap: () {
                                        dbHelper!
                                            .insert(
                                              Cart(
                                                id: index,
                                                productId: index.toString(),
                                                productName: productName[index]
                                                    .toString(),
                                                initialPrice:
                                                    productPrice[index],
                                                productPrice:
                                                    productPrice[index],
                                                quantity: 1,
                                                unitTag: productUnit[index]
                                                    .toString(),
                                                image: productImage[index]
                                                    .toString(),
                                              ),
                                            )
                                            .then((value) {
                                              print('Product is added to cart');
                                              cart.addTotalPrice(
                                                double.parse(
                                                  productPrice[index]
                                                      .toString(),
                                                ),
                                              );
                                              cart.addCounter();
                                            })
                                            .onError((error, stackTrace) {
                                              print(error.toString());
                                            });
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Add To Cart',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



