// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:gpa_calc/Models/Course.dart';
 
import 'package:gpa_calc/Provider/cgpa_provider.dart';
import 'package:provider/provider.dart';

class CgpaScreen extends StatefulWidget {
  const CgpaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CgpaScreenState createState() => _CgpaScreenState();
}

class _CgpaScreenState extends State<CgpaScreen> {
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _creditsController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  List<Course> _currentSemesterCourses = [];

  void _addCourse() {
    final String name = _courseNameController.text;
    final int credits = int.tryParse(_creditsController.text) ?? 0;
    final String grade = _gradeController.text.toUpperCase();

    if (name.isNotEmpty && credits > 0 && grade.isNotEmpty) {
      setState(() {
        _currentSemesterCourses.add(Course(name: name, credits: credits, grade: grade));
      });
      _courseNameController.clear();
      _creditsController.clear();
      _gradeController.clear();
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
        title: const Text("CGPA Calculator"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Add Course to Current Semester"),
            TextField(
              controller: _courseNameController,
              decoration: const InputDecoration(labelText: "Course Name"),
            ),
            TextField(
              controller: _creditsController,
              decoration: const InputDecoration(labelText: "Credits"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _gradeController,
              decoration: const InputDecoration(labelText: "Grade (A-F)"),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _addCourse,
                  child: const Text("Add Course"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _addSemester(context),
                  child: const Text("Add Semester"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text("Semester GPAs"),
            Expanded(
              child: ListView.builder(
                itemCount: cgpaProvider.semesters.length,
                itemBuilder: (context, index) {
                  final semester = cgpaProvider.semesters[index];
                  return ListTile(
                    title: Text("Semester ${index + 1} GPA: ${semester.gpa.toStringAsFixed(2)}"),
                    subtitle: Text("Credits: ${semester.totalCredits}, Points: ${semester.totalPoints}"),
                  );
                },
              ),
            ),
            const Divider(),
            Text("Cumulative CGPA: ${cgpa.toStringAsFixed(2)}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _clearSemesters(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Clear All Data"),
            ),
          ],
        ),
      ),
    );
  }
}
