<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.cafe.dao.InventoryDAO" %>
        <%@ page import="com.cafe.dto.Inventory" %>
            <%@ page import="java.util.List" %>
                <%@ page import="java.util.Map" %>
                    <%@ page import="java.util.HashMap" %>
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
                                        <% // -- 재고 정보 조회 -- InventoryDAO inventoryDAO=new InventoryDAO();
                                            List<Inventory> inventoryList = inventoryDAO.getAllInventory();

                                            // -- 메뉴명 매핑 --
                                            Map<String, String> menuNameMap = new HashMap<String, String>();
                                                    menuNameMap.put("americano", "아메리카노");
                                                    menuNameMap.put("espresso", "에스프레소");
                                                    menuNameMap.put("latte", "카페라떼");
                                                    menuNameMap.put("cappuccino", "카푸치노");

                                                    // -- 재고 정보를 Map으로 변환 --
                                                    Map<String, Integer> stockMap = new HashMap<String, Integer>();
                                                            for (Inventory inv : inventoryList) {
                                                            stockMap.put(inv.getMenuName(), inv.getStockQuantity());
                                                            }

                                                            // -- request 객체에 재고 정보와 메뉴명 매핑 정보 저장 JSP 전달용 --
                                                            request.setAttribute("stockMap", stockMap);
                                                            request.setAttribute("menuNameMap", menuNameMap);
                                                            %>

                                                            <h2>주문 입력 폼</h2>

                                                            <form id="orderForm" method="post"
                                                                action="${pageContext.request.contextPath}/insertOrder.jsp">
                                                                <table class="order-table">

                                                                    <!-- 1. 이름 입력 필드 -->
                                                                    <tr>
                                                                        <th><label for="name">이름 <span
                                                                                    class="required">*</span></label>
                                                                        </th>
                                                                        <td>
                                                                            <input type="text" id="name" name="name"
                                                                                placeholder="이름을 입력하세요" required>
                                                                            <span class="error-message"
                                                                                id="nameError"></span>
                                                                        </td>
                                                                    </tr>

                                                                    <!-- 2. 연락처 입력 필드 -->
                                                                    <tr>
                                                                        <th><label for="contact">연락처 <span
                                                                                    class="required">*</span></label>
                                                                        </th>
                                                                        <td>
                                                                            <input type="tel" id="contact"
                                                                                name="contact" placeholder="연락처를 입력하세요"
                                                                                required>
                                                                            <span class="error-message"
                                                                                id="contactError"></span>
                                                                        </td>
                                                                    </tr>

                                                                    <!-- 3. 메뉴 입력 필드 -->
                                                                    <!-- Select 형식으로 총 4개의 메뉴 중 하나 선택 가능  -->
                                                                    <!-- 재고가 0인 메뉴는 비활성화 및 "Sold Out" 표시 -->
                                                                    <tr>
                                                                        <th><label for="menu">메뉴 <span
                                                                                    class="required">*</span></label>
                                                                        </th>
                                                                        <td>
                                                                            <select id="menu" name="menu" required>
                                                                                <option value="">메뉴를 선택하세요</option>
                                                                                <% // 아메리카노 String
                                                                                    americanoName=menuNameMap.get("americano");
                                                                                    Integer
                                                                                    americanoStock=stockMap.get(americanoName);
                                                                                    boolean
                                                                                    americanoOutOfStock=(americanoStock==null
                                                                                    || americanoStock <=0); %>
                                                                                    <option value="americano"
                                                                                        <%=americanoOutOfStock
                                                                                        ? "disabled" : "" %>>
                                                                                        아메리카노 4500원<%=
                                                                                            americanoOutOfStock
                                                                                            ? " - Sold Out" : "" %>
                                                                                    </option>

                                                                                    <% // 에스프레소 String
                                                                                        espressoName=menuNameMap.get("espresso");
                                                                                        Integer
                                                                                        espressoStock=stockMap.get(espressoName);
                                                                                        boolean
                                                                                        espressoOutOfStock=(espressoStock==null
                                                                                        || espressoStock <=0); %>
                                                                                        <option value="espresso"
                                                                                            <%=espressoOutOfStock
                                                                                            ? "disabled" : "" %>>
                                                                                            에스프레소 4300원<%=
                                                                                                espressoOutOfStock
                                                                                                ? " - Sold Out" : "" %>
                                                                                        </option>

                                                                                        <% // 카페라떼 String
                                                                                            latteName=menuNameMap.get("latte");
                                                                                            Integer
                                                                                            latteStock=stockMap.get(latteName);
                                                                                            boolean
                                                                                            latteOutOfStock=(latteStock==null
                                                                                            || latteStock <=0); %>
                                                                                            <option value="latte"
                                                                                                <%=latteOutOfStock
                                                                                                ? "disabled" : "" %>>
                                                                                                카라멜 라떼 5000원<%=
                                                                                                    latteOutOfStock
                                                                                                    ? " - Sold Out" : ""
                                                                                                    %>
                                                                                            </option>

                                                                                            <% // 카푸치노 String
                                                                                                cappuccinoName=menuNameMap.get("cappuccino");
                                                                                                Integer
                                                                                                cappuccinoStock=stockMap.get(cappuccinoName);
                                                                                                boolean
                                                                                                cappuccinoOutOfStock=(cappuccinoStock==null
                                                                                                || cappuccinoStock <=0);
                                                                                                %>
                                                                                                <option
                                                                                                    value="cappuccino"
                                                                                                    <%=cappuccinoOutOfStock
                                                                                                    ? "disabled" : "" %>
                                                                                                    >
                                                                                                    카푸치노 5000원<%=
                                                                                                        cappuccinoOutOfStock
                                                                                                        ? " - Sold Out"
                                                                                                        : "" %>
                                                                                                </option>
                                                                            </select>
                                                                            <span class="error-message"
                                                                                id="menuError"></span>
                                                                        </td>
                                                                    </tr>

                                                                    <!-- 4. 사이즈 입력 필드 -->
                                                                    <!-- Radio 형식으로 총 5개의 사이즈 중 하나 선택 가능  -->
                                                                    <tr>
                                                                        <th>사이즈 <span class="required">*</span></th>
                                                                        <td>
                                                                            <div class="radio-group">
                                                                                <label><input type="radio" name="size"
                                                                                        value="S" required> S</label>
                                                                                <label><input type="radio" name="size"
                                                                                        value="M" required> M
                                                                                    (+100)</label>
                                                                                <label><input type="radio" name="size"
                                                                                        value="L" required> L
                                                                                    (+200)</label>
                                                                                <label><input type="radio" name="size"
                                                                                        value="G" required> G
                                                                                    (+500)</label>
                                                                                <label><input type="radio" name="size"
                                                                                        value="X" required> X
                                                                                    (+1000)</label>
                                                                            </div>
                                                                            <span class="error-message"
                                                                                id="sizeError"></span>
                                                                        </td>
                                                                    </tr>

                                                                    <!-- 5. 온도 입력 필드 -->
                                                                    <!-- Radio 형식으로 총 2개의 온도 (Hot, Ice) 중 하나 선택 가능  -->
                                                                    <tr>
                                                                        <th>온도 <span class="required">*</span></th>
                                                                        <td>
                                                                            <div class="radio-group">
                                                                                <label><input type="radio"
                                                                                        name="temperature" value="H"
                                                                                        required> Hot (H)</label>
                                                                                <label><input type="radio"
                                                                                        name="temperature" value="I"
                                                                                        required> Ice (I)</label>
                                                                            </div>
                                                                            <span class="error-message"
                                                                                id="temperatureError"></span>
                                                                        </td>
                                                                    </tr>

                                                                    <!-- 6. 수량 입력 필드 -->
                                                                    <!-- Number 형식으로 1 이상의 수량 입력 가능  -->
                                                                    <!-- JS : 입력값이 1이상인지 검증 필요  -->
                                                                    <tr>
                                                                        <th><label for="quantity">수량 <span
                                                                                    class="required">*</span></label>
                                                                        </th>
                                                                        <td>
                                                                            <input type="number" id="quantity"
                                                                                name="quantity" min="1" value="1"
                                                                                required>
                                                                            <span class="error-message"
                                                                                id="quantityError"></span>
                                                                        </td>
                                                                    </tr>

                                                                    <!-- 7. 요청사항 입력 필드 -->
                                                                    <!-- Textarea 형식으로 요청사항 입력 가능  -->
                                                                    <!-- 요구사항 : 공란이 있어도 되고, 최대 100자 이하로 제한  -->
                                                                    <tr>
                                                                        <th><label for="requests">요청사항</label></th>
                                                                        <td>
                                                                            <textarea id="requests" name="requests"
                                                                                rows="4"
                                                                                placeholder="요청사항을 입력하세요 (선택사항)"></textarea>
                                                                        </td>
                                                                    </tr>
                                                                </table>

                                                                <!-- 8. 총 금액 표시 영역 -->
                                                                <div class="total-price-section">
                                                                    <div class="total-label">총 주문 금액</div>
                                                                    <div class="total-amount" id="totalPrice">0원</div>
                                                                </div>

                                                                <div class="button-group">
                                                                    <button type="submit"
                                                                        class="btn btn-submit">주문하기</button>
                                                                    <button type="reset"
                                                                        class="btn btn-reset">초기화</button>
                                                                </div>
                                                            </form>
                                    </div>
                                </main>

                                <jsp:include page="/WEB-INF/views/common/footer.jsp" />

                                <script src="${pageContext.request.contextPath}/js/validate.js"></script>

                            </body>

                            </html>