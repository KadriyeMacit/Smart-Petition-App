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
    required BuildContext context,
  }) async {
    emit(PetitionLoading());

    final now = DateFormat('dd.MM.yyyy').format(DateTime.now());

    final prompt = '''
Kullanıcı aşağıdaki konuda belediyeye iletmek üzere resmi bir dilekçe yazmak istiyor.

Konu: $topic
Açıklama: $details

Lütfen Türkçe, resmi ve kısa bir dilekçe metni oluştur. Hitap şekliyle başlasın ve sonunda saygı ifadeleri, tarih ve iletişim bilgileri bulunsun.
''';

    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      final body = response.text ?? '';

      final fullPetition = '''
Şehitkamil Belediyesi
Şehitkamil Belediye Başkanlığına

Sanayi Mahallesi 60725 Nolu Cad. No:34

$body

Tarih: $now

Adınız Soyadınız: $fullName
Adresiniz: $address
Telefon Numaranız: $phone
İmza:
''';

      emit(PetitionGenerated(fullPetition));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PetitionResultScreen(petitionText: fullPetition),
        ),
      );
    } catch (e) {
      emit(PetitionGenerated('Hata oluştu: $e'));
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
