<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.cafe.dao.InventoryDAO" %>
<%
    response.setContentType("application/json; charset=UTF-8");
    
    // -- 파라미터 수신 (menuName, newQuantity) (메뉴명, 새 재고 수량) --
    String menuName = request.getParameter("menuName");
    String newQuantityStr = request.getParameter("newQuantity");
    
    // -- Variable Init --
    // -- success : 재고 수량 업데이트 성공 여부 
    // -- message : 재고 수량 업데이트 메시지 
    boolean success = false;
    String message = "";
    
    // -- [Exception] Validation Check --
    if (menuName == null || newQuantityStr == null || menuName.trim().isEmpty() || newQuantityStr.trim().isEmpty()) {
        message = "파라미터가 올바르지 않습니다.";
    }
    
    // -- [Success] Inventory Stock Update --
    else {
        
        try {
            int newQuantity = Integer.parseInt(newQuantityStr);
            
            // [Exception] 재고 수량이 음수인 경우
            if (newQuantity < 0) {
                message = "재고 수량은 0 이상이어야 합니다.";
            }
            
            // [Success] 재고 수량 업데이트
            else {
                // InventoryDAO를 사용해서 재고 수량 업데이트
                InventoryDAO inventoryDAO = new InventoryDAO();
                success = inventoryDAO.updateStockQuantity(menuName, newQuantity);
                
                if (success) {
                    message = "재고가 수정되었습니다.";
                } else {
                    message = "재고 수정에 실패했습니다. 메뉴명을 확인해주세요.";
                }
            }
        } 
        // [Exception] 재고 수량이 숫자가 아닌 경우
        catch (NumberFormatException e) {
            message = "재고 수량은 숫자로 입력해주세요.";
        } 
    }
    
    // JSON 응답 출력
    if (message == null) {
        message = "";
    }
    out.print("{\"success\":" + success + ",\"message\":\"" + message + "\"}");
%>

