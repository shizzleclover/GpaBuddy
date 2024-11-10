 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
 
import 'package:gpa_calc/Models/course_new.dart';
import 'package:gpa_calc/Provider/calc_provider.dart';
import 'package:gpa_calc/Provider/cgpa_provider.dart';
import 'package:gpa_calc/Screens/homeScreen.dart';
// ignore: unnecessary_import
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';


void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    Hive.registerAdapter(CourseAdapter());
    await Hive.openBox<Course>('courses');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GpaCalcProvider(),),
        ChangeNotifierProvider(create: (_) => CgpaCalcProvider())
      ],
      child: const MyApp(),
    )
  );
 }


 class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),  
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return const MaterialApp(
            title: 'GPA calculator',
      home:   HomeScreen(),
      debugShowCheckedModeBanner: false,
        );
      }
    
      
    );
  }
}