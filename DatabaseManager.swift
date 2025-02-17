// DatabaseManager.swift
/// Manages database connections and query execution for the MysteryGame application.
//
// Project: Final Brendalis Mystery Game
/// Created by Brendalis Sanchez on 11/27/24.
/// Last updated by Brendalis Sanchez on 12/15/24.
//

import Foundation
import MySQLNIO
import NIO

class DatabaseManager {
    /// Singleton instance for shared access to the database manager.
    static let shared = DatabaseManager()
    /// Event loop group for handling asynchronous database operations.
    private let eventLoopGroup: EventLoopGroup

    /// Private initializer to enforce the singleton pattern.
    private init() {
        // Initialize an event loop group with a single thread for managing database I/O.
        eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    }

    /// Tests the connection to the database and executes a sample query to verify connectivity.
    func testConnectionAndQuery() {
        let query = "SELECT * FROM Rooms"
        
        self.query(query) { result in
            switch result {
            case .success(let rows):
                print("Database query successful. Results:")
                for row in rows {
                    print(row)
                }
            case .failure(let error):
                print("Database query failed with error: \(error)")
            }
        }
    }

    /// Establishes a connection to the MySQL database.
    ///
    /// - Returns: A future representing the active MySQL connection.
    func getConnection() -> EventLoopFuture<MySQLConnection> {
        do {
            // Resolve the database socket address using hostname and port.
            let socketAddress = try SocketAddress.makeAddressResolvingHost("127.0.0.1", port: 3306)
            // Retrieve the database password from environment variables for security.
            let dbPassword = ProcessInfo.processInfo.environment["DB_PASSWORD"] ?? "default_password"
            
            // Establish the MySQL connection using the resolved address and credentials.
            return MySQLConnection.connect(
                to: socketAddress,
                username: "root",
                database: "MysteryGameDB",
                password: dbPassword,
                on: eventLoopGroup.next()
            )
        } catch {
            // Log the error if connection setup fails.
            Logger.logError(AppError.databaseError("Connection error: \(error.localizedDescription)"))
            print("MySQL db connection failed at the getConnection method in DatabaseManager.")
            return eventLoopGroup.next().makeFailedFuture(error)
        }
    }

    /// Executes a SQL query and returns the results.
    ///
    /// - Parameters:
    ///   - query: The SQL query to execute.
    ///   - completion: A closure to handle the query result, which includes either the rows retrieved or an error.
    func query(_ query: String, completion: @escaping (Result<[MySQLRow], Error>) -> Void) {
        // Attempt to establish a connection and execute the query.
        getConnection().whenSuccess { connection in
            connection.simpleQuery(query).whenComplete { result in
                switch result {
                case .success(let rows):
                    completion(.success(rows))
                case .failure(let error):
                    Logger.logError(AppError.databaseError("Query failed: \(error)"))
                    completion(.failure(AppError.databaseError("Query failed: \(error.localizedDescription)")))
                }
                // Close the connection once the query is complete.
                _ = connection.close()
            }
        }

        // Handle connection failure by logging the error and passing it to the completion handler.
        getConnection().whenFailure { error in
            Logger.logError(AppError.databaseError("Connection error: \(error)"))
            completion(.failure(AppError.databaseError("Connection error: \(error.localizedDescription)")))
        }
    }
    
    /// Executes a write operation (e.g., INSERT, UPDATE) on the database.
    ///
    /// - Parameters:
    ///   - query: The SQL query to execute.
    ///   - completion: A closure to handle the result of the write operation (success or failure).
    func executeWrite(_ query: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Establish a connection and execute the write operation.
        getConnection().whenSuccess { connection in
            connection.simpleQuery(query).whenComplete { result in
                // Ensure the connection is closed after the operation.
                _ = connection.close()
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    Logger.logError(AppError.databaseError("Write operation failed: \(error)"))
                    completion(.failure(AppError.databaseError("Write operation failed: \(error.localizedDescription)")))
                }
            }
        }
    }

    /// Preloads data by executing a read query.
    ///
    /// - Parameters:
    ///   - query: The SQL query to execute.
    ///   - completion: A closure to handle the result, which includes either the rows retrieved or an error.
    func preloadData(_ query: String, completion: @escaping (Result<[MySQLRow], Error>) -> Void) {
        self.query(query, completion: completion)
    }

    /// Cleans up resources by shutting down the event loop group gracefully.
    deinit {
        do {
            try eventLoopGroup.syncShutdownGracefully()
        } catch {
            Logger.logError(AppError.databaseError("Error shutting down EventLoopGroup: \(error.localizedDescription)"))
        }
    }
}

extension DatabaseManager {
    /// Fetches all rows from a specified table.
    ///
    /// - Parameters:
    ///   - tableName: The name of the table to query.
    ///   - completion: A closure to handle the result, which includes either the rows retrieved or an error.
    func fetchAll(from tableName: String, completion: @escaping (Result<[MySQLRow], Error>) -> Void) {
        let query = "SELECT * FROM \(tableName)"
        self.query(query, completion: completion)
    }

