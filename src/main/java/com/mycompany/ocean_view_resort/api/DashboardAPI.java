package com.mycompany.ocean_view_resort.api; // Make sure this matches your project package structure

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.json.Json;
import jakarta.json.JsonObject;
import java.io.IOException;
import java.sql.*;
import com.mycompany.ocean_view_resort.util.DBConnection;
import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObjectBuilder;


//@WebServlet("/api/dashboard-stats")
public class DashboardAPI extends HttpServlet {

    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
    JsonObjectBuilder finalResponse = Json.createObjectBuilder();

    try (Connection conn = DBConnection.getConnection()) {
        
        // --- 1. Main Stats (Counters) ---
        String mainSql = "SELECT " +
            "(SELECT COUNT(*) FROM reservations) as total_res, " +
            "(SELECT COUNT(*) FROM guests) as total_gst, " +
            "(SELECT COUNT(*) FROM users) as total_stf, " +
            "(SELECT COALESCE(SUM(total_amount), 0) FROM bills WHERE is_paid = 1) as total_rev, " +
            "(SELECT COUNT(*) FROM reservations WHERE status = 'CONFIRMED') as confirmed_res, " +
            "(SELECT COUNT(*) FROM reservations WHERE status = 'PENDING') as pending_res, " +
            "(SELECT COUNT(*) FROM reservations WHERE status = 'CANCELLED') as cancelled_res";

        try (PreparedStatement ps = conn.prepareStatement(mainSql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                finalResponse.add("reservations", rs.getInt("total_res"))
                            .add("guests", rs.getInt("total_gst"))
                            .add("staff", rs.getInt("total_stf"))
                            .add("revenue", rs.getDouble("total_rev"))
                            .add("confirmed_reservation", rs.getInt("confirmed_res"))
                            .add("pending_reservation", rs.getInt("pending_res"))
                            .add("cancelled_reservation", rs.getInt("cancelled_res"));
            }
        }

        // --- 2. Room Type Distribution (Pie Chart) ---
        // We join with the 'rooms' table to get the actual type name
        String roomSql = "SELECT rt.type_name, COUNT(*) as count " +
                 "FROM reservations res " +
                 "JOIN rooms r ON res.room_id = r.room_id " +
                 "JOIN room_types rt ON r.type_id = rt.id " +
                 "GROUP BY rt.type_name";
        JsonArrayBuilder roomArray = Json.createArrayBuilder();
        try (PreparedStatement ps = conn.prepareStatement(roomSql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                roomArray.add(Json.createObjectBuilder()
                    .add("label", rs.getString("type_name"))
                    .add("value", rs.getInt("count")));
            }
        }
        finalResponse.add("roomTypeData", roomArray);

        // --- 3. Monthly Revenue (Line Chart) ---
       // --- 3. Daily Revenue (Line Chart) ---
String revSql = "SELECT DAY(billing_date) as day, SUM(total_amount) as amount " +
                "FROM bills " +
                "WHERE is_paid = 1 AND MONTH(billing_date) = MONTH(CURRENT_DATE()) " +
                "AND YEAR(billing_date) = YEAR(CURRENT_DATE()) " +
                "GROUP BY DAY(billing_date) " +
                "ORDER BY DAY(billing_date) ASC";

JsonArrayBuilder revArray = Json.createArrayBuilder();
try (PreparedStatement ps = conn.prepareStatement(revSql);
     ResultSet rs = ps.executeQuery()) {
    while (rs.next()) {
        revArray.add(Json.createObjectBuilder()
            // FIX: Changed "month" to "label" and used rs.getInt("day")
            .add("label", "Day " + rs.getInt("day")) 
            .add("amount", rs.getDouble("amount")));
    }
}
finalResponse.add("revenueTrend", revArray);

    } catch (SQLException e) {
        e.printStackTrace();
        finalResponse.add("error", "SQL Error: " + e.getMessage());
    }

    response.setContentType("application/json");
    response.getWriter().write(finalResponse.build().toString());
}
}