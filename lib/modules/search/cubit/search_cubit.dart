import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/search_model/search_model.dart';
import 'package:shop_app/modules/search/cubit/search_states.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remot/dio_helper.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? searchModel;

  void search({required String text}) {
    if (token != null) {
      emit(SearchLoadingState());

      DioHelper.postData(
        url: PRODUCT_SEARCH,
        token: token!,
        data: {
          'text': text,
        },
      ).then((value) {
        searchModel = SearchModel.fromJson(value.data);
        emit(SearchSuccessState());
        print(searchModel!.data!.data.length);
      }).catchError((error) {
        print(error.toString());
        emit(SearchErrorState(error.toString()));
      });
    }
  }
}
