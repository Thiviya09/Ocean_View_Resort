package com.mycompany.ocean_view_resort.observer;

import com.mycompany.ocean_view_resort.model.Bill;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.io.ByteArrayOutputStream;
import java.util.Properties;
import com.itextpdf.text.pdf.PdfAction;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.Document;
import com.itextpdf.text.PageSize;
public class EmailObserver implements BillObserver {

    @Override
    public void onBillGenerated(Bill bill, String guestEmail) {
    System.out.println("Observer received bill for: " + guestEmail); // DEBUG LINE
    try {
        byte[] pdfData = generateProfessionalPdf(bill);
        System.out.println("PDF Generated successfully. Sending email..."); // DEBUG LINE
        sendEmail(guestEmail, bill.getBillId(), pdfData);
        System.out.println("Email Sent!"); // DEBUG LINE
    } catch (Throwable t) { // Use Throwable to catch EVERYTHING (even NoClassDefFoundError)
        System.err.println("CRITICAL ERROR IN OBSERVER:");
        t.printStackTrace();
    }
}

//    public byte[] generateProfessionalPdf(Bill bill) throws Exception {
//        ByteArrayOutputStream baos = new ByteArrayOutputStream();
//        Document document = new Document();
//        PdfWriter.getInstance(document, baos);
//        document.open();
//
//        // Header
//        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, BaseColor.RED);
//        document.add(new Paragraph("OCEAN VIEW RESORT - INVOICE", titleFont));
//        document.add(new Paragraph("Date: " + java.time.LocalDate.now()));
//        document.add(new Paragraph("------------------------------------------------------------------"));
//
//        // Table
//        PdfPTable table = new PdfPTable(2);
//        table.setWidthPercentage(100);
//        table.setSpacingBefore(10f);
//
//        // Inside generateProfessionalPdf method
//        table.addCell("Payment Method");
//        table.addCell(bill.getPaymentMethod());
//
//        table.addCell("Payment Status");
//        table.addCell(bill.isPaid() ? "PAID" : "PENDING");
//        // ... (Continue with existing iText logic)
//        addRows(table, "Reservation ID", String.valueOf(bill.getReservationId()));
//        addRows(table, "Room Charges", "LKR " + bill.getRoomCharge());
//        addRows(table, "Food & Beverages", "LKR " + bill.getFoodCharge());
//        addRows(table, "Service Charge (10%)", "LKR " + bill.getServiceCharge());
//        addRows(table, "Discount", "- LKR " + bill.getDiscount());
//        
//        PdfPCell totalCellLabel = new PdfPCell(new Phrase("GRAND TOTAL", FontFactory.getFont(FontFactory.HELVETICA_BOLD)));
//        PdfPCell totalCellValue = new PdfPCell(new Phrase("LKR " + bill.getTotalAmount(), FontFactory.getFont(FontFactory.HELVETICA_BOLD)));
//        table.addCell(totalCellLabel);
//        table.addCell(totalCellValue);
//
//        document.add(table);
//        document.add(new Paragraph("\nThank you for staying with us!"));
//        document.close();
//        return baos.toByteArray();
//    }
    public byte[] generateProfessionalPdf(Bill bill) throws Exception {
    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    Document document = new Document(PageSize.A4);
    PdfWriter writer = PdfWriter.getInstance(document, baos);
    document.open();

    // --- Fonts ---
    Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 24, new BaseColor(44, 62, 80)); // Dark Navy
    Font subtitleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, BaseColor.GRAY);
    Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 10, BaseColor.BLACK);
    Font tableHeaderFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, BaseColor.WHITE);
    Font totalFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, new BaseColor(200, 16, 46)); // Resort Red

    // --- Header Section (Two-column layout) ---
    PdfPTable headerTable = new PdfPTable(2);
    headerTable.setWidthPercentage(100);
    headerTable.setWidths(new float[]{2, 1});

    // Left: Resort Info
    PdfPCell leftCell = new PdfPCell();
    leftCell.setBorder(Rectangle.NO_BORDER);
    leftCell.addElement(new Paragraph("OCEAN VIEW RESORT", titleFont));
    leftCell.addElement(new Paragraph("Galle Road, Colombo, Sri Lanka", normalFont));
    leftCell.addElement(new Paragraph("Contact: +94 11 234 5678", normalFont));
    headerTable.addCell(leftCell);

    // Right: Invoice Info
    PdfPCell rightCell = new PdfPCell();
    rightCell.setBorder(Rectangle.NO_BORDER);
    rightCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
    Paragraph p = new Paragraph("INVOICE", subtitleFont);
    p.setAlignment(Element.ALIGN_RIGHT);
    rightCell.addElement(p);
    Paragraph p2 = new Paragraph("#INV-" + bill.getBillId(), FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14));
    p2.setAlignment(Element.ALIGN_RIGHT);
    rightCell.addElement(p2);
    Paragraph p3 = new Paragraph("Date: " + java.time.LocalDate.now(), normalFont);
    p3.setAlignment(Element.ALIGN_RIGHT);
    rightCell.addElement(p3);
    headerTable.addCell(rightCell);

    document.add(headerTable);
    document.add(new Paragraph("\n")); // Space

    // --- Bill Details Table ---
    PdfPTable table = new PdfPTable(2);
    table.setWidthPercentage(100);
    table.setSpacingBefore(20f);
    
    // Header Style
    addStyledRow(table, "Description", "Amount (LKR)", tableHeaderFont, new BaseColor(44, 62, 80), true);

    // Data Rows
    addStyledRow(table, "Room Charges for Reservation #" + bill.getReservationId(), String.format("%.2f", bill.getRoomCharge()), normalFont, BaseColor.WHITE, false);
    addStyledRow(table, "Food & Beverages", String.format("%.2f", bill.getFoodCharge()), normalFont, new BaseColor(245, 245, 245), false);
    addStyledRow(table, "Service Charge (10%)", String.format("%.2f", bill.getServiceCharge()), normalFont, BaseColor.WHITE, false);
    
    if(bill.getDiscount() > 0) {
        addStyledRow(table, "Discount Applied", "- " + String.format("%.2f", bill.getDiscount()), normalFont, new BaseColor(255, 235, 235), false);
    }

    document.add(table);

    // --- Totals Section ---
    PdfPTable totalTable = new PdfPTable(2);
    totalTable.setWidthPercentage(40);
    totalTable.setHorizontalAlignment(Element.ALIGN_RIGHT);
    totalTable.setSpacingBefore(10f);

    PdfPCell labelCell = new PdfPCell(new Phrase("GRAND TOTAL", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12)));
    labelCell.setBorder(Rectangle.NO_BORDER);
    labelCell.setPadding(10);
    
    PdfPCell valueCell = new PdfPCell(new Phrase("LKR " + String.format("%.2f", bill.getTotalAmount()), totalFont));
    valueCell.setBorder(Rectangle.NO_BORDER);
    valueCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
    valueCell.setPadding(10);

    totalTable.addCell(labelCell);
    totalTable.addCell(valueCell);
    document.add(totalTable);

    // --- Footer ---
    document.add(new Paragraph("\n\n\n"));
    Paragraph footer = new Paragraph("Payment Method: " + bill.getPaymentMethod() + " | Status: " + (bill.isPaid() ? "PAID" : "PENDING"), normalFont);
    footer.setAlignment(Element.ALIGN_CENTER);
    document.add(footer);
    
    Paragraph thankYou = new Paragraph("\nThank you for choosing Ocean View Resort!", FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE, 10, BaseColor.GRAY));
    thankYou.setAlignment(Element.ALIGN_CENTER);
    document.add(thankYou);

    PdfAction action = new PdfAction(PdfAction.PRINTDIALOG);
    writer.setOpenAction(action);
    document.close();
    return baos.toByteArray();
}

