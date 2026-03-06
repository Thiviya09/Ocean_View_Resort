/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ocean_view_resort.dao;

/**
 *
 * @author thiviya
 */
import com.mycompany.ocean_view_resort.model.Guest;
import com.mycompany.ocean_view_resort.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GuestDAO {
    
    public List<Guest> getAllGuests() throws SQLException {
    List<Guest> list = new ArrayList<>();
    Connection con = DBConnection.getConnection();
    String sql = "SELECT * FROM guests";
    PreparedStatement pst = con.prepareStatement(sql);
    ResultSet rs = pst.executeQuery();

    while (rs.next()) {
        Guest g = new Guest();
        g.setId(rs.getInt("guestId"));
        g.setGuestName(rs.getString("guestName"));
        g.setAddress(rs.getString("address"));
        g.setContactNumber(rs.getString("contact_number"));
        g.setEmail(rs.getString("email"));
        list.add(g);
    }
    return list;
}

    
    public boolean addGuest(Guest g) throws Exception {

    String sql = "INSERT INTO guests (guestName, address, contact_number, email) VALUES (?, ?, ?, ?)";

    Connection con = DBConnection.getConnection();
    try(PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);){
        ps.setString(1, g.getGuestName());
        ps.setString(2, g.getAddress());
        ps.setString(3, g.getContactNumber());
        ps.setString(4, g.getEmail());

        int rows = ps.executeUpdate();

//        ResultSet rs = ps.getGeneratedKeys();
//        if (rs.next()) {
//            return rs.getInt(1);
//        }
        return rows >0;
    } catch (Exception e){
        e.printStackTrace();
        return false;
    }
//    PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

}

    
    public boolean updateGuest(Guest g) throws SQLException {
    Connection con = DBConnection.getConnection();
    String sql = "UPDATE guests SET guestName=?, address=?, contact_number=?, email=? WHERE guestId=?";
    try(PreparedStatement pst = con.prepareStatement(sql);){
        
        pst.setString(1, g.getGuestName());
        pst.setString(2, g.getAddress());
        pst.setString(3, g.getContactNumber());
        pst.setString(4, g.getEmail());
        pst.setInt(5, g.getId());
        int rows = pst.executeUpdate();
        return rows>0;
    } catch (Exception e){
        e.printStackTrace();
        return false;
    }
    
}

    
    public boolean deleteGuest(int guestId) throws SQLException {
    Connection con = DBConnection.getConnection();
    String sql = "DELETE FROM guests WHERE guestId=?";
    try(PreparedStatement pst = con.prepareStatement(sql);){
        pst.setInt(1, guestId);
        int rows = pst.executeUpdate();
        return rows>0;
    }
    
}


    public Guest getGuestById(int guestId) throws SQLException {
        Connection con = DBConnection.getConnection();
        String sql = "SELECT * FROM guests WHERE guestId=?";
        PreparedStatement pst = con.prepareStatement(sql);
        pst.setInt(1, guestId);
        ResultSet rs = pst.executeQuery();
        if(rs.next()){
            Guest g = new Guest();
            g.setId(rs.getInt("guestId"));
            g.setGuestName(rs.getString("guestName"));
            g.setAddress(rs.getString("address"));
            g.setContactNumber(rs.getString("contact_number"));
            g.setEmail(rs.getString("email"));
            return g;
        }
        return null;
    }
    
    public Guest getGuestByBillId(int billId) {
    Connection con = DBConnection.getConnection();
    Guest g = null;
    String sql = "SELECT g.* FROM guests g " +
                 "JOIN reservations r ON g.guestId = r.guest_id " +
                 "JOIN bills b ON r.reservation_id = b.reservation_id " +
                 "WHERE b.bill_id = ?";
    try(PreparedStatement pst = con.prepareStatement(sql);){
        pst.setInt(1, billId);
        ResultSet rs = pst.executeQuery();
        if(rs.next()){
            g = new Guest();
            g.setId(rs.getInt("guestId"));
            g.setGuestName(rs.getString("guestName"));
            g.setAddress(rs.getString("address"));
            g.setContactNumber(rs.getString("contact_number"));
            g.setEmail(rs.getString("email"));
            
        }
    } catch(Exception e){
        e.printStackTrace();
    }
    return g;
}
}
