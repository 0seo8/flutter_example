import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'di/di.dart';
import 'presentation/blocs/random_advice/random_advice_cubit.dart';
import 'presentation/pages/random_advice_page.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Injectable Primer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: BlocProvider(
        create: (context) => getIt<RandomAdviceCubit>(),
        child: const RandomAdvicePage(),
      ),
    );
  }
}