// Helper method for clean row styling
private void addStyledRow(PdfPTable table, String label, String value, Font font, BaseColor bgColor, boolean isHeader) {
    PdfPCell cell1 = new PdfPCell(new Phrase(label, font));
    PdfPCell cell2 = new PdfPCell(new Phrase(value, font));
    
    cell1.setBackgroundColor(bgColor);
    cell2.setBackgroundColor(bgColor);
    cell1.setPadding(8);
    cell2.setPadding(8);
    cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
    
    if(!isHeader) {
        cell1.setBorder(Rectangle.BOTTOM);
        cell2.setBorder(Rectangle.BOTTOM);
        cell1.setBorderColor(BaseColor.LIGHT_GRAY);
        cell2.setBorderColor(BaseColor.LIGHT_GRAY);
    }

    table.addCell(cell1);
    table.addCell(cell2);
}

    private void addRows(PdfPTable table, String label, String value) {
        table.addCell(label);
        table.addCell(value);
    }

    private void sendEmail(String to, int billId, byte[] pdfAttachment) throws Exception {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        final String username = "oceanviewresortTHV.sl@gmail.com";
        final String appPassword = "wjau ynii suam evra";
    
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication("oceanviewresortTHV.sl@gmail.com", "wjau ynii suam evra");
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress("oceanviewresortTHV.sl@gmail.com"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject("Your Resort Bill - #" + billId);

        MimeBodyPart textPart = new MimeBodyPart();
        textPart.setText("Dear Guest, please find your attached invoice.");

        MimeBodyPart attachPart = new MimeBodyPart();
        attachPart.setDataHandler(new jakarta.activation.DataHandler(new jakarta.mail.util.ByteArrayDataSource(pdfAttachment, "application/pdf")));
        attachPart.setFileName("Invoice_" + billId + ".pdf");

        Multipart multipart = new MimeMultipart();
        multipart.addBodyPart(textPart);
        multipart.addBodyPart(attachPart);
        message.setContent(multipart);

        Transport.send(message);
    }
}