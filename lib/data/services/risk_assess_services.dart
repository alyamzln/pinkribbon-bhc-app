import 'package:pinkribbonbhc/data/repositories/risk_assessment/risk_assess_repositories.dart';
import 'package:pinkribbonbhc/features/risk-assessment/models/risk_assess_model.dart';

class RiskAssessmentService {
  final RiskAssessmentRepository _repository = RiskAssessmentRepository();

  Future<RiskAssessment?> getRiskAssessment(String userID) async {
    return await _repository.fetchRiskAssessment(userID);
  }

  Future<String> saveRiskAssessment(String userID, double totalScore) async {
    return await _repository.createOrUpdateRiskAssessment(userID, totalScore);
  }

  Future<void> saveResponse(String assessmentID, String questionID,
      String response, double score) async {
    await _repository.saveAssessmentResponse(
        assessmentID, questionID, response, score);
  }
}
