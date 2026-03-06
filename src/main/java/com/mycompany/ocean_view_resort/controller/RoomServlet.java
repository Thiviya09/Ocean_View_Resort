//package com.mycompany.ocean_view_resort.controller;
//
//import com.mycompany.ocean_view_resort.dao.RoomDAO;
//import com.mycompany.ocean_view_resort.model.Room;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.MultipartConfig;
//import jakarta.servlet.http.*;
//import java.io.*;
//import java.nio.file.Path;
//import java.util.List;
//import java.sql.Connection;
//import com.mycompany.ocean_view_resort.facade.RoomFacade;
//
//@MultipartConfig(fileSizeThreshold=1024*1024*2, maxFileSize=1024*1024*10, maxRequestSize=1024*1024*50)
//public class RoomServlet extends HttpServlet {
//
//    private RoomDAO dao;
//
//    @Override
//    public void init() throws ServletException {
//        dao = new RoomDAO();
//    }
//
//    @Override
//protected void doPost(HttpServletRequest request, HttpServletResponse response)
//        throws ServletException, IOException {
//
//    String id = request.getParameter("roomId");
//    String roomNumber = request.getParameter("roomNumber");
//    String roomType = request.getParameter("roomType");
//    String acType = request.getParameter("acType");
//    String priceStr = request.getParameter("price");
//    String status = request.getParameter("status");
//
//    if(roomNumber == null || roomNumber.isEmpty() ||
//       roomType == null || roomType.isEmpty() ||
//       acType == null || acType.isEmpty() ||
//       priceStr == null || priceStr.isEmpty() ||
//       status == null || status.isEmpty()) {
//        request.getSession().setAttribute("toastMessage", "Please fill all required fields");
//        request.getSession().setAttribute("toastType", "error");
//        response.sendRedirect("manage_rooms.jsp");
//        return;
//    }
//
//    double price = 0;
//    try {
//        price = Double.parseDouble(priceStr);
//    } catch(NumberFormatException e) {
//        request.getSession().setAttribute("toastMessage", "Invalid price format");
//        request.getSession().setAttribute("toastType", "error");
//        response.sendRedirect("manage_rooms.jsp");
//        return;
//    }
//
//    // Handle image upload
//    // 1. Get existing image path from hidden field
//    String existingImagePath = request.getParameter("existingImagePath");
//
//    Part imagePart = request.getPart("image");
//    String imagePath = null;
//
//    // 2. If user uploaded a new image, save it
//    if(imagePart != null && imagePart.getSize() > 0){
//        String fileName = Path.of(imagePart.getSubmittedFileName()).getFileName().toString();
//        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
//        File uploadDir = new File(uploadPath);
//        if(!uploadDir.exists()) uploadDir.mkdir();
//        imagePart.write(uploadPath + File.separator + fileName);
//        imagePath = "uploads/" + fileName;
//    } else {
//        // 3. Otherwise, keep the old image
//        imagePath = existingImagePath;
//    }
//
//
//
//
//    Room room = new Room();
//    room.setRoomNumber(roomNumber);
//    room.setRoomType(roomType);
//    room.setAcType(acType);
//    room.setPricePerNight(price);
//    room.setImagePath(imagePath); // null allowed
//    room.setStatus(status);
//
//    boolean result;
//    if(id == null || id.isEmpty()){
//        result = dao.addRoom(room);
//        request.getSession().setAttribute("toastMessage", result ? "Room added successfully" : "Failed to add room");
//        request.getSession().setAttribute("toastType", result ? "success" : "error");
//    } else {
//        room.setRoomId(Integer.parseInt(id));
//        result = dao.updateRoom(room);
//        request.getSession().setAttribute("toastMessage", result ? "Room updated successfully" : "Failed to update room");
//        request.getSession().setAttribute("toastType", result ? "success" : "error");
//    }
//
//    response.sendRedirect("manage_rooms.jsp");
//}
//
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String action = request.getParameter("action");
//
//        if("delete".equals(action)){
//            int roomId = Integer.parseInt(request.getParameter("id"));
//            boolean result = dao.deleteRoom(roomId);
//            request.getSession().setAttribute("toastMessage", result ? "Room deleted successfully" : "Failed to delete room");
//            request.getSession().setAttribute("toastType", result ? "success" : "error");
//            response.sendRedirect("manage_rooms.jsp");
//        } else if("edit".equals(action)){
//            int roomId = Integer.parseInt(request.getParameter("id"));
//            Room room = dao.getRoomById(roomId);
//            request.setAttribute("room", room);
//            request.getRequestDispatcher("manage_rooms.jsp").forward(request, response);
//        } else if("search".equals(action)){
//            String keyword = request.getParameter("keyword");
//            List<Room> rooms = dao.searchRooms(keyword);
//            request.setAttribute("rooms", rooms);
//            request.getRequestDispatcher("manage_rooms.jsp").forward(request, response);
//        } else {
//            response.sendRedirect("manage_rooms.jsp");
//        }
//    }
//}
//package com.mycompany.ocean_view_resort.controller;
//
//import com.mycompany.ocean_view_resort.facade.RoomFacade;
//import com.mycompany.ocean_view_resort.model.Room;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.MultipartConfig;
//import jakarta.servlet.http.*;
//import java.io.*;
//import java.nio.file.Path;
//import java.util.List;
//
//@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, 
//                 maxFileSize = 1024 * 1024 * 10, 
//                 maxRequestSize = 1024 * 1024 * 50)
//public class RoomServlet extends HttpServlet {
//
//    private RoomFacade facade;
//
//    @Override
//    public void init() throws ServletException {
//        facade = new RoomFacade();
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String id = request.getParameter("roomId");
//        String roomNumber = request.getParameter("roomNumber");
//        String roomType = request.getParameter("roomType");
//        String acType = request.getParameter("acType");
//        String priceStr = request.getParameter("price");
//        String status = request.getParameter("status");
//
//        // Validate required fields
//        if(roomNumber == null || roomNumber.isEmpty() ||
//           roomType == null || roomType.isEmpty() ||
//           acType == null || acType.isEmpty() ||
//           priceStr == null || priceStr.isEmpty() ||
//           status == null || status.isEmpty()) {
//
//            request.getSession().setAttribute("toastMessage", "Please fill all required fields");
//            request.getSession().setAttribute("toastType", "error");
//            response.sendRedirect("manage_rooms.jsp");
//            return;
//        }
//
//        double price = 0;
//        try {
//            price = Double.parseDouble(priceStr);
//        } catch(NumberFormatException e) {
//            request.getSession().setAttribute("toastMessage", "Invalid price format");
//            request.getSession().setAttribute("toastType", "error");
//            response.sendRedirect("manage_rooms.jsp");
//            return;
//        }
//
//        // Handle image upload
//        String existingImagePath = request.getParameter("existingImagePath");
//        Part imagePart = request.getPart("image");
//        String imagePath = null;
//
//        if(imagePart != null && imagePart.getSize() > 0){
//            String fileName = Path.of(imagePart.getSubmittedFileName()).getFileName().toString();
//            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
//            File uploadDir = new File(uploadPath);
//            if(!uploadDir.exists()) uploadDir.mkdir();
//            imagePart.write(uploadPath + File.separator + fileName);
//            imagePath = "uploads/" + fileName;
//        } else {
//            // Keep existing image if no new image uploaded
//            imagePath = existingImagePath;
//        }
//
//        Room room = new Room();
//        room.setRoomNumber(roomNumber);
//        room.setRoomType(roomType);
//        room.setAcType(acType);
//        room.setPricePerNight(price);
//        room.setImagePath(imagePath); 
//        room.setStatus(status);
//
//        boolean result;
//        if(id == null || id.isEmpty()){
//            // Add new room via facade
//            result = facade.addRoom(room);
//            request.getSession().setAttribute("toastMessage", result ? "Room added successfully" : "Failed to add room");
//            request.getSession().setAttribute("toastType", result ? "success" : "error");
//        } else {
//            // Update existing room
//            room.setRoomId(Integer.parseInt(id));
//            result = facade.updateRoom(room);
//            request.getSession().setAttribute("toastMessage", result ? "Room updated successfully" : "Failed to update room");
//            request.getSession().setAttribute("toastType", result ? "success" : "error");
//        }
//
//        response.sendRedirect("manage_rooms.jsp");
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String action = request.getParameter("action");
//
//        if("delete".equals(action)){
//            int roomId = Integer.parseInt(request.getParameter("id"));
//            boolean result = facade.deleteRoom(roomId);
//            request.getSession().setAttribute("toastMessage", result ? "Room deleted successfully" : "Failed to delete room");
//            request.getSession().setAttribute("toastType", result ? "success" : "error");
//            response.sendRedirect("manage_rooms.jsp");
//
//        } else if("edit".equals(action)){
//            int roomId = Integer.parseInt(request.getParameter("id"));
//            Room room = facade.getRoomById(roomId);
//            request.setAttribute("room", room);
//            request.getRequestDispatcher("manage_rooms.jsp").forward(request, response);
//
//        } else if("search".equals(action)){
//            String keyword = request.getParameter("keyword");
//            List<Room> rooms = facade.searchRooms(keyword);
//            request.setAttribute("rooms", rooms);
//            request.getRequestDispatcher("manage_rooms.jsp").forward(request, response);
//
//        } else {
//            // Default redirect to rooms page
//            response.sendRedirect("manage_rooms.jsp");
//        }
//    }
//}
package com.mycompany.ocean_view_resort.controller;

