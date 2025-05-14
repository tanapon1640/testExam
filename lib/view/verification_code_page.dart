import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectofsgn/view/main_page.dart';
import '../controller/verification_controller.dart';
import '../controller/session_controller.dart';

class VerificationCodePage extends StatefulWidget {
  final String email;

  const VerificationCodePage({super.key, this.email = 'user@example.com'});

  @override
  VerificationCodePageState createState() => VerificationCodePageState();
}

class VerificationCodePageState extends State<VerificationCodePage> {
  final List<TextEditingController> _codeControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  final VerificationController _verificationController =
      VerificationController();
  final SessionController _sessionController = SessionController();
  bool _isFormFilled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    for (var controller in _codeControllers) {
      controller.addListener(checkFormFilled);
    }
  }

  @override
  void dispose() {
    for (var i = 0; i < 4; i++) {
      _codeControllers[i].dispose();
      _focusNodes[i].dispose();
    }
    super.dispose();
  }

  void checkFormFilled() {
    bool allFilled = _codeControllers.every(
      (controller) => controller.text.isNotEmpty,
    );
    if (allFilled != _isFormFilled) {
      setState(() {
        _isFormFilled = allFilled;
      });
    }
  }

  void verifyCode() {
    if (!_isFormFilled) return;

    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration(seconds: 1), () {
      String enteredCode =
          _codeControllers.map((controller) => controller.text).join();

      if (_verificationController.verifyCode(enteredCode)) {
        _sessionController.startSession(
          context,
          username: widget.email.split('@')[0],
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification code incorrect. Please try again.'),
          ),
        );

        for (var controller in _codeControllers) {
          controller.clear();
        }

        FocusScope.of(context).requestFocus(_focusNodes[0]);
      }

      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30, top: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Verification',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.shade800,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 114,
                  height: 114,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromARGB(255, 236, 246, 250),
                  ),
                  child: Icon(Icons.mail_outline, size: 35),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Enter verification code',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            Text(
              'sent to your email',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  height: 60,
                  width: 45,
                  child: Center(
                    child: TextField(
                      controller: _codeControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      cursorColor: Colors.blue.shade800,
                      maxLength: 1,
                      cursorHeight: 35,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue.shade800,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: TextStyle(fontSize: 24),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          FocusScope.of(
                            context,
                          ).requestFocus(_focusNodes[index + 1]);
                        }
                      },
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 35),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _isFormFilled && !_isLoading ? verifyCode : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isFormFilled ? Colors.blue.shade800 : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                          'VERIFY',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
              ),
            ),

            TextButton(
              onPressed: () {},
              child: Text(
                'Resend Code',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
