 
import 'package:gpa_calc/Models/course_new.dart';
import 'package:hive/hive.dart';

part 'semester.g.dart';

@HiveType(typeId: 1)
class Semester extends HiveObject{

  @HiveField(0)
  final List<Course> courses;

  @HiveField(1)
  final double gpa;

  @HiveField(2)
  final int totalCredits;

  @HiveField(3)
  final double totalPoints;
  
  Semester({
   required this.courses, 
   required this.gpa, 
   required this.totalCredits,
    required this.totalPoints

  });
}