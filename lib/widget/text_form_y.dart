import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:interior_v_1/helper/custome_colour.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLength;
  final IconData icon;
  final IconData? suffixIcon;
  final String? Function(String?)? validator;
  final bool showError;
  final bool editable;
  final TextInputType keyboardType;
  final VoidCallback? onSuffixIconTap;

  const CustomTextField({
    required this.controller,
    required this.hintText,
    required this.maxLength,
    required this.icon,
    this.suffixIcon,
    this.validator,
    this.showError = false,
    this.editable = true,
    this.keyboardType = TextInputType.text,
    this.onSuffixIconTap,
    Key? key,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
    widget.controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    widget.controller.removeListener(_handleTextChange);
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _handleTextChange() {
    if (widget.showError) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    String? errorText =
    widget.showError ? widget.validator!(widget.controller.text) : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              errorText,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        if (errorText != null) SizedBox(height: 5),
        Container(
          height: 48,
          width: w * 0.9,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isFocused
                  ? CustomColors.orangeColor
                  : CustomColors.yellowBorderColor,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: TextField(
            focusNode: _focusNode,
            style: TextStyle(fontSize: 17, color: Colors.black),
            controller: widget.controller,
            textAlign: TextAlign.justify,
            keyboardType: widget.keyboardType,
            maxLength: widget.maxLength,
            enabled: widget.editable,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontSize: 17,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              fillColor: Colors.white,
              isDense: true,
              counterText: '',
              icon: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  widget.icon,
                  size: 24,
                ),
              ),
              suffixIcon: widget.suffixIcon != null
                  ? GestureDetector(
                onTap: widget.onSuffixIconTap,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    widget.suffixIcon,
                    size: 32,
                  ),
                ),
              )
                  : null,
              contentPadding: EdgeInsets.symmetric(
                  vertical: 12, horizontal: 0.0),
            ),
          ),
        ),
      ],
    );
  }
}

// class CustomTextField extends StatefulWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final int maxLength;
//   final IconData icon;
//   final String? Function(String?)? validator;
//   final bool showError;
//   final bool editable;
//   final TextInputType keyboardType;
//
//   const CustomTextField({
//     required this.controller,
//     required this.hintText,
//     required this.maxLength,
//     required this.icon,
//     this.validator,
//     this.showError = false,
//     this.editable = true,
//     this.keyboardType = TextInputType.text,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   _CustomTextFieldState createState() => _CustomTextFieldState();
// }
//
// class _CustomTextFieldState extends State<CustomTextField> {
//   final FocusNode _focusNode = FocusNode();
//   bool _isFocused = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _focusNode.addListener(_handleFocusChange);
//     widget.controller.addListener(_handleTextChange);
//   }
//
//   @override
//   void dispose() {
//     _focusNode.removeListener(_handleFocusChange);
//     _focusNode.dispose();
//     widget.controller.removeListener(_handleTextChange);
//     super.dispose();
//   }
//
//   void _handleFocusChange() {
//     setState(() {
//       _isFocused = _focusNode.hasFocus;
//     });
//   }
//
//   void _handleTextChange() {
//     if (widget.showError) {
//       setState(() {});
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
//     String? errorText =
//         widget.showError ? widget.validator!(widget.controller.text) : null;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (errorText != null)
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 5.0),
//             child: Text(
//               errorText,
//               style: TextStyle(color: Colors.red, fontSize: 12),
//             ),
//           ),
//         if (errorText != null) SizedBox(height: 5),
//         Container(
//           height: 48,
//           width: w * 0.9,
//           clipBehavior: Clip.antiAlias,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(
//               color: _isFocused
//                   ? CustomColors.orangeColor
//                   : CustomColors.yellowBorderColor,
//               width: 1.2,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.1),
//                 spreadRadius: 1,
//                 blurRadius: 2,
//                 offset: Offset(0, 0),
//               ),
//             ],
//           ),
//           child: TextField(
//             focusNode: _focusNode,
//             style: TextStyle(fontSize: 17, color: Colors.black),
//             controller: widget.controller,
//             textAlign: TextAlign.justify,
//             keyboardType: widget.keyboardType,
//             maxLength: widget.maxLength,
//             enabled: widget.editable,
//             decoration: InputDecoration(
//               hintText: widget.hintText,
//               hintStyle: TextStyle(
//                 fontSize: 17,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: BorderSide.none,
//               ),
//               fillColor: Colors.white,
//               isDense: true,
//               counterText: '',
//               icon: Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: Icon(
//                   widget.icon,
//                   size: 24,
//                 ),
//               ),
//               contentPadding: EdgeInsets.symmetric(
//                   vertical: 12, horizontal: 0.0),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
