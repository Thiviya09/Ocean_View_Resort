///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//package com.mycompany.ocean_view_resort.controller;
//
//import java.io.IOException;
//import java.io.PrintWriter;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import com.mycompany.ocean_view_resort.dao.GuestDAO;
//import com.mycompany.ocean_view_resort.model.Guest;
//import jakarta.servlet.*;
//import jakarta.servlet.http.HttpSession;
//
////import jakarta.servlet.annotation.WebServlet;
//import java.sql.SQLException;
///**
// *
// * @author thiviya
// */
//public class GuestServlet extends HttpServlet {
//
//    /**
//     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
//     * methods.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//   
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//        throws ServletException, IOException {
//
//        
//
//        String action = request.getParameter("action");
//        GuestDAO dao = new GuestDAO();
//
//        try {
//
//            if (action == null) {
//                response.sendRedirect("manage_guests.jsp");
//                return;
//            }
//
//            switch (action) {
//
//                case "delete":
//                    int deleteId = Integer.parseInt(request.getParameter("id"));
//    dao.deleteGuest(deleteId);
//
//    // Get session
//    HttpSession session = request.getSession();
//    session.setAttribute("toastMessage", "Guest deleted successfully!");
//    session.setAttribute("toastType", "success");
//
//    response.sendRedirect("manage_guests.jsp");;
//                    break;
//
//                case "edit":
//                    int editId = Integer.parseInt(request.getParameter("id"));
//                    Guest g = dao.getGuestById(editId);
//                    request.setAttribute("guest", g);
//                    RequestDispatcher rd = request.getRequestDispatcher("manage_guests.jsp");
//                    rd.forward(request, response);
//                    break;
//
//                default:
//                    response.sendRedirect("manage_guests.jsp");
//                    break;
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.sendRedirect("manage_guests.jsp");
//        }
//}
//
//    /**
//     *
//     * @param request
//     * @param response
//     * @throws ServletException
//     * @throws IOException
//     */
//    @Override
//protected void doPost(HttpServletRequest request, HttpServletResponse response)
//        throws ServletException, IOException {
//
//    String id = request.getParameter("id");
//    String guestName = request.getParameter("guestName");
//    String address = request.getParameter("address");
//    String contactNumber = request.getParameter("contact_number");
//    String email = request.getParameter("email");
//
//    Guest g = new Guest();
//    g.setGuestName(guestName);
//    g.setAddress(address);
//    g.setContactNumber(contactNumber);
//    g.setEmail(email);
//
//    GuestDAO dao = new GuestDAO();
//
//    try {
//
//        if (id == null || id.isEmpty()) {
//            dao.addGuest(g);
//            request.getSession().setAttribute("toastMessage", "Guest added successfully!");
//            request.getSession().setAttribute("toastType", "success");
//        } else {
//            g.setId(Integer.parseInt(id));
//            dao.updateGuest(g);
//            request.getSession().setAttribute("toastMessage", "Guest updated successfully!");
//            request.getSession().setAttribute("toastType", "success");
//        }
//
//    } catch (Exception e) {
//        e.printStackTrace();
//        request.getSession().setAttribute("toastMessage", "Error: " + e.getMessage());
//        request.getSession().setAttribute("toastType", "error");
//    }
//
//    response.sendRedirect("manage_guests.jsp");
//}
//
//
//}
package com.mycompany.ocean_view_resort.controller;

import com.mycompany.ocean_view_resort.dao.GuestDAO;
import com.mycompany.ocean_view_resort.factory.DAOFactory;
import com.mycompany.ocean_view_resort.model.Guest;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * GuestServlet now uses DAOFactory to get GuestDAO
 */
public class GuestServlet extends HttpServlet {

    private GuestDAO guestDAO;

    @Override
    public void init() throws ServletException {
        // Directly get GuestDAO from static factory method
        guestDAO = DAOFactory.getGuestDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if (action == null) {
                response.sendRedirect("manage_guests.jsp");
                return;
            }

            switch (action) {

                case "delete":
                    int deleteId = Integer.parseInt(request.getParameter("id"));
                    boolean deleted = guestDAO.deleteGuest(deleteId);

                    HttpSession session = request.getSession();
                    session.setAttribute("toastMessage", deleted ? "Guest deleted successfully!" : "Failed to delete guest");
                    session.setAttribute("toastType", deleted ? "success" : "error");

                    response.sendRedirect("manage_guests.jsp");
                    break;

                case "edit":
                    int editId = Integer.parseInt(request.getParameter("id"));
                    Guest guest = guestDAO.getGuestById(editId);
                    request.setAttribute("guest", guest);

                    RequestDispatcher rd = request.getRequestDispatcher("manage_guests.jsp");
                    rd.forward(request, response);
                    break;

                default:
                    response.sendRedirect("manage_guests.jsp");
                    break;
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage_guests.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        String guestName = request.getParameter("guestName");
        String address = request.getParameter("address");
        String contactNumber = request.getParameter("contact_number");
        String email = request.getParameter("email");

        Guest guest = new Guest();
        guest.setGuestName(guestName);
        guest.setAddress(address);
        guest.setContactNumber(contactNumber);
        guest.setEmail(email);

        try {
            if (id == null || id.isEmpty()) {
                boolean added = guestDAO.addGuest(guest);
                request.getSession().setAttribute("toastMessage", added ? "Guest added successfully!" : "Failed to add guest");
                request.getSession().setAttribute("toastType", added ? "success" : "error");
            } else {
                guest.setId(Integer.parseInt(id));
                boolean updated = guestDAO.updateGuest(guest);
                request.getSession().setAttribute("toastMessage", updated ? "Guest updated successfully!" : "Failed to update guest");
                request.getSession().setAttribute("toastType", updated ? "success" : "error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("toastMessage", "Error: " + e.getMessage());
            request.getSession().setAttribute("toastType", "error");
        }

        response.sendRedirect("manage_guests.jsp");
    }
}