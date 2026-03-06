package com.mycompany.ocean_view_resort.facade;

///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
// */
//package com.mycompany.ocean_view_resort.facade;
//
//
//import com.mycompany.ocean_view_resort.dao.RoomDAO;
//import com.mycompany.ocean_view_resort.dao.RoomTypeDAO;
//import com.mycompany.ocean_view_resort.factory.DAOFactory;
//import com.mycompany.ocean_view_resort.model.Room;
//import com.mycompany.ocean_view_resort.model.RoomType;
//import java.sql.SQLException;
//import java.util.List;
//
//public class RoomFacade {
//
//    private RoomDAO roomDAO;
//    private RoomTypeDAO roomTypeDAO;
//
//    public RoomFacade() {
//        roomDAO = DAOFactory.getRoomDAO();
//        roomTypeDAO = DAOFactory.getRoomTypeDAO();
//    }
//
//    public boolean addRoom(Room room) {
//        return roomDAO.addRoom(room);
//    }
//
//    public boolean updateRoom(Room room) {
//        return roomDAO.updateRoom(room);
//    }
//
//    public boolean deleteRoom(int id) {
//        return roomDAO.deleteRoom(id);
//    }
//
//    public Room getRoomById(int id) {
//        try {
//            return roomDAO.getRoomById(id);
//        } catch (Exception e) {
//            e.printStackTrace();
//            return null;
//        }
//    }
//
//    // Get all rooms
//    public List<Room> getAllRooms() {
//        try {
//            return roomDAO.getAllRooms();
//        } catch (Exception ex) {
//            System.getLogger(RoomFacade.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
//        }
//        return null;
//    }
//
//    public List<RoomType> getAllRoomTypes() throws SQLException { return roomTypeDAO.getAllRoomTypes(); }
//    // Search rooms by number or type
//    public List<Room> searchRooms(String keyword) {
//        try {
//            return roomDAO.searchRooms(keyword);
//        } catch (Exception e) {
//            e.printStackTrace();
//            return null;
//        }
//    }
//}package com.mycompany.ocean_view_resort.facade;

import com.mycompany.ocean_view_resort.dao.RoomDAO;
import com.mycompany.ocean_view_resort.dao.RoomTypeDAO;
import com.mycompany.ocean_view_resort.factory.DAOFactory;
import com.mycompany.ocean_view_resort.model.Room;
import com.mycompany.ocean_view_resort.model.RoomType;

import java.util.List;

public class RoomFacade {

    private RoomDAO roomDAO;
    private RoomTypeDAO roomTypeDAO;

    public RoomFacade() {
        roomDAO = DAOFactory.getRoomDAO();
        roomTypeDAO = DAOFactory.getRoomTypeDAO();
    }

    public boolean addRoom(Room room) {
        return roomDAO.addRoom(room);
    }

    public boolean updateRoom(Room room) {
        return roomDAO.updateRoom(room);
    }

    public boolean deleteRoom(int id) {
        return roomDAO.deleteRoom(id);
    }

    public Room getRoomById(int id) {
        return roomDAO.getRoomById(id);
    }

    public List<Room> getAllRooms() {
        return roomDAO.getAllRooms();
    }

    public List<RoomType> getAllRoomTypes() {
        return roomTypeDAO.getAllRoomTypes();
    }

    public List<Room> searchRooms(String keyword) {
        return roomDAO.searchRooms(keyword);
    }
}