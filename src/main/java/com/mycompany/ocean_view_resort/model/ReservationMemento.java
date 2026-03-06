/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ocean_view_resort.model;

/**
 *
 * @author thiviya
 */


public class ReservationMemento {

    private final Reservation reservation;

    public ReservationMemento(Reservation reservation) {
        this.reservation = reservation;
    }

    public Reservation getSavedState() {
        return reservation;
    }
}