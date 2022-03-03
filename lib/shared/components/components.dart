import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/shared/cubit/shop_cubit.dart';
import 'package:shop_app/shared/styles/colors.dart';

void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
    // save the last route or note
    (route) => false); // remove all last route

Widget defaultTextFormField({
  required TextEditingController controller,
  required String? Function(String? value) validator,
  required TextInputType inputType,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function()? onSuffixPressed,
  Function()? onTap,
  Function(String s)? onChanged,
  Function(String s)? onSubmit,
  bool isPassword = false,
  TextCapitalization textCapitalization = TextCapitalization.none,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: inputType,
      cursorColor: defaultColor,
      obscureText: isPassword,
      onTap: onTap,
      onChanged: onChanged,
      onFieldSubmitted: onSubmit,
      textCapitalization: textCapitalization,
      style: TextStyle(color: defaultColor),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: IconButton(icon: Icon(suffix), onPressed: onSuffixPressed),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: defaultColor),
        ),
      ),
      validator: validator,
    );

Widget defaultButton({
  double width = double.infinity, // giv it default width but can edit later
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 5.0,
  required String text,
  required Function()? onPressed,
}) =>
    Container(
      width: width,
      height: 40,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: MaterialButton(
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: onPressed,
      ),
    );

Widget defaultTextButton(
        {required Function() function, required String text}) =>
    TextButton(
      onPressed: function,
      child: Text(text.toUpperCase()),
    );

// Show toast depends on the state of the operation
void showToast({required String message, required ToastStates state}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: choseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0);
}

enum ToastStates { SUCCESS, ERROR, WARNING }

// get hte color of the toast depend on the state
// success, error and warning
Color choseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(start: 20),
      child: Container(
        color: Colors.grey,
        height: 1,
        width: double.infinity,
      ),
    );

Widget buildProductListItem(context, model, {isNullOldPrice = true}) =>
    Container(
      padding: const EdgeInsets.all(20),
      height: 125,
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                image: NetworkImage(model.image!),
                width: 125,
                height: 125,
              ),
              if (model.discount != 0 && isNullOldPrice)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  color: Colors.red,
                  child: const Text(
                    'DISCOUNT',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                )
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      '${model.price}',
                      style: TextStyle(fontSize: 12, color: defaultColor),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    if (model.discount != 0 && isNullOldPrice)
                      Text(
                        '${model.oldPrice}',
                        style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough),
                      ),
                    const Spacer(),
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: CircleAvatar(
                        backgroundColor:
                            ShopCubit.get(context).inFavorites[model.id]!
                                ? defaultColor
                                : Colors.grey,
                        radius: 15,
                        child: const Icon(
                          Icons.favorite_outline,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                      onPressed: () {
                        // do same thing here also
                        ShopCubit.get(context).changeFavorites(model.id!);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );