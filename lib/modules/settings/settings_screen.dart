import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/cubit/shop_cubit.dart';
import 'package:shop_app/shared/cubit/shop_states.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessUpdateUserDataState) {
          showToast(
              message: 'User information updated successfully',
              state: ToastStates.SUCCESS);
        } else if (state is ShopErrorUpdateUserDataState) {
          showToast(
              message: 'User information don\'t updated ',
              state: ToastStates.ERROR);
        }
      },
      builder: (context, state) {
        var model = ShopCubit.get(context).userDataModel;
        if (model != null) {
          _nameController.text = model.data!.name!;
          _emailController.text = model.data!.email!;
          _phoneController.text = model.data!.phone!;
        }
        return ConditionalBuilder(
          condition: model != null,
          builder: (context) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: NetworkImage(model!.data!.image!),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultTextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Name must not be empty';
                          }
                          return null;
                        },
                        inputType: TextInputType.text,
                        label: 'Name',
                        prefix: Icons.person_outline,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      defaultTextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email must not be empty';
                          }
                          return null;
                        },
                        inputType: TextInputType.emailAddress,
                        label: 'Email',
                        prefix: Icons.email_outlined,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      defaultTextFormField(
                        controller: _phoneController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Phone must not be empty';
                          }
                          return null;
                        },
                        inputType: TextInputType.phone,
                        label: 'Phone',
                        prefix: Icons.phone,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      defaultButton(
                        text: 'logout',
                        onPressed: () {
                          signOut(context);
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ConditionalBuilder(
                        condition: state is! ShopLoadingUpdateUserDataState,
                        builder: (BuildContext context) {
                          return defaultButton(
                            text: 'Update',
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                ShopCubit.get(context).updateUserData(
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  phone: _phoneController.text,
                                );
                              }
                            },
                          );
                        },
                        fallback: (BuildContext context) =>
                            const Center(child: CircularProgressIndicator()),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
