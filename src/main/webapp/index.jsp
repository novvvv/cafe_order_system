<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cafe.dao.OrderDAO" %>
<%@ page import="com.cafe.util.WaitTimeCalculator" %>
<%@ page import="java.util.Map" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>웹 카페 - 메인</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reset.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .wait-time-section {
            background-color: #f9f9f9;
            border: 1px solid #e5e5e5;
            border-radius: 8px;
            padding: 2rem;
            margin-bottom: 3rem;
            text-align: center;
        }
        .wait-time-label {
            font-size: 1rem;
            color: #666;
            margin-bottom: 0.5rem;
            font-weight: 400;
            letter-spacing: 0.3px;
        }
        .wait-time-value {
            font-size: 2rem;
            color: #000000;
            font-weight: 500;
            letter-spacing: -0.5px;
        }
        .wait-time-info {
            font-size: 0.875rem;
            color: #999;
            margin-top: 0.75rem;
            font-weight: 300;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main>
        <div class="main-container" style="padding-top: 6rem; padding-bottom: 4rem; padding-left: 2rem; padding-right: 2rem;">
            <%
                // 대기시간 계산 로직
                OrderDAO orderDAO = new OrderDAO();
                Map<String, Integer> menuCounts = orderDAO.getPendingOrdersByMenu();
                int pendingOrderCount = orderDAO.getPendingOrderCount();
                
                // 대기시간 계산 (바리스타 수 기본값 사용: -1)
                int waitTimeSeconds = WaitTimeCalculator.calculateWaitTime(menuCounts, pendingOrderCount, -1);
                String formattedWaitTime = WaitTimeCalculator.formatWaitTime(waitTimeSeconds);
            %>
            
            <!-- 예상 대기시간 표시 섹션 -->
            <section class="wait-time-section">
                <div class="wait-time-label">예상 대기시간</div>
                <div class="wait-time-value"><%= formattedWaitTime %></div>
                <div class="wait-time-info">
                    현재 대기 중인 주문: <%= pendingOrderCount %>건
                </div>
            </section>
            
            <section class="image-gallery" style="margin-top: 2rem;">
                <div class="image-row" style="display: flex; flex-direction: row; justify-content: space-between; align-items: center; gap: 2.5rem; width: 100%;">
                    <img src="${pageContext.request.contextPath}/images/img_1.png" alt="이미지 1" class="gallery-image" style="width: 23%; max-width: 350px; max-height: 350px; height: auto; object-fit: contain; display: inline-block;">
                    <img src="${pageContext.request.contextPath}/images/img_2.png" alt="이미지 2" class="gallery-image" style="width: 23%; max-width: 350px; max-height: 350px; height: auto; object-fit: contain; display: inline-block;">
                    <img src="${pageContext.request.contextPath}/images/img_3.png" alt="이미지 3" class="gallery-image" style="width: 23%; max-width: 350px; max-height: 350px; height: auto; object-fit: contain; display: inline-block;">
                    <img src="${pageContext.request.contextPath}/images/img_4.png" alt="이미지 4" class="gallery-image" style="width: 23%; max-width: 350px; max-height: 350px; height: auto; object-fit: contain; display: inline-block;">
                </div>
            </section>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>

