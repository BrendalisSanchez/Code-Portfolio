// Import necessary classes for handling lists, maps, and user input
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Scanner;

// Main class representing the Mystery Game
public class Main {

    // A map storing all rooms in the game, with room names as keys
    static HashMap<String, Room> rooms = new HashMap<>();

    // A map representing connections between rooms (i.e., which room leads to which)
    static HashMap<String, HashMap<String, String>> adjacency = new HashMap<>();

    // Variable to store the current room player is in
    static Room currentRoom;

    // List to store clues that the player collects
    static ArrayList<String> inventory = new ArrayList<>();

    // Main function: starting point of the game
    public static void main(String[] args) {
        // Initializing rooms and their connections
        initializeRooms();
        initializeAdjacency();
        // Setting the starting room as "Entrance Hall"
        currentRoom = rooms.get("Entrance Hall");

        // Print game introduction
        System.out.println("Welcome to the Sanchez Mystery Game! ");
        System.out.println("Your goal is to collect all clues and interogate all suspects to find the murderer!");
        System.out.println("Good luck! And stay safe! ");

        // Create a scanner object to get user inputs
        try (Scanner scanner = new Scanner(System.in)) {
            while (true) { // Game loop keeps running until a game-over condition is met
                // Display current location to player
                System.out.println("You are currently in the " + currentRoom.name + ".");
                // Ask the player for their next action
                System.out.print("What would you like to do? (Move/Get Clue/Interrogate/Quit) ");
                final String command = scanner.nextLine().toLowerCase(); // Convert the input to lowercase for easier comparison

                // Decide action based on player's command
                switch (command) {
                    case "move":
                        System.out.print("Which direction? (N/E/S/W) ");
                        final String direction = scanner.nextLine().toUpperCase(); // Convert direction to uppercase for comparison
                        move(direction); // Call the move function to handle movement logic
                        break;
                    case "get clue":
                        getClue(); // Call function to handle clue collection
                        break;
                    case "interrogate":
                        interrogate(); // Call function to handle suspect interrogation
                        break;
                    case "quit":
                        System.out.println("Thanks for playing! See you next time."); // End game message
                        return; // End the game loop and terminate the program
                    default:
                        System.out.println("Invalid command! Please try again."); // Inform player of invalid command
                }
            }
        }
    }

    // Function to initialize all rooms and their properties
    public static void initializeRooms() {
        rooms.put("Entrance Hall", new Room("Entrance Hall", null, null, null));
        rooms.put("Library", new Room("Library", "Bloody Knife", "The Butler", "Library's secret door location"));
        // ... [other rooms are similarly initialized]
    }

    // Function to define how rooms are connected
    public static void initializeAdjacency() {
        adjacency.put("Entrance Hall", new HashMap<String, String>() {
            {
                put("E", "Library");
                put("S", "Ballroom");
            }
        });
        // ... [other room connections are similarly defined]
    }

    // Function to move the player to a different room
    public static void move(final String direction) {
        // If the chosen direction is a valid exit from the current room
        if (adjacency.get(currentRoom.name).containsKey(direction)) {
            currentRoom = rooms.get(adjacency.get(currentRoom.name).get(direction)); // Update current room
            System.out.println("You are now in the " + currentRoom.name);
            // If the new room contains the murderer, handle game-over scenarios
            if ("The Murderer".equals(currentRoom.suspect)) {
                // Check if player has all clues
                if (inventory.size() == 6) {
                    System.out.println("Congratulations! You have confronted the murderer and solved the mystery!");
                    System.exit(0);
                } else {
                    System.out.println("You have encountered the murderer before collecting all clues. Game Over!");
                    System.exit(0);
                }
            }
        } else {
            System.out.println("You cannot go that way!"); // Inform player that chosen direction is invalid
        }
    }

    // Function to handle clue collection logic
    public static void getClue() {
        if (currentRoom.clue != null) { // If there's a clue in the current room
            inventory.add(currentRoom.clue); // Add the clue to the player's inventory
            System.out.println("You have collected the clue: " + currentRoom.clue);
            currentRoom.clue = null; // Remove the clue from the room
        } else {
            System.out.println("There is no clue in this room!"); // Inform player if no clue is present
        }
    }

    // Function to handle suspect interrogation logic
    public static void interrogate() {
        if (currentRoom.suspect != null) { // If there's a suspect in the current room
            System.out.println("You are interrogating " + currentRoom.suspect + ".");
            if (currentRoom.interrogationClue != null) { // If the suspect has a clue
                inventory.add(currentRoom.interrogationClue); // Add clue to player's inventory
                System.out.println("You obtained a clue from the interrogation: " + currentRoom.interrogationClue);
                currentRoom.interrogationClue = null; // Remove the clue from the suspect
            } else {
                System.out.println(currentRoom.suspect + " didn't reveal any clues."); // Inform player if suspect has no clue
            }
        } else {
            System.out.println("There is no one to interrogate in this room!"); // Inform player if no suspect is present
        }
    }
}

// Class defining the properties of a room in the game
class Room {
    String name; // Room's name
    String clue; // Clue present in the room (if any)
    String suspect; // Suspect present in the room (if any)
    String interrogationClue; // Clue obtained from suspect (if any)

    // Constructor to create a new room object with specified properties
    public Room(final String name, final String clue, final String suspect, final String interrogationClue) {
        this.name = name;
        this.clue = clue;
        this.suspect = suspect;
        this.interrogationClue = interrogationClue;
    }
}