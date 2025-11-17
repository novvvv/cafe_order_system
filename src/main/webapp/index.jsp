<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>웹 카페 - 메인</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reset.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main>
        <section>
            <h2>환영합니다!</h2>
            <p>JSP 프로젝트가 정상적으로 실행되었습니다.</p>
            <p>현재 시간: <%= new java.util.Date() %></p>
        </section>
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>

