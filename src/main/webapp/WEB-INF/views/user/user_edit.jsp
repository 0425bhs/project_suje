<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>

        <html>

        <head>
            <meta charset="UTF-8">
            <title>내 정보</title>
            <link rel="stylesheet"
             href="${pageContext.request.contextPath}/css/user/user_edit.css" />
            

            
               
        </head>

        <body>
            <div class="join-container">
                <form method="post" enctype="multipart/form-data">

                    <input type="hidden" name="email" value="${user.email}" />

                    <input type="hidden" name="user_id" value="${user.user_id}" />

                    <input type="hidden" name="ori_photo_name" 
                    value="${user.photo_name}" id="ori_photo_name" />

                    <input type="hidden" name="del_photo_name" 
                    value="${user.photo_name}" />

                    <table class="usertable" id="usertable">
                        <caption>회원정보 수정</caption>

                        <tr>
                            <th>아이디</th>
                            <td>
                                <div class="input-row">

                                    <input name="nick_name" id="nick_name"
                                     oninput="chk()" value="${user.nick_name}" />

                                    <input type="button" value="중복체크" 
                                    class="btn-secondary" onclick="check_nick()" />

                                </div>
                            </td>
                        </tr>

                        <tr>
                            <th>이름</th>
                            <td><input name="name" value="${user.name}" /></td>
                        </tr>

                        <tr>
                            <th>현재 비밀번호</th>
                            <td>
                                <div class="input-row" style="display: flex; align-items: center; gap: 8px;">
                                    <input name="ori_password" id="ori_password" maxlength="16"
                                    type="password" oninput="chk2()"
                                        placeholder="영문, 숫자 포함 8자 이상 16자 이하" />
                                    <button type="button" class="eye-btn" onclick="togglePwdVisibility3(event)">
                <i class="ti ti-eye-off" id="eyeIcon3"></i>
            </button>
                                    <input type="button" value="확인" class="btn-secondary" 
                                    onclick="check_func()" />
                                </div>
                                <div id="pwd-rules" style="font-size:13px; margin-top:6px;"></div>
                            </td>
                        </tr>

                        <tr>
                            <th> 새 비밀번호</th>
                            <td>
                                <div class="input-row" style="display: flex; align-items: center; gap: 8px;">
                                    <input name="password" id="password" type="password" disabled="disabled" 
                                     maxlength="16"   placeholder="영문, 숫자 포함 8자 이상 16자 이하" />
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
                                <div class="input-row" style="display: flex; align-items: center; gap: 8px;">
                                    <input name="checkPassword" id="checkPassword"
                                     type="password" disabled="disabled" maxlength="16"
                                        placeholder="영문, 숫자 포함 8자 이상 16자 이하" />
                                    <button type="button" class="eye-btn" onclick="togglePwdVisibility2(event)">
                <i class="ti ti-eye-off" id="eyeIcon2"></i>
            </button>
                                </div>
                            </td>
                        </tr>

                        <tr>
                            <th>프로필사진</th>
                            <td>
                                <c:if test="${user.photo_name ne 'no_file' }">
                                    <div id="photo_div">
                                        <img src="${pageContext.request.contextPath}/upload/${user.photo_name}"
                                            width="100" />

                                        <input type="button" value="X" 
                                        onclick="deletePhoto()" />
                                    </div>
                                </c:if>

                                <input type="file" name="photo" />
                            </td>
                        </tr>


                        <tr>
                            <th>전화번호</th>
                            <td>
                                <input name="phone" value="${user.phone}" />
                            </td>
                        </tr>

                        <tr>
                            <th>성별</th>
                            <td>
                                <input type="radio" name="gender" value="male" id="male" <c:if
                                    test="${user.gender == 'male'}">checked</c:if> >
                                <label for="male">남자</label>

                                <input type="radio" name="gender" value="female" id="female" <c:if
                                    test="${user.gender == 'female'}">checked</c:if> >
                                <label for="female">여자</label>
                            </td>
                        </tr>

                    </table>

                    <table class="modify_table">
                        <tr>
                            <td colspan="3" align="center" style="padding-top: 30px;">
                                <input type="button" value="변경" class="btn-main" onclick="send(this.form)" />


                                <input type="button" value="판매자 신청하기" class="btn-main"
                                    onclick="applySeller(this.form)" />

                                <input type="button" value="취소" class="btn-cancel" onclick="history.back()" />

                            </td>
                        </tr>

                    </table>

                </form>
            </div>

            <script src="${pageContext.request.contextPath}/js/user_edit.js"></script>

        </body>

        </html>