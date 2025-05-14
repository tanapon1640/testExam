class VerificationModel {
  final String expectedCode;

  VerificationModel({this.expectedCode = '0011'});

  bool verifyCode(String enteredCode) {
    return enteredCode == expectedCode;
  }
}
