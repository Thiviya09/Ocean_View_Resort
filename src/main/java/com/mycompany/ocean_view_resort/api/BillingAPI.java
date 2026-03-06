package com.mycompany.ocean_view_resort.api;

import com.mycompany.ocean_view_resort.dao.BillDAO;
import com.mycompany.ocean_view_resort.dao.GuestDAO; // Import your GuestDAO
import com.mycompany.ocean_view_resort.model.Guest;
import com.mycompany.ocean_view_resort.model.Bill;
import com.mycompany.ocean_view_resort.observer.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.json.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.*;


public class BillingAPI extends HttpServlet {
    private static List<BillObserver> observers = new ArrayList<>();
    private GuestDAO guestDAO = new GuestDAO(); // Initialize GuestDAO
    private BillDAO billDAO = new BillDAO();
    static {
        observers.add(new EmailObserver()); 
        System.out.println("System: EmailObserver attached to BillingAPI.");
    }
    public BillingAPI() {
//        observers.add(new EmailObserver()); // Observer Pattern
    }

//    @Override
//protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
//    response.setContentType("application/json");
//    JsonObject body = Json.createReader(request.getReader()).readObject();
//
//    
//    try {
//        // 1. Populate the Bill object
//        
//        Bill bill = new Bill();
//        boolean exists = billDAO.isBillAlreadyGenerated(bill.getReservationId());
//boolean success;
//        bill.setReservationId(body.getInt("reservationId"));
//        bill.setRoomCharge(body.getJsonNumber("roomCharge").doubleValue());
//        bill.setFoodCharge(body.getJsonNumber("foodCharge").doubleValue());
//        bill.setServiceCharge(body.getJsonNumber("serviceCharge").doubleValue());
//        bill.setDiscount(body.getJsonNumber("discount").doubleValue());
//        bill.setTotalAmount(body.getJsonNumber("totalAmount").doubleValue());
//        bill.setPaymentMethod(body.getString("paymentMethod"));
//        bill.setPaid(body.getBoolean("isPaid"));
//        
//        
//        
//        // 2. Fetch Guest Email
//        int guestId = body.getInt("guestId");
//        Guest guest = guestDAO.getGuestById(guestId);
//        String recipientEmail = (guest != null) ? guest.getEmail() : "guest@example.com";
//
//        // 3. Try to Save to Database
//        if (exists) {
//            // If it exists, update all values (Food, Discount, Total, Status)
//            success = billDAO.updateExistingBill(bill);
//        } else {
//            // If it's new, insert it
//            success = billDAO.saveBill(bill);
//        }
//        boolean isSaved = billDAO.saveBill(bill);
//        
//        // If it was already saved previously, fetch the existing Bill ID 
//        // so the PDF shows the correct ID.
//        if (!isSaved) {
//            List<Bill> allBills = billDAO.getAllBills();
//            for(Bill b : allBills) {
//                if(b.getReservationId() == bill.getReservationId()) {
//                    bill.setBillId(b.getBillId());
//                    break;
//                }
//            }
//        } else {
//             // If newly saved, get the latest ID
//             List<Bill> all = billDAO.getAllBills();
//             if(!all.isEmpty()) bill.setBillId(all.get(0).getBillId());
//        }
//
//        // 4. ALWAYS START BACKGROUND THREAD FOR EMAIL
//        // This will run whether 'isSaved' is true OR false.
//        new Thread(() -> {
//            try {
//                System.out.println("Inside thread: notifying " + observers.size() + " observers"); // DEBUG LINE
//                for (BillObserver observer : observers) {
//                    observer.onBillGenerated(bill, recipientEmail);
//                }
//            } catch (Exception e) {
//                System.err.println("Email failed: " + e.getMessage());
//            }
//        }).start();
//
//        // 5. Construct Response Message
//        String msg = isSaved ? "Bill saved and email sending..." : "Bill already existed, but invoice email has been resent!";
//        
//        response.getWriter().write(Json.createObjectBuilder()
//            .add("status", "success")
//            .add("message", msg)
//            .build().toString());
//
//    } catch (Exception e) {
//        e.printStackTrace();
//        response.setStatus(500);
//        response.getWriter().write("{\"status\":\"error\", \"message\":\"System error\"}");
//    }
//}
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
    response.setContentType("application/json");
    try {
        JsonObject body = Json.createReader(request.getReader()).readObject();
        
        // 1. Map JSON to Object
        Bill bill = new Bill();
        int resId = body.getInt("reservationId");
        bill.setReservationId(resId);
        bill.setRoomCharge(body.getJsonNumber("roomCharge").doubleValue());
        bill.setFoodCharge(body.getJsonNumber("foodCharge").doubleValue());
        bill.setServiceCharge(body.getJsonNumber("serviceCharge").doubleValue());
        bill.setDiscount(body.getJsonNumber("discount").doubleValue());
        bill.setTotalAmount(body.getJsonNumber("totalAmount").doubleValue());
        bill.setPaymentMethod(body.getString("paymentMethod"));
        bill.setPaid(body.getBoolean("isPaid"));

        // 2. Database Logic
        boolean exists = billDAO.isBillAlreadyGenerated(resId);
        boolean success;
        
        if (exists) {
            success = billDAO.updateExistingBill(bill);
        } else {
            success = billDAO.saveBill(bill);
        }

        // 3. Fetch ID and Guest Info
        // After saving/updating, get the bill object from DB to ensure we have the ID
        Bill updatedBill = billDAO.getBillByReservationId(resId); 
        int guestId = body.getInt("guestId");
        Guest guest = guestDAO.getGuestById(guestId);
        String recipientEmail = (guest != null) ? guest.getEmail() : "guest@example.com";

        // 4. Trigger Email Observer
        if (updatedBill != null) {
            new Thread(() -> {
                try {
                    for (BillObserver observer : observers) {
                        observer.onBillGenerated(updatedBill, recipientEmail);
                    }
                } catch (Exception e) {
                    System.err.println("Email failed: " + e.getMessage());
                }
            }).start();
        }

        // 5. Response
        String msg = !exists ? "Bill saved and email sent!" : "Bill updated and email resent!";
        response.getWriter().write(Json.createObjectBuilder()
            .add("status", "success")
            .add("message", msg)
            .build().toString());

    } catch (Exception e) {
        e.printStackTrace();
        response.setStatus(500);
        response.getWriter().write("{\"status\":\"error\", \"message\":\"" + e.getMessage() + "\"}");
    }
}    
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
//       String billIdParam = request.getParameter("downloadId"); 
//        if (billIdParam != null) {
//        // --- DOWNLOAD LOGIC ---
//        int billId = Integer.parseInt(billIdParam);
//        Bill bill = billDAO.getBillById(billId); // You'll need this method in DAO
//
//        if (bill != null) {
//            try {
//                // Reuse your PDF logic from EmailObserver (extract it to a Utility class if possible)
//                EmailObserver pdfTool = new EmailObserver(); 
//                byte[] pdfData = pdfTool.generateProfessionalPdf(bill);
//
//                response.setContentType("application/pdf");
//                response.setHeader("Content-Disposition", "attachment; filename=Invoice_" + billId + ".pdf");
//                response.setContentLength(pdfData.length);
//                response.getOutputStream().write(pdfData);
//                return;
//            } catch (Exception e) {
//                e.printStackTrace();
//            }
//        }
//    }
//        List<Bill> bills = billDAO.getAllBills();
//        JsonArrayBuilder arrayBuilder = Json.createArrayBuilder();
//        
//        for (Bill b : bills) {
//            arrayBuilder.add(Json.createObjectBuilder()
//                .add("billId", b.getBillId())
//                .add("reservationId", b.getReservationId())
//                .add("totalAmount", b.getTotalAmount())
//                .add("paymentMethod", b.getPaymentMethod())
//                .add("isPaid", b.isPaid())
//                .add("billingDate", b.getBillingDate().toString())
//                .build());
//        }
//        
//        response.setContentType("application/json");
//        response.getWriter().write(arrayBuilder.build().toString());
//    }
//    @Override
//protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
//    String billIdParam = request.getParameter("downloadId"); 
//    String resendId = request.getParameter("resendId");
////
//response.setContentType("application/json");
//    response.setCharacterEncoding("UTF-8");
//    java.io.PrintWriter out = response.getWriter();
//    
//    try {
////        String resendId = request.getParameter("resendId");
//        if (resendId != null) {
//    int billId = Integer.parseInt(resendId);
//    Bill bill = billDAO.getBillById(billId);
//    
//    if (bill != null) {
//        
//        Guest guest = guestDAO.getGuestByBillId(billId); // You may need to create this method in GuestDAO
//        
//        final String recipientEmail = (guest != null) ? guest.getEmail() : "oceanviewresortTHV.sl@gmail.com"; 
//
//        // 2. Re-trigger the background thread
//        new Thread(() -> {
//            try {
//                System.out.println("Resending email for Bill #" + billId + " to " + recipientEmail);
//                for (BillObserver observer : observers) {
//                    observer.onBillGenerated(bill, recipientEmail);
//                }
//            } catch (Exception e) {
//                System.err.println("Resend failed: " + e.getMessage());
//            }
//        }).start();
//        
//        response.setContentType("application/json");
//        response.getWriter().write("{\"status\":\"success\", \"message\":\"Email resend triggered to " + recipientEmail + "!\"}");
//        return;
//    }
//}
//        
//        boolean success = true; // Replace with your actual success check
//        
//        if (success) {
//            out.print("{\"status\": \"success\", \"message\": \"Email sent successfully!\"}");
//        } else {
//            out.print("{\"status\": \"error\", \"message\": \"Failed to send email.\"}");
//        }
//    } catch (Exception e) {
//        out.print("{\"status\": \"error\", \"message\": \"Server Error: " + e.getMessage() + "\"}");
//    } finally {
//        out.flush();
//    }
//    
////if (resendId != null) {
////    int billId = Integer.parseInt(resendId);
////    Bill bill = billDAO.getBillById(billId);
////    
////    if (bill != null) {
////        
////        Guest guest = guestDAO.getGuestByBillId(billId); // You may need to create this method in GuestDAO
////        
////        final String recipientEmail = (guest != null) ? guest.getEmail() : "oceanviewresortTHV.sl@gmail.com"; 
////
////        // 2. Re-trigger the background thread
////        new Thread(() -> {
////            try {
////                System.out.println("Resending email for Bill #" + billId + " to " + recipientEmail);
////                for (BillObserver observer : observers) {
////                    observer.onBillGenerated(bill, recipientEmail);
////                }
////            } catch (Exception e) {
////                System.err.println("Resend failed: " + e.getMessage());
////            }
////        }).start();
////        
////        response.setContentType("application/json");
////        response.getWriter().write("{\"status\":\"success\", \"message\":\"Email resend triggered to " + recipientEmail + "!\"}");
////        return;
////    }
////}
////if (request.getParameter("resendId") != null) {
////    int bId = Integer.parseInt(request.getParameter("resendId"));
////    Bill b = billDAO.getBillById(bId);
////    // Trigger observer manually
////    new EmailObserver().onBillGenerated(b, "oceanviewresortTHV.sl@gmail.com"); 
////    response.getWriter().write("{\"message\":\"Resent successfully\"}");
////    return;
////}
//    // 1. Check if this is a PDF download request
//    String previewId = request.getParameter("previewId");
//    if (previewId != null || billIdParam != null) {
//        int billId = Integer.parseInt(previewId != null ? previewId : billIdParam);
//        Bill bill = billDAO.getBillById(billId);
//
//        if (bill != null) {
//            try {
//                EmailObserver pdfTool = new EmailObserver(); 
//                byte[] pdfData = pdfTool.generateProfessionalPdf(bill);
//
//                response.setContentType("application/pdf");
//                if (previewId != null) {
//    response.setHeader("Content-Disposition", "inline; filename=Invoice_" + billId + ".pdf");
//} else {
//    response.setHeader("Content-Disposition", "attachment; filename=Invoice_" + billId + ".pdf");
//}
//                response.getOutputStream().write(pdfData);
//                return; // STOP HERE for downloads
//            } catch (Exception e) { e.printStackTrace(); }
//        }
//    }
//
//    // 2. If no downloadId, return the JSON list for the table
//    List<Bill> bills = billDAO.getAllBills();
//    JsonObject summary = billDAO.getBillingSummary();
//    JsonArrayBuilder arrayBuilder = Json.createArrayBuilder();
//    for (Bill b : bills) {
//        arrayBuilder.add(Json.createObjectBuilder()
//            .add("billId", b.getBillId())
//            .add("reservationId", b.getReservationId())
//            .add("totalAmount", b.getTotalAmount())
//            .add("paymentMethod", b.getPaymentMethod())
//            .add("isPaid", b.isPaid())
//            .add("billingDate", b.getBillingDate().toString()));
//    }
//    JsonObject finalResponse = Json.createObjectBuilder()
//        .add("summary", summary != null ? summary : Json.createObjectBuilder().build())
//        .add("bills", arrayBuilder.build())
//        .build();
//    
//    String jsonResponse = finalResponse.toString();
//    
//    response.setContentType("application/json");
//    response.setCharacterEncoding("UTF-8");
//    
//    // Clear any previous buffer content just in case
//    response.getWriter().write(jsonResponse);
//    response.getWriter().flush();
////    response.setContentType("application/json");
////    response.getWriter().write(arrayBuilder.build().toString());
////    response.getWriter().write(finalResponse.toString());
//}

