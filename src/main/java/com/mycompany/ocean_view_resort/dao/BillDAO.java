/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ocean_view_resort.dao;

import com.mycompany.ocean_view_resort.model.Bill;
import com.mycompany.ocean_view_resort.util.DBConnection;
import jakarta.json.Json;
import jakarta.json.JsonObject;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BillDAO {
    
    public boolean isBillAlreadyGenerated(int reservationId) {
        String sql = "SELECT COUNT(*) FROM bills WHERE reservation_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reservationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
        public boolean updateExistingBill(Bill bill) {
    String sql = "UPDATE bills SET " +
                 "food_charge = ?, " +
                 "discount = ?, " +
                 "total_amount = ?, " +
                 "payment_method = ?, " +
                 "is_paid = ?, " +
                 "service_charge = ? " +
                 "WHERE reservation_id = ?";
                 
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setDouble(1, bill.getFoodCharge());
        ps.setDouble(2, bill.getDiscount());
        ps.setDouble(3, bill.getTotalAmount());
        ps.setString(4, bill.getPaymentMethod());
        ps.setBoolean(5, bill.isPaid());
        ps.setDouble(6, bill.getServiceCharge());
        ps.setInt(7, bill.getReservationId());
        
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}
    public boolean saveBill(Bill bill) {
        
        if (isBillAlreadyGenerated(bill.getReservationId())) {
            System.out.println("Bill for Reservation ID " + bill.getReservationId() + " already exists. Skipping save.");
            updateExistingBill(bill);
            return false; 
        }
        String sql = "INSERT INTO bills (reservation_id, room_charge, food_charge, service_charge, discount, total_amount, payment_method, is_paid, billing_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bill.getReservationId());
            ps.setDouble(2, bill.getRoomCharge());
            ps.setDouble(3, bill.getFoodCharge());
            ps.setDouble(4, bill.getServiceCharge());
            ps.setDouble(5, bill.getDiscount());
            ps.setDouble(6, bill.getTotalAmount());
            ps.setString(7, bill.getPaymentMethod());
            ps.setBoolean(8, bill.isPaid());
            ps.setDate(9, Date.valueOf(java.time.LocalDate.now()));
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Bill> getAllBills() {
        List<Bill> list = new ArrayList<>();
        String sql = "SELECT * FROM bills ORDER BY billing_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Bill b = new Bill();
                b.setBillId(rs.getInt("bill_id"));
                b.setReservationId(rs.getInt("reservation_id"));
                b.setRoomCharge(rs.getDouble("room_charge"));
                b.setFoodCharge(rs.getDouble("food_charge"));
                b.setServiceCharge(rs.getDouble("service_charge"));
                b.setDiscount(rs.getDouble("discount"));
                b.setTotalAmount(rs.getDouble("total_amount"));
                b.setPaymentMethod(rs.getString("payment_method"));
                b.setPaid(rs.getBoolean("is_paid"));
                b.setBillingDate(rs.getDate("billing_date").toLocalDate());
                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public Bill getBillById(int billId) {
    String sql = "SELECT * FROM bills WHERE bill_id = ?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, billId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                Bill b = new Bill();
                b.setBillId(rs.getInt("bill_id"));
                b.setReservationId(rs.getInt("reservation_id"));
                b.setRoomCharge(rs.getDouble("room_charge"));
                b.setFoodCharge(rs.getDouble("food_charge"));
                b.setServiceCharge(rs.getDouble("service_charge"));
                b.setDiscount(rs.getDouble("discount"));
                b.setTotalAmount(rs.getDouble("total_amount"));
                b.setPaymentMethod(rs.getString("payment_method"));
                b.setPaid(rs.getBoolean("is_paid"));
                b.setBillingDate(rs.getDate("billing_date").toLocalDate());
                return b;
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}
    public Bill getBillByReservationId(int resId) {
    String sql = "SELECT * FROM bills WHERE reservation_id = ?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, resId);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            Bill bill = new Bill();
            bill.setBillId(rs.getInt("bill_id"));
            bill.setReservationId(rs.getInt("reservation_id"));
            bill.setRoomCharge(rs.getDouble("room_charge"));
            bill.setFoodCharge(rs.getDouble("food_charge"));
            bill.setServiceCharge(rs.getDouble("service_charge"));
            bill.setDiscount(rs.getDouble("discount"));
            bill.setTotalAmount(rs.getDouble("total_amount"));
            bill.setPaymentMethod(rs.getString("payment_method"));
            bill.setPaid(rs.getBoolean("is_paid"));
            bill.setBillingDate(rs.getTimestamp("billing_date").toLocalDateTime().toLocalDate());
            return bill;
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}
//    public JsonObject getBillingSummary() {
//    String sql = "SELECT COUNT(*) as count, SUM(total_amount) as total, " +
//                 "SUM(CASE WHEN is_paid = 1 THEN total_amount ELSE 0 END) as paid_total, " +
//                 "SUM(CASE WHEN is_paid = 0 THEN total_amount ELSE 0 END) as pending_total " +
//                 "FROM bills";
//    
//    try (Connection conn = DBConnection.getConnection();
//         PreparedStatement ps = conn.prepareStatement(sql);
//         ResultSet rs = ps.executeQuery()) {
//        
//        if (rs.next()) {
//            return Json.createObjectBuilder()
//                .add("totalBills", rs.getInt("count"))
//                .add("totalRevenue", rs.getDouble("total"))
//                .add("paidRevenue", rs.getDouble("paid_total"))
//                .add("pendingRevenue", rs.getDouble("pending_total"))
//                .build();
//        }
//    } catch (SQLException e) {
//        e.printStackTrace();
//    }
//    return null;
//}
    public JsonObject getBillingSummary() {
    String sql = "SELECT SUM(total_amount) as total, " +
                 "SUM(CASE WHEN is_paid = 1 THEN total_amount ELSE 0 END) as paid, " +
                 "SUM(CASE WHEN is_paid = 0 THEN total_amount ELSE 0 END) as pending " +
                 "FROM bills";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        
        if (rs.next()) {
            return Json.createObjectBuilder()
                .add("totalRevenue", rs.getDouble("total"))
                .add("paidRevenue", rs.getDouble("paid"))
                .add("pendingRevenue", rs.getDouble("pending"))
                .build();
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    // Return zeros instead of null to prevent JavaScript errors
    return Json.createObjectBuilder()
            .add("totalRevenue", 0.0)
            .add("paidRevenue", 0.0)
            .add("pendingRevenue", 0.0)
            .build();
}
    

}