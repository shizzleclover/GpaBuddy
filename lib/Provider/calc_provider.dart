import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:gpa_calc/Models/course.dart';

class GpaCalcProvider with ChangeNotifier {
  final Box<Course> _courseBox = Hive.box<Course>('courses');

  int _totalCredits = 0;
  double _totalPoints = 0.0;

  int get totalCredits => _totalCredits;
  double get totalPoint => _totalPoints;

  List<Course> get courses => _courseBox.values.toList();

  // Add a new course and save it in Hive
  void addCourse(String name, int credits, String grade) {
    final newCourse = Course(name: name, credits: credits, grade: grade.toUpperCase());
    _courseBox.add(newCourse); // Save to Hive
    notifyListeners();
  }

  // Calculate GPA and return total credits and total points for current courses
  Map<String, dynamic> calculateGpa() {
    _totalCredits = 0;
    _totalPoints = 0.0;

    for (var course in _courseBox.values) {
      _totalCredits += course.credits;
      _totalPoints += _getGradePoints(course.grade) * course.credits;
    }

    double gpa = _totalCredits > 0 ? _totalPoints / _totalCredits : 0.0;
    return {
      'gpa': gpa,
      'totalCredits': _totalCredits,
      'totalPoints': _totalPoints,
    };
  }

  // Map grade letters to grade points
  double _getGradePoints(String grade) {
    switch (grade) {
      case 'A':
        return 5.0;
      case 'B':
        return 4.0;
      case 'C':
        return 3.0;
      case 'D':
        return 2.0;
      case 'E':
        return 1.0;
      case 'F':
        return 0.0;
      default:
        return 0.0;
    }
  }

  // Clear courses for new GPA calculation
  void clearCourses() async {
    await _courseBox.clear(); // Clear all stored courses in Hive
    _totalCredits = 0;
    _totalPoints = 0.0;
    notifyListeners();
  }
}
