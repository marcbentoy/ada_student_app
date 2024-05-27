import 'package:ada_student_app/constants.dart';
import 'package:ada_student_app/screens/student_records_screen.dart';
import 'package:ada_student_app/utils/utils.dart';
import 'package:ada_student_app/widgets/custom_filled_button_widget.dart';
import 'package:ada_student_app/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IdInputScreen extends StatefulWidget {
  const IdInputScreen({super.key});

  @override
  State<IdInputScreen> createState() => _IdInputScreenState();
}

class _IdInputScreenState extends State<IdInputScreen> {
  TextEditingController schoolIdCtrlr = TextEditingController();
  TextEditingController pbUrlCtrlr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            // logo
            Image.asset("assets/images/logo_full.png"),
            const SizedBox(height: 24),

            // sub headline
            Text(
              "Student App",
              style: GoogleFonts.inter(),
            ),

            const SizedBox(height: 64),

            // email entry
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Student ID",
                  style: GoogleFonts.inter(),
                ),
                const SizedBox(height: 4),
                CustomTextField(
                  controller: schoolIdCtrlr,
                  hintText: "school id",
                ),
              ],
            ),

            const SizedBox(height: 32),

            // view records button
            CustomFilledButton(
              click: () async {
                final pbUrl = await getPbUrl();
                final pb = PocketBase(pbUrl);
                try {
                  final response = await pb.collection('students').getList(
                        filter: 'schoolId = "${schoolIdCtrlr.text}"',
                      );

                  debugPrint(response.toString());

                  if (response.items.isEmpty) {
                    showInvalidSB();
                  }

                  navigateToViewRecordsScreen(response.items.first.id);
                  showSuccessSB();
                } catch (e) {
                  debugPrint(e.toString());
                  showInvalidSB();
                }
              },
              width: double.infinity,
              child: Text(
                "View Records",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            const Spacer(),

            TextButton(
              onPressed: () async {
                // get pbUrl
                String pbUrl = await getPbUrl();
                pbUrlCtrlr.text = pbUrl;

                promptChangePbUrl();
              },
              child: Text(
                "pb url",
                style: GoogleFonts.inter(
                  color: kblue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showInvalidSB() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: kred,
        content: Text(
          "Invalid student school id",
          style: GoogleFonts.inter(),
        ),
      ),
    );
  }

  void navigateToViewRecordsScreen(String id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ViewRecordsScreen(studentId: id);
        },
      ),
    );
  }

  void promptChangePbUrl() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: kwhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width < 400
                  ? MediaQuery.of(context).size.width - 24
                  : 400,
              height: 200,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // headline
                  Text(
                    "Update Pocketbase URL",
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  ),

                  // text field
                  CustomTextField(
                    controller: pbUrlCtrlr,
                    hintText: "new pb url",
                  ),

                  // save button
                  CustomFilledButton(
                    width: double.infinity,
                    click: () async {
                      // update shared prefs
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString("pbUrl", pbUrlCtrlr.text);

                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "SAVE URL",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void showSuccessSB() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: kgreen,
        content: Text(
          "Student ID found",
          style: GoogleFonts.inter(),
        ),
      ),
    );
  }
}
