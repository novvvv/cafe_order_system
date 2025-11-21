package com.cafe.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * 데이터베이스 연결을 관리하는 유틸리티 클래스
 */
public class DBUtil {

    // TODO: 실제 데이터베이스 정보로 변경 필요
    private static final String DB_URL = "jdbc:mysql://localhost:3306/cafe_db?useSSL=false&serverTimezone=Asia/Seoul&characterEncoding=UTF-8";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "0908";
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";

    /**
     * 데이터베이스 연결을 반환합니다.
     * 
     * @return Connection 객체
     * @throws SQLException 데이터베이스 연결 오류 시
     */
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName(DB_DRIVER);
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("JDBC 드라이버를 찾을 수 없습니다.", e);
        }
    }

    /**
     * 데이터베이스 연결을 닫습니다.
     * 
     * @param conn 닫을 Connection 객체
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
