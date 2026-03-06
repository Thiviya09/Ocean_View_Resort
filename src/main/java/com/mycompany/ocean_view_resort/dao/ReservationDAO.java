///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
// */
//package com.mycompany.ocean_view_resort.dao;
//
///**
// *
// * @author thiviya
// */
//import com.mycompany.ocean_view_resort.model.*;
//import com.mycompany.ocean_view_resort.model.Reservation;
//import com.mycompany.ocean_view_resort.util.DBConnection;
//import java.sql.*;
//import java.time.LocalDate;
//import java.util.*;
//
//public class ReservationDAO {
//
//    public void saveReservation(Reservation r) {
//
//        String sql = "INSERT INTO reservations " +
//                "(guest_id, room_id, check_in, check_out, total_amount, status) " +
//                "VALUES (?,?,?,?,?,?)";
//
//        try (Connection con = DBConnection.getConnection();
//             PreparedStatement ps = con.prepareStatement(sql)) {
//
//            ps.setInt(1, r.getGuestId());
//            ps.setInt(2, r.getRoomId());
//            ps.setDate(3, DateAdapter.toSqlDate(r.getCheckIn()));
//            ps.setDate(4, DateAdapter.toSqlDate(r.getCheckOut()));
//            ps.setDouble(5, r.getTotalAmount());
//            ps.setString(6, r.getStatus());
//
//            ps.executeUpdate();
//
//        } catch (Exception e) { e.printStackTrace(); }
//    }
//
//    public boolean isRoomAvailable(int roomId, LocalDate checkIn, LocalDate checkOut) {
//    // The query is actually correct for overlapping dates: 
//    // A conflict exists if (ExistingCheckIn < NewCheckOut) AND (ExistingCheckOut > NewCheckIn)
//    String sql = "SELECT COUNT(*) FROM reservations " +
//                 "WHERE room_id = ? AND status = 'CONFIRMED' " +
//                 "AND check_in < ? AND check_out > ?";
//
//    try (Connection con = DBConnection.getConnection();
//         PreparedStatement ps = con.prepareStatement(sql)) {
//
//        ps.setInt(1, roomId);
//        ps.setDate(2, java.sql.Date.valueOf(checkOut)); // Using standard LocalDate to SQL Date
//        ps.setDate(3, java.sql.Date.valueOf(checkIn));
//
//        try (ResultSet rs = ps.executeQuery()) {
//            if (rs.next()) {
//                int count = rs.getInt(1);
//                System.out.println("Conflict count for room " + roomId + ": " + count);
//                return count == 0; // If 0, room is available!
//            }
//        }
//    } catch (Exception e) { 
//        System.err.println("Error in isRoomAvailable: " + e.getMessage());
//        e.printStackTrace(); 
//        // If the DB fails, we usually return false for safety, 
//        // but let's make sure we see the error in the console!
//    }
//
//    return false; 
//}
//
//    public List<Reservation> getAllReservations() {
//
//        List<Reservation> list = new ArrayList<>();
//        String sql = "SELECT * FROM reservations";
//
//        try (Connection con = DBConnection.getConnection();
//             PreparedStatement ps = con.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//
//            while (rs.next()) {
//
//                Reservation r = new Reservation();
//                r.setReservationId(rs.getInt("reservation_id"));
//                r.setGuestId(rs.getInt("guest_id"));
//                r.setRoomId(rs.getInt("room_id"));
//                r.setCheckIn(rs.getDate("check_in").toLocalDate());
//                r.setCheckOut(rs.getDate("check_out").toLocalDate());
//                r.setTotalAmount(rs.getDouble("total_amount"));
//                r.setStatus(rs.getString("status"));
//
//                list.add(r);
//            }
//
//        } catch (Exception e) { e.printStackTrace(); }
//
//        return list;
//    }
//
//    public void cancelReservation(int reservationId) {
//
//        String sql = "UPDATE reservations SET status='CANCELLED' WHERE reservation_id=?";
//
//        try (Connection con = DBConnection.getConnection();
//             PreparedStatement ps = con.prepareStatement(sql)) {
//
//            ps.setInt(1, reservationId);
//            ps.executeUpdate();
//
//        } catch (Exception e) { e.printStackTrace(); }
//    }
//    
//    public List<LocalDate[]> getBookedDateRanges(int roomId) {
//    List<LocalDate[]> ranges = new ArrayList<>();
//
//    String sql = "SELECT check_in, check_out FROM reservations " +
//                 "WHERE room_id=? AND status='CONFIRMED'";
//
//    try (Connection con = DBConnection.getConnection();
//         PreparedStatement ps = con.prepareStatement(sql)) {
//
//        ps.setInt(1, roomId);
//        ResultSet rs = ps.executeQuery();
//
//        while (rs.next()) {
//            LocalDate in = rs.getDate("check_in").toLocalDate();
//            LocalDate out = rs.getDate("check_out").toLocalDate();
//            ranges.add(new LocalDate[]{in, out});
//        }
//
//    } catch (Exception e) {
//        e.printStackTrace();
//    }
//
//    return ranges;
//}
//}

