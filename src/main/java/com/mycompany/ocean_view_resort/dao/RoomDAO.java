//package com.mycompany.ocean_view_resort.dao;
//
//import com.mycompany.ocean_view_resort.model.Room;
//import com.mycompany.ocean_view_resort.util.DBConnection;
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//
//public class RoomDAO {
//    private Connection con;
////
//    public RoomDAO(){
//    try {
//        Class.forName("com.mysql.cj.jdbc.Driver");
//        this.con = DriverManager.getConnection(
//            "jdbc:mysql://localhost:3306/ocean_view_resort",
//            "root",
//            ""
//        );
//    } catch(Exception e) {
//        e.printStackTrace();
//    }
//}
//
////     Connection conn= DBConnection.getConnection();
//    Connection conn = DBConnection.getConnection();
//
//    // Add Room
//    public boolean addRoom(Room room){
//        System.out.println("Connection inside addRoom: " + conn);
//        Connection conn = DBConnection.getConnection();
//        String sql = "INSERT INTO rooms (room_number, room_type, ac_type, price_per_night, image_path, status) VALUES (?,?,?,?,?,?)";
//        try (PreparedStatement pst = conn.prepareStatement(sql)) {
//            pst.setString(1, room.getRoomNumber());
//            pst.setString(2, room.getRoomType());
//            pst.setString(3, room.getAcType());
//            pst.setDouble(4, room.getPricePerNight());
//            if(room.getImagePath() != null){
//                pst.setString(5, room.getImagePath());
//            } else {
//                pst.setNull(5, java.sql.Types.VARCHAR);
//            }
//
//            pst.setString(6, room.getStatus());
//            int rows = pst.executeUpdate();
//            return rows > 0;
//        } catch(Exception e){
//            e.printStackTrace();
//            return false;
//        }
//    }
//
//    // Update Room
//    public boolean updateRoom(Room room){
//        String sql = "UPDATE rooms SET room_number=?, room_type=?, ac_type=?, price_per_night=?, image_path=?, status=? WHERE room_id=?";
//        try (PreparedStatement pst = conn.prepareStatement(sql)) {
//            pst.setString(1, room.getRoomNumber());
//            pst.setString(2, room.getRoomType());
//            pst.setString(3, room.getAcType());
//            pst.setDouble(4, room.getPricePerNight());
//            if(room.getImagePath() != null){
//                pst.setString(5, room.getImagePath());
//            } else {
//                pst.setNull(5, java.sql.Types.VARCHAR);
//            }
//
//            pst.setString(6, room.getStatus());
//            pst.setInt(7, room.getRoomId());
//            int rows = pst.executeUpdate();
//            return rows > 0;
//        } catch(Exception e){
//            e.printStackTrace();
//            return false;
//        }
//    }
//
//    // Delete Room
//    public boolean deleteRoom(int roomId){
//        String sql = "DELETE FROM rooms WHERE room_id=?";
//        try (PreparedStatement pst = conn.prepareStatement(sql)) {
//            pst.setInt(1, roomId);
//            int rows = pst.executeUpdate();
//            return rows > 0;
//        } catch(Exception e){
//            e.printStackTrace();
//            return false;
//        }
//    }
//
//    // Get single room
//    public Room getRoomById(int roomId){
//        Room room = null;
//        String sql = "SELECT * FROM rooms WHERE room_id=?";
//        try (PreparedStatement pst = conn.prepareStatement(sql)) {
//            pst.setInt(1, roomId);
//            ResultSet rs = pst.executeQuery();
//            if(rs.next()){
//                room = new Room();
//                room.setRoomId(rs.getInt("room_id"));
//                room.setRoomNumber(rs.getString("room_number"));
//                room.setRoomType(rs.getString("room_type"));
//                room.setAcType(rs.getString("ac_type"));
//                room.setPricePerNight(rs.getDouble("price_per_night"));
//                room.setImagePath(rs.getString("image_path"));
//                room.setStatus(rs.getString("status"));
//            }
//        } catch(Exception e){
//            e.printStackTrace();
//        }
//        return room;
//    }
//
//    // Get all rooms
////     public List<Room> getAllRooms() throws SQLException {
////        List<Room> list = new ArrayList<>();
////        String sql = "SELECT * FROM rooms";
////        PreparedStatement ps = conn.prepareStatement(sql);
////        ResultSet rs = ps.executeQuery();
////        while(rs.next()){
////            Room r = new Room(
////                rs.getInt("room_id"),
////                rs.getString("room_number"),
////                rs.getString("room_type"),
////                rs.getString("ac_type"),
////                rs.getDouble("price_per_night"),
////                rs.getString("status"),
////                rs.getString("image_path")
////            );
////            list.add(r);
////        }
////        return list;
////    }
//    public List<Room> getAllRooms() throws Exception {
//
//        List<Room> list = new ArrayList<>();
//
//        String sql = "SELECT r.*, rt.type_name, rt.capacity " +
//                "FROM rooms r " +
//                "JOIN room_types rt ON r.type_id = rt.type_id";
//
//        try(Connection con = DBConnection.getConnection();
//            PreparedStatement pst = con.prepareStatement(sql);
//            ResultSet rs = pst.executeQuery()) {
//
//            while(rs.next()) {
//
//                Room r = new Room();
//                r.setRoomId(rs.getInt("room_id"));
//                r.setRoomNumber(rs.getString("room_number"));
//                r.setTypeId(rs.getInt("type_id"));
//                r.setTypeName(rs.getString("type_name"));
//                r.setCapacity(rs.getInt("capacity"));
//                r.setAcType(rs.getString("ac_type"));
//                r.setPricePerNight(rs.getDouble("price_per_night"));
//                r.setStatus(rs.getString("status"));
//
//                list.add(r);
//            }
//        }
//        return list;
//    }
//
//    // Search rooms by number or type
//    public List<Room> searchRooms(String keyword){
//        List<Room> list = new ArrayList<>();
//        String sql = "SELECT * FROM rooms WHERE room_number LIKE ? OR room_type LIKE ?";
//        try (PreparedStatement pst = conn.prepareStatement(sql)) {
//            pst.setString(1, "%" + keyword + "%");
//            pst.setString(2, "%" + keyword + "%");
//            ResultSet rs = pst.executeQuery();
//            while(rs.next()){
//                Room room = new Room();
//                room.setRoomId(rs.getInt("room_id"));
//                room.setRoomNumber(rs.getString("room_number"));
//                room.setRoomType(rs.getString("room_type"));
//                room.setAcType(rs.getString("ac_type"));
//                room.setPricePerNight(rs.getDouble("price_per_night"));
//                room.setImagePath(rs.getString("image_path"));
//                room.setStatus(rs.getString("status"));
//                list.add(room);
//            }
//        } catch(Exception e){
//            e.printStackTrace();
//        }
//        return list;
//    }
//}
//
//
//
//
package com.mycompany.ocean_view_resort.dao;

