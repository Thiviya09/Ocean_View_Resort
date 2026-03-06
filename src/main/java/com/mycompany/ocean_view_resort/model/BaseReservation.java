/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ocean_view_resort.model;

/**
 *
 * @author thiviya
 */

public class BaseReservation implements ReservationComponent {

    private double pricePerNight;
    private int days;

    public BaseReservation(double pricePerNight, int days) {
        this.pricePerNight = pricePerNight;
        this.days = days;
    }

    public double calculateTotal() {
        return pricePerNight * days;
    }
}