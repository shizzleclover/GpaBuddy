// // screens/home_screen.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/gpa_provider.dart';

// class HomeScreen extends StatelessWidget {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController creditsController = TextEditingController();
//   final TextEditingController gradeController = TextEditingController();

//   void _calculateGpa(BuildContext context) {
//     var provider = Provider.of<GpaProvider>(context, listen: false);
//     var result = provider.calculateGpa();

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text('GPA Results'),
//         content: Text(
//           'GPA: ${result['gpa'].toStringAsFixed(2)}\n'
//           'Total Credits: ${result['totalCredits']}\n'
//           'Total Points: ${result['totalPoints'].toStringAsFixed(2)}',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _addCourse(BuildContext context) {
//     var provider = Provider.of<GpaProvider>(context, listen: false);

//     String name = nameController.text;
//     int credits = int.tryParse(creditsController.text) ?? 0;
//     String grade = gradeController.text.toUpperCase();

//     if (name.isNotEmpty && credits > 0 && grade.isNotEmpty) {
//       provider.addCourse(name, credits, grade);
//       nameController.clear();
//       creditsController.clear();
//       gradeController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var courses = Provider.of<GpaProvider>(context).courses;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('GPA & CGPA Calculator'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(labelText: 'Course Name'),
//             ),
//             TextField(
//               controller: creditsController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(labelText: 'Credits'),
//             ),
//             TextField(
//               controller: gradeController,
//               decoration: InputDecoration(labelText: 'Grade (A-F)'),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () => _addCourse(context),
//               child: Text('Add Course'),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: courses.length,
//                 itemBuilder: (context, index) {
//                   final course = courses[index];
//                   return ListTile(
//                     title: Text('${course.name}'),
//                     subtitle: Text('Credits: ${course.credits} | Grade: ${course.grade}'),
//                   );
//                 },
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () => _calculateGpa(context),
//               child: Text('Calculate GPA'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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

  @override
  Widget build(BuildContext context) {
    var courses = Provider.of<GpaCalcProvider>(context).courses;
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
         
        centerTitle: true,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            // Left Container: Input Fields and Course List
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
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
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: creditsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Credits',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _addCourse(context),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Add Course'),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: courses.length,
                        itemBuilder: (context, index) {
                          final course = courses[index];
                          return Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 8),
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
            const SizedBox(width: 20),

            // Right Container: GPA Results
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[50],
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'GPA Results',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    ),
                    const SizedBox(height: 16),
                    Consumer<GpaCalcProvider>(
                      builder: (context, provider, child) {
                        var result = provider.calculateGpa();
                        return Column(
                          children: [
                            Text(
                              'GPA: ${result['gpa'].toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text('Total Credits: ${result['totalCredits']}'),
                            Text('Total Points: ${result['totalPoints'].toStringAsFixed(2)}'),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () => _calculateGpa(context),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                      ),
                      child: const Text(
                        'Calculate GPA',
                        style: TextStyle(color: Colors.white),
                      ),
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