@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
    String billIdParam = request.getParameter("downloadId");
    String resendId = request.getParameter("resendId");
    String previewId = request.getParameter("previewId");

    // --- ACTION 1: RESEND EMAIL ---
    if (resendId != null) {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try {
            int billId = Integer.parseInt(resendId);
            Bill bill = billDAO.getBillById(billId);

            if (bill != null) {
                Guest guest = guestDAO.getGuestByBillId(billId);
                final String recipientEmail = (guest != null) ? guest.getEmail() : "oceanviewresortTHV.sl@gmail.com";

                new Thread(() -> {
                    try {
                        for (BillObserver observer : observers) {
                            observer.onBillGenerated(bill, recipientEmail);
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }).start();

                response.getWriter().write("{\"status\":\"success\", \"message\":\"Email resend triggered to " + recipientEmail + "!\"}");
            } else {
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Bill not found.\"}");
            }
        } catch (Exception e) {
            response.getWriter().write("{\"status\":\"error\", \"message\":\"" + e.getMessage() + "\"}");
        }
        return; // CRITICAL: Stop here so we don't send the bill list too
    }

    // --- ACTION 2: PDF PREVIEW / DOWNLOAD ---
    if (previewId != null || billIdParam != null) {
        try {
            int billId = Integer.parseInt(previewId != null ? previewId : billIdParam);
            Bill bill = billDAO.getBillById(billId);

            if (bill != null) {
                EmailObserver pdfTool = new EmailObserver();
                byte[] pdfData = pdfTool.generateProfessionalPdf(bill);

                response.setContentType("application/pdf");
                String disposition = (previewId != null) ? "inline" : "attachment";
                response.setHeader("Content-Disposition", disposition + "; filename=Invoice_" + billId + ".pdf");
                
                response.getOutputStream().write(pdfData);
                return; // STOP HERE for downloads
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // --- ACTION 3: FETCH DATA FOR TABLE (Default Action) ---
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    try {
        List<Bill> bills = billDAO.getAllBills();
        JsonObject summary = billDAO.getBillingSummary();
        
        JsonArrayBuilder arrayBuilder = Json.createArrayBuilder();
        for (Bill b : bills) {
            arrayBuilder.add(Json.createObjectBuilder()
                .add("billId", b.getBillId())
                .add("reservationId", b.getReservationId())
                .add("totalAmount", b.getTotalAmount())
                .add("paymentMethod", b.getPaymentMethod() != null ? b.getPaymentMethod() : "N/A")
                .add("isPaid", b.isPaid())
                .add("billingDate", b.getBillingDate() != null ? b.getBillingDate().toString() : "N/A"));
        }

        JsonObject finalResponse = Json.createObjectBuilder()
            .add("summary", summary != null ? summary : Json.createObjectBuilder()
                .add("totalRevenue", 0.0).add("paidRevenue", 0.0).add("pendingRevenue", 0.0).build())
            .add("bills", arrayBuilder.build())
            .build();

        response.getWriter().write(finalResponse.toString());
        response.getWriter().flush();

    } catch (Exception e) {
        e.printStackTrace();
        response.setStatus(500);
        response.getWriter().write("{\"status\":\"error\", \"message\":\"Server error fetching bills\"}");
    }
}
}