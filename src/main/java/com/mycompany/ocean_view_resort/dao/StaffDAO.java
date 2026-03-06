package com.mycompany.ocean_view_resort.dao;

import com.mycompany.ocean_view_resort.model.Staff;
import com.mycompany.ocean_view_resort.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StaffDAO {

    public List<Staff> getAllStaff() throws SQLException {
        List<Staff> list = new ArrayList<>();
        Connection con = DBConnection.getConnection();
        String sql = "SELECT * FROM users";
        PreparedStatement pst = con.prepareStatement(sql);
        ResultSet rs = pst.executeQuery();
        while(rs.next()){
            Staff s = new Staff();
            s.setId(rs.getInt("id"));
            s.setUsername(rs.getString("username"));
            s.setPassword(rs.getString("password"));
            s.setRole(rs.getString("role"));
            s.setFullname(rs.getString("fullname"));
            s.setContact(rs.getString("contact"));
            s.setEmail(rs.getString("email"));
            list.add(s);
        }
        return list;
    }

    public void addStaff(Staff s) throws SQLException {
        Connection con = DBConnection.getConnection();
        String sql = "INSERT INTO users(username,password,role,fullname,contact,email) VALUES(?,?,?,?,?,?)";
        PreparedStatement pst = con.prepareStatement(sql);
        pst.setString(1, s.getUsername());
        pst.setString(2, s.getPassword());
        pst.setString(3, s.getRole());
        pst.setString(4, s.getFullname());
        pst.setString(5, s.getContact());
        pst.setString(6, s.getEmail());
        pst.executeUpdate();
    }

    public void updateStaff(Staff s) throws SQLException {
        Connection con = DBConnection.getConnection();
        boolean isPasswordProvided = (s.getPassword() != null && !s.getPassword().trim().isEmpty());
    
        String sql;
        if (isPasswordProvided) {
            sql = "UPDATE users SET username=?, password=?, role=?, fullname=?, contact=?, email=? WHERE id=?";
        } else {
            sql = "UPDATE users SET username=?, role=?, fullname=?, contact=?, email=? WHERE id=?";
        }
//        String sql = "UPDATE users SET username=?, password=?, role=?, fullname=?, contact=?, email=? WHERE id=?";
        PreparedStatement pst = con.prepareStatement(sql);
        if (isPasswordProvided) {
        pst.setString(1, s.getUsername());
        pst.setString(2, s.getPassword());
        pst.setString(3, s.getRole());
        pst.setString(4, s.getFullname());
        pst.setString(5, s.getContact());
        pst.setString(6, s.getEmail());
        pst.setInt(7, s.getId());
    } else {
        pst.setString(1, s.getUsername());
        pst.setString(2, s.getRole());
        pst.setString(3, s.getFullname());
        pst.setString(4, s.getContact());
        pst.setString(5, s.getEmail());
        pst.setInt(6, s.getId());
    }
        pst.executeUpdate();
    }

    public void deleteStaff(int id) throws SQLException {
        Connection con = DBConnection.getConnection();
        String sql = "DELETE FROM users WHERE id=?";
        PreparedStatement pst = con.prepareStatement(sql);
        pst.setInt(1, id);
        pst.executeUpdate();
    }

    public Staff getStaffById(int id) throws SQLException {
        Connection con = DBConnection.getConnection();
        String sql = "SELECT * FROM users WHERE id=?";
        PreparedStatement pst = con.prepareStatement(sql);
        pst.setInt(1, id);
        ResultSet rs = pst.executeQuery();
        if(rs.next()){
            Staff s = new Staff();
            s.setId(rs.getInt("id"));
            s.setUsername(rs.getString("username"));
            s.setPassword(rs.getString("password"));
            s.setRole(rs.getString("role"));
            s.setFullname(rs.getString("fullname"));
            s.setContact(rs.getString("contact"));
            s.setEmail(rs.getString("email"));
            return s;
        }
        return null;
    }
}
