/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.ocean_view_resort.controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.mycompany.ocean_view_resort.dao.*;
import com.mycompany.ocean_view_resort.model.*;
import com.mycompany.ocean_view_resort.mediator.ReservationMediator;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;


/**
 *
 * @author thiviya
 */

public class ReservationServlet extends HttpServlet {

    

    
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws IOException {
//        
//        // At the top of doPost
//HttpSession session = request.getSession();
//
//try {
//    int guestId = Integer.parseInt(request.getParameter("guestId"));
//    int roomId = Integer.parseInt(request.getParameter("roomId"));
//
//    LocalDate checkIn = LocalDate.parse(request.getParameter("checkIn"));
//    LocalDate checkOut = LocalDate.parse(request.getParameter("checkOut"));
//
//    ReservationMediator mediator = new ReservationMediator();
//
//    // Check availability
//    if (!mediator.isAvailable(roomId, checkIn, checkOut)) {
//        session.setAttribute("toastMessage", "Room not available for selected dates!");
//        session.setAttribute("toastType", "error");
//        response.sendRedirect("reservation");
//        return;
//    }
//
//    // Check duration
//    if (!checkOut.isAfter(checkIn)) {
//        session.setAttribute("toastMessage", "Check-out must be after check-in!");
//        session.setAttribute("toastType", "warning");
//        response.sendRedirect("reservation");
//        return;
//    }
//
//    RoomDAO roomDAO = new RoomDAO();
//    Room room = roomDAO.getRoomById(roomId);
//
//    // Check capacity
////    if (room.getCapacity() < 1) { // example validation
////        session.setAttribute("toastMessage", "Room capacity is insufficient!");
////        session.setAttribute("toastType", "warning");
////        response.sendRedirect("manage_reservations.jsp");
////        return;
////
    /// @param request
    /// @param response}
//
//    int days = (int) ChronoUnit.DAYS.between(checkIn, checkOut);
//    double total = room.getPricePerNight() * days;
//
//    Reservation r = new Reservation();
//    r.setGuestId(guestId);
//    r.setRoomId(roomId);
//    r.setCheckIn(checkIn);
//    r.setCheckOut(checkOut);
//    r.setTotalAmount(total);
//    r.setStatus("CONFIRMED");
//
//    mediator.bookReservation(r);
//
//    session.setAttribute("toastMessage", "Reservation successfully created!");
//    session.setAttribute("toastType", "success");
//    response.sendRedirect("reservation");
//
//} catch (Exception e) {
//    e.printStackTrace();
//    session.setAttribute("toastMessage", "Error: " + e.getMessage());
//    session.setAttribute("toastType", "error");
//    response.sendRedirect("reservation");
//}
//
//
//        int guestId = Integer.parseInt(request.getParameter("guestId"));
//        int roomId = Integer.parseInt(request.getParameter("roomId"));
//
//        LocalDate checkIn = LocalDate.parse(request.getParameter("checkIn"));
//        LocalDate checkOut = LocalDate.parse(request.getParameter("checkOut"));
//
//        int days = (int) java.time.temporal.ChronoUnit.DAYS.between(checkIn, checkOut);
//
//        RoomDAO roomDAO = new RoomDAO();
//        Room room = roomDAO.getRoomById(roomId);
//
//        ReservationComponent base =
//                new BaseReservation(room.getPricePerNight(), days);
//
//        ReservationComponent discount =
//                new SeasonalDiscount(base, 0.10);
//
//        double total = discount.calculateTotal();
//
//        Reservation r = new Reservation();
//        r.setGuestId(guestId);
//        r.setRoomId(roomId);
//        r.setCheckIn(checkIn);
//        r.setCheckOut(checkOut);
//        r.setTotalAmount(total);
//        r.setStatus("CONFIRMED");
//
//        ReservationMediator mediator = new ReservationMediator();
//
//        if (!mediator.isAvailable(roomId, checkIn, checkOut)) {
//            response.getWriter().write("Room not available");
//            return;
//        }
//
//        mediator.bookReservation(r);
//
//        response.sendRedirect("reservation");
//    }
        
//        @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        ReservationMediator mediator = new ReservationMediator();
//        RoomDAO roomDAO = new RoomDAO();
//        String action = request.getParameter("action");
//        
//        if ("cancel".equals(action)) {
//            int id = Integer.parseInt(request.getParameter("id"));
//            String roomIdStr = request.getParameter("roomId");
//
//            if (roomIdStr != null) {
//                int roomId = Integer.parseInt(roomIdStr);
//                // Call the mediator to handle both: Cancel reservation AND update room
//                mediator.cancelReservation(id); 
//                roomDAO.updateRoomStatus(roomId, "AVAILABLE");
//            } else {
//                mediator.cancelReservation(id);
//            }
//
//            response.sendRedirect("reservation");
//            return;
//}
//
//        request.setAttribute("reservations", mediator.getAllReservations());
//        request.getRequestDispatcher("manage_reservations.jsp")
//                .forward(request, response);
//    }
        
       @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String action = request.getParameter("action");
    
    // Keep your cancel logic if you still use it via traditional links
    if ("cancel".equals(action)) {
        ReservationMediator mediator = new ReservationMediator();
        int id = Integer.parseInt(request.getParameter("id"));
        mediator.cancelReservation(id);
        response.sendRedirect("manage-reservations");
        return;
    }

    // SIMPLIFIED: Just send the user to the page. 
    // The JavaScript in the JSP will handle loading the data.
    request.getRequestDispatcher("manage_reservations.jsp").forward(request, response);
} 
    
    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
    HttpSession session = request.getSession();

    try {
        int guestId = Integer.parseInt(request.getParameter("guestId"));
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        LocalDate checkIn = LocalDate.parse(request.getParameter("checkIn"));
        LocalDate checkOut = LocalDate.parse(request.getParameter("checkOut"));

        ReservationMediator mediator = new ReservationMediator();

        // 1. Logic Check: Dates
        if (!checkOut.isAfter(checkIn)) {
            session.setAttribute("toastMessage", "Check-out must be after check-in!");
            session.setAttribute("toastType", "warning");
            response.sendRedirect("reservation");
            return;
        }

        // 2. Logic Check: Availability
        if (!mediator.isAvailable(roomId, checkIn, checkOut)) {
            session.setAttribute("toastMessage", "Room not available for selected dates!");
            session.setAttribute("toastType", "error");
            response.sendRedirect("reservation");
            return;
        }

        // 3. Calculate Total (Using your Decorator pattern logic)
        RoomDAO roomDAO = new RoomDAO();
        Room room = roomDAO.getRoomById(roomId);
        int days = (int) ChronoUnit.DAYS.between(checkIn, checkOut);

        ReservationComponent base = new BaseReservation(room.getPricePerNight(), days);
        ReservationComponent discount = new SeasonalDiscount(base, 0.10);
        double total = discount.calculateTotal();

        // 4. Save
        Reservation r = new Reservation();
        r.setGuestId(guestId);
        r.setRoomId(roomId);
        r.setCheckIn(checkIn);
        r.setCheckOut(checkOut);
        r.setTotalAmount(total);
        r.setStatus("CONFIRMED");

        mediator.bookReservation(r);

        session.setAttribute("toastMessage", "Reservation successfully created!");
        session.setAttribute("toastType", "success");
        response.sendRedirect("reservation");

    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("toastMessage", "Error: " + e.getMessage());
        session.setAttribute("toastType", "error");
        response.sendRedirect("reservation");
    }
}
}