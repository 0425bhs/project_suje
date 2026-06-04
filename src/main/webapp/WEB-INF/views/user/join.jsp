<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>

        <html>

        <head>
            <meta charset="UTF-8">
            <title>회원가입</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/join.css" />
            <script src="${pageContext.request.contextPath}/js/join.js"></script>
        </head>

        <body>
            <div class="join-container">
                <form method="post">

                    <table class="join-table">
                        <caption>회원가입</caption>

                        <tr>
                            <th>회원 구분</th>
                            <td>
                                <input type="radio" name="role" value="USER" id="user" 
                                onclick="toggleForm()" checked>
                                <label for="user">일반회원</label>

                                <input type="radio" name="role" value="SELLER" id="seller" 
                                onclick="toggleForm()">
                                <label for="seller">판매자</label>


                            </td>
                        </tr>
                    </table>


                    <table class="usertable" id="usertable">

                        <tr>
                            <th>이메일(본인인증)</th>
                            <td>
                                <div class="input-row">

                                    <input name="email" id="authEmail" 
                                    placeholder="email을 입력하세요" />

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

                                    <input name="nickName" id="nickName" onchange="chk()" 
                                    placeholder="닉네임을 입력하세요" />

                                    <input type="button" value="중복체크" class="btn-secondary" 
                                    onclick="check_nick()"/>

                                </div>
                            </td>
                        </tr>

                        <tr>
                            <th>이름</th>
                            <td><input name="name" /></td>
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
                                <input name="phone" />
                            </td>
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
                    </table>

                    <table id="sellertable" class="sellertable" style="display: none;">

                        <tr>
                            <th>상호</th>
                            <td><input name="companyName" /></td>
                        </tr>

                        <tr>
                            <th>사업자 등록번호</th>
                            <td><input name="businessNumber" type="number" /></td>
                        </tr>


                        <tr>
                            <th>대표자명</th>
                            <td>
                                <input name="representativeName" />
                            </td>
                        </tr>

                        <tr>
                            <th>사업자 개업일자</th>
                            <td>
                                <input name="openingDate" type="date" />
                            </td>
                        </tr>

                        <tr>
                            <th>사업자 주소</th>
                            <td>
                                <input name="businessAddress" />
                            </td>
                        </tr>

                    </table>

                    <table class="join-table">
                        <tr>
                            <td colspan="2" align="center" style="padding-top: 30px;">
                                <input type="button" value="가입" class="btn-main" 
                                onclick="send(this.form)" />
                                <input type="button" value="취소" class="btn-cancel" 
                                onclick="history.back()" />
                          
                            </td>
                        </tr>
    
                    </table>

                    <div class="kakao-wrap">
                <button type="button" class="btn-kakao" onclick="alert('카카오 간편 회원가입은 현재 준비 중입니다! 정식 연동 시 오픈됩니다.');">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                        <path d="M12 3c-4.97 0-9 3.185-9 7.115 0 2.558 1.7 4.792 4.27 6.03-.18.663-.65 2.395-.74 2.74-.12.446.15.44.32.327.13-.087 2.11-1.43 2.95-2.003.7.195 1.44.306 2.2.306 4.97 0 9-3.185 9-7.115S16.97 3 12 3z"/>
                    </svg>
                    카카오톡으로 시작하기
                </button>
            </div>

                </form>
            </div>
        </body>

        </html>