import 'package:ada_student_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.obscure,
    required this.hintText,
  });

  final String hintText;
  final bool? obscure;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: kgreen,
      obscureText: obscure ?? false,
      controller: controller,
      style: GoogleFonts.inter(),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kborder),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kborder),
          borderRadius: BorderRadius.circular(8),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: kborder),
          borderRadius: BorderRadius.circular(8),
        ),
        fillColor: kdarkwhite,
        filled: true,
      ),
    );
  }
}
