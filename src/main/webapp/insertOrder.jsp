<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cafe.dto.Order" %>
<%@ page import="com.cafe.dao.OrderDAO" %>
<%@ page isErrorPage="false" %>
<!DOCTYPE html>
<html lang="ko">
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>주문 처리</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reset.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/order.css">
    
</head>
<body>

    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main>
        <div class="order-container">
            <%
                // * 변수 선언부 * 
                String name = "";
                String contact = "";
                String menu = "";
                String size = "";
                String temperature = "";
                int quantity = 1;
                int totalPrice = 0;
                boolean success = false;
                String message = "";
                boolean isValid = true;
                
                try {
                    
                    // * request - 요청 파라미터 받기 * 
                    request.setCharacterEncoding("UTF-8");                    
                    name = request.getParameter("name");
                    contact = request.getParameter("contact");
                    menu = request.getParameter("menu");
                    size = request.getParameter("size");
                    temperature = request.getParameter("temperature");
                    String quantityStr = request.getParameter("quantity");
                    String requests = request.getParameter("requests");
                    
                    // 오류 메시지 
                    String errorMessage = "";
                
                // * 서버측 파라미터 검증 * 
                // * 클라이언트측에서 JS를 비활성화시 클라이언트 검증이 동작하지 않기에 이중 검증 (Defense in Depth) 구조를 채택 * 
                if (name == null || name.trim().isEmpty()) {
                    isValid = false;
                    errorMessage = "이름을 입력해주세요.";
                } else if (contact == null || contact.trim().isEmpty()) {
                    isValid = false;
                    errorMessage = "연락처를 입력해주세요.";
                } else if (menu == null || menu.isEmpty()) {
                    isValid = false;
                    errorMessage = "메뉴를 선택해주세요.";
                } else if (size == null || size.isEmpty()) {
                    isValid = false;
                    errorMessage = "사이즈를 선택해주세요.";
                } else if (temperature == null || temperature.isEmpty()) {
                    isValid = false;
                    errorMessage = "온도를 선택해주세요.";
                } else if (quantityStr == null || quantityStr.trim().isEmpty()) {
                    isValid = false;
                    errorMessage = "수량을 입력해주세요.";
                }
                
                // 가격 계산 
                int basePrice = 0;
                int sizePrice = 0;
                int unitPrice = 0;
                
                if (isValid) {
                    // 메뉴별 기본 가격
                    if ("americano".equals(menu)) {
                        basePrice = 4500;
                    } else if ("espresso".equals(menu)) {
                        basePrice = 4300;
                    } else if ("latte".equals(menu)) {
                        basePrice = 5000;
                    } else if ("cappuccino".equals(menu)) {
                        basePrice = 5000;
                    }
                    
                    // 사이즈별 추가 금액
                    if ("S".equals(size)) {
                        sizePrice = 0;
                    } else if ("M".equals(size)) {
                        sizePrice = 100;
                    } else if ("L".equals(size)) {
                        sizePrice = 200;
                    } else if ("G".equals(size)) {
                        sizePrice = 500;
                    } else if ("X".equals(size)) {
                        sizePrice = 1000;
                    }
                    
                    quantity = Integer.parseInt(quantityStr);
                    unitPrice = basePrice + sizePrice;
                    totalPrice = unitPrice * quantity;
                    
                    // Order 객체 생성 및 DB 저장
                    Order order = new Order();
                    order.setCustomerName(name);
                    order.setCustomerPhone(contact);
                    order.setMenuName(menu);
                    order.setSizeCode(size);
                    order.setTemperature(temperature);
                    order.setQuantity(quantity);
                    order.setUnitPrice(unitPrice);
                    order.setTotalPrice(totalPrice);
                    order.setRequestMessage(requests != null ? requests : "");
                    
                    // OrderDAO를 사용해서 DB에 저장
                    OrderDAO orderDAO = new OrderDAO();
                    success = orderDAO.insertOrder(order);
                    
                    if (success) {
                        message = "주문이 성공적으로 등록되었습니다.";
                    } else {
                        message = "주문 등록에 실패했습니다.";
                    }
                } else {
                    message = errorMessage;
                }
            } catch (NumberFormatException e) {
                message = "수량은 숫자로 입력해주세요.";
            } catch (Exception e) {
                message = "오류가 발생했습니다. 다시 시도해주세요.";
            }
            %>
            
            <h2>주문 처리 결과</h2>
            
            <% if (success && isValid) { %>
                <div class="result-message success-message">
                    <p class="result-title"><%= message %></p>
                    <div class="order-info-table">
                        <table class="order-table">
                            <tr>
                                <th>주문자</th>
                                <td><%= name %></td>
                            </tr>
                            <tr>
                                <th>연락처</th>
                                <td><%= contact %></td>
                            </tr>
                            <tr>
                                <th>메뉴</th>
                                <td>
                                    <% 
                                        String menuDisplay = "";
                                        if ("americano".equals(menu)) menuDisplay = "아메리카노";
                                        else if ("espresso".equals(menu)) menuDisplay = "에스프레소";
                                        else if ("latte".equals(menu)) menuDisplay = "카라멜 라떼";
                                        else if ("cappuccino".equals(menu)) menuDisplay = "카푸치노";
                                    %>
                                    <%= menuDisplay %>
                                </td>
                            </tr>
                            <tr>
                                <th>사이즈</th>
                                <td><%= size %></td>
                            </tr>
                            <tr>
                                <th>온도</th>
                                <td><%= "H".equals(temperature) ? "Hot" : "Ice" %></td>
                            </tr>
                            <tr>
                                <th>수량</th>
                                <td><%= quantity %>개</td>
                            </tr>
                            <tr>
                                <th>총 금액</th>
                                <td class="total-price-cell"><%= String.format("%,d", totalPrice) %>원</td>
                            </tr>
                        </table>
                    </div>
                </div>
            <% } else { %>
                <div class="result-message error-message">
                    <p class="result-title"><%= message %></p>
                </div>
            <% } %>
            
            <div class="button-group">
                <a href="${pageContext.request.contextPath}/orderForm.jsp" class="btn">다시 주문하기</a>
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn">메인으로</a>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>

