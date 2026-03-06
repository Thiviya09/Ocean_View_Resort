/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ocean_view_resort.model;

/**
 *
 * @author thiviya
 */
public class Guest {
    
    private int guestId;
    private String guestName;
    private String address;
    private String contactNumber;
    private String email;
    
    public int getId() { return guestId; }
    public void setId(int id) { this.guestId = id; }
    
    public String getGuestName(){
        return guestName;
    }
    
    public void setGuestName(String guestName){
        this.guestName = guestName;
    }
    
    public String getAddress(){
        return address;
    }
    public void setAddress(String address){
        this.address = address;
    }
    
    public String getContactNumber(){
        return contactNumber;
    }
    public void setContactNumber(String contactNumber){
        this.contactNumber = contactNumber;
    }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}
