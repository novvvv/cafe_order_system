package com.cafe.dao;

import com.cafe.dto.Order;
import com.cafe.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    // * insertOrder() - 주문 데이터 삽입 함수
    // * 데이터베이스에 주문 데이터 (Order)를 삽입한다.
    public boolean insertOrder(Order order) {

        Connection conn = null; // JDBC Connection 객체
        PreparedStatement pstmt = null; // SQL 쿼리 실행 PreparedStatement 객체

        // INSERT QUERY
        String sql = "INSERT INTO cafe_orders " +
                "(customer_name, customer_phone, menu_name, size_code, temperature, " +
                "quantity, unit_price, total_price, request_message) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {

            // 데이터베이스 생성
            conn = DBUtil.getConnection();

            // PreparedStatement 생성
            pstmt = conn.prepareStatement(sql);

            // 파라미터 설정
            pstmt.setString(1, order.getCustomerName());
            pstmt.setString(2, order.getCustomerPhone());
            pstmt.setString(3, order.getMenuName());
            pstmt.setString(4, order.getSizeCode());
            pstmt.setString(5, order.getTemperature());
            pstmt.setInt(6, order.getQuantity());
            pstmt.setInt(7, order.getUnitPrice());
            pstmt.setInt(8, order.getTotalPrice());
            pstmt.setString(9, order.getRequestMessage() != null ? order.getRequestMessage() : "");

            // SQL 실행
            int result = pstmt.executeUpdate();

            // 결과 반환 (1개 이상의 행이 영향을 받으면 성공)
            return result > 0;

        }

        catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        finally {
            closeResources(pstmt, conn);
        }
    }

    // * getAllOrders() - 전체 주문 목록 조회 (최신순으로 정렬))
    // * 데이터베이스에서 주문 데이터 (Order)를 조회해 리스트로 반환한다. *
    public List<Order> getAllOrders() {

        Connection conn = null; // JDBC Connection 객체
        PreparedStatement pstmt = null; // SQL 쿼리 실행 PreparedStatement 객체
        ResultSet rs = null; // SQL 쿼리 결과 ResultSet 객체
        List<Order> orderList = new ArrayList<Order>(); // Order 객체 리스트

        // SELECT QUERY - 최신 주문부터 표시
        String sql = "SELECT order_id, customer_name, customer_phone, menu_name, " +
                "size_code, temperature, quantity, unit_price, total_price, " +
                "request_message, order_time " +
                "FROM cafe_orders " +
                "ORDER BY order_time DESC";

        try {
            conn = DBUtil.getConnection();

            pstmt = conn.prepareStatement(sql);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                order.setCustomerName(rs.getString("customer_name"));
                order.setCustomerPhone(rs.getString("customer_phone"));
                order.setMenuName(rs.getString("menu_name"));
                order.setSizeCode(rs.getString("size_code"));
                order.setTemperature(rs.getString("temperature"));
                order.setQuantity(rs.getInt("quantity"));
                order.setUnitPrice(rs.getInt("unit_price"));
                order.setTotalPrice(rs.getInt("total_price"));
                order.setRequestMessage(rs.getString("request_message"));
                order.setOrderTime(rs.getTimestamp("order_time"));

                orderList.add(order);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return orderList;
    }

    // * closeResources() - 리소스 해제 함수 (ResultSet 포함)
    private void closeResources(ResultSet rs, PreparedStatement pstmt, Connection conn) {

        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // * closeResources() - 리소스 해제 함수 (기존 메서드 - 하위 호환성)
    private void closeResources(PreparedStatement pstmt, Connection conn) {

        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