    /// Fetches a single row from a specified table by its ID.
    ///
    /// - Parameters:
    ///   - tableName: The name of the table to query.
    ///   - id: The unique identifier of the row to fetch.
    ///   - completion: A closure to handle the result, which includes either the row retrieved or an error.
    func fetchRow(from tableName: String, byID id: Int, completion: @escaping (Result<MySQLRow?, Error>) -> Void) {
        let query = "SELECT * FROM \(tableName) WHERE id = \(id)"
        self.query(query) { result in
            switch result {
            case .success(let rows):
                // Return the first row if available, or nil if no rows are found.
                completion(.success(rows.first))
            case .failure(let error):
                Logger.logError(AppError.databaseError("Fetch row failed: \(error)"))
                completion(.failure(AppError.databaseError("Fetch row failed: \(error.localizedDescription)")))
            }
        }
    }
}



////
////  DatabaseManager.swift
////  FinalMysteryGame
////
/////  Created by Brendalis Sanchez on 11/27/24.
/////  Last updated by Brendalis Sanchez on 12/15/24.
//
//import Foundation
//import MySQLNIO
//import NIO
//
///// A singleton class for managing database connections and executing queries.
//class DatabaseManager {
//    // MARK: - Singleton Instance
//    static let shared = DatabaseManager()
//
//    // MARK: - Private Properties
//    private let eventLoopGroup: EventLoopGroup
//
//    // MARK: - Initialization
//    private init() {
//        // Create an EventLoopGroup for managing asynchronous tasks
//        eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
//    }
//
//    // MARK: - Database Connection
//    /// Creates a new connection to the MySQL database.
//    ///
//    /// - Returns: An `EventLoopFuture` containing the `MySQLConnection`.
//    func getConnection() -> EventLoopFuture<MySQLConnection> {
//        do {
//            let socketAddress = try SocketAddress.makeAddressResolvingHost("127.0.0.1", port: 3306)
//            let dbPassword = ProcessInfo.processInfo.environment["DB_PASSWORD"] ?? "default_password"
//
//            return MySQLConnection.connect(
//                to: socketAddress,
//                username: "root",
//                database: "MysteryGameDB",
//                password: dbPassword,
//                on: eventLoopGroup.next()
//            )
//        } catch {
//            print("Failed to resolve database host: \(error)")
//            return eventLoopGroup.next().makeFailedFuture(error)
//        }
//    }
//
//    // MARK: - Query Execution
//    /// Executes a simple query and returns the results.
//    ///
//    /// - Parameters:
//    ///   - query: The SQL query string to execute.
//    ///   - completion: A closure that receives the query results or an error.
//    func query(_ query: String, completion: @escaping (Result<[MySQLRow], Error>) -> Void) {
//        getConnection().whenSuccess { connection in
//            connection.simpleQuery(query).whenComplete { result in
//                switch result {
//                case .success(let rows):
//                    completion(.success(rows))
//                case .failure(let error):
//                    print("Query failed: \(error.localizedDescription)")
//                    completion(.failure(error))
//                }
//                _ = connection.close()
//            }
//        }
//
//        getConnection().whenFailure { error in
//            print("Connection failed: \(error.localizedDescription)")
//            completion(.failure(error))
//        }
//    }
//
//    /// Executes a write operation (INSERT, UPDATE, DELETE) and handles the result.
//    ///
//    /// - Parameters:
//    ///   - query: The SQL query string to execute.
//    ///   - completion: A closure that indicates success or failure.
//    func executeWrite(_ query: String, completion: @escaping (Result<Void, Error>) -> Void) {
//        getConnection().whenSuccess { connection in
//            connection.simpleQuery(query).whenComplete { result in
//                _ = connection.close()
//                switch result {
//                case .success:
//                    completion(.success(()))
//                case .failure(let error):
//                    print("Write operation failed: \(error.localizedDescription)")
//                    completion(.failure(error))
//                }
//            }
//        }
//
//        getConnection().whenFailure { error in
//            print("Connection failed: \(error.localizedDescription)")
//            completion(.failure(error))
//        }
//    }
//
//    // MARK: - Debugging
//    /// Prints the result of a test query for debugging purposes.
//    func testConnectionAndQuery() {
//        let testQuery = "SELECT * FROM Rooms"
//        query(testQuery) { result in
//            switch result {
//            case .success(let rows):
//                print("Test Query Successful:")
//                for row in rows {
//                    print(row)
//                }
//            case .failure(let error):
//                print("Test Query Failed: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    // MARK: - Deinitialization
//    deinit {
//        do {
//            try eventLoopGroup.syncShutdownGracefully()
//        } catch {
//            print("Error shutting down EventLoopGroup: \(error.localizedDescription)")
//        }
//    }
//}
