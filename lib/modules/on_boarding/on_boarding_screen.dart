import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/cubit/shop_cubit.dart';
import 'package:shop_app/shared/cubit/shop_states.dart';
import 'package:shop_app/shared/network/local/cash_helper.dart';
import 'package:shop_app/shared/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({required this.image, required this.title, required this.body});
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<BoardingModel> boarding = [
    BoardingModel(
        image: 'assets/images/onboarding_1.png',
        title: 'Screen Title 1',
        body: 'Screen Body 1'),
    BoardingModel(
        image: 'assets/images/onboarding_2.png',
        title: 'Screen Title 2',
        body: 'Screen Body 2'),
    BoardingModel(
        image: 'assets/images/onboarding_3.png',
        title: 'Screen Title 3',
        body: 'Screen Body 3'),
  ];

  var boardController = PageController();

  var _isLast = false;

  void submit() {
    CashHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if (value) {
        navigateAndFinish(
          context,
          LoginScreen(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              defaultTextButton(
                text: 'skip',
                function: submit,
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: boardController,
                    itemBuilder: (BuildContext context, int index) =>
                        buildBoardingItem(boarding[index]),
                    itemCount: boarding.length,
                    onPageChanged: (index) {
                      if (index == boarding.length - 1) {
                        setState(() {
                          _isLast = true;
                        });
                      } else {
                        setState(() {
                          _isLast = false;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    SmoothPageIndicator(
                      controller: boardController,
                      count: boarding.length,
                      effect: ExpandingDotsEffect(
                          dotColor: Colors.grey,
                          activeDotColor: defaultColor,
                          dotHeight: 10,
                          dotWidth: 10,
                          expansionFactor: 4,
                          spacing: 5),
                    ),
                    const Spacer(),
                    FloatingActionButton(
                      onPressed: () {
                        if (_isLast) {
                          submit();
                        } else {
                          boardController.nextPage(
                              duration: const Duration(milliseconds: 750),
                              curve: Curves.fastLinearToSlowEaseIn);
                        }
                      },
                      child: const Icon(Icons.arrow_forward),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image(
              image: AssetImage(model.image),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            model.title,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            model.body,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      );
}
