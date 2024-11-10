
import 'package:flutter/material.dart';
 
import 'package:gpa_calc/Models/course_new.dart';
import 'package:gpa_calc/Models/semester.dart';
 

class CgpaCalcProvider with ChangeNotifier {
  final List<Semester> _semesters = []; // List of semesters to store each semester's courses
  List<Semester> get semesters => _semesters;

  // Add a new semester

  void addSemester(List<Course> courses) {
    double semesterGpa = _calculateGpa(courses);
    int totalCredits = courses.fold(0, (sum, course) => sum + course.credits);
    double totalPoints = courses.fold(0, (sum, course) => sum + (_getGradePoints(course.grade) * course.credits));
    
    _semesters.add(Semester(courses: courses, gpa: semesterGpa, totalCredits: totalCredits, totalPoints: totalPoints));
    notifyListeners();
  }

  // Calculate GPA for a list of courses
  double _calculateGpa(List<Course> courses) {
    int totalCredits = courses.fold(0, (sum, course) => sum + course.credits);
    double totalPoints = courses.fold(0, (sum, course) => sum + (_getGradePoints(course.grade) * course.credits));
    
    return totalCredits > 0 ? totalPoints / totalCredits : 0.0;
  }

  // Calculate CGPA across all semesters
  double calculateCgpa() {
    int totalCredits = _semesters.fold(0, (sum, semester) => sum + semester.totalCredits);
    double totalPoints = _semesters.fold(0, (sum, semester) => sum + semester.totalPoints);

    return totalCredits > 0 ? totalPoints / totalCredits : 0.0;
  }

  // Clear all semesters and reset CGPA calculation
  void clearSemesters() {
    _semesters.clear();
    notifyListeners();
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
}
 