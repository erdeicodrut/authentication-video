import 'package:auth_app/common/http_helper.dart';
import 'package:auth_app/features/authentication/index.dart';
import 'package:auth_app/features/names/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  initDio();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc(AuthService())),
        BlocProvider<NamesBloc>(create: (context) => NamesBloc(NamesService())),
      ],
      child: MaterialApp(
        title: 'Authentication app',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/names': (context) => NamesScreen(),
        },
      ),
    );
  }
}
