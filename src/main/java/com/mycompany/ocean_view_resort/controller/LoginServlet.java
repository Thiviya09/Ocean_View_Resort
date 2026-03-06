package com.mycompany.ocean_view_resort.controller;

import com.mycompany.ocean_view_resort.model.Staff;
import com.mycompany.ocean_view_resort.services.AuthService;
import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

//@WebServlet("/login")
public class LoginServlet extends HttpServlet {

//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String username = request.getParameter("username");
//        String password = request.getParameter("password");
//
//        try {
//            Class.forName("com.mysql.cj.jdbc.Driver");
//            Connection con = DriverManager.getConnection(
//                    "jdbc:mysql://localhost:3306/ocean_view_resort", "root", "");
//
//            PreparedStatement pst = con.prepareStatement(
//                    "SELECT * FROM users WHERE username=? AND password=?");
//            pst.setString(1, username);
//            pst.setString(2, password);
//
//            ResultSet rs = pst.executeQuery();
//
//            if (rs.next()) {
//                String role = rs.getString("role");
//
//                HttpSession session = request.getSession();
//                session.setAttribute("username", username);
//                session.setAttribute("role", role);
//
//                if ("admin".equals(role)) {
//                    response.sendRedirect("admin_dashboard.jsp");
//                } else {
//                    response.sendRedirect("staff_dashboard.jsp");
//                }
//            } else {
//                response.sendRedirect("index.jsp?error=1");
//            }
//
//            con.close();
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }

    private AuthService authService = new AuthService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String userParam = request.getParameter("username");
        String passParam = request.getParameter("password");

        Staff user = authService.authenticate(userParam, passParam);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user); // Store the whole object
            session.setAttribute("role", user.getRole());

            // Redirection Logic
            if ("admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("admin_dashboard.jsp");
            } else {
                response.sendRedirect("staff_dashboard.jsp");
            }
        } else {
            request.setAttribute("error", "Invalid Credentials. Please try again.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
}
