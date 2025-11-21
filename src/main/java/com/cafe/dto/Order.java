package com.cafe.dto;

import java.sql.Timestamp;

/**
 * 주문 정보를 담는 DTO
 */

public class Order {

    private int orderId; // 주문 ID (자동 증가)
    private String customerName; // 고객 이름
    private String customerPhone; // 고객 연락처
    private String menuName; // 메뉴 이름
    private String sizeCode; // 사이즈 코드 (S, M, L, G, X)
    private String temperature; // 온도 (H: Hot, I: Ice)
    private int quantity; // 수량
    private int unitPrice; // 단가
    private int totalPrice; // 총 가격
    private String requestMessage; // 요청사항
    private Timestamp orderTime; // 주문 일시

    // 기본 생성자
    public Order() {
    }

    // 생성자
    public Order(String customerName, String customerPhone, String menuName,
            String sizeCode, String temperature, int quantity,
            int unitPrice, int totalPrice, String requestMessage) {
        this.customerName = customerName;
        this.customerPhone = customerPhone;
        this.menuName = menuName;
        this.sizeCode = sizeCode;
        this.temperature = temperature;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.totalPrice = totalPrice;
        this.requestMessage = requestMessage;
    }

    // Getter and Setter
    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public String getMenuName() {
        return menuName;
    }

    public void setMenuName(String menuName) {
        this.menuName = menuName;
    }

    public String getSizeCode() {
        return sizeCode;
    }

    public void setSizeCode(String sizeCode) {
        this.sizeCode = sizeCode;
    }

    public String getTemperature() {
        return temperature;
    }

    public void setTemperature(String temperature) {
        this.temperature = temperature;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(int unitPrice) {
        this.unitPrice = unitPrice;
    }

    public int getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(int totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getRequestMessage() {
        return requestMessage;
    }

    public void setRequestMessage(String requestMessage) {
        this.requestMessage = requestMessage;
    }

    public Timestamp getOrderTime() {
        return orderTime;
    }

    public void setOrderTime(Timestamp orderTime) {
        this.orderTime = orderTime;
    }

}
