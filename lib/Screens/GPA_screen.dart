import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
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
        title: const Text('GPA Results', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          'GPA: ${result['gpa'].toStringAsFixed(2)}\n'
          'Total Credits: ${result['totalCredits']}\n'
          'Total Points: ${result['totalPoints'].toStringAsFixed(2)}',
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

  @override
  Widget build(BuildContext context) {
    var courses = Provider.of<GpaCalcProvider>(context).courses;
    ScreenUtil.init(context, designSize: const Size(1440, 900), minTextAdapt: true);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Row(
          children: [
            // Left Container: Input Fields and Course List
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
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
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    TextField(
                      controller: creditsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Credits',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    DropdownButtonFormField<String>(
                      value: selectedGrade,
                      items: gradeOptions.map((grade) {
                        return DropdownMenuItem<String>(
                          value: grade,
                          child: Text(grade),
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedGrade = value!;
                      },
                      decoration: InputDecoration(
                        labelText: 'Grade (A - F)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () => _addCourse(context),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      child: const Text('Add Course'),
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
                            margin: EdgeInsets.symmetric(vertical: 8.h),
                            child: ListTile(
                              title: Text(course.name),
                              subtitle: Text('Credits: ${course.credits} | Grade: ${course.grade}'),
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

            // Right Container: GPA Results
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[50],
                  borderRadius: BorderRadius.circular(15.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
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
                      style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    ),
                    SizedBox(height: 16.h),
                    Consumer<GpaCalcProvider>(
                      builder: (context, provider, child) {
                        var result = provider.calculateGpa();
                        return Column(
                          children: [
                            Text(
                              'GPA: ${result['gpa'].toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8.h),
                            Text('Total Credits: ${result['totalCredits']}'),
                            Text('Total Points: ${result['totalPoints'].toStringAsFixed(2)}'),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 30.h),
                    ElevatedButton(
                      onPressed: () => _calculateGpa(context),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        backgroundColor: Colors.deepPurple,
                        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 30.w),
                      ),
                      child: const Text(
                        'Calculate GPA',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                     SizedBox(height: 20.h,),
                    ElevatedButton(
                    onPressed: () => _clearCourse(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("Clear All Data"),
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
