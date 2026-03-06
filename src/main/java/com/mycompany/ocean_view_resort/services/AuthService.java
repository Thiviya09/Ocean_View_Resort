package com.mycompany.ocean_view_resort.services;

import java.sql.*;
import com.mycompany.ocean_view_resort.model.Staff; // Assuming your User model is named Staff

public class AuthService {
    private String dbURL = "jdbc:mysql://localhost:3306/ocean_view_resort";
    private String dbUser = "root";
    private String dbPass = "";

    public Staff authenticate(String username, String password) {
        Staff user = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass)) {
                String sql = "SELECT * FROM users WHERE username=? AND password=?";
                PreparedStatement pst = con.prepareStatement(sql);
                pst.setString(1, username);
                pst.setString(2, password);
                
                ResultSet rs = pst.executeQuery();
                if (rs.next()) {
                    user = new Staff();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setRole(rs.getString("role"));
                    user.setFullname(rs.getString("fullname"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }
}