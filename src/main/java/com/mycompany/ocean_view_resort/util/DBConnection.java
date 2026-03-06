/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ocean_view_resort.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
/**
 *
 * @author thiviya
 */

public class DBConnection {

    private static Connection connection;

    private DBConnection() {}

    public static Connection getConnection() {

        try {
            if (connection == null || connection.isClosed()) {

                connection = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/ocean_view_resort",
                        "root",
                        ""
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return connection;
    }
}