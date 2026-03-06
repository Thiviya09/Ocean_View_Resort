package com.mycompany.ocean_view_resort.model;

import java.util.Map;

public class Room {

    private int roomId;
    private String roomNumber;
    private int typeId;            // FK
    private String roomType;       // For display (JOIN)
    private String acType;
    private double pricePerNight;
    private String status;
    private String imagePath;

    public Room() {}

    public Room(int roomId, String roomNumber, int typeId,
                String roomType, String acType,
                double pricePerNight, String status, String imagePath) {

        this.roomId = roomId;
        this.roomNumber = roomNumber;
        this.typeId = typeId;
        this.roomType = roomType;
        this.acType = acType;
        this.pricePerNight = pricePerNight;
        this.status = status;
        this.imagePath = imagePath;
    }

    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public int getTypeId() { return typeId; }
    public void setTypeId(int typeId) { this.typeId = typeId; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public String getAcType() { return acType; }
    public void setAcType(String acType) { this.acType = acType; }

    public double getPricePerNight() { return pricePerNight; }
    public void setPricePerNight(double pricePerNight) { this.pricePerNight = pricePerNight; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public void setExtraData(Map<String, Object> roomTypeData) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}