import '../resources/data_state.dart';

abstract class NoParamUseCase<T> {
  Future<DataState<T>> call();
}

abstract class OneParamUseCase<T, P> {
  Future<DataState<T>> call(P param);
}

abstract class TwoParamsUseCase<T, P1, P2> {
  Future<DataState<T>> call(P1 param1, P2 param2);
}

abstract class TreeParamsUseCase<T, P1, P2, P3> {
  Future<DataState<T>> call(P1 param1, P2 param2, P3 param3);
}