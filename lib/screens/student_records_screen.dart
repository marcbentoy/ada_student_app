import 'package:ada_student_app/models/entry_model.dart';
import 'package:ada_student_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:simple_heatmap_calendar/simple_heatmap_calendar.dart';

import 'package:ada_student_app/constants.dart';

class ViewRecordsScreen extends StatefulWidget {
  final String studentId;

  const ViewRecordsScreen({super.key, required this.studentId});

  @override
  State<ViewRecordsScreen> createState() => _ViewRecordsScreenState();
}

class _ViewRecordsScreenState extends State<ViewRecordsScreen> {
  List<EntryModel> records = [];
  Map<DateTime, num> heatMapData = {};

  @override
  void initState() {
    super.initState();

    getRecords();
    getHeatMapData();
  }

  void getRecords() async {
    final pbUrl = await getPbUrl();
    final pb = PocketBase(pbUrl);

    records.clear();

    final responses = await pb.collection('records').getFullList(
          sort: '-created,-entryDate',
          filter: 'student="${widget.studentId}"',
        );

    debugPrint(responses.first.toString());

    final studenData = await pb.collection('students').getOne(widget.studentId);

    for (var response in responses) {
      records.add(EntryModel(
        isOut: response.data["entry"] == "in" ? false : true,
        roomName: response.data["room"],
        studentId: studenData.data["schoolId"],
        studentName: studenData.data["name"],
        entryDate: DateTime.parse(response.data["entryDate"] == ""
            ? response.created
            : response.data["entryDate"]),
      ));
    }

    setState(() {
      records;
    });

    heatMapData.clear();
    for (var element in records) {
      heatMapData[DateTime.parse(
          DateFormat("yyyy-MM-dd").format(element.entryDate))] = (heatMapData[
                  DateTime.parse(
                      DateFormat("yyyy-MM-dd").format(element.entryDate))] ??
              0) +
          1;
    }

    setState(() {
      heatMapData;
    });
  }

  void getHeatMapData() {
    for (var element in records) {
      heatMapData[DateTime.parse(
          DateFormat("yyyy-MM-dd").format(element.entryDate))] = (heatMapData[
                  DateTime.parse(
                      DateFormat("yyyy-MM-dd").format(element.entryDate))] ??
              0) +
          1;
    }

    setState(() {
      heatMapData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kwhite,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // heatmap
            HeatmapCalendar<num>(
              startDate: DateTime(2024),
              endedDate: DateTime.now(),
              colorMap: {
                1: kblue.withOpacity(0.2),
                2: kblue.withOpacity(0.4),
                3: kblue.withOpacity(0.6),
                4: kblue.withOpacity(0.8),
                5: kblue,
              },
              cellSize: const Size.square(16.0),
              colorTipCellSize: const Size.square(12.0),
              style: const HeatmapCalendarStyle.defaults(
                cellValueFontSize: 6.0,
                cellRadius: BorderRadius.all(Radius.circular(4.0)),
                weekLabelValueFontSize: 12.0,
                monthLabelFontSize: 12.0,
              ),
              layoutParameters: const HeatmapLayoutParameters.defaults(
                monthLabelPosition: CalendarMonthLabelPosition.top,
                weekLabelPosition: CalendarWeekLabelPosition.right,
                colorTipPosition: CalendarColorTipPosition.bottom,
              ),
              selectedMap: heatMapData,
            ),

            const SizedBox(
              height: 16,
            ),

            // recent records
            Expanded(
              child: ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  return EntryRecordWidget(
                    entryDate: records[index].entryDate,
                    isOut: records[index].isOut,
                    roomName: records[index].roomName,
                    studentId: records[index].studentId,
                    studentName: records[index].studentName,
                  );
                },
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: klightblue,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: kdarkblue,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Student Records",
          style: GoogleFonts.inter(
            color: kdarkblue,
            letterSpacing: -0.8,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // refresh button
          IconButton(
            onPressed: () {
              getRecords();
            },
            icon: Icon(
              Icons.refresh_rounded,
              color: kdarkblue,
            ),
          ),
        ],
      ),
    );
  }
}

class EntryRecordWidget extends StatelessWidget {
  const EntryRecordWidget({
    super.key,
    required this.isOut,
    required this.roomName,
    required this.entryDate,
    required this.studentId,
    required this.studentName,
  });

  final bool isOut;
  final String roomName;
  final DateTime entryDate;
  final String studentId;
  final String studentName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isOut ? klightyellow : klightgreen,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              // entry data
              Row(
                children: [
                  // entry type
                  Text(
                    isOut ? "OUT" : "IN",
                    style: GoogleFonts.inter(
                      color: isOut ? kdarkyellow : kdarkgreen,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.4,
                    ),
                  ),

                  const SizedBox(
                    width: 8,
                  ),

                  // room name
                  Text(
                    roomName,
                    style: GoogleFonts.inter(
                      color: isOut ? kdarkyellow : kdarkgreen,
                      letterSpacing: -0.4,
                    ),
                  ),

                  const Spacer(),

                  // date time
                  Text(
                    DateFormat("yyyy-MM-dd kk:mm").format(entryDate),
                    style: GoogleFonts.inter(
                      color: isOut ? kdarkyellow : kdarkgreen,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),

              // student data
              Row(
                children: [
                  // student id
                  Text(
                    studentId,
                    style: GoogleFonts.inter(
                      color: isOut ? kdarkyellow : kdarkgreen,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.4,
                    ),
                  ),

                  const Spacer(),

                  // student name
                  Text(
                    studentName,
                    style: GoogleFonts.inter(
                      color: isOut ? kdarkyellow : kdarkgreen,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
