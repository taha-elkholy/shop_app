import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/cubit/shop_cubit.dart';
import 'package:shop_app/shared/cubit/shop_states.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
            condition: ShopCubit.get(context).getFavoritesModel != null,
            builder: (context) =>
                (ShopCubit.get(context).getFavoritesModel!.data!.data.isEmpty)
                    ? const Center(
                        child: Text('No Favorites, add more'),
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => buildProductListItem(
                              context,
                              ShopCubit.get(context)
                                  .getFavoritesModel!
                                  .data!
                                  .data[index]
                                  .product,
                            ),
                        separatorBuilder: (context, index) => myDivider(),
                        itemCount: ShopCubit.get(context)
                            .getFavoritesModel!
                            .data!
                            .data
                            .length),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()));
      },
    );
  }

}
