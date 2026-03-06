/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ocean_view_resort.mediator;

/**
 *
 * @author saran
 */


import com.mycompany.ocean_view_resort.dao.*;
import com.mycompany.ocean_view_resort.model.*;
import java.time.LocalDate;
import java.util.List;

public class ReservationMediator {

    private RoomDAO roomDAO = new RoomDAO();
    private ReservationDAO reservationDAO = new ReservationDAO();
    private ReservationCaretaker caretaker = new ReservationCaretaker();

    public boolean isAvailable(int roomId, LocalDate in, LocalDate out) {
        return reservationDAO.isRoomAvailable(roomId, in, out);
    }

    public void bookReservation(Reservation r) {
        try {
            //        reservationDAO.saveReservation(r);
            reservationDAO.save(r);
        } catch (Exception ex) {
            System.getLogger(ReservationMediator.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
        }
        roomDAO.updateRoomStatus(r.getRoomId(), "UNAVAILABLE");
    }

    public void cancelReservation(int id) {
//        reservationDAO.cancelReservation(id);
           reservationDAO.delete(id);
    }

    public List<Reservation> getAllReservations() {
//        return reservationDAO.getAllReservations();
            return reservationDAO.findAll();
    }
}