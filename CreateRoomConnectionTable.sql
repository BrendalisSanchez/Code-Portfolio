-- =============================================
-- Author: <Brendalis Sanchez>
-- Create date: <12/05/2024>
-- Description: <The table is used to define relationships or connections between rooms, creating a structure similar to a graph, where rooms are nodes and connections are edges.>
-- =============================================

 CREATE TABLE RoomConnection (
     id INT AUTO_INCREMENT PRIMARY KEY,
     room_id INT NOT NULL,                 -- Source room ID
     connected_room_id INT NOT NULL,       -- Destination room ID
     FOREIGN KEY (room_id) REFERENCES Room(id)
         ON DELETE CASCADE
         ON UPDATE CASCADE,
     FOREIGN KEY (connected_room_id) REFERENCES Room(id)
         ON DELETE CASCADE
         ON UPDATE CASCADE
 );
