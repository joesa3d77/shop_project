import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/models/product_model.dart';
import '../../../core/utils/json_list_parser.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final ApiClient apiClient;
  SearchCubit(this.apiClient) : super(SearchInitial());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }
    emit(SearchLoading());
    try {
      final response = await apiClient.get(ApiConstants.productsSearch, query: {'q': query});
      final list = parseJsonList(response.data);
      emit(SearchLoaded(list.map((e) => ProductModel.fromJson(e)).toList()));
    } catch (e) {
      emit(const SearchError('try again'));
    }
  }
}
