<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cafe.dto.Inventory" %>
<%@ page import="com.cafe.dao.InventoryDAO" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>재고 관리</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reset.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/order.css">
    <style>
        .stock-input-wrapper {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .stock-input {
            width: 100px;
            padding: 0.5rem;
            border: 1px solid #000000;
            border-radius: 0;
            font-size: 0.95rem;
            font-family: inherit;
            background-color: transparent;
            color: #000000;
            text-align: center;
        }
        
        .stock-input:focus {
            outline: none;
            border-color: #000000;
            border-width: 2px;
        }
        
        .btn-update {
            padding: 0.5rem 1rem;
            border: 1px solid #000000;
            border-radius: 0;
            font-size: 0.85rem;
            font-weight: 400;
            cursor: pointer;
            transition: all 0.2s;
            background-color: #ffffff;
            color: #000000;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .btn-update:hover {
            background-color: #000000;
            color: #ffffff;
        }
        
        .stock-quantity {
            font-weight: 500;
            color: #000000;
        }
        
        .stock-quantity.low-stock {
            color: #666666;
        }
        
        .stock-quantity.out-of-stock {
            color: #999999;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main>
        <div class="order-container">
            <h2>재고 관리</h2>
            
            <!-- Server-Side 재고 조회 -->
            <%
                InventoryDAO inventoryDAO = new InventoryDAO();
                List<Inventory> inventoryList = inventoryDAO.getAllInventory();
            %>
            
            <!-- JSTL 변수 선언-->
            <c:set var="inventoryList" value="<%= inventoryList %>" />
            
            <c:choose>
                <c:when test="${empty inventoryList}">
                    <div class="empty-message">
                        <p>재고 정보가 없습니다.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="order-list-table">
                        <thead>
                            <tr>
                                <th>메뉴명</th>
                                <th>현재 재고</th>
                                <th>수정</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="inventory" items="${inventoryList}">
                                <tr>
                                    <td>${inventory.menuName}</td>
                                    <td>
                                        <span class="stock-quantity ${inventory.stockQuantity == 0 ? 'out-of-stock' : (inventory.stockQuantity <= 5 ? 'low-stock' : '')}">
                                            ${inventory.stockQuantity}개
                                        </span>
                                    </td>
                                    <td>
                                        <div class="stock-input-wrapper">
                                            <input type="number" 
                                                   class="stock-input" 
                                                   id="stock-${inventory.menuId}" 
                                                   min="0" 
                                                   value="${inventory.stockQuantity}"
                                                   data-menu-name="${inventory.menuName}"
                                                   data-menu-id="${inventory.menuId}">
                                            <button type="button" 
                                                    class="btn-update" 
                                                    onclick="updateStock(this)"
                                                    data-menu-name="${inventory.menuName}"
                                                    data-menu-id="${inventory.menuId}">
                                                수정
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
            
            <!-- 버튼 그룹 -->
            <div class="button-group">
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn">메인으로</a>
            </div>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <script>
        // -- updateStock() : 재고 수정 함수 --
        function updateStock(buttonElement) {

            // -- Variable Init --
            var menuName = buttonElement.getAttribute('data-menu-name');
            var menuId = buttonElement.getAttribute('data-menu-id');
            var stockInput = document.getElementById('stock-' + menuId);
            var newQuantity = parseInt(stockInput.value);
            
            // -- Validation Check --
            if (isNaN(newQuantity) || newQuantity < 0) {
                alert('재고 수량은 0 이상의 숫자로 입력해주세요.');
                return;
            }
            
            // -- AJAX Request --
            var xhr = new XMLHttpRequest();
            xhr.open('POST', '${pageContext.request.contextPath}/updateInventory.jsp', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            
            // 요청 완료 시 처리
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        try {
                            var response = JSON.parse(xhr.responseText);
                            
                            if (response.success) {
                                // 성공 시 현재 재고 표시 업데이트
                                var row = buttonElement.closest('tr');
                                var stockQuantityCell = row.querySelector('.stock-quantity');
                                stockQuantityCell.textContent = newQuantity + '개';
                                
                                // 재고 상태에 따른 클래스 업데이트
                                stockQuantityCell.className = 'stock-quantity';
                                if (newQuantity == 0) {
                                    stockQuantityCell.classList.add('out-of-stock');
                                } else if (newQuantity <= 5) {
                                    stockQuantityCell.classList.add('low-stock');
                                }
                                
                            } else {
                                alert(response.message || '재고 수정에 실패했습니다.');
                                // 실패 시 원래 값으로 복원
                                stockInput.value = stockQuantityCell.textContent.replace('개', '');
                            }
                        } catch (e) {
                        }
                    } else {
                        alert('서버 오류가 발생했습니다.');
                    }
                }
            };
            
            // -- AJAX Request Send --
            xhr.send('menuName=' + encodeURIComponent(menuName) + '&newQuantity=' + encodeURIComponent(newQuantity));
        }
    </script>
</body>
</html>

