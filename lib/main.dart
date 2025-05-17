import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_petition_app/app_colors.dart';
import 'package:smart_petition_app/cubit/petition_cubit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_petition_app/view/petition_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Error loading .env file: $e");
    dotenv.testLoad(fileInput: '');
  }

  runApp(const PetitionApp());
}

class PetitionApp extends StatelessWidget {
  const PetitionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Petition',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorSchemeSeed: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: BlocProvider(
        create: (_) => PetitionCubit(),
        child: const PetitionScreen(),
      ),
    );
  }
}
