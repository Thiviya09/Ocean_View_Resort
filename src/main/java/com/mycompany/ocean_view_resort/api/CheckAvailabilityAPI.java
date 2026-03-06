/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ocean_view_resort.api;

import com.mycompany.ocean_view_resort.mediator.ReservationMediator;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;

//@WebServlet("/api/checkAvailability")
public class CheckAvailabilityAPI extends HttpServlet {

    private final ReservationMediator mediator = new ReservationMediator();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            LocalDate checkIn = LocalDate.parse(request.getParameter("checkIn"));
            LocalDate checkOut = LocalDate.parse(request.getParameter("checkOut"));

            boolean available = mediator.isAvailable(roomId, checkIn, checkOut);

            out.print("{\"available\":" + available + "}");

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"available\":false}");
        }
    }
}