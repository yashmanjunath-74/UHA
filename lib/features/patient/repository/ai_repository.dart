import 'package:fpdart/fpdart.dart';
import '../../../core/failure.dart';
import '../../../core/type_defs.dart';

class AIRepository {
  /// Simulate an AI triage response
  FutureEither<Map<String, dynamic>> getTriageAnalysis(String symptoms) async {
    try {
      // simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock analysis logic
      if (symptoms.toLowerCase().contains('fever')) {
        return right({
          'diagnosis': 'Viral Fever / Flu',
          'specialist': 'General Physician',
          'severity': 'Moderate',
          'advice': 'Rest well and stay hydrated. Monitor your temperature.',
        });
      } else if (symptoms.toLowerCase().contains('chest pain')) {
        return right({
          'diagnosis': 'Possible Cardiac Issue',
          'specialist': 'Cardiologist',
          'severity': 'HIGH - EMERGENCY',
          'advice': 'Please visit the nearest emergency room immediately.',
        });
      }

      return right({
        'diagnosis': 'Analyzing symptoms...',
        'specialist': 'General Physician',
        'severity': 'Low',
        'advice': 'Consult a doctor if symptoms persist.',
      });
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
