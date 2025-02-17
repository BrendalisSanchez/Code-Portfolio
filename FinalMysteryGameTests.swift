// FinalMysteryGameTests.swift
/// Unit tests for verifying the functionality of the Final Brendalis Mystery Game.
//
// Project: Final Brendalis Mystery Game
/// Created by Brendalis Sanchez on 11/3/24.
/// Last updated by Brendalis Sanchez on 12/1/24.
//

import XCTest
// import MySQLNIO
// import NIO

@testable import FinalMysteryGame

final class FinalMysteryGameTests: XCTestCase {

    /**
     * Tests the initialization of a Room object.
     */
    func testRoomInitialization() {
        let room = Room(id: 1, name: "Library", description: "A room full of books.", clues: ["Key"], suspect: "The Butler")
        
        XCTAssertEqual(room.name, "Library")
        XCTAssertEqual(room.description, "A room full of books.")
        XCTAssertEqual(room.clues, ["Key"])
        XCTAssertEqual(room.suspect, "The Butler")
    }

    /**
     * Tests the functionality of collecting a clue in a room.
     */
    func testGetClue() {
        let room = Room(id: 1, name: "Library", description: "A quiet place", clues: ["Key"], suspect: nil)
        let gameState = GameState(inventory: Set(), requiredClues: ["Key"], userId: 1, currentRoom: room, collectedClues: [])
        let mysteryGame = MysteryGame()
        mysteryGame.currentRoom = room
        mysteryGame.gameState = gameState
        
        mysteryGame.getClue()
        
        XCTAssertTrue(mysteryGame.gameState.inventory.contains("Key"))
        XCTAssertEqual(mysteryGame.currentRoom?.clues, [])
    }

    /**
     * Tests player movement between rooms.
     */
    func testMoveFunction() {
        let entrance = Room(id: 1, name: "Entrance", description: "The starting point", clues: [], suspect: nil)
        let library = Room(id: 2, name: "Library", description: "A room full of books", clues: [], suspect: nil)
        let kitchen = Room(id: 3, name: "Kitchen", description: "A place to cook", clues: [], suspect: nil)

        RoomGraph.shared.preloadConnections { _ in
            RoomGraph.shared.connectRooms(from: entrance.id, to: library.id)
            RoomGraph.shared.connectRooms(from: library.id, to: kitchen.id)
        }

        let mysteryGame = MysteryGame()
        mysteryGame.rooms = [1: entrance, 2: library, 3: kitchen]
        mysteryGame.currentRoom = entrance
        
        mysteryGame.move(to: "Library")
        XCTAssertEqual(mysteryGame.currentRoom?.name, "Library")
        
        mysteryGame.move(to: "Kitchen")
        XCTAssertEqual(mysteryGame.currentRoom?.name, "Kitchen")
        
        mysteryGame.move(to: "Ballroom")
        XCTAssertEqual(mysteryGame.currentRoom?.name, "Kitchen")
    }

    /**
     * Tests encountering the murderer with all required clues.
     */
    func testEncounterMurdererWithClues() {
        let room = Room(id: 4, name: "Ballroom", description: "A large room", clues: [], suspect: "The Murderer")
        let gameState = GameState(inventory: Set(["Key", "Knife", "Fingerprint"]), requiredClues: ["Key", "Knife", "Fingerprint"], userId: 1, currentRoom: room, collectedClues: ["Key", "Knife", "Fingerprint"])
        let mysteryGame = MysteryGame()
        mysteryGame.gameState = gameState
        mysteryGame.currentRoom = room

        let result = mysteryGame.gameState.checkWinLoss(isMurdererFound: true)
        
        XCTAssertTrue(result)
        XCTAssertTrue(mysteryGame.gameState.gameOver)
    }

    /**
     * Tests encountering the murderer without all required clues.
     */
    func testEncounterMurdererWithoutClues() {
        let room = Room(id: 5, name: "Ballroom", description: "A large room", clues: [], suspect: "The Murderer")
        let gameState = GameState(inventory: Set(), requiredClues: ["Key", "Knife", "Fingerprint"], userId: 1, currentRoom: room, collectedClues: [])
        let mysteryGame = MysteryGame()
        mysteryGame.gameState = gameState
        mysteryGame.currentRoom = room

        let result = mysteryGame.gameState.checkWinLoss(isMurdererFound: true)
        
        XCTAssertTrue(result)
        XCTAssertTrue(mysteryGame.gameState.gameOver)
    }

