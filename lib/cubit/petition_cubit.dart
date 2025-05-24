import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:smart_petition_app/cubit/petition_state.dart';
import 'package:smart_petition_app/view/petition_result_screen.dart';

class PetitionCubit extends Cubit<PetitionState> {
  PetitionCubit() : super(PetitionInitial());

  final model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
  );

  void generatePetition({
    required String topic,
    required String details,
    required String fullName,
    required String address,
    required String phone,
    required String tc,
    required BuildContext context,
  }) async {
    emit(PetitionLoading());

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Dilekçe oluşturuluyor...',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
    );

    final now = DateFormat('dd.MM.yyyy').format(DateTime.now());

    final prompt = '''
Aşağıdaki bilgileri kullanarak resmi bir dilekçe oluştur:
- Konu: $topic
- Açıklama: $details
- Ad Soyad: $fullName
- TC Kimlik No: $tc
- Adres: $address
- Telefon: $phone (isteğe bağlı)

Dilekçe Türkçe, resmi ve kısa olmalı. Hazır çıktıya uygun olmalı ve kullanıcıya tekrar doldurtulacak alanlar (örneğin [Adınız Soyadınız]) veya ** gibi işaretler içermemeli. 
''';

    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      final body = response.text ?? '';

      final fullPetition = '''
Şehitkamil Belediyesi
Şehitkamil Belediye Başkanlığına

Sanayi Mahallesi 60725 Nolu Cad. No:34

Tarih: $now

Konu: $topic

$body

''';

      emit(PetitionGenerated(fullPetition));

      if (context.mounted) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PetitionResultScreen(petitionText: fullPetition),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Dilekçe oluşturulurken bir hata oluştu. Lütfen tekrar deneyin.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      emit(PetitionInitial());
    }
  }

  void exportPDF(String text) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (pw.Context context) => pw.Text(text)));
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
