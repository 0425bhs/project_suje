<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<section class="myshop-user-card">

    <div class="myshop-user-info">
        <div class="myshop-profile-icon">👤</div>

        <div>
            <!-- 중요: 로그인 계정 이름 표시 -->
            <strong>
                <c:choose>
                    <c:when test="${not empty loginUser.name}">
                        ${loginUser.name}님
                    </c:when>

                    <c:when test="${not empty loginUser.nick_name}">
                        ${loginUser.nick_name}님
                    </c:when>

                    <c:when test="${not empty sessionScope.user.name}">
                        ${sessionScope.user.name}님
                    </c:when>

                    <c:when test="${not empty sessionScope.user.nick_name}">
                        ${sessionScope.user.nick_name}님
                    </c:when>

                    <c:otherwise>
                        회원님
                    </c:otherwise>
                </c:choose>
            </strong>

            <!-- 중요: 로그인 계정 이메일 표시 -->
            <c:choose>
                <c:when test="${not empty loginUser.email}">
                    <p>${loginUser.email}</p>
                </c:when>

                <c:when test="${not empty sessionScope.user.email}">
                    <p>${sessionScope.user.email}</p>
                </c:when>

                <c:otherwise>
                    <p>로그인 후 내 쇼핑 정보를 확인할 수 있습니다.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="myshop-order-count">
        <span>${param.label}</span>
        <strong>${empty param.count ? 0 : param.count}건</strong>
    </div>

</section>