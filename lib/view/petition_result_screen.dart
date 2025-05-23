import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smart_petition_app/cubit/petition_cubit.dart';
import 'package:smart_petition_app/utils/app_colors.dart';

class PetitionResultScreen extends StatelessWidget {
  final String petitionText;

  const PetitionResultScreen({super.key, required this.petitionText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oluşturulan Dilekçe'),
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppColors.white,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'pdf',
            backgroundColor: AppColors.green,
            foregroundColor: AppColors.white,
            onPressed:
                () => context.read<PetitionCubit>().exportPDF(petitionText),
            child: const Icon(Icons.picture_as_pdf_outlined),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'share',
            backgroundColor: AppColors.green,
            foregroundColor: AppColors.white,
            onPressed: () => Share.share(petitionText),
            child: const Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            petitionText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