import com.mycompany.ocean_view_resort.facade.RoomFacade;
import com.mycompany.ocean_view_resort.model.Room;
import com.mycompany.ocean_view_resort.model.RoomType;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.sql.SQLException;
import java.util.List;

@MultipartConfig
public class RoomServlet extends HttpServlet {

    private RoomFacade facade;

    @Override
    public void init() {
        facade = new RoomFacade();
    }

    // ================= POST =================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("roomId");
        String roomNumber = request.getParameter("roomNumber");
        String typeIdStr = request.getParameter("roomTypeId");
        String acType = request.getParameter("acType");
        String priceStr = request.getParameter("price");
        String status = request.getParameter("status");

        double price = Double.parseDouble(priceStr);
        int typeId = Integer.parseInt(typeIdStr);

        // Image upload
        String existingImagePath = request.getParameter("existingImagePath");
        Part imagePart = request.getPart("image");
        String imagePath = existingImagePath;

        if (imagePart != null && imagePart.getSize() > 0) {
    String fileName = Path.of(imagePart.getSubmittedFileName()).getFileName().toString();

    // 1. Permanent Path (Your source code)
    String srcPath = "C:/Netbeans project/Ocean_View_Resort/src/main/webapp/images";
    
    // 2. Deployment Path (Where the server is currently running)
    String deployPath = getServletContext().getRealPath("") + File.separator + "images";

    // Create directories
    new File(srcPath).mkdirs();
    new File(deployPath).mkdirs();

    // Save to Source (for future rebuilds)
    imagePart.write(srcPath + File.separator + fileName);
    
    // Save to Deploy folder (so it shows up RIGHT NOW)
    // We use standard file copying because imagePart.write can usually only be called once
    java.nio.file.Files.copy(
        Path.of(srcPath + File.separator + fileName), 
        Path.of(deployPath + File.separator + fileName), 
        java.nio.file.StandardCopyOption.REPLACE_EXISTING
    );

    imagePath = "images/" + fileName;
}

