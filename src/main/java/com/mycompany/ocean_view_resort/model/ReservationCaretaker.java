/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ocean_view_resort.model;

/**
 *
 * @author thiviya
 */

import java.util.Stack;

public class ReservationCaretaker {

    private Stack<ReservationMemento> history = new Stack<>();

    public void save(Reservation reservation) {
        history.push(new ReservationMemento(reservation));
    }

    public Reservation undo() {
        if (!history.isEmpty()) {
            return history.pop().getSavedState();
        }
        return null;
    }
}