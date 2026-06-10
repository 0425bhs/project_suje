<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>

        <html>

        <head>
            <meta charset="UTF-8">
            <title>내 정보</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user/seller_edit.css" />
            <script src="${pageContext.request.contextPath}/js/user/seller_edit.js"></script>
        </head>

        <body>
            <div class="join-container">
                <form method="post">

                  <table class="usertable" id="usertable">
                        <caption>회원정보 수정</caption>

                       

                        <tr>
                            <th>인증</th>
                            <td>
                                <div class="input-row">

                                    <input name="email" id="authEmail" 
                                    value = "${user.email}" />

                                    <input type="button" value="전송" class="btn-secondary"
                                        onclick="mailCheck(this.form)" />
                                </div>

                                <div class="input-row">
                                    <input id="authInput" placeholder="인증번호 6자리" 
                                    maxlength="6" disabled="disabled" />

                                    <input type="button" value="인증"  /> 
                                    <!--onclick="authCheck()"-->
                                </div>
                            </td>
                        </tr>

                        <tr>
                            <th>닉네임</th>
                            <td>
                                <div class="input-row">

                                    <input name="nick_name" id="nick_name" onchange="chk()" 
                                     value = "${user.nick_name}" value = "nick_name"/>

                                    <input type="button" value="중복체크" class="btn-secondary" 
                                    onclick="check_nick()"/>

                                </div>
                            </td>
                        </tr>

                        <tr>
                            <th>이름</th>
                            <td><input name="name" value = "${user.name}"/></td>
                        </tr>


<tr>
    <th>비밀번호</th>
    <td>
        <div class="input-row" style="display: flex; align-items: center; gap: 8px;">
            <input name="password" id="password" type="password" 
            placeholder="영문, 숫자 포함 8자 이상" />
            <button type="button" id="toggleBtn" onclick="togglePwdVisibility(event)"
             style="background: none; border: none; cursor: pointer; font-size: 18px; padding: 4px;">
                👁️
            </button>
        </div>
    </td>
</tr>

<tr>
    <th>비밀번호 확인</th>
    <td>
        <div class="input-row" style="display: flex; align-items: center; gap: 8px;">
            <input name="checkPassword" id="checkPassword" type="password" 
            placeholder="영문, 숫자 포함 8자 이상" />
            <button type="button" id="toggleBtn2" onclick="togglePwdVisibility2(event)"
             style="background: none; border: none; cursor: pointer; font-size: 18px; padding: 4px;">
                👁️
            </button>
        </div>
    </td>
</tr>

                        <tr>
                            <th>전화번호</th>
                            <td>
                                <input name="phone" value = "${user.phone}"/>
                            </td>
                        </tr>

                        <tr>
                            <th>성별</th>
                            <td>
                                <input type="radio" name="gender" value="male" id="male" 
                                <c:if test="${user.gender == 'male'}">checked</c:if> >
                                <label for="male">남자</label>

                                <input type="radio" name="gender" value="female" id="female"
                                <c:if test = "${user.gender == 'female'}">checked</c:if> >
                                <label for="female">여자</label>
                            </td>
                        </tr>
                    </table>

                    <table id="sellertable" class="sellertable" style="display: none;">

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
                            <td>
                                <input name="representative_name" />
                            </td>
                        </tr>

                        <tr>
                            <th>사업자 개업일자</th>
                            <td>
                                <input name="opening_date" type="date" />
                            </td>
                        </tr>

                        <tr>
                            <th>사업자 주소</th>
                            <td>
                                <input name="business_address" />
                            </td>
                        </tr>

                    </table>

                    <table class="join-table">
                        <tr>
                            <td colspan="2" align="center" style="padding-top: 30px;">
                                <input type="button" value="변경" class="btn-main" 
                                onclick="send(this.form)" />
                                <input type="button" value="취소" class="btn-cancel" 
                                onclick="history.back()" />
                          
                            </td>
                        </tr>
    
                    </table>

                </form>
            </div>
        </body>

        </html>