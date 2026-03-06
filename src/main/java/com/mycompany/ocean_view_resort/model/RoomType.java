package com.mycompany.ocean_view_resort.model;

public class RoomType {

    private int typeId;
    private String typeName;
    private int capacity;

    public RoomType() {}

    public RoomType(int typeId, String typeName, int capacity) {
        this.typeId = typeId;
        this.typeName = typeName;
        this.capacity = capacity;
    }

    public int getTypeId() { return typeId; }
    public void setTypeId(int typeId) { this.typeId = typeId; }

    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }

    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }
}