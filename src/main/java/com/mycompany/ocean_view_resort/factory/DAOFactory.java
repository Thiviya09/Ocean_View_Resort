/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ocean_view_resort.factory;


import com.mycompany.ocean_view_resort.dao.RoomDAO;
import com.mycompany.ocean_view_resort.dao.RoomTypeDAO;
import com.mycompany.ocean_view_resort.dao.GuestDAO;
import com.mycompany.ocean_view_resort.dao.StaffDAO;

public class DAOFactory {

    public static RoomDAO getRoomDAO() {
        return new RoomDAO();
    }

    public static GuestDAO getGuestDAO() {
        return new GuestDAO();
    }

    public static StaffDAO getStaffDAO() {
        return new StaffDAO();
    }
    
    public static RoomTypeDAO getRoomTypeDAO() {
        return new RoomTypeDAO();
    }
}