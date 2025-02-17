# 🚀 Code Portfolio

## 📌 Overview
Welcome to my GitHub portfolio! This repository showcases a variety of coding projects and scripts, spanning different programming languages and technologies. Each file represents a unique project or functionality, ranging from backend development and database management to game design and API development.

---

## 📂 File Descriptions

### **JavaScript**
- **[`app.js`](./app.js)**  
  - A backend server file using **Express.js**.  
  - Handles routing, middleware configuration, CORS setup, and passport authentication.  
  - Implements database connectivity via `./app_api/models/db`.  
  - Routes are defined for handling users, travel data, and an API interface.

### **Swift**
- **[`DatabaseManager.swift`](./DatabaseManager.swift)**  
  - A **Swift** class for managing MySQL database connections in the **Final Brendalis Mystery Game**.  
  - Implements a singleton pattern for efficient connection pooling.  
  - Supports executing SQL queries, fetching rows, and writing data to the database.  
  - Includes functions for preloading data, checking connection status, and handling errors gracefully.

- **[`FinalMysteryGameTests.swift`](./FinalMysteryGameTests.swift)**  
  - Unit tests for the **Final Brendalis Mystery Game**.  
  - Tests core game functionalities, including player movement, clue collection, room navigation, and win/loss conditions.  
  - Uses `XCTest` for validation and structured test case management.

### **Java**
- **[`Main.java`](./Main.java)**  
  - A text-based **mystery game** implemented in Java.  
  - Uses **HashMaps** to store room connections and player inventory.  
  - Features movement, clue collection, and interrogation mechanics.  
  - Players can explore rooms, collect clues, and find the murderer to win the game.

### **C++**
- **[`ProjectTwo.cpp`](./ProjectTwo.cpp)**  
  - A **CS 300 Course Planner** project written in C++.  
  - Reads course data from a CSV file, stores it in an **unordered_map**, and allows searching for courses.  
  - Provides functionality to:
    - Load course data.
    - Print an alphanumeric list of courses.
    - Display course details, including prerequisites.

### **SQL**
- **[`CreateRoomConnectionTable.sql`](./CreateRoomConnectionTable.sql)**  
  - SQL script for creating a **Room Connection Table** in a database.  
  - Defines relational structures for storing room connections in the **Mystery Game**.  
  - Helps facilitate navigation and pathfinding.

- **[`TraineeAccounts_Search_Pagination.txt`](./TraineeAccounts_Search_Pagination.txt)**  
  - A **stored procedure** for paginated search results on trainee accounts.  
  - Queries multiple tables to fetch user details, zone status, and account information efficiently.

### **React (JavaScript)**
- **[`TraineeAccountsTable.txt`](./TraineeAccountsTable.txt)**  
  - A **React** component for rendering trainee account details in a table.  
  - Uses `prop-types` for type checking.  
  - Includes action menu options for modifying or deleting trainee accounts.

### **C# (ASP.NET Core)**
- **[`TraineeAcountsAPIController.txt`](./TraineeAcountsAPIController.txt)**  
  - An **ASP.NET Core API controller** for managing trainee accounts.  
  - Implements RESTful endpoints for fetching, updating, and deleting trainee accounts.  
  - Uses `Microsoft.AspNetCore.Mvc` and dependency injection for service management.
