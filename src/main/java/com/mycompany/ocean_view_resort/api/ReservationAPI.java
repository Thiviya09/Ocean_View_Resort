package com.mycompany.ocean_view_resort.api;

import com.mycompany.ocean_view_resort.dao.ReservationDAO;
import com.mycompany.ocean_view_resort.model.Reservation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.json.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

//@WebServlet("/api/reservations/*")
public class ReservationAPI extends HttpServlet {

    private ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check availability: /api/reservations/availability?roomId=1&checkIn=2026-03-05&checkOut=2026-03-07
        String path = request.getPathInfo();
        if ("/availability".equals(path)) {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            LocalDate checkIn = LocalDate.parse(request.getParameter("checkIn"));
            LocalDate checkOut = LocalDate.parse(request.getParameter("checkOut"));

            boolean available = reservationDAO.isRoomAvailable(roomId, checkIn, checkOut);

            JsonObject json = Json.createObjectBuilder()
                    .add("roomId", roomId)
                    .add("available", available)
                    .build();

            response.setContentType("application/json");
            response.getWriter().write(json.toString());
            return;
        }

        // Get all reservations
        List<Reservation> reservations = reservationDAO.findAll();
        JsonArrayBuilder arrBuilder = Json.createArrayBuilder();
        for (Reservation r : reservations) {
            JsonObject obj = Json.createObjectBuilder()
                    .add("reservationId", r.getReservationId())
                    .add("guestId", r.getGuestId())
                    .add("roomId", r.getRoomId())
                    .add("checkIn", r.getCheckIn().toString())
                    .add("checkOut", r.getCheckOut().toString())
                    .add("totalAmount", r.getTotalAmount())
                    .add("status", r.getStatus())
                    .build();
            arrBuilder.add(obj);
        }

        response.setContentType("application/json");
        response.getWriter().write(arrBuilder.build().toString());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Create new reservation
        BufferedReader reader = request.getReader();
        JsonObject body = Json.createReader(reader).readObject();

        try {
            int guestId = body.get("guestId").getValueType() == JsonValue.ValueType.NUMBER 
              ? body.getInt("guestId") 
              : Integer.parseInt(body.getString("guestId"));
//            
            int roomId = body.get("roomId").getValueType() == JsonValue.ValueType.NUMBER 
              ? body.getInt("roomId") 
              : Integer.parseInt(body.getString("roomId"));
//            int roomId = Integer.parseInt(body.getString("roomId"));
            LocalDate checkIn = LocalDate.parse(body.getString("checkIn"));
            LocalDate checkOut = LocalDate.parse(body.getString("checkOut"));
            double totalAmount = body.getJsonNumber("totalAmount").doubleValue();
            // Replace r.setStatus("CONFIRMED"); with:
            String status = body.containsKey("status") ? body.getString("status") : "PENDING";
            
            // Check availability
            if (!reservationDAO.isRoomAvailable(roomId, checkIn, checkOut)) {
                response.setStatus(HttpServletResponse.SC_CONFLICT); // 409
                JsonObject err = Json.createObjectBuilder()
                        .add("error", "Room not available for selected dates")
                        .build();
                response.getWriter().write(err.toString());
                return;
            }

            Reservation r = new Reservation();
            r.setGuestId(guestId);
            r.setRoomId(roomId);
            r.setCheckIn(checkIn);
            r.setCheckOut(checkOut);
            r.setTotalAmount(totalAmount);
            r.setStatus(status);

            reservationDAO.save(r);

            response.setStatus(HttpServletResponse.SC_CREATED);
            JsonObject success = Json.createObjectBuilder()
                    .add("message", "Reservation created successfully")
                    .add("reservationId", r.getReservationId())
                    .build();
            response.getWriter().write(success.toString());

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            JsonObject err = Json.createObjectBuilder()
                    .add("error", e.getMessage())
                    .build();
            response.getWriter().write(err.toString());
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Update reservation: /api/reservations/{id}
        String path = request.getPathInfo();
        if (path == null || path.equals("/")) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int reservationId = Integer.parseInt(path.substring(1));
        BufferedReader reader = request.getReader();
        JsonObject body = Json.createReader(reader).readObject();

        try {
            int guestId = Integer.parseInt(body.get("guestId").toString().replace("\"", ""));
            int roomId = Integer.parseInt(body.get("roomId").toString().replace("\"", ""));

            LocalDate checkIn = LocalDate.parse(body.getString("checkIn"));
            LocalDate checkOut = LocalDate.parse(body.getString("checkOut"));

            double totalAmount = Double.parseDouble(body.get("totalAmount").toString().replace("\"", ""));

            String status = body.getString("status");
            boolean skipAvailabilityCheck = "CANCELLED".equalsIgnoreCase(status);
            // Check availability excluding this reservation
            // ONLY check availability if the status is NOT 'CANCELLED'
//            if (!"CANCELLED".equalsIgnoreCase(status)) {
//                if (!reservationDAO.isRoomAvailableForUpdate(roomId, checkIn, checkOut, reservationId)) {
//                    response.setStatus(HttpServletResponse.SC_CONFLICT);
//                    JsonObject err = Json.createObjectBuilder()
//                            .add("error", "Room not available for selected dates")
//                            .build();
//                    response.getWriter().write(err.toString());
//                    return;
//                }
//            }
            if (!skipAvailabilityCheck) {
                boolean isAvailable = reservationDAO.isRoomAvailableForUpdate(roomId, checkIn, checkOut, reservationId);
                if (!isAvailable) {
                    response.setStatus(HttpServletResponse.SC_CONFLICT);
                    response.getWriter().write("{\"error\": \"Room is already booked for these dates by someone else.\"}");
                    return;
                }
            }
            

            

            Reservation r = new Reservation();
            r.setReservationId(reservationId);
            r.setGuestId(guestId);
            r.setRoomId(roomId);
            r.setCheckIn(checkIn);
            r.setCheckOut(checkOut);
            r.setTotalAmount(totalAmount);
            r.setStatus(status);

            boolean updated = reservationDAO.update(r);

            if(updated){
                JsonObject success = Json.createObjectBuilder()
                    .add("message", "Reservation updated successfully")
                    .build();
            response.getWriter().write(success.toString());
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            JsonObject err = Json.createObjectBuilder()
                    .add("error", "Reservation can not be updated!")
                    .build();
            response.getWriter().write(err.toString());
            }
            

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            JsonObject err = Json.createObjectBuilder()
                    .add("error", e.getMessage())
                    .build();
            response.getWriter().write(err.toString());
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Delete reservation: /api/reservations/{id}
        String path = request.getPathInfo();
        if (path == null || path.equals("/")) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int reservationId = Integer.parseInt(path.substring(1));
        reservationDAO.delete(reservationId);

        JsonObject success = Json.createObjectBuilder()
                .add("message", "Reservation cancelled successfully")
                .build();
        response.getWriter().write(success.toString());
    }

    private void elseif(boolean b) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}