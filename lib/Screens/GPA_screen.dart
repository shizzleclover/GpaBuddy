import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Provider/calc_provider.dart';

// ignore: must_be_immutable
class CalcScreen extends StatelessWidget {
  CalcScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController creditsController = TextEditingController();
  String? selectedGrade;
  final List<String> gradeOptions = ['A', 'B', 'C', 'D', 'E', 'F'];

  void _calculateGpa(BuildContext context) {
    var provider = Provider.of<GpaCalcProvider>(context, listen: false);
    var result = provider.calculateGpa();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        title: Text(
          'GPA Results',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
        ),
        content: Text(
          'GPA: ${result['gpa'].toStringAsFixed(2)}\n'
          'Total Credits: ${result['totalCredits']}\n'
          'Total Points: ${result['totalPoints'].toStringAsFixed(2)}',
          style: GoogleFonts.poppins(color: Colors.blueGrey[700]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _addCourse(BuildContext context) {
    var provider = Provider.of<GpaCalcProvider>(context, listen: false);
    String name = nameController.text;
    int credits = int.tryParse(creditsController.text) ?? 0;

    if (name.isNotEmpty && credits > 0 && selectedGrade != null) {
      provider.addCourse(name, credits, selectedGrade!);
      nameController.clear();
      creditsController.clear();
      selectedGrade = null;
    }
  }

  void _clearCourse(BuildContext context) {
    Provider.of<GpaCalcProvider>(context, listen: false).clearCourses();
  }


  // void _removeCourse(BuildContext context) {
  //   Provider.of<GpaCalcProvider>(context, listen: false)._removeCourse();
  // }
  @override
  Widget build(BuildContext context) {
    var courses = Provider.of<GpaCalcProvider>(context).courses;
    ScreenUtil.init(context, designSize: const Size(1440, 900), minTextAdapt: true);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'GPA Calculator',
          style: GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 5,
        backgroundColor: Colors.blueGrey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey.withOpacity(0.1),
                      blurRadius: 10.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Course Name',
                        labelStyle: GoogleFonts.poppins(),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    TextField(
                      controller: creditsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Credits',
                        labelStyle: GoogleFonts.poppins(),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    DropdownButtonFormField<String>(
                      value: selectedGrade,
                      items: gradeOptions.map((grade) {
                        return DropdownMenuItem<String>(
                          value: grade,
                          child: Text(grade, style: GoogleFonts.poppins()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedGrade = value!;
                      },
                      decoration: InputDecoration(
                        labelText: 'Grade (A - F)',
                        labelStyle: GoogleFonts.poppins(),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () => _addCourse(context),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        backgroundColor: Colors.blueGrey[700],
                      ),
                      child: Text('Add Course', style: GoogleFonts.poppins(color: Colors.white)),
                    ),
                    SizedBox(height: 20.h),
                    Expanded(
                      child: ListView.builder(
                        itemCount: courses.length,
                        itemBuilder: (context, index) {
                          final course = courses[index];
                          return Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                            elevation: 3,
                            color: Colors.blueGrey[50],
                            margin: EdgeInsets.symmetric(vertical: 8.h),
                            child: ListTile(
                              title: Text(course.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                              subtitle: Text(
                                'Credits: ${course.credits} | Grade: ${course.grade}',
                                style: GoogleFonts.poppins(),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red[400]),
                                onPressed:  () {},
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20.w),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(15.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey.withOpacity(0.1),
                      blurRadius: 10.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'GPA Results',
                      style: GoogleFonts.poppins(
                          fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
                    ),
                    SizedBox(height: 16.h),
                    Consumer<GpaCalcProvider>(
                      builder: (context, provider, child) {
                        var result = provider.calculateGpa();
                        return Column(
                          children: [
                            Text(
                              'GPA: ${result['gpa'].toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Total Credits: ${result['totalCredits']}',
                              style: GoogleFonts.poppins(),
                            ),
                            Text(
                              'Total Points: ${result['totalPoints'].toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 30.h),
                    ElevatedButton(
                      onPressed: () => _calculateGpa(context),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        backgroundColor: Colors.blueGrey[800],
                        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 30.w),
                      ),
                      child: Text(
                        'Calculate GPA',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      onPressed: () => _clearCourse(context),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
                      child: Text("Clear All Data", style: GoogleFonts.poppins(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
