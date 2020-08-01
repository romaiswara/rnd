import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:rndroma/bloc_vs_cubit/counter_bloc.dart';
import 'package:rndroma/bloc_vs_cubit/counter_cubit.dart';

class BlocCubitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: BlocProvider<CounterBloc>(
              create: (context) => CounterBloc(0),
              child: CounterBlocPage(),
            ),
          ),
          Flexible(
            flex: 1,
            child: CubitProvider<CounterCubit>(
              create: (context) => CounterCubit(0),
              child: CounterCubitPage(),
            ),
          ),
        ],
      ),
    );
  }
}

class CounterBlocPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterBloc, int>(
      builder: (context, count) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'BLOC: $count',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      context.bloc<CounterBloc>().add(CounterEvent.increment);
                    },
                    color: Colors.blue,
                    child: Text(
                      '+',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      context.bloc<CounterBloc>().add(CounterEvent.decrement);
                    },
                    color: Colors.red,
                    child: Text(
                      '-',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class CounterCubitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CubitBuilder<CounterCubit, int>(
      builder: (context, count) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'CUBIT: $count',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      context.cubit<CounterCubit>().increment();
                    },
                    color: Colors.blue,
                    child: Text(
                      '+',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      context.cubit<CounterCubit>().decrement();
                    },
                    color: Colors.red,
                    child: Text(
                      '-',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

