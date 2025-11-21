<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cafe.dto.Order" %>
<%@ page import="com.cafe.dao.OrderDAO" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>주문 목록</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reset.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/order.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main>
        <div class="order-container">
            <h2>주문 목록</h2>
            
            <%
                // OrderDAO를 사용해서 주문 목록 조회
                OrderDAO orderDAO = new OrderDAO();
                List<Order> orderList = orderDAO.getAllOrders();
                
                // 메뉴명 한글 변환을 위한 변수
                String menuDisplay = "";
                String temperatureDisplay = "";
            %>
            
            <!-- JSTL 변수 선언-->
            <c:set var="orderList" value="<%= orderList %>" />
            
            <c:choose>
                <c:when test="${empty orderList}">
                    <div class="empty-message">
                        <p>주문 내역이 없습니다.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="order-list-table">
                        <thead>
                            <tr>
                                <th>주문번호</th>
                                <th>주문자</th>
                                <th>연락처</th>
                                <th>메뉴</th>
                                <th>사이즈</th>
                                <th>온도</th>
                                <th>수량</th>
                                <th>총 금액</th>
                                <th>주문 시간</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${orderList}">
                                <tr>
                                    <td>${order.orderId}</td>
                                    <td>${order.customerName}</td>
                                    <td>${order.customerPhone}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.menuName == 'americano'}">아메리카노</c:when>
                                            <c:when test="${order.menuName == 'espresso'}">에스프레소</c:when>
                                            <c:when test="${order.menuName == 'latte'}">카라멜 라떼</c:when>
                                            <c:when test="${order.menuName == 'cappuccino'}">카푸치노</c:when>
                                            <c:otherwise>${order.menuName}</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${order.sizeCode}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.temperature == 'H'}">Hot</c:when>
                                            <c:when test="${order.temperature == 'I'}">Ice</c:when>
                                            <c:otherwise>${order.temperature}</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${order.quantity}개</td>
                                    <td class="total-price-cell"><fmt:formatNumber value="${order.totalPrice}" pattern="#,###"/>원</td>
                                    <td><fmt:formatDate value="${order.orderTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
            
            <!-- 버튼 그룹 -->
            <div class="button-group">
                <a href="${pageContext.request.contextPath}/orderForm.jsp" class="btn">새 주문하기</a>
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn">메인으로</a>
            </div>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>

