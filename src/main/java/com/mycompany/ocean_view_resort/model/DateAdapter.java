/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ocean_view_resort.model;

/**
 *
 * @author thiviya
 */

import java.sql.Date;
import java.time.LocalDate;

public class DateAdapter {

    public static Date toSqlDate(LocalDate date) {
        return Date.valueOf(date);
    }

    public static LocalDate toLocalDate(Date date) {
        return date.toLocalDate();
    }
}