package com.mycompany.ocean_view_resort.dao;

import com.mycompany.ocean_view_resort.model.Reservation;
import com.mycompany.ocean_view_resort.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    public boolean isRoomAvailable(int roomId, LocalDate checkIn, LocalDate checkOut) {

        String sql = "SELECT COUNT(*) FROM reservations " +
                "WHERE room_id=? AND status='CONFIRMED' " +
                "AND (check_in < ? AND check_out > ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, roomId);
            ps.setDate(2, Date.valueOf(checkOut));
            ps.setDate(3, Date.valueOf(checkIn));

            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) == 0;

        } catch (Exception e) { e.printStackTrace(); }

        return false;
    }

    public void save(Reservation r) throws Exception {

        String sql = "INSERT INTO reservations " +
                "(guest_id, room_id, check_in, check_out, total_amount, status) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, r.getGuestId());
            ps.setInt(2, r.getRoomId());
            ps.setDate(3, Date.valueOf(r.getCheckIn()));
            ps.setDate(4, Date.valueOf(r.getCheckOut()));
            ps.setDouble(5, r.getTotalAmount());
            ps.setString(6, r.getStatus());

            ps.executeUpdate();
        }
    }

    public List<Reservation> findAll() {

        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM reservations";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Reservation r = new Reservation();
                r.setReservationId(rs.getInt("reservation_id"));
                r.setGuestId(rs.getInt("guest_id"));
                r.setRoomId(rs.getInt("room_id"));
                r.setCheckIn(rs.getDate("check_in").toLocalDate());
                r.setCheckOut(rs.getDate("check_out").toLocalDate());
                r.setTotalAmount(rs.getDouble("total_amount"));
                r.setStatus(rs.getString("status"));
                list.add(r);
            }

        } catch (Exception e) { e.printStackTrace(); }

        return list;
    }
public boolean update(Reservation r) {
    // Ensure every field has a comma between it and the next one
    String sql = "UPDATE reservations SET check_in=?, check_out=?, total_amount=?, guest_id=?, room_id=?, status=? WHERE reservation_id=?";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setDate(1, java.sql.Date.valueOf(r.getCheckIn()));
        ps.setDate(2, java.sql.Date.valueOf(r.getCheckOut()));
        ps.setDouble(3, r.getTotalAmount());
        ps.setInt(4, r.getGuestId());
        ps.setInt(5, r.getRoomId());
        ps.setString(6, r.getStatus());
        ps.setInt(7, r.getReservationId());

        int rowsAffected = ps.executeUpdate();
        return rowsAffected > 0;

    } catch (SQLException e) { 
        // Log the specific SQL error to the console
        System.err.println("SQL Error during update: " + e.getMessage());
        e.printStackTrace(); 
    }
    return false;
}
    public boolean delete(int id) {

        String sql = "DELETE FROM reservations WHERE reservation_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }

        return false;
    }

    public List<LocalDate[]> getBookedDateRanges(int roomId) {

        List<LocalDate[]> ranges = new ArrayList<>();

        String sql = "SELECT check_in, check_out FROM reservations " +
                "WHERE room_id=? AND status='CONFIRMED'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                LocalDate in = rs.getDate("check_in").toLocalDate();
                LocalDate out = rs.getDate("check_out").toLocalDate();
                ranges.add(new LocalDate[]{in, out});
            }

        } catch (Exception e) { e.printStackTrace(); }

        return ranges;
    }
    
    public boolean isRoomAvailableForUpdate(int roomId, LocalDate checkIn, LocalDate checkOut, int reservationId) {
    // Optimized SQL to check for overlaps
    String sql = "SELECT COUNT(*) FROM reservations " +
                 "WHERE room_id = ? " +
                 "AND reservation_id <> ? " + 
                 "AND status <> 'CANCELLED' " +
                 "AND (check_in < ? AND check_out > ?)"; // Simplified overlap logic
                 
    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setInt(1, roomId);
        ps.setInt(2, reservationId);
        // An overlap exists if: ExistingCheckIn < NewCheckOut AND ExistingCheckOut > NewCheckIn
        ps.setDate(3, java.sql.Date.valueOf(checkOut));
        ps.setDate(4, java.sql.Date.valueOf(checkIn));
        
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            // If count is 0, it means no OTHER reservation conflicts with these dates
            return rs.getInt(1) == 0;
        }
    } catch (Exception e) { 
        e.printStackTrace(); 
    }
    return false;
}
}