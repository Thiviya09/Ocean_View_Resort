/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ocean_view_resort.model;

/**
 *
 * @author saran
 */

public class SeasonalDiscount extends DiscountDecorator {

    private double discountRate;

    public SeasonalDiscount(ReservationComponent component, double discountRate) {
        super(component);
        this.discountRate = discountRate;
    }

    public double calculateTotal() {
        double total = component.calculateTotal();
        return total - (total * discountRate);
    }
}