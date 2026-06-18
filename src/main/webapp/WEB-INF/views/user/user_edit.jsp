<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="join-container">
    <form method="post" enctype="multipart/form-data">

        <input type="hidden" name="role"           id="role"           value="${dto.user.role}" />
        <input type="hidden" name="ori_login_id"   id="ori_login_id"   value="${dto.user.login_id}" />
        <input type="hidden" name="ori_nick_name"  id="ori_nick_name"  value="${dto.user.nick_name}" />
        <input type="hidden" name="email"                               value="${dto.user.email}" />
        <input type="hidden" name="user_id"                             value="${dto.user.user_id}" />
        <input type="hidden" name="ori_photo_name" id="ori_photo_name" value="${dto.user.photo_name}" />
        <input type="hidden" name="del_photo_name"                      value="${dto.user.photo_name}" />

        <table class="usertable" id="usertable">
            <caption>회원정보 수정</caption>

            <tr>
                <th>아이디</th>
                <td>
                    <div class="input-row">
                        <input name="login_id" id="login_id" oninput="chk()"
                               value="${dto.user.login_id}" placeholder="아이디를 입력하세요" />
                        <input type="button" value="중복체크" id="login_id_btn" disabled="disabled"
                               class="btn-secondary" onclick="check_loginId()" />
                    </div>
                </td>
            </tr>

            <tr>
                <th>닉네임</th>
                <td>
                    <div class="input-row">
                        <input name="nick_name" id="nick_name" oninput="chknick()"
                               value="${dto.user.nick_name}" placeholder="닉네임을 입력하세요" />
                        <input type="button" value="중복체크" id="nick_check_btn" disabled="disabled"
                               class="btn-secondary" onclick="check_nick()" />
                    </div>
                </td>
            </tr>

            <tr>
                <th>이름</th>
                <td>
                    <input name="name" value="${dto.user.name}" placeholder="이름을 입력하세요" />
                </td>
            </tr>

            <tr>
                <th>현재 비밀번호</th>
                <td>
                    <div class="input-row">
                        <div class="input-wrapper" style="flex:1;">
                            <input name="ori_password" id="ori_password" type="password"
                                   maxlength="16" oninput="chk2()"
                                   placeholder="현재 비밀번호를 입력하세요" />
                            <button type="button" class="eye-btn" onclick="togglePwdVisibility3(event)">
                                <i class="ti ti-eye-off" id="eyeIcon3"></i>
                            </button>
                        </div>
                        <input type="button" value="확인" class="btn-secondary" onclick="check_func()" />
                    </div>
                </td>
            </tr>

            <tr>
                <th>새 비밀번호</th>
                <td>
                    <div class="input-wrapper">
                        <input name="password" id="password" type="password"
                               maxlength="16" oninput="checkPwdRules()"
                               placeholder="영문, 숫자 포함 8자 이상 16자 이하" />
                        <button type="button" class="eye-btn" onclick="togglePwdVisibility(event)">
                            <i class="ti ti-eye-off" id="eyeIcon"></i>
                        </button>
                    </div>
                    <div id="pwd-rules"></div>
                </td>
            </tr>

            <tr>
                <th>비밀번호 확인</th>
                <td>
                    <div class="input-wrapper">
                        <input name="checkPassword" id="checkPassword" type="password"
                               disabled="disabled" maxlength="16" oninput="checkPwdMatch()"
                               placeholder="비밀번호를 다시 입력하세요" />
                        <button type="button" class="eye-btn" onclick="togglePwdVisibility2(event)">
                            <i class="ti ti-eye-off" id="eyeIcon2"></i>
                        </button>
                    </div>
                    <div id="pwd-match"></div>
                </td>
            </tr>

            <tr>
                <th>전화번호</th>
                <td>
                    <input name="phone" value="${dto.user.phone}" placeholder="'-'없이 입력" />
                </td>
            </tr>

            <tr>
                <th>성별</th>
                <td>
                    <input type="radio" name="gender" value="male" id="male"
                           <c:if test="${dto.user.gender == 'male'}">checked</c:if> />
                    <label for="male">남자</label>
                    <input type="radio" name="gender" value="female" id="female"
                           <c:if test="${dto.user.gender == 'female'}">checked</c:if> />
                    <label for="female">여자</label>
                </td>
            </tr>

            <tr>
                <th>프로필사진</th>
                <td>
                    <c:if test="${dto.user.photo_name ne 'no_file'}">
                        <div id="photo_div">
                            <img src="${pageContext.request.contextPath}/upload/${dto.user.photo_name}"
                                 width="80" height="80" />
                            <input type="button" value="X" onclick="deletePhoto()" />
                        </div>
                    </c:if>
                    <input type="file" name="photo" />
                </td>
            </tr>

        </table>

        <c:if test="${dto.user.role == 'SELLER'}">
            <table id="sellertable" class="sellertable">
                <caption>사업자 정보 수정</caption>
                <tr>
                    <th>상호</th>
                    <td><input name="company_name" value="${dto.seller.company_name}" placeholder="상호명을 입력하세요" /></td>
                </tr>
                <tr>
                    <th>사업자 등록번호</th>
                    <td><input name="business_number" type="number" value="${dto.seller.business_number}" placeholder="사업자 등록번호" /></td>
                </tr>
                <tr>
                    <th>대표자명</th>
                    <td><input name="representative_name" value="${dto.seller.representative_name}" placeholder="대표자명을 입력하세요" /></td>
                </tr>
                <tr>
                    <th>사업자 개업일자</th>
                    <td><input name="opening_date" type="date" value="${dto.seller.opening_date}" /></td>
                </tr>
                <tr>
                    <th>사업자 주소</th>
                    <td><input name="business_address" value="${dto.seller.business_address}" placeholder="사업자 주소를 입력하세요" /></td>
                </tr>
            </table>
        </c:if>

        <div class="btn-area">
            <input type="button" value="변경" class="btn-main" onclick="send(this.form)" />
            <c:if test="${dto.user.role == 'USER'}">
                <input type="button" value="판매자 신청하기" class="btn-main"
                       onclick="location.href='/update_seller.do'" />
            </c:if>
            <input type="button" value="취소" class="btn-cancel" onclick="history.back()" />
        </div>

    </form>
</div>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/user/user_edit.css" />
<script src="${pageContext.request.contextPath}/js/user_edit.js"></script>