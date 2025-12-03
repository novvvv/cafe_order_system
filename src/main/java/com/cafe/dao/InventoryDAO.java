package com.cafe.dao;

import com.cafe.dto.Inventory;
import com.cafe.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class InventoryDAO {

    // Method: getAllInventory() - 전체 재고 조회
    // -- 데이터베이스에서 모든 재고 정보를 조회해 리스트로 반환한다.
    public List<Inventory> getAllInventory() {

        // -- Init --
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Inventory> inventoryList = new ArrayList<Inventory>();

        // -- SQL Query --
        String sql = "SELECT menu_id, menu_name, stock_quantity " +
                "FROM cafe_inventory " +
                "ORDER BY menu_name";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {

                Inventory inventory = new Inventory();
                inventory.setMenuId(rs.getInt("menu_id"));
                inventory.setMenuName(rs.getString("menu_name"));
                inventory.setStockQuantity(rs.getInt("stock_quantity"));
                inventoryList.add(inventory);

            }
        }

        catch (SQLException e) {
            e.printStackTrace();
        }

        finally {
            closeResources(rs, pstmt, conn);
        }

        return inventoryList;
    }

    // Method: getInventoryByMenuName() - 특정 메뉴의 재고 조회
    // -- 메뉴명으로 재고 정보를 조회한다.
    public Inventory getInventoryByMenuName(String menuName) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Inventory inventory = null;

        String sql = "SELECT menu_id, menu_name, stock_quantity " +
                "FROM cafe_inventory " +
                "WHERE menu_name = ?";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, menuName);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                inventory = new Inventory();
                inventory.setMenuId(rs.getInt("menu_id"));
                inventory.setMenuName(rs.getString("menu_name"));
                inventory.setStockQuantity(rs.getInt("stock_quantity"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return inventory;
    }

    // Method: decreaseStock() - 재고 차감
    // -- 주문 처리 시 재고를 차감한다. --
    public boolean decreaseStock(String menuName, int quantity) {

        // -- Init --
        Connection conn = null;
        PreparedStatement pstmt = null;

        // -- SQL Query --
        String sql = "UPDATE cafe_inventory " +
                "SET stock_quantity = stock_quantity - ? " +
                "WHERE menu_name = ? AND stock_quantity >= ?";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, quantity);
            pstmt.setString(2, menuName);
            pstmt.setInt(3, quantity); // 재고가 충분한지 확인

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

    // Method: isOutOfStock() - 품절 여부 확인
    // -- 메뉴의 재고가 0인지 확인한다. --
    public boolean isOutOfStock(String menuName) {
        Inventory inventory = getInventoryByMenuName(menuName);

        if (inventory == null) {
            return true; // 메뉴가 없으면 품절로 처리
        }

        return inventory.getStockQuantity() <= 0;
    }

    // Method: updateStockQuantity() - 재고 수량 직접 업데이트
    // -- 재고 수량을 직접 설정한다. (관리자 페이지용)
    public boolean updateStockQuantity(String menuName, int newQuantity) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "UPDATE cafe_inventory " +
                "SET stock_quantity = ? " +
                "WHERE menu_name = ?";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, newQuantity);
            pstmt.setString(2, menuName);

            int result = pstmt.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(pstmt, conn);
        }
    }

    // Method: closeResources() - 리소스 해제 함수 (ResultSet 포함)
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

    // Method: closeResources() - 리소스 해제 함수 (기존 메서드 - 하위 호환성)
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
