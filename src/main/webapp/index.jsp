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
        <div class="main-container" style="padding-top: 6rem; padding-bottom: 4rem; padding-left: 2rem; padding-right: 2rem;">
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

