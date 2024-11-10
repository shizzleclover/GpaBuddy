GPA and CGPA Calculator App
This is a GPA and CGPA Calculator app built with Flutter. It helps students calculate their GPA and CGPA based on their course grades and credits. The app supports adding multiple courses, calculating GPA for a semester, and persists course data across app restarts using Hive for local storage.

Features:
Course Management: Add courses with their respective credits and grades.
GPA Calculation: Automatically calculates GPA based on the inputted grades and credits.
CGPA Calculation: The app allows you to track your CGPA over multiple semesters (implementation can be extended).
Persistent Storage: All course data (name, credits, grade) is saved using Hive, so your data is retained even after the app is closed or restarted.
User-friendly Interface: Clean and intuitive UI for easy navigation and calculation.
Technologies:
Flutter: Cross-platform mobile development framework.
Hive: NoSQL database for storing and retrieving course data locally.
Provider: State management to handle data updates across the app.

How to Run:
Clone the repository:
 
git clone https://github.com/yourusername/gpa-cgpa-calculator.git
Install dependencies:
 
flutter pub get
Run the app:

flutter run

Future Enhancements:
Semester-wise GPA Tracking: Ability to calculate GPA for multiple semesters and track CGPA.
Grade Prediction: Provide tips or predictions to help improve GPA based on course performance.
Cloud Sync: Sync data across devices using Firebase or other cloud solutions.

Feel free to modify and adjust as per your requirements!
