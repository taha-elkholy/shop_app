import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_layout/shop_layout.dart';
import 'package:shop_app/modules/register/register_cubit/register_cubit.dart';
import 'package:shop_app/modules/register/register_cubit/register_states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/cubit/shop_cubit.dart';
import 'package:shop_app/shared/network/local/cash_helper.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            if (state.model.status == true) {
              showToast(
                message: '${state.model.message}',
                state: ToastStates.SUCCESS,
              );
              CashHelper.saveData(key: 'token', value: state.model.data!.token!)
                  .then((value) {
                // when success login, save the new value of token
                // immediately to prevent errors
                token = state.model.data!.token!;

                // make sure to get the data here
                // before navigate to home layout
                ShopCubit.get(context).getHomeData();
                ShopCubit.get(context).getCategoriesData();
                ShopCubit.get(context).getFavoritesData();
                ShopCubit.get(context).getUserData();

                navigateAndFinish(context, ShopLayout());
              });
            } else {
              showToast(
                message: '${state.model.message}',
                state: ToastStates.ERROR,
              );
            }
          }
        },
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REGISTER',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          'Register now to brows our hot offer',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        defaultTextFormField(
                            controller: _nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your name';
                              }
                            },
                            inputType: TextInputType.text,
                            label: 'User Name',
                            prefix: Icons.person,
                            textCapitalization: TextCapitalization.sentences),
                        const SizedBox(
                          height: 15,
                        ),
                        defaultTextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your email address';
                            }
                          },
                          inputType: TextInputType.emailAddress,
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        defaultTextFormField(
                          controller: _phoneController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your phone number';
                            }
                          },
                          inputType: TextInputType.phone,
                          label: 'Phone Number',
                          prefix: Icons.phone,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        defaultTextFormField(
                            controller: _passwordController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your password';
                              }
                            },
                            inputType: TextInputType.visiblePassword,
                            label: 'Password',
                            prefix: Icons.lock_open_rounded,
                            isPassword: cubit.isPassword,
                            suffix: cubit.suffixIcon,
                            onSuffixPressed: () {
                              cubit.changePasswordVisibility();
                            }),
                        const SizedBox(
                          height: 15,
                        ),
                        defaultTextFormField(
                            controller: _confirmPasswordController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please confirm your password';
                              } else if (value != _passwordController.text) {
                                return 'Password not match';
                              }
                            },
                            onSubmit: (value) {
                              if (formKey.currentState!.validate()) {
                                cubit.userRegister(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    phone: _phoneController.text,
                                    password: _passwordController.text);
                              }
                            },
                            inputType: TextInputType.visiblePassword,
                            label: 'Confirm Password',
                            prefix: Icons.lock_open_rounded,
                            isPassword: cubit.isPassword,
                            suffix: cubit.suffixIcon,
                            onSuffixPressed: () {
                              cubit.changePasswordVisibility();
                            }),
                        const SizedBox(
                          height: 30,
                        ),
                        ConditionalBuilder(
                          condition: state is! RegisterLoadingState,
                          builder: (BuildContext context) => defaultButton(
                              text: 'register',
                              isUpperCase: true,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  cubit.userRegister(
                                      name: _nameController.text,
                                      email: _emailController.text,
                                      phone: _phoneController.text,
                                      password: _passwordController.text);
                                }
                              }),
                          fallback: (BuildContext context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account?'),
                            defaultTextButton(
                                text: 'Login',
                                function: () {
                                  Navigator.pop(context);
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
