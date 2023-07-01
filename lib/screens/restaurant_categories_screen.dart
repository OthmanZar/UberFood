import 'package:flutter/material.dart';
import 'package:projetc2/models/categories.dart';
import 'package:projetc2/screens/restaurant_detail_screen.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../global/app_color.dart';
import '../global/app_text_style.dart';

import '../models/restaurents_model.dart';

import '../widgets/row_text_button.dart';
import '../widgets/space_widget.dart';
import '../widgets/text_widget.dart';

class RestaurantCategoriescreen extends StatelessWidget {
  const RestaurantCategoriescreen({Key? key}) : super(key: key);
  static const routeName = "/RestaurantCategoriescreen";
  static CategoryModel categoryModel = CategoryModel();
  @override
  Widget build(BuildContext context) {
    final List<Object?> arguments =
        ModalRoute.of(context)!.settings.arguments as List<Object?>;
    final int restaurantId = arguments[0] as int;
    final int cityId = arguments[1] as int;
    // final provider = Provider.of<Restaurants>(context);
    final RestaurantModel restaurant = getRestaurantById(restaurantId);

    return Scaffold(
      body: FutureBuilder(
        future: categoryModel.fetchCategoriesData(),
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
            final List<Category> categories = categoryModel.categories;

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
                      //
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
                            //    const Icon(
                            //    Icons.location_on,
                            //  color: greenColor1,
                            //size: 30,
                            //),
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
                      RowTextBtn(text: "Categories", onPressed: () {}),
                      const SpaceWidget(),
                      // MenuGrid(menu: restaurant.menu),
                      SizedBox(
                        height: 28.h,
                        child: categories.isEmpty
                            ? const Center(
                                child: Text("No Category in restaurant yet"),
                              )
                            : ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: categories.length,
                                itemBuilder: (ctx, i) {
                                  final category = categories[i];
                                  return SizedBox(
                                    height: 28.h,
                                    width: 45.w,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          RestaurantDetailScreen.routeName,
                                          arguments: [
                                            restaurant.id,
                                            categories[i].id,
                                            cityId
                                          ],
                                        );
                                      },
                                      child: Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              width:
                                                  150, // Specify the desired width
                                              height:
                                                  150, // Specify the desired height
                                              child: Image.network(
                                                restaurant.image,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SpaceWidget(),
                                            FittedBox(
                                              child: Text(
                                                category.name,
                                                style: textStyle2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
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
