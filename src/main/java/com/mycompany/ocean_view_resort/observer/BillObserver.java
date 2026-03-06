/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.mycompany.ocean_view_resort.observer;
import com.mycompany.ocean_view_resort.model.Bill;

public interface BillObserver {
    void onBillGenerated(Bill bill, String guestEmail);
}