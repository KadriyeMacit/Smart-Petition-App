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
    final output = '''
Şehitkamil Belediyesi
Şehitkamil Belediye Başkanlığına

Sanayi Mahallesi 60725 Nolu Cad. No:34

Mahallemizde $details nedeniyle aşağıdaki dilekçeyi sunuyoruz:

Sayın Yetkili,

$topic ile ilgili olarak yaşanan sorunlardan dolayı mahalle sakinleri olarak mağduriyet yaşamaktayız. Bu durumun çözülmesi adına gerekli işlemlerin yapılmasını arz ederiz.

Gereğini arz ederiz.

Tarih: $now

Adınız Soyadınız: $fullName
Adresiniz: $address
Telefon Numaranız: $phone
İmza:
''';

    emit(PetitionGenerated(output));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PetitionResultScreen(petitionText: output),
      ),
    );
  }

  void exportPDF(String text) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (pw.Context context) => pw.Text(text)));
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
