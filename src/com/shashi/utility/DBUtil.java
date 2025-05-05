package com.shashi.utility;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ResourceBundle;

public class DBUtil {
    private static Connection conn;

    public DBUtil() {}

    public static Connection provideConnection() {
        try {
            if (conn == null || conn.isClosed()) {
                ResourceBundle rb = ResourceBundle.getBundle("application");
                String connectionString = rb.getString("db.connectionString");
                String driverName = rb.getString("db.driverName");
                String username = rb.getString("db.username");
                String password = rb.getString("db.password");

                try {
                    Class.forName(driverName);
                } catch (ClassNotFoundException e) {
                    System.out.println("JDBC Driver not found: " + e.getMessage());
                    e.printStackTrace();
                    return null;
                }

                conn = DriverManager.getConnection(connectionString, username, password);
                System.out.println("Connected to database successfully.");
            }
        } catch (SQLException e) {
            System.out.println("Database connection failed: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
        return conn;
    }

    public static void closeConnection(Connection con) {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
                System.out.println("Connection closed successfully.");
            }
        } catch (SQLException e) {
            System.out.println("Failed to close connection: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static void closeConnection(ResultSet rs) {
        try {
            if (rs != null && !rs.isClosed()) {
                rs.close();
                System.out.println("ResultSet closed successfully.");
            }
        } catch (SQLException e) {
            System.out.println("Failed to close ResultSet: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static void closeConnection(PreparedStatement ps) {
        try {
            if (ps != null && !ps.isClosed()) {
                ps.close();
                System.out.println("PreparedStatement closed successfully.");
            }
        } catch (SQLException e) {
            System.out.println("Failed to close PreparedStatement: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
