package com.cafe.dao;

import com.cafe.dto.Order;
import com.cafe.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class OrderDAO {

    // Logic insertOrder() - 주문 데이터 삽입 함수
    // -- 데이터베이스에 주문 데이터 (Order)를 삽입한다.
    public boolean insertOrder(Order order) {

        Connection conn = null; // JDBC Connection 객체
        PreparedStatement pstmt = null; // SQL 쿼리 실행 PreparedStatement 객체

        // INSERT QUERY
        String sql = "INSERT INTO cafe_orders " +
                "(customer_name, customer_phone, menu_name, size_code, temperature, " +
                "quantity, unit_price, total_price, request_message, order_status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

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
            pstmt.setString(10, order.getOrderStatus() != null ? order.getOrderStatus() : "WAITING");

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
                "request_message, order_time, order_status " +
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
                order.setOrderStatus(rs.getString("order_status"));

                orderList.add(order);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return orderList;
    }

    // * getCompletedOrdersByDate() - 완료된 주문 일별 통계 조회
    // * COMPLETED 상태인 주문을 일별로 그룹화하여 주문 건수와 총 매출을 반환한다.
    public Map<String, Map<String, Object>> getCompletedOrdersByDate() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Map<String, Map<String, Object>> dateStats = new LinkedHashMap<>();

        String sql = "SELECT DATE(order_time) as order_date, " +
                "COUNT(*) as order_count, " +
                "SUM(total_price) as total_revenue " +
                "FROM cafe_orders " +
                "WHERE order_status = 'COMPLETED' " +
                "GROUP BY DATE(order_time) " +
                "ORDER BY order_date DESC";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                String date = rs.getString("order_date");
                Map<String, Object> stats = new HashMap<>();
                stats.put("orderCount", rs.getInt("order_count"));
                stats.put("totalRevenue", rs.getLong("total_revenue"));
                dateStats.put(date, stats);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return dateStats;
    }

    // * getCompletedOrdersByWeek() - 완료된 주문 주간 통계 조회
    // * COMPLETED 상태인 주문을 주간으로 그룹화하여 주문 건수와 총 매출을 반환한다.
    public Map<String, Map<String, Object>> getCompletedOrdersByWeek() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Map<String, Map<String, Object>> weekStats = new LinkedHashMap<>();

        String sql = "SELECT CONCAT(YEAR(order_time), '-W', LPAD(WEEK(order_time, 1), 2, '0')) as order_week, " +
                "COUNT(*) as order_count, " +
                "SUM(total_price) as total_revenue " +
                "FROM cafe_orders " +
                "WHERE order_status = 'COMPLETED' " +
                "GROUP BY YEAR(order_time), WEEK(order_time, 1) " +
                "ORDER BY YEAR(order_time) DESC, WEEK(order_time, 1) DESC";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                String week = rs.getString("order_week");
                Map<String, Object> stats = new HashMap<>();
                stats.put("orderCount", rs.getInt("order_count"));
                stats.put("totalRevenue", rs.getLong("total_revenue"));
                weekStats.put(week, stats);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return weekStats;
    }

    // * getCompletedOrdersByMonth() - 완료된 주문 월별 통계 조회
    // * COMPLETED 상태인 주문을 월별로 그룹화하여 주문 건수와 총 매출을 반환한다.
    public Map<String, Map<String, Object>> getCompletedOrdersByMonth() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Map<String, Map<String, Object>> monthStats = new LinkedHashMap<>();

        String sql = "SELECT DATE_FORMAT(order_time, '%Y-%m') as order_month, " +
                "COUNT(*) as order_count, " +
                "SUM(total_price) as total_revenue " +
                "FROM cafe_orders " +
                "WHERE order_status = 'COMPLETED' " +
                "GROUP BY DATE_FORMAT(order_time, '%Y-%m') " +
                "ORDER BY order_month DESC";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                String month = rs.getString("order_month");
                Map<String, Object> stats = new HashMap<>();
                stats.put("orderCount", rs.getInt("order_count"));
                stats.put("totalRevenue", rs.getLong("total_revenue"));
                monthStats.put(month, stats);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return monthStats;
    }

    // * updateOrderStatus() - 주문 상태 업데이트 함수
    // * 주문 ID와 새로운 상태를 받아서 주문 상태를 업데이트한다.
    public boolean updateOrderStatus(int orderId, String status) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "UPDATE cafe_orders SET order_status = ? WHERE order_id = ?";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setInt(2, orderId);
            int result = pstmt.executeUpdate();
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

    // Method getPendingOrdersByMenu() - Waiting/Pending 상태 주문을 메뉴별로 조회
    // -- 메뉴별로 그룹화하여 각 메뉴의 총 수량(quantity 합계)을 반환한다. --
    public Map<String, Integer> getPendingOrdersByMenu() {

        // -- Init --
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Map<String, Integer> menuCounts = new HashMap<>();

        // -- SQL Query --
        // -- order_stauts가 WAITING 혹은 PENDING 상태인 주문을 그룹화하여, 수량을 반환 --
        String sql = "SELECT menu_name, SUM(quantity) as total_quantity " +
                "FROM cafe_orders " +
                "WHERE order_status IN ('WAITING', 'PENDING') " +
                "GROUP BY menu_name";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                String menuName = rs.getString("menu_name");
                int totalQuantity = rs.getInt("total_quantity");
                menuCounts.put(menuName, totalQuantity);
            }

        }

        catch (SQLException e) {
            e.printStackTrace();
        }

        finally {
            closeResources(rs, pstmt, conn);
        }

        return menuCounts;
    }

    // Method getPendingOrderCount() - Waiting/Pending 상태 주문 총 건수 조회
    // -- 제조중인 주문의 총 건수를 반환한다. --
    public int getPendingOrderCount() {

        // -- Init --
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;

        // -- SQL Query --
        // -- order_stauts가 WAITING 혹은 PENDING 상태인 주문의 총 건수를 반환 --
        String sql = "SELECT COUNT(*) as total_count " +
                "FROM cafe_orders " +
                "WHERE order_status IN ('WAITING', 'PENDING')";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                count = rs.getInt("total_count");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return count;
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
