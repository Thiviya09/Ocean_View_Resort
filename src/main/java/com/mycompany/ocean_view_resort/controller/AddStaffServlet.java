package com.mycompany.ocean_view_resort.controller;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.mycompany.ocean_view_resort.util.DBConnection;

//@WebServlet("/AddStaffServlet")
public class AddStaffServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String contact = request.getParameter("contact");

        try {
            Connection con = DBConnection.getConnection();

            String sql = "INSERT INTO users(username,password,role,fullname,email,contact) VALUES (?,?,?,?,?,?)";
            PreparedStatement pst = con.prepareStatement(sql);

            pst.setString(1, username);
            pst.setString(2, password);
            pst.setString(3, "staff");
            pst.setString(4, fullname);
            pst.setString(5, email);
            pst.setString(6, contact);

            pst.executeUpdate();

            HttpSession session = request.getSession();
            session.setAttribute("msg", "Staff added successfully!");

            con.close();

        } catch (SQLIntegrityConstraintViolationException e) {
            HttpSession session = request.getSession();
            session.setAttribute("msg", "Username already exists!");
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("admin_dashboard.jsp");
    }
}