        Room room = new Room();
        room.setRoomNumber(roomNumber);
        room.setTypeId(typeId);
        room.setAcType(acType);
        room.setPricePerNight(price);
        room.setStatus(status);
        room.setImagePath(imagePath);

        boolean result;

        if (id == null || id.isEmpty()) {
            result = facade.addRoom(room);
        } else {
            room.setRoomId(Integer.parseInt(id));
            result = facade.updateRoom(room);
        }

        request.getSession().setAttribute("toastMessage", "Room saved successfully!");
        request.getSession().setAttribute("toastType", "success");

        response.sendRedirect("room");
    }

    // ================= GET =================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("delete".equals(action)) {

            int id = Integer.parseInt(request.getParameter("id"));
            facade.deleteRoom(id);
            
            request.getSession().setAttribute("toastMessage", "Room deleted successfully.");
            request.getSession().setAttribute("toastType", "success");

            response.sendRedirect("room");
            return;
        }

        if ("edit".equals(action)) {

            int id = Integer.parseInt(request.getParameter("id"));
            Room room = facade.getRoomById(id);
            request.setAttribute("room", room);
        }

        if ("search".equals(action)) {

            String keyword = request.getParameter("keyword");
            request.setAttribute("rooms", facade.searchRooms(keyword));
        } else {
            List<Room> roomList = facade.getAllRooms();
            System.out.println("ROOM COUNT = " + (roomList == null ? "NULL" : roomList.size()));

            request.setAttribute("rooms", roomList);
        }
        
