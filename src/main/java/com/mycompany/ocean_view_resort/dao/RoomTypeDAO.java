/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ocean_view_resort.dao;

import com.mycompany.ocean_view_resort.model.RoomType;
import com.mycompany.ocean_view_resort.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
//public class RoomTypeDAO {
//    public List<String> getAllRoomTypes() throws SQLException{
//        List<String> types = new ArrayList<>();
//        String sql = "SELECT type_name FROM room_types";
//        try (Connection con = DBConnection.getConnection();
//             PreparedStatement pst = con.prepareStatement(sql);
//             ResultSet rs = pst.executeQuery()) {
//
//            while (rs.next()) {
//                types.add(rs.getString("type_name"));
//            }
//
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return types;
//    }
//    
//    public void addRoomType(String typeName) throws SQLException {
//        Connection con = DBConnection.getConnection();
//        String sql = "INSERT INTO room_types(type_name) VALUES(?)";
//        PreparedStatement pst = con.prepareStatement(sql);
//        pst.setString(1, typeName);
//        pst.executeUpdate();
//    }
//
//    public void updateRoomType(int id, String typeName) throws SQLException {
//        Connection con = DBConnection.getConnection();
//        String sql = "UPDATE room_types SET type_name=? WHERE id=?";
//        PreparedStatement pst = con.prepareStatement(sql);
//        pst.setString(1, typeName);
//        pst.setInt(2, id);
//        pst.executeUpdate();
//    }
//
//    public void deleteRoomType(int id) throws SQLException {
//        Connection con = DBConnection.getConnection();
//        String sql = "DELETE FROM room_types WHERE id=?";
//        PreparedStatement pst = con.prepareStatement(sql);
//        pst.setInt(1, id);
//        pst.executeUpdate();
//    }
//}

public class RoomTypeDAO {

    public List<RoomType> getAllRoomTypes() {

        List<RoomType> list = new ArrayList<>();
        String sql = "SELECT * FROM room_types";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new RoomType(
                        rs.getInt("id"),
                        rs.getString("type_name"),
                        rs.getInt("capacity")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean addRoomType(RoomType type) {

        String sql = "INSERT INTO room_types (type_name, capacity) VALUES (?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, type.getTypeName());
            ps.setInt(2, type.getCapacity());
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateRoomType(RoomType type) {

        String sql = "UPDATE room_types SET type_name=?, capacity=? WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, type.getTypeName());
            ps.setInt(2, type.getCapacity());
            ps.setInt(3, type.getTypeId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteRoomType(int id) {

        String checkSql = "SELECT COUNT(*) FROM rooms WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement check = con.prepareStatement(checkSql)) {

            check.setInt(1, id);
            ResultSet rs = check.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                return false;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        String sql = "DELETE FROM room_types WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}