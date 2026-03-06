//package com.mycompany.ocean_view_resort.controller;
//
//import com.mycompany.ocean_view_resort.factory.DAOFactory;
//import com.mycompany.ocean_view_resort.dao.RoomTypeDAO;
//
//import jakarta.servlet.*;
//import jakarta.servlet.http.*;
//import java.io.IOException;
//
//public class RoomTypeServlet extends HttpServlet {
//
//    private RoomTypeDAO roomTypeDAO;
//
//    @Override
//    public void init() {
//        roomTypeDAO = DAOFactory.getRoomTypeDAO();
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String id = request.getParameter("id");
//        String typeName = request.getParameter("typeName");
//
//        try {
//            if (id == null || id.isEmpty()) {
//                roomTypeDAO.addRoomType(typeName);
//            } else {
//                roomTypeDAO.updateRoomType(Integer.parseInt(id), typeName);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        response.sendRedirect("room");
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String action = request.getParameter("action");
//
//        try {
//            if ("delete".equals(action)) {
//                int id = Integer.parseInt(request.getParameter("id"));
//                roomTypeDAO.deleteRoomType(id);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        response.sendRedirect("room");
//    }
//}
package com.mycompany.ocean_view_resort.controller;

import com.mycompany.ocean_view_resort.dao.RoomTypeDAO;
import com.mycompany.ocean_view_resort.factory.DAOFactory;
import com.mycompany.ocean_view_resort.model.RoomType;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.google.gson.Gson;
import java.io.IOException;
import java.util.List;

//@WebServlet("/roomType")
public class RoomTypeServlet extends HttpServlet {

    private RoomTypeDAO roomTypeDAO;

    @Override
    public void init() {
        roomTypeDAO = DAOFactory.getRoomTypeDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idStr = request.getParameter("id");
        String typeName = request.getParameter("typeName");
        String capacityStr = request.getParameter("capacity");

        if (typeName == null || typeName.isEmpty() ||
            capacityStr == null || capacityStr.isEmpty()) {

            request.getSession().setAttribute("toastMessage", "All fields required");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect("room");
            return;
        }

        int capacity;

        try {
            capacity = Integer.parseInt(capacityStr);
            if (capacity <= 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("toastMessage", "Invalid capacity");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect("room");
            return;
        }

        try {

            if (idStr == null || idStr.isEmpty()) {

                RoomType rt = new RoomType();
                rt.setTypeName(typeName);
                rt.setCapacity(capacity);

                roomTypeDAO.addRoomType(rt);

                request.getSession().setAttribute("toastMessage", "Room type added");
            } else {

                RoomType rt = new RoomType();
                rt.setTypeId(Integer.parseInt(idStr));
                rt.setTypeName(typeName);
                rt.setCapacity(capacity);

                roomTypeDAO.updateRoomType(rt);

                request.getSession().setAttribute("toastMessage", "Room type updated");
            }

            request.getSession().setAttribute("toastType", "success");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("toastMessage", "Operation failed");
            request.getSession().setAttribute("toastType", "error");
        }

        response.sendRedirect("room");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String action = request.getParameter("action");

        if ("delete".equals(action)) {

            int id = Integer.parseInt(request.getParameter("id"));

            try {
                boolean deleted = roomTypeDAO.deleteRoomType(id);

                if (!deleted) {
                    request.getSession().setAttribute("toastMessage",
                            "Cannot delete. Rooms are using this type.");
                    request.getSession().setAttribute("toastType", "error");
                } else {
                    request.getSession().setAttribute("toastMessage",
                            "Room type deleted successfully");
                    request.getSession().setAttribute("toastType", "success");
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if ("list".equals(action)) {
    List<RoomType> types = roomTypeDAO.getAllRoomTypes();
    Gson gson = new Gson();
    String json = gson.toJson(types); // converts list to JSON
    response.setContentType("application/json");
    response.getWriter().write(json);
    return;}

        response.sendRedirect("room");
    }
}