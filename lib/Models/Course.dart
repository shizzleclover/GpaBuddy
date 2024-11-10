
import 'package:hive/hive.dart';

part 'Course.g.dart';

@HiveType(typeId: 0)

class Course extends HiveObject{
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int credits;

  @HiveField(2)
  final String grade;

  Course({required this.credits, required this.grade, required this.name});
}