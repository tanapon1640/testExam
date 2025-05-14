import '../model/verification_model.dart';

class VerificationController {
  final VerificationModel _model = VerificationModel();
  
  bool verifyCode(String code) {
    return _model.verifyCode(code);
  }
}