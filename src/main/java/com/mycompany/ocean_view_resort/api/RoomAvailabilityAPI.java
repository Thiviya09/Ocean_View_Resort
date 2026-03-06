package com.mycompany.ocean_view_resort.api;

import com.mycompany.ocean_view_resort.dao.ReservationDAO;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
//
//@WebServlet("/api/rooms/*")
public class RoomAvailabilityAPI extends HttpServlet {

    private final ReservationDAO dao = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        resp.setContentType("application/json");

        String[] parts = req.getPathInfo().split("/");
        int roomId = Integer.parseInt(parts[1]);

        List<LocalDate[]> ranges = dao.getBookedDateRanges(roomId);

        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < ranges.size(); i++) {
            LocalDate[] r = ranges.get(i);
            json.append("{\"start\":\"").append(r[0])
                .append("\",\"end\":\"").append(r[1]).append("\"}");
            if (i < ranges.size() - 1) json.append(",");
        }
        json.append("]");

        resp.getWriter().write(json.toString());
    }
}