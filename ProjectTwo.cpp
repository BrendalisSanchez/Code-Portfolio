// CS 300 Project Two
// Brendalis Sanchez
// ProjectTwo.cpp

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>
#include <algorithm>

    using namespace std;

    // Define the Course structure
    struct Course {
        string number; // The course number (e.g., "CSCI100")
        string name;   // The course name (e.g., "Introduction to Computer Science")
        vector<string> prerequisites; // List of prerequisites for the course
    };

    // Function declarations
    /**
     * Reads and parses the course data from a CSV file.
     * @param fileName - The name of the CSV file containing course data.
     * @return An unordered_map of Course objects with course numbers as keys.
     * @details This function reads the course data line by line, parses each line into a Course object, and stores it in an unordered_map.
     *          It also validates prerequisites to ensure they exist in the map.
     */
    unordered_map<string, Course> loadCourses(const string & fileName);

    /**
     * Prints an alphanumeric list of all courses in the provided map.
     * @param courses - An unordered_map of Course objects to be printed.
     * @details Extracts all course numbers, sorts them alphanumerically, and displays their details.
     */
    void printCourseList(const unordered_map<string, Course>&courses);

    /**
     * Prints the details of a specific course, including prerequisites.
     * @param courses - An unordered_map of Course objects to search in.
     * @param courseNumber - The course number of the course to display details for.
     * @details If the course exists, prints its number, name, and list of prerequisites. Otherwise, displays an error message.
     */
    void printCourseDetails(const unordered_map<string, Course>&courses, const string & courseNumber);

    /**
     * Checks if a course with a given course number exists in the provided map.
     * @param courses - An unordered_map of Course objects to search in.
     * @param courseNumber - The course number to check for existence.
     * @return True if the course exists, otherwise false.
     * @details Utilizes unordered_map's find method for efficient lookup.
     */
    bool courseExists(const unordered_map<string, Course>&courses, const string & courseNumber);

    int main() {
        unordered_map<string, Course> courses; // Data structure to store loaded courses
        string fileName; // Variable to hold the name of the input file
        int choice = 0; // Variable to store the user’s menu choice

        cout << "Welcome to the Course Planner." << endl;
        cout << "CS 300 - Project Two" << endl;
        cout << "Brendalis Sanchez" << endl;

        // Main menu loop
        while (choice != 9) {
            // Display the menu options
            cout << "\n1. Load Data Structure." << endl;
            cout << "2. Print Course List." << endl;
            cout << "3. Print Course." << endl;
            cout << "9. Exit." << endl;
            cout << "\nWhat would you like to do? ";
            cin >> choice;

            switch (choice) {
            case 1: {
                cout << "Enter the file name to load: ";
                cin >> fileName;
                cout << "Attempting to open file: " << fileName << endl; // Debugging output
                courses = loadCourses(fileName);
                if (!courses.empty()) {
                    cout << "Data loaded successfully." << endl;
                }
                break;
            }
            case 2:
                if (courses.empty()) {
                    cout << "No data loaded. Please load the data first." << endl;
                }
                else {
                    printCourseList(courses);
                }
                break;
            case 3: {
                if (courses.empty()) {
                    cout << "No data loaded. Please load the data first." << endl;
                }
                else {
                    string courseNumber;
                    cout << "What course do you want to know about? ";
                    cin >> courseNumber;
                    printCourseDetails(courses, courseNumber);
                }
                break;
            }
            case 9:
                cout << "Thank you for using the course planner!" << endl;
                break;
            default:
                cout << choice << " is not a valid option." << endl;
            }
        }

        return 0;
    }

    unordered_map<string, Course> loadCourses(const string& fileName) {
        unordered_map<string, Course> courses; // Hash table to store the parsed course data
        ifstream inputFile(fileName); // Open the file for reading

        if (!inputFile.is_open()) {
            cerr << "Error: Cannot open file \"" << fileName << "\". Check if the file exists and the path is correct." << endl;
            return courses;
        }

        string line;
        while (getline(inputFile, line)) {
            if (line.empty()) { // Skip empty lines
                continue;
            }

            stringstream ss(line);
            string token;
            vector<string> tokens;

            // Split the line into tokens by comma
            while (getline(ss, token, ',')) {
                tokens.push_back(token);
            }

            if (tokens.size() < 2) { // Validate the format of the line
                cerr << "Error: Invalid line format: " << line << endl;
                continue;
            }

            // Create or retrieve a Course object
            string courseNumber = tokens[0];
            Course& course = courses[courseNumber];
            course.number = courseNumber;
            course.name = tokens[1];

            // Add prerequisites to the course
            for (size_t i = 2; i < tokens.size(); ++i) {
                string prerequisite = tokens[i];
                course.prerequisites.push_back(prerequisite);

                // Ensure the prerequisite course exists in the map
                if (courses.find(prerequisite) == courses.end()) {
                    Course prerequisiteCourse;
                    prerequisiteCourse.number = prerequisite;
                    courses[prerequisite] = prerequisiteCourse;
                }
            }
        }

        inputFile.close(); // Close the file
        return courses;
    }


    bool courseExists(const unordered_map<string, Course>&courses, const string & courseNumber) {
        return courses.find(courseNumber) != courses.end();
    }

    void printCourseList(const unordered_map<string, Course>&courses) {
        // Extract and sort course numbers
        vector<string> courseNumbers;
        for (const auto& pair : courses) {
            courseNumbers.push_back(pair.first);
        }
        sort(courseNumbers.begin(), courseNumbers.end());

        cout << "\nCourse List:" << endl;
        for (const auto& number : courseNumbers) {
            cout << number << ", " << courses.at(number).name << endl;
        }
    }

    void printCourseDetails(const unordered_map<string, Course>&courses, const string & courseNumber) {
        auto it = courses.find(courseNumber);
        if (it == courses.end()) {
            cout << "Error: Course not found." << endl;
            return;
        }

        const Course& course = it->second;
        cout << "\nCourse Number: " << course.number << endl;
        cout << "Course Name: " << course.name << endl;

        if (!course.prerequisites.empty()) {
            cout << "Prerequisites:" << endl;
            for (const auto& prerequisite : course.prerequisites) {
                cout << " - " << prerequisite << endl;
            }
        }
        else {
            cout << "No prerequisites." << endl;
        }
    }
