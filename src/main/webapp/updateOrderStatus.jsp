<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.cafe.dao.OrderDAO" %>
<%
    response.setContentType("application/json; charset=UTF-8");
    
    // 파라미터 수신 (OrderId, newStatus) (주문 아이디, 상태)
    String orderIdStr = request.getParameter("orderId");
    String newStatus = request.getParameter("newStatus");
    
    boolean success = false;
    String message = "";
    
    // [Exception] 파라미터 유효성 검증
    if (orderIdStr == null || newStatus == null || orderIdStr.trim().isEmpty() || newStatus.trim().isEmpty()) {
        message = "파라미터가 올바르지 않습니다.";
    }

    // [Exception] 상태 값 유효성 검증
    else if (!newStatus.equals("WAITING") && !newStatus.equals("PENDING") && 
             !newStatus.equals("COMPLETED") && !newStatus.equals("CANCELED")) {
        message = "유효하지 않은 상태 값입니다.";
    }

    // [Success] 주문 상태 업데이트
    else {
        try {
            int orderId = Integer.parseInt(orderIdStr);
            
            // OrderDAO를 사용해서 주문 상태 업데이트 
            OrderDAO orderDAO = new OrderDAO();
            success = orderDAO.updateOrderStatus(orderId, newStatus);
            
            if (success) {
                message = "주문 상태가 변경되었습니다.";
            } else {
                message = "주문 상태 변경에 실패했습니다.";
            }
        } 
        // [Exception] 주문 ID가 숫자가 아닌 경우
        catch (NumberFormatException e) {
            message = "주문 ID가 올바르지 않습니다.";
        } 
        
        // [Exception] 오류가 발생한 경우
        catch (Exception e) {
            message = "오류가 발생했습니다.";
        }
    }
    
    // JSON 응답 출력
    if (message == null) {
        message = "";
    }
    out.print("{\"success\":" + success + ",\"message\":\"" + message + "\"}");
%>