    /**
     * Tests the save and load progress functionality.
     */
    func testSaveAndLoadProgress() {
        let room = Room(id: 1, name: "Hall", description: "A grand hall.", clues: [], suspect: nil)
        let gameState = GameState(inventory: Set(["Key"]), requiredClues: ["Key", "Knife", "Fingerprint"], userId: 1, currentRoom: room, collectedClues: ["Key"])
        gameState.saveProgress()
        
        GameState.loadProgress(for: 1) { loadedState in
            DispatchQueue.main.async {
                XCTAssertEqual(loadedState?.userId, 1)
                XCTAssertEqual(loadedState?.collectedClues, ["Key"])
            }
        }
    }

    /**
     * Tests the restart game functionality.
     */
    func testRestartGame() {
        let mysteryGame = MysteryGame()
        mysteryGame.gameState.inventory = Set(["Key", "Knife", "Fingerprint"])
        mysteryGame.restartGame()
        
        XCTAssertFalse(mysteryGame.gameStarted)
        XCTAssertTrue(mysteryGame.gameState.inventory.isEmpty)
        XCTAssertNil(mysteryGame.currentRoom)
    }

    /**
     * Tests quitting the game.
     */
    func testQuitGame() {
        let mysteryGame = MysteryGame()
        mysteryGame.quitGame()
        
        XCTAssertTrue(mysteryGame.gameState.gameOver)
        XCTAssertEqual(mysteryGame.feedbackMessage, "Thank you for playing! Please restart the app to play again.")
    }

    /**
     * Tests RoomGraph connections and pathfinding.
     */
    func testRoomGraphFunctionality() {
        let graph = RoomGraph.shared
        graph.preloadConnections { _ in
            graph.connectRooms(from: 1, to: 2)
            graph.connectRooms(from: 2, to: 3)
        }
        
        XCTAssertTrue(graph.isConnected(from: 1, to: 2))
        XCTAssertTrue(graph.isConnected(from: 2, to: 3))
        XCTAssertFalse(graph.isConnected(from: 1, to: 3))
    }
}






//
//  FinalMysteryGameTests.swift
//  FinalMysteryGameTests
//
/// Created by Brendalis Sanchez on 11/3/24.
/// Last updated by Brendalis Sanchez on 12/15/24.

