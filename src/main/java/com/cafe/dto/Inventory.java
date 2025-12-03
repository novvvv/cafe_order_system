package com.cafe.dto;

/**
 * 재고 정보를 담는 DTO
 */
public class Inventory {

    private int menuId; // 메뉴 ID (자동 증가)
    private String menuName; // 메뉴 이름
    private int stockQuantity; // 잔여 재고 수량

    // 기본 생성자
    public Inventory() {
    }

    // 생성자
    public Inventory(String menuName, int stockQuantity) {
        this.menuName = menuName;
        this.stockQuantity = stockQuantity;
    }

    // Getter and Setter
    public int getMenuId() {
        return menuId;
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }

    public String getMenuName() {
        return menuName;
    }

    public void setMenuName(String menuName) {
        this.menuName = menuName;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }
}
