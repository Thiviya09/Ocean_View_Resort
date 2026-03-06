/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ocean_view_resort.model;

/**
 *
 * @author thiviya
 */

public abstract class DiscountDecorator implements ReservationComponent {

    protected ReservationComponent component;

    public DiscountDecorator(ReservationComponent component) {
        this.component = component;
    }
}