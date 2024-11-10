import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gpa_calc/Models/course_new.dart';
import 'package:gpa_calc/Provider/cgpa_provider.dart';
import 'package:provider/provider.dart';

class CgpaScreen extends StatefulWidget {
  const CgpaScreen({super.key});

  @override
  _CgpaScreenState createState() => _CgpaScreenState();
}

class _CgpaScreenState extends State<CgpaScreen> {
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _creditsController = TextEditingController();
  String? selectedGrade;
  final List<String> gradeOptions = ['A', 'B', 'C', 'D', 'E', 'F'];
  List<Course> _currentSemesterCourses = [];

  void _addCourse() {
    final String name = _courseNameController.text;
    final int credits = int.tryParse(_creditsController.text) ?? 0;
    final String grade = selectedGrade ?? '';

    if (name.isNotEmpty && credits > 0 && grade.isNotEmpty) {
      setState(() {
        _currentSemesterCourses.add(Course(name: name, credits: credits, grade: grade));
      });
      _courseNameController.clear();
      _creditsController.clear();
      selectedGrade = null;
    }
  }

  void _addSemester(BuildContext context) {
    if (_currentSemesterCourses.isNotEmpty) {
      Provider.of<CgpaCalcProvider>(context, listen: false).addSemester(_currentSemesterCourses);
      setState(() {
        _currentSemesterCourses = [];
      });
    }
  }

  void _clearSemesters(BuildContext context) {
    Provider.of<CgpaCalcProvider>(context, listen: false).clearSemesters();
  }

  @override
  Widget build(BuildContext context) {
    final cgpaProvider = Provider.of<CgpaCalcProvider>(context);
    final cgpa = cgpaProvider.calculateCgpa();

    return Scaffold(
      appBar: AppBar(
        title: Text("CGPA Calculator", style: TextStyle(fontSize: 18.sp)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Add Course to Current Semester", style: TextStyle(fontSize: 16.sp)),
                  TextField(
                    controller: _courseNameController,
                    decoration: InputDecoration(
                      labelText: "Course Name",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextField(
                    controller: _creditsController,
                    decoration: InputDecoration(
                      labelText: "Credits",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16.h),
                  DropdownButtonFormField<String>(
                    value: selectedGrade,
                    items: gradeOptions.map((grade) {
                      return DropdownMenuItem<String>(
                        value: grade,
                        child: Text(grade, style: TextStyle(fontSize: 14.sp)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGrade = value!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Grade (A - F)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _addCourse,
                        child: Text("Add Course", style: TextStyle(fontSize: 14.sp)),
                      ),
                      SizedBox(width: 10.w),
                      ElevatedButton(
                        onPressed: () => _addSemester(context),
                        child: Text("Add Semester", style: TextStyle(fontSize: 14.sp)),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text("Courses Added to Current Semester", style: TextStyle(fontSize: 16.sp)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _currentSemesterCourses.length,
                      itemBuilder: (context, index) {
                        final course = _currentSemesterCourses[index];
                        return ListTile(
                          title: Text(course.name, style: TextStyle(fontSize: 14.sp)),
                          subtitle: Text("Credits: ${course.credits}, Grade: ${course.grade}", style: TextStyle(fontSize: 12.sp)),
                        );
                      },
                    ),
                  ),
                  Divider(),
                  Text("Semester GPAs", style: TextStyle(fontSize: 16.sp)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cgpaProvider.semesters.length,
                      itemBuilder: (context, index) {
                        final semester = cgpaProvider.semesters[index];
                        return ListTile(
                          title: Text("Semester ${index + 1} GPA: ${semester.gpa.toStringAsFixed(2)}", style: TextStyle(fontSize: 14.sp)),
                          subtitle: Text("Credits: ${semester.totalCredits}, Points: ${semester.totalPoints}", style: TextStyle(fontSize: 12.sp)),
                        );
                      },
                    ),
                  ),
                  Divider(),
                  ElevatedButton(
                    onPressed: () => _clearSemesters(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text("Clear All Data", style: TextStyle(fontSize: 14.sp)),
                  ),
                ],
              ),
            ),
            SizedBox(width: 20.w),
            Container(
              width: 200.w,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.blue.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "CGPA Summary",
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Cumulative CGPA: ${cgpa.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  SizedBox(height: 20.h),
                  if (cgpaProvider.semesters.isNotEmpty) ...[
                    for (int i = 0; i < cgpaProvider.semesters.length; i++)
                      Text(
                        "Semester ${i + 1}: ${cgpaProvider.semesters[i].gpa.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
