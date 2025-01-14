import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFormField extends StatelessWidget {
  final String? label;
  final Widget? child;
  const CustomFormField({super.key, this.child, this.label});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Stack(
        children: [
          Container(
              width: double.infinity,
              height: double.infinity,
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black.withOpacity(0.3), width: 1.1),
                  borderRadius: BorderRadius.circular(4)),
              alignment: Alignment.centerLeft,
              child: child),
          Positioned(
            left: 14,
            child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Text(
                  label ?? "null",
                  style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.w500),
                )),
          )
        ],
      ),
    );
  }
}
