<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>주문 입력 폼</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reset.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/order.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main>
        <div class="order-container">

            <h2>주문 입력 폼</h2>
            
            <form id="orderForm" method="post" action="${pageContext.request.contextPath}/order/process">
                <table class="order-table">

                    <!-- 1. 이름 입력 필드 -->
                    <tr>
                        <th><label for="name">이름 <span class="required">*</span></label></th>
                        <td>
                            <input type="text" id="name" name="name" placeholder="이름을 입력하세요" required>
                            <span class="error-message" id="nameError"></span>
                        </td>
                    </tr>
                    
                    <!-- 2. 연락처 입력 필드 -->
                    <tr>
                        <th><label for="contact">연락처 <span class="required">*</span></label></th>
                        <td>
                            <input type="tel" id="contact" name="contact" placeholder="연락처를 입력하세요" required>
                            <span class="error-message" id="contactError"></span>
                        </td>
                    </tr>
                    
                    <!-- 3. 메뉴 입력 필드 -->
                    <!-- Select 형식으로 총 4개의 메뉴 중 하나 선택 가능  -->
                    <tr>
                        <th><label for="menu">메뉴 <span class="required">*</span></label></th>
                        <td>
                            <select id="menu" name="menu" required>
                                <option value="">메뉴를 선택하세요</option>
                                <option value="americano">아메리카노</option>
                                <option value="latte">라떼</option>
                                <option value="cappuccino">카푸치노</option>
                                <option value="espresso">에스프레소</option>
                            </select>
                            <span class="error-message" id="menuError"></span>
                        </td>
                    </tr>
                    
                    <!-- 4. 사이즈 입력 필드 -->
                    <!-- Radio 형식으로 총 5개의 사이즈 중 하나 선택 가능  -->
                    <tr>
                        <th>사이즈 <span class="required">*</span></th>
                        <td>
                            <div class="radio-group">
                                <label><input type="radio" name="size" value="S" required> S</label>
                                <label><input type="radio" name="size" value="M" required> M</label>
                                <label><input type="radio" name="size" value="L" required> L</label>
                                <label><input type="radio" name="size" value="G" required> G</label>
                                <label><input type="radio" name="size" value="X" required> X</label>
                            </div>
                            <span class="error-message" id="sizeError"></span>
                        </td>
                    </tr>
                    
                    <!-- 5. 온도 입력 필드 -->
                    <!-- Radio 형식으로 총 2개의 온도 (Hot, Ice) 중 하나 선택 가능  -->
                    <tr>
                        <th>온도 <span class="required">*</span></th>
                        <td>
                            <div class="radio-group">
                                <label><input type="radio" name="temperature" value="H" required> Hot (H)</label>
                                <label><input type="radio" name="temperature" value="I" required> Ice (I)</label>
                            </div>
                            <span class="error-message" id="temperatureError"></span>
                        </td>
                    </tr>
                    
                    <!-- 6. 수량 입력 필드 -->
                    <!-- Number 형식으로 1 이상의 수량 입력 가능  -->
                    <!-- JS : 입력값이 1이상인지 검증 필요  -->
                    <tr>
                        <th><label for="quantity">수량 <span class="required">*</span></label></th>
                        <td>
                            <input type="number" id="quantity" name="quantity" min="1" value="1" required>
                            <span class="error-message" id="quantityError"></span>
                        </td>
                    </tr>
                    
                    <!-- 7. 요청사항 입력 필드 -->
                    <!-- Textarea 형식으로 요청사항 입력 가능  -->
                    <!-- 요구사항 : 공란이 있어도 되고, 최대 100자 이하로 제한  -->
                    <tr>
                        <th><label for="requests">요청사항</label></th>
                        <td>
                            <textarea id="requests" name="requests" rows="4" placeholder="요청사항을 입력하세요 (선택사항)"></textarea>
                        </td>
                    </tr>
                </table>
                
                <div class="button-group">
                    <button type="submit" class="btn btn-submit">주문하기</button>
                    <button type="reset" class="btn btn-reset">초기화</button>
                </div>
            </form>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script src="${pageContext.request.contextPath}/js/orderValidation.js"></script>
</body>
</html>

