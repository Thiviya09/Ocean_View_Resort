/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
//package com.mycompany.ocean_view_resort.controller;
//
//import java.io.IOException;
//import java.io.PrintWriter;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//
//
//import com.mycompany.ocean_view_resort.dao.StaffDAO;
//import com.mycompany.ocean_view_resort.model.Staff;
//import jakarta.servlet.*;
//import jakarta.servlet.http.*;
//
//public class StaffServlet extends HttpServlet {
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        HttpSession session = request.getSession();
//        String role = (String)session.getAttribute("role");
//
//        if(role == null || !"admin".equals(role)){
//            response.sendRedirect("index.jsp");
//            return;
//        }
//
//        String action = request.getParameter("action");
//        StaffDAO dao = new StaffDAO();
//
//        try {
//            if(action == null){
//                response.sendRedirect("manage_staff.jsp");
//                return;
//            }
//
//            switch(action){
//                case "edit":
//                    int editId = Integer.parseInt(request.getParameter("id"));
//                    Staff s = dao.getStaffById(editId);
//                    request.setAttribute("staff", s);
//                    RequestDispatcher rd = request.getRequestDispatcher("manage_staff.jsp");
//                    rd.forward(request, response);
//                    break;
//
//                case "delete":
//                    int deleteId = Integer.parseInt(request.getParameter("id"));
//                    dao.deleteStaff(deleteId);
//                    session.setAttribute("toastMessage","Staff deleted successfully!");
//                    session.setAttribute("toastType","success");
//                    response.sendRedirect("manage_staff.jsp");
//                    break;
//
//                default:
//                    response.sendRedirect("manage_staff.jsp");
//                    break;
//            }
//
//        } catch(Exception e){
//            e.printStackTrace();
//            session.setAttribute("toastMessage","Something went wrong!");
//            session.setAttribute("toastType","error");
//            response.sendRedirect("manage_staff.jsp");
//        }
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        HttpSession session = request.getSession();
//        String role = (String)session.getAttribute("role");
//
//        if(role == null || !"admin".equals(role)){
//            response.sendRedirect("index.jsp");
//            return;
//        }
//
//        String id = request.getParameter("id");
//        String username = request.getParameter("username");
//        String password = request.getParameter("password");
//        String staffRole = request.getParameter("role");
//        String fullname = request.getParameter("fullname");
//        String contact = request.getParameter("contact");
//        String email = request.getParameter("email");
//
//        Staff s = new Staff();
//        s.setUsername(username);
//        s.setPassword(password);
//        s.setRole(staffRole);
//        s.setFullname(fullname);
//        s.setContact(contact);
//        s.setEmail(email);
//
//        StaffDAO dao = new StaffDAO();
//
//        try{
//            if(id == null || id.isEmpty()){
//                dao.addStaff(s);
//                session.setAttribute("toastMessage","Staff added successfully!");
//                session.setAttribute("toastType","success");
//            } else {
//                s.setId(Integer.parseInt(id));
//                dao.updateStaff(s);
//                session.setAttribute("toastMessage","Staff updated successfully!");
//                session.setAttribute("toastType","success");
//            }
//        } catch(Exception e){
//            e.printStackTrace();
//            session.setAttribute("toastMessage","Something went wrong!");
//            session.setAttribute("toastType","error");
//        }
//
//        response.sendRedirect("manage_staff.jsp");
//    }
//}
package com.mycompany.ocean_view_resort.controller;

import com.mycompany.ocean_view_resort.dao.StaffDAO;
import com.mycompany.ocean_view_resort.factory.DAOFactory;
import com.mycompany.ocean_view_resort.model.Staff;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class StaffServlet extends HttpServlet {

    private StaffDAO staffDAO;

    @Override
    public void init() throws ServletException {
        // Get StaffDAO via DAOFactory
        staffDAO = DAOFactory.getStaffDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        if (role == null || !"admin".equals(role)) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            if (action == null) {
                response.sendRedirect("manage_staff.jsp");
                return;
            }

            switch (action) {
                case "edit":
                    int editId = Integer.parseInt(request.getParameter("id"));
                    Staff s = staffDAO.getStaffById(editId);
                    request.setAttribute("staff", s);
                    RequestDispatcher rd = request.getRequestDispatcher("manage_staff.jsp");
                    rd.forward(request, response);
                    break;

                case "delete":
                    int deleteId = Integer.parseInt(request.getParameter("id"));
                    staffDAO.deleteStaff(deleteId);
                    session.setAttribute("toastMessage", "Staff deleted successfully!");
                    session.setAttribute("toastType", "success");
                    response.sendRedirect("manage_staff.jsp");
                    break;

                default:
                    response.sendRedirect("manage_staff.jsp");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("toastMessage", "Something went wrong!");
            session.setAttribute("toastType", "error");
            response.sendRedirect("manage_staff.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        if (role == null || !"admin".equals(role)) {
            response.sendRedirect("index.jsp");
            return;
        }

        String id = request.getParameter("id");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String staffRole = request.getParameter("role");
        String fullname = request.getParameter("fullname");
        String contact = request.getParameter("contact");
        String email = request.getParameter("email");

        Staff s = new Staff();
        s.setUsername(username);
        s.setPassword(password);
        s.setRole(staffRole);
        s.setFullname(fullname);
        s.setContact(contact);
        s.setEmail(email);

        try {
            if (id == null || id.isEmpty()) {
                staffDAO.addStaff(s);
                session.setAttribute("toastMessage", "Staff added successfully!");
                session.setAttribute("toastType", "success");
            } else {
                s.setId(Integer.parseInt(id));
                staffDAO.updateStaff(s);
                session.setAttribute("toastMessage", "Staff updated successfully!");
                session.setAttribute("toastType", "success");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("toastMessage", "Something went wrong!");
            session.setAttribute("toastType", "error");
        }

        response.sendRedirect("manage_staff.jsp");
    }
}