//response.sendRedirect("room");

        List<RoomType> types = null;
        types = facade.getAllRoomTypes();
        request.setAttribute("roomTypes", types);

        request.getRequestDispatcher("manage_rooms.jsp")
               .forward(request, response);
    }
    
}
//package com.mycompany.ocean_view_resort.controller;
//
//import com.mycompany.ocean_view_resort.facade.RoomFacade;
//import com.mycompany.ocean_view_resort.model.Room;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.MultipartConfig;
//import jakarta.servlet.http.*;
//import java.io.*;
//import java.nio.file.Path;
//import java.util.List;
//import jakarta.servlet.RequestDispatcher;
//import java.sql.SQLException;
//
//@MultipartConfig(fileSizeThreshold=1024*1024*2, maxFileSize=1024*1024*10, maxRequestSize=1024*1024*50)
//public class RoomServlet extends HttpServlet {
//
//    private RoomFacade facade;
//
//    List<String> roomTypes;
//
//    public RoomServlet() throws SQLException {
//        this.roomTypes = facade.getAllRoomTypes();
//    }
//    
//   
//
//    @Override
//    public void init() throws ServletException {
//        facade = new RoomFacade();
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        request.setAttribute("roomTypes", roomTypes);
//        String id = request.getParameter("roomId");
//        String roomNumber = request.getParameter("roomNumber");
//        String roomType = request.getParameter("roomType");
//        String acType = request.getParameter("acType");
//        String priceStr = request.getParameter("price");
//        String status = request.getParameter("status");
//        String existingImagePath = request.getParameter("existingImagePath");
//
//        // Validation
//        if(roomNumber == null || roomNumber.isEmpty() ||
//           roomType == null || roomType.isEmpty() ||
//           acType == null || acType.isEmpty() ||
//           priceStr == null || priceStr.isEmpty() ||
//           status == null || status.isEmpty()) {
//
//            request.getSession().setAttribute("toastMessage", "Please fill all required fields");
//            request.getSession().setAttribute("toastType", "error");
//            response.sendRedirect("manage_rooms.jsp");
//            return;
//        }
//
//        double price = 0;
//        try {
//            price = Double.parseDouble(priceStr);
//        } catch(NumberFormatException e) {
//            request.getSession().setAttribute("toastMessage", "Invalid price format");
//            request.getSession().setAttribute("toastType", "error");
//            response.sendRedirect("manage_rooms.jsp");
//            return;
//        }
//
//        // Handle image upload
//        Part imagePart = request.getPart("image");
//        String imagePath = null;
//
//        if(imagePart != null && imagePart.getSize() > 0){
//            String fileName = Path.of(imagePart.getSubmittedFileName()).getFileName().toString();
//            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
//            File uploadDir = new File(uploadPath);
//            if(!uploadDir.exists()) uploadDir.mkdir();
//            imagePart.write(uploadPath + File.separator + fileName);
//            imagePath = "uploads/" + fileName;
//        } else {
//            // Keep existing image for updates
//            imagePath = existingImagePath;
//        }
//
//        Room room = new Room();
//        room.setRoomNumber(roomNumber);
//        room.setRoomType(roomType);
//        room.setAcType(acType);
//        room.setPricePerNight(price);
//        room.setImagePath(imagePath);
//        room.setStatus(status);
//
//        boolean result;
//        if(id == null || id.isEmpty()){
//            result = facade.addRoom(room);
//            request.getSession().setAttribute("toastMessage", result ? "Room added successfully" : "Failed to add room");
//            request.getSession().setAttribute("toastType", result ? "success" : "error");
//        } else {
//            room.setRoomId(Integer.parseInt(id));
//            result = facade.updateRoom(room);
//            request.getSession().setAttribute("toastMessage", result ? "Room updated successfully" : "Failed to update room");
//            request.getSession().setAttribute("toastType", result ? "success" : "error");
//        }
//
//        response.sendRedirect("manage_rooms.jsp");
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String action = request.getParameter("action");
//
//        if("delete".equals(action)){
//            int roomId = Integer.parseInt(request.getParameter("id"));
//            boolean result = facade.deleteRoom(roomId);
//            request.getSession().setAttribute("toastMessage", result ? "Room deleted successfully" : "Failed to delete room");
//            request.getSession().setAttribute("toastType", result ? "success" : "error");
//            response.sendRedirect("manage_rooms.jsp");
//
//        } else if("edit".equals(action)){
//            int roomId = Integer.parseInt(request.getParameter("id"));
//            Room room = facade.getRoomById(roomId);  // <- Now works
//            request.setAttribute("room", room);
//            request.getRequestDispatcher("manage_rooms.jsp").forward(request, response);
//
//        } else if("search".equals(action)){
//            String keyword = request.getParameter("keyword");
//            List<Room> rooms = facade.searchRooms(keyword);
//            request.setAttribute("rooms", rooms);
//            request.getRequestDispatcher("manage_rooms.jsp").forward(request, response);
//
//        } else {
//            response.sendRedirect("manage_rooms.jsp");
//        }
//    }
//}
//package com.mycompany.ocean_view_resort.controller;
//
//import com.mycompany.ocean_view_resort.facade.RoomFacade;
//import com.mycompany.ocean_view_resort.model.Room;
//
//import jakarta.servlet.ServletException;
//import jakarta.servlet.RequestDispatcher;
//import jakarta.servlet.annotation.MultipartConfig;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//
//import java.io.IOException;
//import java.util.List;
//
////@WebServlet("/room")
//@MultipartConfig
//public class RoomServlet extends HttpServlet {
//
//    
//    private RoomFacade facade;
//
//    @Override
//    public void init() throws ServletException {
//        facade = new RoomFacade();
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String action = request.getParameter("action");
//
//        try {
//
//            // Always load room types for dropdown
//            List<Room> rooms = facade.getAllRooms();
//        request.setAttribute("rooms", rooms);
//        
//            List<String> roomTypes = facade.getAllRoomTypes();
//            request.setAttribute("roomTypes", roomTypes);
//
////            if (action == null) {
////                response.sendRedirect("manage_rooms.jsp");
////                  RequestDispatcher rd = request.getRequestDispatcher("manage_rooms.jsp");
////rd.forward(request, response);
////response.sendRedirect("room");
////                return;
////            }
//
////            switch (action) {
////
////                case "edit":
////                    int editId = Integer.parseInt(request.getParameter("id"));
////                    Room room = facade.getRoomById(editId);
////                    request.setAttribute("room", room);
////                    RequestDispatcher rd = request.getRequestDispatcher("manage_rooms.jsp");
////                    rd.forward(request, response);
////                    break;
////
////                case "delete":
////                    int deleteId = Integer.parseInt(request.getParameter("id"));
////                    facade.deleteRoom(deleteId);
////
////                    HttpSession session = request.getSession();
////                    session.setAttribute("toastMessage", "Room deleted successfully!");
////                    session.setAttribute("toastType", "success");
////
//////                    response.sendRedirect("manage_rooms.jsp");
////                    response.sendRedirect("room");
//////                      rd = request.getRequestDispatcher("manage_rooms.jsp");
//////rd.forward(request, response);
////                    break;
////
////                default:
//////                    response.sendRedirect("manage_rooms.jsp");
//////                    rd = request.getRequestDispatcher("manage_rooms.jsp");
//////rd.forward(request, response);
////                    response.sendRedirect("room");
////                    break;
////            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
////            response.sendRedirect("manage_rooms.jsp");
////                RequestDispatcher rd = request.getRequestDispatcher("manage_rooms.jsp");
////rd.forward(request, response);
////            response.sendRedirect("manage_rooms.jsp");
//response.sendRedirect(request.getContextPath() + "/room");
//        }
//       
//
//        if("delete".equals(action)){
//            int roomId = Integer.parseInt(request.getParameter("roomId"));
//            boolean result = facade.deleteRoom(roomId);
//            request.getSession().setAttribute("toastMessage", result ? "Room deleted successfully" : "Failed to delete room");
//            request.getSession().setAttribute("toastType", result ? "success" : "error");
////            response.sendRedirect("manage_rooms.jsp");
//response.sendRedirect(request.getContextPath() + "/room");
//
//        } else if("edit".equals(action)){
//            int roomId = Integer.parseInt(request.getParameter("roomId"));
//            Room room = facade.getRoomById(roomId);  // <- Now works
//            request.setAttribute("room", room);
//            request.getRequestDispatcher("manage_rooms.jsp").forward(request, response);
//
//        } else if("search".equals(action)){
//            String keyword = request.getParameter("keyword");
//            List<Room> rooms = facade.searchRooms(keyword);
//            request.setAttribute("rooms", rooms);
//            request.getRequestDispatcher("manage_rooms.jsp").forward(request, response);
//
//        }
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String id = request.getParameter("roomId");
//        String roomNumber = request.getParameter("roomNumber");
//        String roomType = request.getParameter("roomType");
//        String price = request.getParameter("price");
//
//        Room room = new Room();
//        room.setRoomNumber(roomNumber);
//        room.setRoomType(roomType);
//        room.setPricePerNight(Double.parseDouble(price));
//        
//
//
//        try {
//
//            boolean result = false;
//            if (id == null || id.isEmpty()) {
//    result = facade.addRoom(room);
//    request.getSession().setAttribute("toastMessage",
//        result ? "Room added successfully" : "Failed to add room");} 
//            else {
//                room.setRoomId(Integer.parseInt(id));
//                result = facade.updateRoom(room);
//                request.getSession().setAttribute("toastMessage", result ? "Room updated successfully" : "Failed to update room");
//                request.getSession().setAttribute("toastType", result ? "success" : "error");
//            }
//
////            request.getSession().setAttribute("toastType", "success");
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            request.getSession().setAttribute("toastMessage", "Something went wrong!");
//            request.getSession().setAttribute("toastType", "error");
//        }
////        response.sendRedirect("manage_rooms.jsp");
//response.sendRedirect(request.getContextPath() + "/room");
//    }
//}
