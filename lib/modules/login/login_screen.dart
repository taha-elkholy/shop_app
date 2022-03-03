import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_layout/shop_layout.dart';
import 'package:shop_app/modules/login/login_cubit/login_cubit.dart';
import 'package:shop_app/modules/login/login_cubit/login_states.dart';
import 'package:shop_app/modules/register/register_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/cubit/shop_cubit.dart';
import 'package:shop_app/shared/network/local/cash_helper.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // start BlocProvider of LoginCubit here
      // as we do not need it in any where
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
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
        // get the user model
        builder: (context, state) {
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
                          'LOGIN',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          'login now to brows our hot offer',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 30,
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
                            controller: _passwordController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your password';
                              }
                            },
                            onSubmit: (value) {
                              if (formKey.currentState!.validate()) {
                                LoginCubit.get(context).userLogin(
                                    email: _emailController.text,
                                    password: _passwordController.text);
                              }
                            },
                            inputType: TextInputType.visiblePassword,
                            label: 'Password',
                            prefix: Icons.lock_open_rounded,
                            isPassword: LoginCubit.get(context).isPassword,
                            suffix: LoginCubit.get(context).suffixIcon,
                            onSuffixPressed: () {
                              LoginCubit.get(context)
                                  .changePasswordVisibility();
                            }),
                        const SizedBox(
                          height: 30,
                        ),
                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          builder: (BuildContext context) => defaultButton(
                              text: 'login',
                              isUpperCase: true,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  LoginCubit.get(context).userLogin(
                                      email: _emailController.text,
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
                            const Text('Don\'t have account?'),
                            defaultTextButton(
                                text: 'register',
                                function: () {
                                  navigateTo(context, RegisterScreen());
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
