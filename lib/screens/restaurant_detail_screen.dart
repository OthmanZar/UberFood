import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projetc2/widgets/cart_grid.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../global/app_color.dart';
import '../global/app_text_style.dart';
import '../models/restaurents_model.dart';
import '../widgets/row_text_button.dart';
import '../widgets/space_widget.dart';
import '../widgets/text_widget.dart';
import '../models/Meal.dart';
import '../models/order.dart';

class RestaurantDetailScreen extends StatefulWidget {
  const RestaurantDetailScreen({Key? key}) : super(key: key);
  static const routeName = "/RestaurantDetailScreen";
  static MealModel categoryModel = MealModel();
  static OrderModel order = OrderModel();

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  final user = FirebaseAuth.instance.currentUser;
  // bool isLoading = true; // New variable to track loading state
  List<int> quantities = []; // List to store the quantities
  MealModel cat = MealModel();

  @override
  Widget build(BuildContext context) {
    final List<Object?> arguments =
        ModalRoute.of(context)!.settings.arguments as List<Object?>;
    final int restaurantId = arguments[0] as int;
    final int categoryId = arguments[1] as int;
    final int cityId = arguments[2] as int;
    final RestaurantModel restaurant = getRestaurantById(restaurantId);

    return Scaffold(
      body: FutureBuilder(
        future: RestaurantDetailScreen.categoryModel
            .fetchMealsData(restaurantId, categoryId),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final List<Meal> categories =
                RestaurantDetailScreen.categoryModel.meals;
            //isLoading = false;
            Iterable ite = RestaurantDetailScreen.order.ord1.keys;
            // Initialize the quantities list with default values
            quantities = List<int>.filled(categories.length, 0);

            if (restaurant.id != RestaurantDetailScreen.order.idResataurent) {
              // Clear the order if restaurantId is different
              RestaurantDetailScreen.order.ord.clear();
              RestaurantDetailScreen.order.ord1.clear();
              RestaurantDetailScreen.order.idResataurent = restaurantId;
            }

            if (ite.isNotEmpty) {
              for (int i = 0; i < categories.length; i++) {
                quantities[i] =
                    RestaurantDetailScreen.order.ord[categories[i].id] ?? 0;
              }
            }
            RestaurantDetailScreen.order.restcity = restaurant.idrestCity;
            RestaurantDetailScreen.order.idResataurent = restaurantId;
            RestaurantDetailScreen.order.idCity = cityId;
            //  RestaurantDetailScreen.order.idCategory = categoryId;
            RestaurantDetailScreen.order.meal
                .add(RestaurantDetailScreen.categoryModel);

            CartGrid.cart = RestaurantDetailScreen.order.ord1;
            print(CartGrid.cart.length);
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: greenColor1,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  pinned: true,
                  expandedHeight: 36.h,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: Hero(
                          tag: restaurantId,
                          child: Image.network(
                            restaurant.image,
                            fit: BoxFit.cover,
                            colorBlendMode: BlendMode.darken,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -6,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 7.h,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Text(
                              "Popular",
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  color: greenColor1,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.star,
                                  color: greenColor1,
                                  size: 30,
                                ))
                          ],
                        ),
                      ),
                      TextWidget(text: restaurant.name, textStyle: textStyle1),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: greenColor1,
                            size: 30,
                          ),
                          Text(restaurant.street)
                        ],
                      ),
                      const SpaceWidget(),
                      RowTextBtn(text: "Meals", onPressed: () {}),
                      const SpaceWidget(),
                      if (categories.isNotEmpty)
                        SizedBox(
                          height: 28.h,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (ctx, i) {
                              final category = categories[i];
                              int quantity = quantities[
                                  i]; // Retrieve the quantity for the current item
                              return SizedBox(
                                height: 28.h,
                                width: 45.w,
                                child: InkWell(
                                  onTap: () {},
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.network(
                                            category.image,
                                            fit: BoxFit.cover,
                                          ),
                                          const SpaceWidget(),
                                          Column(
                                            children: [
                                              TextWidget(
                                                text: category.name,
                                                textStyle: textStyle2,
                                              ),
                                              TextWidget(
                                                text: "${category.price}",
                                                textStyle: textStyle4,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                icon: RestaurantDetailScreen
                                                        .order.ord.keys
                                                        .contains(
                                                            categories[i].id)
                                                    ? const Icon(
                                                        Icons.check,
                                                        color: redColor1,
                                                      )
                                                    : const Icon(
                                                        Icons
                                                            .add_shopping_cart_sharp,
                                                        color: greenColor1,
                                                      ),
                                                onPressed: RestaurantDetailScreen
                                                        .order.ord.keys
                                                        .contains(
                                                            categories[i].id)
                                                    ? null // Disable the button if meal is already in cart
                                                    : () {
                                                        setState(() {
                                                          if (!RestaurantDetailScreen
                                                              .order.ord.keys
                                                              .contains(
                                                                  categories[i]
                                                                      .id)) {
                                                            RestaurantDetailScreen
                                                                    .order.ord1[
                                                                categories[
                                                                    i]] = 1;
                                                            RestaurantDetailScreen
                                                                    .order.ord[
                                                                categories[i]
                                                                    .id] = 1;
                                                          } else {
                                                            RestaurantDetailScreen
                                                                .order.ord1
                                                                .remove(
                                                                    categories[
                                                                        i]);
                                                            RestaurantDetailScreen
                                                                .order.ord
                                                                .remove(
                                                                    categories[
                                                                            i]
                                                                        .id);
                                                          }
                                                        });
                                                      },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      else
                        Center(
                          child: Text('No Meal in restaurant yet'),
                        ),
                      SizedBox(
                        height: 200.h,
                      )
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
