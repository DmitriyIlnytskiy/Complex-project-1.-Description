import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/fuel_repository.dart';
import 'firebase_options.dart';

import 'data/repositories/auth_repository.dart';
import 'data/repositories/maintenance_repository.dart';
import 'logic/auth/auth_cubit.dart';
import 'logic/fuel/fuel_cubit.dart';
import 'logic/maintenance/maintenance_cubit.dart';
import 'presentation/screens/dashboard_screen.dart';
import 'presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const GearShiftApp());
}

class GearShiftApp extends StatelessWidget {
  const GearShiftApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate Repositories once
    final authRepository = AuthRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepository: authRepository),
        ),
      ],
      child: MaterialApp(
        title: 'GearShift',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          scaffoldBackgroundColor: Colors.grey.shade100,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF37474F),
            foregroundColor: Colors.white,
          ),
        ),
        // Listen to Auth State to decide which screen to show!
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<MaintenanceCubit>(
                    create: (context) => MaintenanceCubit(
                      repository: MaintenanceRepository(userId: state.userId),
                    ),
                  ),
                  BlocProvider<FuelCubit>(
                    create: (context) => FuelCubit(
                      repository: FuelRepository(userId: state.userId),
                    ),
                  ),
                ],
                child: const DashboardScreen(),
              );
            }
            // If Unauthenticated or Initial, show Login
            return const LoginScreen();
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
