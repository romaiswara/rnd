import 'package:cubit/cubit.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit(int initialState) : super(0);

  void increment() => emit(state + 1);

  void decrement() => emit(state - 1);
}
