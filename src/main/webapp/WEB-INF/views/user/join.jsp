<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user/join.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" />
</head>
<body>
<div class="join-container">
    <form method="post" enctype="multipart/form-data">
        <input type="hidden" name="role" id="role" value="${role}" />

        <table class="usertable" id="usertable">

            <tr>
                <th>아이디</th>
                <td>
                    <div class="input-row">
                        <input name="login_id" id="login_id" onchange="chkid()" placeholder="아이디를 입력하세요" />
                        <input type="button" value="중복체크" class="btn-secondary" onclick="check_loginId()" />
                    </div>
                </td>
            </tr>

             <tr>
                <th>닉네임</th>
                <td>
                    <div class="input-row">
                        <input name="nick_name" id="nick_name" onchange="chknick()" placeholder="닉네임을 입력하세요" />
                        <input type="button" value="중복체크" class="btn-secondary" onclick="check_nick()" />
                    </div>
                </td>
            </tr>

    <tr>
    <th>비밀번호</th>
    <td>
        <div class="input-wrapper">
            <input name="password" id="password" type="password" oninput="checkPwdRules()"
                maxlength="16" placeholder="영문, 숫자 포함 8자 이상 16자 이하" />
            <button type="button" class="eye-btn" onclick="togglePwdVisibility(event)">
                <i class="ti ti-eye-off" id="eyeIcon"></i>
            </button>
        </div>
        <div id="pwd-rules" style="font-size:13px; margin-top:6px;"></div>
    </td>
</tr>
<tr>
    <th>비밀번호 확인</th>
    <td>
        <div class="input-wrapper">
            <input name="checkPassword" id="checkPassword" type="password" oninput="checkPwdMatch()"
               maxlength="16" placeholder="영문, 숫자 포함 8자 이상 16자 이하" />
            <button type="button" class="eye-btn" onclick="togglePwdVisibility2(event)">
                <i class="ti ti-eye-off" id="eyeIcon2"></i>
            </button>
        </div>
        <div id="pwd-match" style="font-size:13px; margin-top:6px;"></div>
    </td>
</tr>

<tr>
    <th>이메일(본인인증)</th>
    <td>
        <div class="input-row">
            <input name="email" id="authEmail" placeholder="email을 입력하세요" />
            <input type="button" value="중복체크" class="btn-secondary" onclick="mailDupliCheck()" />
        </div>
        <div class="input-row">
            <input id="authInput" placeholder="인증번호 6자리" maxlength="6" disabled="disabled" />
            <input type="button" value="인증번호 전송" class="btn-secondary" onclick="mailCheck(this.form)" />
            <input type="button" value="인증" onclick="authCheck()" class="btn-secondary" />
        </div>
    </td>
</tr>
            
            <tr>
                <th>이름</th>
                <td><input name="name" /></td>
            </tr>

            <tr>
                <th>성별</th>
                <td>
                    <input type="radio" name="gender" value="male" id="male" checked>
                    <label for="male">남자</label>
                    <input type="radio" name="gender" value="female" id="female">
                    <label for="female">여자</label>
                </td>
            </tr>

            <tr>
                <th>전화번호</th>
                <td><input name="phone" placeholder="'-'없이 입력"/></td>
            </tr>

            <tr>
                <th>프로필사진</th>
                <td><input type="file" name="photo" /></td>
            </tr>
            
        </table>

        <c:if test="${role == 'SELLER'}">
        <table id="sellertable" class="sellertable" >
            <tr>
                <th>상호</th>
                <td><input name="company_name" /></td>
            </tr>
            <tr>
                <th>사업자 등록번호</th>
                <td><input name="business_number" type="number" /></td>
            </tr>
            <tr>
                <th>대표자명</th>
                <td><input name="representative_name" /></td>
            </tr>
            <tr>
                <th>사업자 개업일자</th>
                <td><input name="opening_date" type="date" /></td>
            </tr>
            <tr>
                <th>사업자 주소</th>
                <td><input name="business_address" /></td>
            </tr>
        </table>
        </c:if>

        <table class="join-table">
            <tr>
                <td colspan="2" align="center" style="padding-top: 30px;">
                    <input type="button" value="가입" class="btn-main" onclick="send(this.form)" />
                    <input type="button" value="취소" class="btn-cancel" onclick="history.back()" />
                </td>
            </tr>
        </table>

    </form>
</div>

<script src="${pageContext.request.contextPath}/js/join.js"></script>
</body>
</html>