//import XCTest
//@testable import FinalMysteryGame
//
//final class FinalMysteryGameTests: XCTestCase {
//
//        // MARK: - RoomGraph Tests
//
//        func testRoomGraphConnections() {
//            let roomGraph = RoomGraph.shared
//
//            // Test adding connections
//            roomGraph.connectRooms(from: 1, to: 2)
//            XCTAssertTrue(roomGraph.isConnected(from: 1, to: 2), "Room 1 and 2 should be connected.")
//            XCTAssertTrue(roomGraph.isConnected(from: 2, to: 1), "Room 2 and 1 should be connected (bidirectional).")
//
//            // Test no connection
//            XCTAssertFalse(roomGraph.isConnected(from: 1, to: 3), "Room 1 and 3 should not be connected.")
//
//            // Test shortest path
//            roomGraph.connectRooms(from: 2, to: 3)
//            let path = roomGraph.findShortestPath(from: 1, to: 3)
//            XCTAssertEqual(path, [1, 2, 3], "The shortest path from Room 1 to Room 3 should be [1, 2, 3].")
//
//            // Test no path
//            let noPath = roomGraph.findShortestPath(from: 1, to: 4)
//            XCTAssertTrue(noPath.isEmpty, "There should be no path from Room 1 to Room 4.")
//        }
//
//        // MARK: - MysteryGame Tests
//
//        func testMysteryGameStart() {
//            let mysteryGame = MysteryGame()
//            mysteryGame.startGame()
//
//            XCTAssertTrue(mysteryGame.gameStarted, "The game should be started.")
//            XCTAssertEqual(mysteryGame.feedbackMessage, """
//            Welcome to the game!
//            Collect all the clues and find the murderer!
//            Use commands like 'move library', 'get clue', or 'interrogate'.
//            """, "Feedback message should welcome the player.")
//        }
//
//    /*
//        func testMysteryGameMove() {
//            let mysteryGame = MysteryGame()
//
//            // Mock rooms
//            let entrance = Room(id: 1, name: "Entrance", description: "Start room", clues: [], suspect: nil)
//            let library = Room(id: 2, name: "Library", description: "Room with books", clues: [], suspect: nil)
//
//            mysteryGame.rooms = ["Entrance": entrance, "Library": library]
//            mysteryGame.currentRoom = entrance
//
//            // Connect rooms
//            RoomGraph.shared.connectRooms(from: 1, to: 2)
//            RoomGraph.shared.printGraph()
//
//            // Move to Library
//            mysteryGame.userCommand = "move library"
//            mysteryGame.processCommand()
//
//            XCTAssertEqual(mysteryGame.currentRoom?.name, "Library", "The player should move to the Library.")
//            XCTAssertEqual(mysteryGame.feedbackMessage, "You moved to Library.", "Feedback should confirm the move.")
//        }
//     */
//    func testMysteryGameMove() {
//        let mysteryGame = MysteryGame()
//
//        // Mock rooms
//        let entrance = Room(id: 1, name: "Entrance", description: "Start room", clues: [], suspect: nil)
//        let library = Room(id: 2, name: "Library", description: "Room with books", clues: [], suspect: nil)
//
//        mysteryGame.rooms = ["Entrance": entrance, "Library": library]
//        mysteryGame.currentRoom = entrance
//
//        // Connect rooms
//        RoomGraph.shared.connectRooms(from: 1, to: 2)
//        RoomGraph.shared.printGraph() // Debug connections
//
//        // Move to Library
//        mysteryGame.userCommand = "move library"
//        mysteryGame.processCommand()
//
//        // Assertions
//        XCTAssertEqual(mysteryGame.currentRoom?.name, "Library", "The player should move to the Library.")
//        XCTAssertEqual(mysteryGame.feedbackMessage, "You moved to Library.", "Feedback should confirm the move.")
//    }
//
//
//        func testMysteryGameCollectClue() {
//            let mysteryGame = MysteryGame()
//
//            // Mock room with a clue
//            let entrance = Room(id: 1, name: "Entrance", description: "Start room", clues: ["Key"], suspect: nil)
//            mysteryGame.rooms = ["Entrance": entrance]
//            mysteryGame.currentRoom = entrance
//
//            // Collect clue
//            mysteryGame.userCommand = "get clue"
//            mysteryGame.processCommand()
//
//            XCTAssertTrue(mysteryGame.inventory.contains("Key"), "The inventory should contain the collected clue 'Key'.")
//            XCTAssertEqual(mysteryGame.feedbackMessage, "You collected the clue: Key.", "Feedback should confirm clue collection.")
//        }
//
//        func testMysteryGameInterrogate() {
//            let mysteryGame = MysteryGame()
//
//            // Mock room with a suspect
//            let library = Room(id: 1, name: "Library", description: "Room with books", clues: [], suspect: "The Murderer")
//            mysteryGame.rooms = ["Library": library]
//            mysteryGame.currentRoom = library
//            mysteryGame.inventory = ["Key", "Knife", "Fingerprint"]
//
//            // Interrogate
//            mysteryGame.userCommand = "interrogate"
//            mysteryGame.processCommand()
//
//            XCTAssertTrue(mysteryGame.gameOver, "The game should end after successfully identifying the murderer.")
//            XCTAssertEqual(mysteryGame.feedbackMessage, "Congratulations! You found the murderer and solved the case!", "Feedback should confirm victory.")
//        }
//
//        // MARK: - GameState Tests
//
//        func testGameStateWinCondition() {
//            let mockRoom = Room(id: 1, name: "Entrance", description: "Start room", clues: [], suspect: nil)
//            let gameState = GameState(userId: 1, currentRoom: mockRoom, requiredClues: ["Key", "Knife", "Fingerprint"])
//
//            gameState.inventory = ["Key", "Knife", "Fingerprint"]
//            let won = gameState.checkWinLoss(isMurdererFound: true)
//
//            XCTAssertTrue(won, "The player should win when all required clues are collected and the murderer is found.")
//        }
//
//        func testGameStateSaveAndLoad() {
//            let mockRoom = Room(id: 1, name: "Entrance", description: "Start room", clues: [], suspect: nil)
//            let gameState = GameState(userId: 1, currentRoom: mockRoom, requiredClues: ["Key", "Knife", "Fingerprint"])
//
//            gameState.inventory = ["Key", "Knife"]
//            gameState.saveProgress()
//
//            GameState.loadProgress(for: 1) { loadedGameState in
//                XCTAssertNotNil(loadedGameState, "The loaded game state should not be nil.")
//                XCTAssertEqual(loadedGameState?.inventory, ["Key", "Knife"], "The inventory should match the saved progress.")
//            }
//        }
//
//        // MARK: - DatabaseManager Tests
//
//        func testDatabaseManagerQuery() {
//            let expectation = XCTestExpectation(description: "Database query should succeed.")
//
//            DatabaseManager.shared.query("SELECT * FROM Rooms") { result in
//                switch result {
//                case .success(let rows):
//                    XCTAssertFalse(rows.isEmpty, "Query should return at least one row.")
//                    expectation.fulfill()
//                case .failure(let error):
//                    XCTFail("Query failed: \(error.localizedDescription)")
//                }
//            }
//
//            wait(for: [expectation], timeout: 5.0)
//        }
//    }
//
