import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:smart_petition_app/cubit/petition_state.dart';

class PetitionCubit extends Cubit<PetitionState> {
  PetitionCubit() : super(PetitionInitial());

  final model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
  );

  void generatePetition(String topic, String details) async {
    emit(PetitionLoading());

    final prompt = '''
Kullanıcı aşağıdaki konuda belediyeye iletmek üzere resmi bir dilekçe yazmak istiyor.

Konu: $topic  
Açıklama: $details

Lütfen Türkçe, resmi ve kısa bir dilekçe metni oluştur.
''';

    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      final output = response.text ?? 'Dilekçe oluşturulamadı.';

      emit(PetitionGenerated(output));
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