import com.mycompany.ocean_view_resort.model.Room;
import com.mycompany.ocean_view_resort.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RoomDAO {

    public boolean addRoom(Room room) {

        String sql = "INSERT INTO rooms (room_number, type_id, ac_type, price_per_night, image_path, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, room.getRoomNumber());
            ps.setInt(2, room.getTypeId());
            ps.setString(3, room.getAcType());
            ps.setDouble(4, room.getPricePerNight());
            ps.setString(5, room.getImagePath());
            ps.setString(6, room.getStatus());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateRoom(Room room) {

        String sql = "UPDATE rooms SET room_number=?, type_id=?, ac_type=?, price_per_night=?, image_path=?, status=? WHERE room_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, room.getRoomNumber());
            ps.setInt(2, room.getTypeId());
            ps.setString(3, room.getAcType());
            ps.setDouble(4, room.getPricePerNight());
            ps.setString(5, room.getImagePath());
            ps.setString(6, room.getStatus());
            ps.setInt(7, room.getRoomId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteRoom(int id) {

        String sql = "DELETE FROM rooms WHERE room_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Room> getAllRooms() {

        List<Room> list = new ArrayList<>();

        String sql = "SELECT r.*, rt.type_name " +
                     "FROM rooms r " +
                     "JOIN room_types rt ON r.type_id = rt.id";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Room room = new Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setTypeId(rs.getInt("type_id"));
                room.setRoomType(rs.getString("type_name"));
                room.setAcType(rs.getString("ac_type"));
                room.setPricePerNight(rs.getDouble("price_per_night"));
                room.setImagePath(rs.getString("image_path"));
                room.setStatus(rs.getString("status"));

//                Map<String, Object> roomTypeData = new HashMap<>();
//                roomTypeData.put("typeName", rs.getString("type_name"));
//                roomTypeData.put("capacity", rs.getInt("capacity"));
//    
//                room.setExtraData(roomTypeData); 
                list.add(room);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Room getRoomById(int id) {

        String sql = "SELECT r.*, rt.* " +
                     "FROM rooms r " +
                     "JOIN room_types rt ON r.type_id = rt.id " +
                     "WHERE r.room_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Room room = new Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setTypeId(rs.getInt("type_id"));
                room.setRoomType(rs.getString("type_name"));
                room.setAcType(rs.getString("ac_type"));
                room.setPricePerNight(rs.getDouble("price_per_night"));
                room.setImagePath(rs.getString("image_path"));
                room.setStatus(rs.getString("status"));
                return room;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
    
public List<Room> searchRooms(String keyword) {

    List<Room> list = new ArrayList<>();

    String sql = "SELECT r.*, rt.type_name, rt.capacity " +
                 "FROM rooms r " +
                 "JOIN room_types rt ON r.type_id = rt.id " +
                 "WHERE r.room_number LIKE ? OR rt.type_name LIKE ?";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, "%" + keyword + "%");
        ps.setString(2, "%" + keyword + "%");

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Room room = new Room();

            room.setRoomId(rs.getInt("room_id"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setTypeId(rs.getInt("type_id"));
                room.setRoomType(rs.getString("type_name")); // From the JOIN
                room.setAcType(rs.getString("ac_type"));
                room.setPricePerNight(rs.getDouble("price_per_night"));
                room.setStatus(rs.getString("status"));
                room.setImagePath(rs.getString("image_path"));

            list.add(room);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}

public void updateRoomStatus(int roomId, String status) {

    String sql = "UPDATE rooms SET status = ? WHERE room_id = ?";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, status);
        ps.setInt(2, roomId);

        ps.executeUpdate();

    } catch (Exception e) {
        e.printStackTrace();
    }
}
}