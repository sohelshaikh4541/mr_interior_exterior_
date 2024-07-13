import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:interior_v_1/api/apiServices.dart';
import 'package:interior_v_1/helper/bottom_nav_bar.dart';
import 'package:interior_v_1/helper/custome_colour.dart';
import 'package:interior_v_1/view/homepage/homepage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final FocusNode mobileFocusNode = FocusNode();

  String errorMessage = '';
  String errorOTP = '';

  final RegExp _mobileRegExp = RegExp(r'^[6-9]\d{9}$');
  bool otpVal = false;
  bool isLoading = false;
  String mobileNo = "";
  String otpNo = "";
  Map<String, dynamic> _response = {};
  String data = "";

  Future<void> _login(String mobileNo) async {
    StatesServices statesServices = StatesServices();
    Map<String, dynamic> response = await statesServices.postLogin(mobileNo);

    setState(() {
      print("Response===$response");
      _response = response;
      isLoading = false;
    });

    if (_response['status'] == true) {
      setState(() {
        otpVal = true;
      });
    } else {
      Fluttertoast.showToast(
          msg: _response['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  void initState() {
    super.initState();
    mobileFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    mobileController.dispose();
    otpController.dispose();
    mobileFocusNode.dispose();
    super.dispose();
  }

  void _handleProceed() async {
    setState(() {
      isLoading = true;
    });

    mobileNo = mobileController.text.trim();

    if (mobileNo.isNotEmpty) {
      if (_mobileRegExp.hasMatch(mobileNo)) {
        setState(() {
          errorMessage = '';
        });
        await _login(mobileNo);
      } else {
        setState(() {
          errorMessage = 'Please enter a valid 10-digit mobile number';
          isLoading = false;
        });
      }
    } else {
      setState(() {
        errorMessage = 'Please enter your mobile number';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double oneThirdHeight = screenHeight / 3;
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: oneThirdHeight,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/login.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              if (!otpVal)
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 30),
                  child: Text(
                    'Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1D1D25),
                      fontSize: 24,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ),
              if (!otpVal)
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 30),
                  child: Text(
                    'Happy to see you',
                    style: TextStyle(
                      color: Color(0xFF808D9E),
                      fontSize: 16,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                  ),
                ),
              SizedBox(
                height: 25,
              ),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 35),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 10),
                  ),
                ),
              SizedBox(
                height: 5,
              ),
              if (!otpVal)
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: w * 0.85,
                    height: 48,
                    padding: const EdgeInsets.only(
                        top: 0, left: 6, right: 85, bottom: 0),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 1,
                            color: mobileFocusNode.hasFocus
                                ? Colors.orange
                                : Color(0x4CFFA500)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.phone_android),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Center(
                            child: TextFormField(
                              controller: mobileController,
                              focusNode: mobileFocusNode,
                              style: TextStyle(fontSize: 17),
                              textAlign: TextAlign.justify,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Mobile Number',
                                hintStyle: TextStyle(fontSize: 17),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 12),
                              ),
                              maxLength: 10,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  errorMessage = '';
                                });
                              },
                              buildCounter: (BuildContext context,
                                      {int? currentLength,
                                      required bool isFocused,
                                      int? maxLength}) =>
                                  null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(
                height: 20,
              ),
              if (otpVal)
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Please enter otp we've sent you on \n +91-$mobileNo",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1D1D25),
                      fontSize: 16,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                ),
              SizedBox(
                height: 10,
              ),
              if (otpVal)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 6,
                    controller: otpController,
                    onChanged: (value) {
                      setState(() {
                        errorOTP = '';
                      });
                    },
                    onCompleted: (value) {
                      print('axolotls' + value);
                    },
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      inactiveFillColor: Colors.grey[300],
                      activeFillColor: Colors.white,
                    ),
                    textStyle: TextStyle(fontSize: 20),
                  ),
                ),
              if (errorOTP.isNotEmpty)
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    errorOTP,
                    style: TextStyle(color: Colors.red, fontSize: 10),
                  ),
                ),
              SizedBox(
                height: 20,
              ),
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(),
                ),
              if (!otpVal && !isLoading)
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 150,
                    height: 50,
                    child: TextButton(
                      onPressed: _handleProceed,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFFFFA500)),
                        overlayColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Color(0xFF2B9EBFF).withOpacity(0.2);
                          } else {
                            return Colors.transparent;
                          }
                        }),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                                color: CustomColors.yellowBorderColor,
                                width: 1),
                          ),
                        ),
                      ),
                      child: Text(
                        'Proceed',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                ),
              if (otpVal)
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 150,
                    height: 50,
                    child: TextButton(
                      onPressed: () async {
                        otpNo = otpController.text.trim();
                        if (otpNo.length == 6 && otpNo == _response['otp']) {
                          SharedPreferences sp =
                              await SharedPreferences.getInstance();
                          sp.setString('otp', _response['otp']);
                          sp.setString(
                              'userid', _response['user']['id'].toString());
                          sp.setString('name', _response['user']['name']);
                          sp.setString('mobile', _response['user']['mobile']);
                          sp.setString('email', _response['user']['email']);
                          sp.setString('gender', _response['user']['gender']);
                          sp.setString(
                              'usertype', _response['user']['usertype']);
                          sp.setString('address', _response['user']['address']);
                          sp.setString('city', _response['user']['city']);
                          sp.setString('state', _response['user']['state']);
                          sp.setString(
                              'pin_code', _response['user']['pin_code']);
                          sp.setString(
                              'profile_pic', _response['user']['profile_pic']);
                          sp.setBool('isLogin', true);
                          setState(() {
                            errorOTP = '';
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomNavBar()),
                          );
                        } else {
                          setState(() {
                            errorOTP = 'Please enter a valid OTP';
                          });
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFFFFA500)),
                        overlayColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Color(0xFF2B9EBFF).withOpacity(0.2);
                          } else {
                            return Colors.transparent;
                          }
                        }),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                                color: CustomColors.yellowBorderColor,
                                width: 1),
                          ),
                        ),
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
