<%@ page contentType="text/html; charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <title>관리자 센터 - 회원 관리</title>
            <link rel="stylesheet" href="/css/admin/admin_common.css">
            <link rel="stylesheet" href="/css/admin/admin_detail_panel.css">
            <script src="/js/admin_detail_common.js"></script>
            <script>
                document.addEventListener("DOMContentLoaded", () => {
                    let selectedMemberId = "";
                    let selectedMemberRow = null;
                    let selectedMemberStatus = "";

                    const master = document.getElementById("adminMasterDetail");
                    const rows = document.querySelectorAll(".admin-clickable-row");

                    const statusControl = document.getElementById("statusControl");
                    const statusChangeButton = document.getElementById("statusChangeButton");
                    const statusCancelButton = document.getElementById("statusCancelButton");
                    const statusReason = document.getElementById("statusReason");

                    const memoContent = document.getElementById("adminMemoContent");
                    const memoSaveButton = document.getElementById("adminMemoSaveButton");

                    //상태값을 한글로 반환
                    function getMemberStatusLabel(status) {
                        switch (status) {
                            case "active":
                                return "활성";
                            case "suspended":
                                return "정지";
                            case "withdrawn":
                                return "탈퇴";
                            default:
                                return "-";
                        }
                    }
                    //상태값 렌더링(상세정보, 상태뱃지, 상태변경, 목록)
                    function renderMemberStatus(status) {
                        const memberStatus = status || selectedMemberStatus;
                        const statusText = getMemberStatusLabel(memberStatus);
                        const statusBadge = document.getElementById("memberDetailStatusBadge");

                        if (!memberStatus) {
                            return;
                        }

                        selectedMemberStatus = memberStatus;

                        //상세 정보에 반영
                        setText("status", statusText);

                        //상태 뱃지에 반영
                        if (statusBadge) {
                            statusBadge.className = "admin-detail-status-badge " + memberStatus;
                            statusBadge.textContent = statusText;
                        }

                        //상태 변경 버튼에 반영
                        if (statusControl) {
                            statusControl.value = memberStatus;
                        }

                        if (statusChangeButton) {
                            statusChangeButton.disabled = true;
                        }

                        //목록에 반영
                        if (selectedMemberRow) {
                            const rowBadge = selectedMemberRow.querySelector("[data-member-status]");

                            if (rowBadge) {
                                rowBadge.className = "admin-status " + memberStatus;
                                rowBadge.textContent = statusText;
                            }

                            selectedMemberRow.dataset.status = memberStatus;
                        }
                    }
                    //상세 패널 상단값 렌더링
                    function renderMemberDetailHead(data) {
                        const user = data.user;
                        const memberMeta = (user.login_id || "-") + " · " + (user.role === "SELLER" ? "판매자" : "일반회원");
                        setText("memberDetailTitle", user.name);
                        setText("memberDetailMeta", memberMeta);

                        renderMemberStatus(user.status);
                    }
                    //상세 정보 회원 활동 렌더링
                    function renderMemberActivity(data) {
                        const user = data.user;
                        const memberId = encodeURIComponent(user.user_id);

                        document.getElementById("memberOrderLink").href =
                            "/admin/orders?user_id=" + memberId;

                        document.getElementById("memberReviewLink").href =
                            "/admin/reviews?user_id=" + memberId;

                        document.getElementById("memberInquiryLink").href =
                            "/admin/inquiries?user_id=" + memberId;

                        document.getElementById("memberReportLink").href =
                            "/admin/reports?user_id=" + memberId;

                        const sellerActions = document.getElementById("memberSellerActions");
                        const sellerManageLink = document.getElementById("memberSellerManageLink");
                        const sellerShopLink = document.getElementById("memberSellerShopLink");
                        const seller = data.seller;

                        if (sellerActions && sellerManageLink && sellerShopLink) {
                            const hasSeller = user.role === "SELLER" && seller && seller.seller_id;

                            sellerActions.hidden = !hasSeller;
                            sellerManageLink.href = "/admin/sellers?user_id=" + memberId;

                            if (hasSeller) {
                                sellerShopLink.href = "/seller_shop_homepage.do?seller_id="
                                    + encodeURIComponent(seller.seller_id);
                            } else {
                                sellerShopLink.removeAttribute("href");
                            }
                        }

                        setText("memberOrderCount", data.orderCount);
                        setText("memberReviewCount", data.reviewCount);
                        setText("memberInquiryCount", data.inquiryCount);
                        setText("memberReportCount", data.reportCount);
                    }
                    //상세 정보 값 렌더링
                    function renderMemberDetailInfo(data) {
                        const user = data.user;

                        renderMemberActivity(data);

                        setText("userId", user.user_id);
                        setText("role", user.role === "SELLER" ? "판매자" : "일반회원");
                        setText("name", user.name);
                        setText("nickName", user.nick_name);
                        setText("loginId", user.login_id);
                        setText("email", user.email);
                        setText("phone", user.phone);
                        setText("gender", user.gender);
                        setText("createdAt", user.created_at);
                        setText("updatedAt", user.updated_at);
                    }
                    //관리자 메모 불러오기
                    function loadAdminMemo(targetType, targetId) {
                        if (!memoContent) {
                            return;
                        }

                        fetch("/admin/memos?target_type=" + encodeURIComponent(targetType)
                            + "&target_id=" + encodeURIComponent(targetId))
                            .then(res => res.json())
                            .then(data => {
                                if (!data.success) {
                                    alert(data.message || "메모를 불러오지 못했습니다.");
                                    return;
                                }

                                if (data.memoList && data.memoList.length > 0) {
                                    memoContent.value = data.memoList[0].content || "";
                                    return;
                                }

                                memoContent.value = "";
                            });
                    }
                    
                    //행을 눌렀을 때 상세 패널 열리고 닫히는 이벤트
                    rows.forEach((row) => {
                        row.addEventListener("click", () => {
                            //상세 패널이 열려있고 이미 선택된 행을 눌렀을 때
                            if (!master.classList.contains("is-collapsed") && row.classList.contains("selected")) {
                                closeDetailPanel(master, row);
                                return;
                            }

                            openDetailPanel(master, rows, row);
                            selectedMemberRow = row;

                            //상세 패널 내용 변경
                            const userId = row.dataset.userId;

                            fetch("/admin/members/detail?user_id=" + encodeURIComponent(userId))
                                .then(res => res.json())
                                .then(data => {
                                    if (!data.success) {
                                        alert(data.message);
                                        return;
                                    }        
                                    const user = data.user;
                                    selectedMemberId = user.user_id;

                                    renderMemberDetailHead(data);
                                    renderMemberDetailInfo(data);
                                    loadAdminMemo("MEMBER", user.user_id);
                                    loadAdminActionLogs("MEMBER", user.user_id);

                                    highlightAdminKeyword(document.getElementById("adminDetailPanel"));
                                })
                        });
                    });

                    //상세 패널 탭 버튼 기능
                    document.querySelectorAll(".admin-detail-tab").forEach((tab) => {
                        tab.addEventListener("click", () => {
                            const tabName = tab.dataset.detailTab;

                            //선택된 버튼 변경
                            document.querySelectorAll(".admin-detail-tab").forEach((item) => {
                                item.classList.toggle("active", item === tab);
                            });

                            //선택된 패널 변경
                            document.querySelectorAll(".admin-detail-tab-panel").forEach((panel) => {
                                panel.classList.toggle("active", panel.dataset.detailPanel === tabName);
                            });
                        });
                    });

                    //상태 변경 버튼 동작
                    if (statusChangeButton && statusControl) {
                        statusChangeButton.disabled = true;

                        statusControl.addEventListener("change", () => {
                            statusChangeButton.disabled = statusControl.value === selectedMemberStatus;
                        });

                        statusChangeButton.addEventListener("click", () => {
                            fetch("/admin/members/status", {
                                method: "POST",
                                headers: {
                                    "Content-Type": "application/x-www-form-urlencoded"
                                },
                                body: "user_id=" + encodeURIComponent(selectedMemberId)
                                    + "&status=" + encodeURIComponent(statusControl.value)
                                    + "&memo=" + encodeURIComponent(statusReason ? statusReason.value : "")
                            })
                            .then(res => res.json())
                            .then(data => {
                                if (!data.success) {
                                    alert(data.message);
                                    return;
                                }

                                renderMemberStatus(data.status);
                                loadAdminActionLogs("MEMBER", selectedMemberId);

                                if (statusReason) {
                                    statusReason.value = "";
                                }
                            });
                        });
                    }

                    //상태 변경 취소
                    if (statusCancelButton && statusControl) {
                        statusCancelButton.addEventListener("click", () => {
                            if (selectedMemberStatus) {
                                statusControl.value = selectedMemberStatus;
                            }

                            if (statusChangeButton) {
                                statusChangeButton.disabled = true;
                            }

                            if (statusReason) {
                                statusReason.value = "";
                            }
                        });
                    }

                    //메모 작성 기능
                    if (memoSaveButton && memoContent) {
                        memoSaveButton.addEventListener("click", () => {
                            fetch("/admin/memos", {
                                method: "POST",
                                headers: {
                                    "Content-Type": "application/x-www-form-urlencoded"
                                },
                                body: "target_type=MEMBER"
                                    + "&target_id=" + encodeURIComponent(selectedMemberId)
                                    + "&content=" + encodeURIComponent(memoContent.value)
                            })
                            .then(res => res.json())
                            .then(data => {
                                if (!data.success) {
                                    alert(data.message || "메모 저장에 실패했습니다.");
                                    return;
                                }

                                alert("메모가 저장되었습니다.");
                            });
                        });
                    }
                });

            </script>
        </head>

        <body>
            <div class="admin-board">
                <jsp:include page="admin_sidebar.jsp">
                    <jsp:param name="activeMenu" value="members" />
                    <jsp:param name="sidebarTitle" value="회원 관리" />
                </jsp:include>

                <main class="admin-main admin-main-fixed">
                    <header class="admin-main-header">
                        <div>
                            <span class="admin-page-label">MEMBER MANAGEMENT</span>
                            <h1>회원 관리</h1>
                        </div>
                    </header>

                    <div class="admin-fixed-list-layout">
                        <div class="admin-filter-box admin-filter-modern">
                        <form class="admin-filter-form" action="/admin/members" method="get">
                            <div class="admin-filter-main-row">
                                <div class="admin-filter-tabs">
                                    <a href="/admin/members?role=all&keyword=${keyword}&user_id=${user_id}&gender=${gender}&status=${status}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                                        class="${role == 'all' ? 'active' : ''}">전체</a>
                                    <a href="/admin/members?role=user&keyword=${keyword}&user_id=${user_id}&gender=${gender}&status=${status}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                                        class="${role == 'user' ? 'active' : ''}">일반회원</a>
                                    <a href="/admin/members?role=seller&keyword=${keyword}&user_id=${user_id}&gender=${gender}&status=${status}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                                        class="${role == 'seller' ? 'active' : ''}">판매자</a>
                                </div>

                                <div class="admin-search-wrap">
                                    <input type="text" class="admin-search" id="keyword" name="keyword"
                                        placeholder="아이디, 이름, 이메일, 닉네임, 전화번호 검색" value="${keyword}">
                                    <span class="admin-search-icon" aria-hidden="true"></span>
                                </div>
                                <button type="submit" class="admin-btn admin-search-submit">검색</button>
                                <button type="button" class="admin-btn light admin-filter-toggle">
                                    상세 검색
                                </button>
                                <select class="admin-filter-control admin-sort-control" id="sort" name="sort">
                                    <option value="latest" ${sort eq 'latest' ? 'selected' : ''}>최신순</option>
                                    <option value="oldest" ${sort eq 'oldest' ? 'selected' : ''}>오래된순</option>
                                </select>
                                <select class="admin-filter-control admin-page-size-control" id="pageSize" name="size">
                                    <option value="10" ${pagination.size == 10 ? 'selected' : ''}>10개씩</option>
                                    <option value="30" ${pagination.size == 30 ? 'selected' : ''}>30개씩</option>
                                    <option value="50" ${pagination.size == 50 ? 'selected' : ''}>50개씩</option>
                                </select>
                            </div>

                            <div class="admin-filter-detail-row" id="memberAdvancedFilter">
                                <label class="admin-filter-field">
                                    <span>유형</span>
                                    <select class="admin-filter-control" name="role">
                                        <option value="all" ${role eq 'all' ? 'selected' : ''}>전체</option>
                                        <option value="user" ${role eq 'user' ? 'selected' : ''}>일반회원</option>
                                        <option value="seller" ${role eq 'seller' ? 'selected' : ''}>판매자</option>
                                    </select>
                                </label>

                                <label class="admin-filter-field">
                                    <span>상태</span>
                                    <select class="admin-filter-control" name="status">
                                        <option value="all" ${status eq 'all' ? 'selected' : ''}>전체</option>
                                        <option value="active" ${status eq 'active' ? 'selected' : ''}>활성</option>
                                        <option value="suspended" ${status eq 'suspended' ? 'selected' : ''}>정지</option>
                                        <option value="withdrawn" ${status eq 'withdrawn' ? 'selected' : ''}>탈퇴</option>
                                    </select>
                                </label>

                                <label class="admin-filter-field">
                                    <span>성별</span>
                                    <select class="admin-filter-control" name="gender">
                                        <option value="all" ${gender eq 'all' ? 'selected' : ''}>전체</option>
                                        <option value="male" ${gender eq 'male' ? 'selected' : ''}>남성</option>
                                        <option value="female" ${gender eq 'female' ? 'selected' : ''}>여성</option>
                                    </select>
                                </label>

                                <label class="admin-filter-field admin-filter-date-range">
                                    <span>가입일 범위</span>
                                    <input type="date" class="admin-filter-control" name="startDate"
                                           value="${startDate}">
                                    <em>~</em>
                                    <input type="date" class="admin-filter-control" name="endDate"
                                           value="${endDate}">
                                </label>

                                <button type="submit" class="admin-btn admin-filter-submit">적용</button>
                            </div>

                            <c:if test="${role ne 'all' || not empty keyword || not empty user_id
                                          || gender ne 'all' || status ne 'all'
                                          || not empty startDate || not empty endDate}">
                                <div class="admin-filter-applied">
                                    <span class="admin-filter-applied-label">적용된 조건:</span>

                                    <c:if test="${role ne 'all'}">
                                        <a class="admin-filter-chip"
                                            href="/admin/members?role=all&keyword=${keyword}&user_id=${user_id}&gender=${gender}&status=${status}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                            유형:
                                            ${role eq 'user' ? '일반회원' : '판매자'}
                                            <span>&times;</span>
                                        </a>
                                    </c:if>

                                    <c:if test="${not empty keyword}">
                                        <a class="admin-filter-chip"
                                            href="/admin/members?role=${role}&user_id=${user_id}&gender=${gender}&status=${status}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                            검색어: ${keyword}
                                            <span>&times;</span>
                                        </a>
                                    </c:if>

                                    <c:if test="${not empty user_id}">
                                        <a class="admin-filter-chip"
                                            href="/admin/members?role=${role}&keyword=${keyword}&gender=${gender}&status=${status}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                            회원:
                                            <c:choose>
                                                <c:when test="${not empty filterUser}">
                                                    ${filterUser.name} · ${filterUser.login_id}
                                                </c:when>
                                                <c:otherwise>${user_id}</c:otherwise>
                                            </c:choose>
                                            <span>&times;</span>
                                        </a>
                                    </c:if>

                                    <c:if test="${gender ne 'all'}">
                                        <a class="admin-filter-chip"
                                            href="/admin/members?role=${role}&keyword=${keyword}&user_id=${user_id}&status=${status}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                            성별:
                                            <c:choose>
                                                <c:when test="${gender eq 'male'}">
                                                    남성
                                                </c:when>
                                                <c:when test="${gender eq 'female'}">
                                                    여성
                                                </c:when>
                                            </c:choose>
                                            <span>&times;</span>
                                        </a>
                                    </c:if>
                                    
                                    <c:if test="${status ne 'all'}">
                                        <a class="admin-filter-chip"
                                            href="/admin/members?role=${role}&keyword=${keyword}&user_id=${user_id}&gender=${gender}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                            상태:
                                            <c:choose>
                                                <c:when test="${status eq 'active'}">
                                                    활성
                                                </c:when>
                                                <c:when test="${status eq 'suspended'}">
                                                    정지
                                                </c:when>
                                                <c:when test="${status eq 'withdrawn'}">
                                                    탈퇴
                                                </c:when>
                                            </c:choose>
                                            <span>&times;</span>
                                        </a>
                                    </c:if>

                                    <c:if test="${not empty startDate or not empty endDate}">
                                        <a class="admin-filter-chip"
                                            href="/admin/members?role=${role}&keyword=${keyword}&user_id=${user_id}&gender=${gender}&status=${status}&sort=${sort}&size=${pagination.size}&page=1">
                                            가입일: ${startDate} ~ ${endDate}
                                            <span>&times;</span>
                                        </a>
                                    </c:if>
                                    <a class="admin-filter-clear" href="/admin/members">전체 해제</a>
                                </div>
                            </c:if>

                            <input type="hidden" name="user_id" value="${user_id}">
                            <input type="hidden" name="page" value="1">
                        </form>
                    </div>

                    <section class="admin-master-detail admin-master-detail-filtered is-collapsed" id="adminMasterDetail">
                        <div class="admin-card admin-list-panel">
                            <div class="admin-table-wrap">
                                <table class="admin-table admin-member-table">
                                    <thead>
                                        <tr>
                                            <th>번호</th>
                                            <th>회원명</th>
                                            <th>아이디</th>
                                            <th>닉네임</th>
                                            <th>이메일</th>
                                            <th>유형</th>
                                            <th>상태</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:if test="${empty userList}">
                                            <tr>
                                                <td colspan="7">회원 목록이 없습니다.</td>
                                            </tr>
                                        </c:if>
                                        <c:forEach var="user" items="${userList}" varStatus="loop">
                                            <tr class="admin-clickable-row" data-user-id="${user.user_id}">
                                                <td>${pagination.offset + loop.index + 1}</td>
                                                <td class="admin-highlight-target"><strong>${user.name}</strong></td>
                                                <td class="admin-highlight-target">${user.login_id}</td>
                                                <td class="admin-highlight-target">${user.nick_name}</td>
                                                <td class="left admin-highlight-target">${user.email}</td>
                                                <td>${user.role eq 'SELLER' ? "판매자" : "일반회원"}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${user.status eq 'active'}">
                                                            <span class="admin-status active" data-member-status>
                                                                활성
                                                            </span>
                                                        </c:when>
                                                        
                                                        <c:when test="${user.status eq 'suspended'}">
                                                            <span class="admin-status suspended" data-member-status>
                                                                정지
                                                            </span>
                                                        </c:when>

                                                        <c:when test="${user.status eq 'withdrawn'}">
                                                            <span class="admin-status withdrawn" data-member-status>
                                                                탈퇴
                                                            </span>
                                                        </c:when>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <aside class="admin-card admin-detail-panel" id="adminDetailPanel">
                            <div class="admin-detail-panel-inner">
                                <div class="admin-detail-content">
                                    <div class="admin-detail-head">
                                        <div class="admin-detail-head-main">
                                            <div class="admin-detail-title-block">
                                                <div class="admin-detail-title-line">
                                                    <h2 id="memberDetailTitle">회원 상세</h2>
                                                    <span class="admin-detail-status-badge"
                                                        id="memberDetailStatusBadge">-</span>
                                                </div>
                                                <p id="memberDetailMeta">목록에서 회원을 선택하세요.</p>
                                            </div>
                                            <div class="admin-detail-toolbar">
                                                <button type="button" class="admin-detail-close"
                                                    aria-label="닫기">&times;</button>
                                            </div>
                                        </div>
                                        <div class="admin-detail-tabs">
                                            <button type="button" class="admin-detail-tab active" data-detail-tab="info">
                                                정보
                                            </button>
                                            <button type="button" class="admin-detail-tab" data-detail-tab="manage">
                                                관리
                                            </button>
                                        </div>
                                    </div>

                                    <div class="admin-detail-tab-body">
                                        <div class="admin-detail-tab-panel active" data-detail-panel="info">
                                            <div class="admin-detail-info-scroll">
                                                <div class="admin-detail-manage-section admin-detail-quick-link-section">
                                                    <div class="admin-detail-section-head">
                                                        <h3>바로가기</h3>
                                                    </div>
                                                    <div class="admin-detail-activity">
                                                        <a href="#" id="memberOrderLink">
                                                            <strong id="memberOrderCount">-</strong>
                                                            <span>주문</span>
                                                        </a>
                                                        <a href="#" id="memberReviewLink">
                                                            <strong id="memberReviewCount">-</strong>
                                                            <span>후기</span>
                                                        </a>
                                                        <a href="#" id="memberInquiryLink">
                                                            <strong id="memberInquiryCount">-</strong>
                                                            <span>문의</span>
                                                        </a>
                                                        <a href="#" id="memberReportLink">
                                                            <strong id="memberReportCount">-</strong>
                                                            <span>신고</span>
                                                        </a>
                                                    </div>
                                                    <div class="admin-detail-link-list admin-detail-seller-link-list" id="memberSellerActions" hidden>
                                                        <a href="#" id="memberSellerManageLink">
                                                            <span>판매자 관리</span>
                                                        </a>
                                                        <a href="#" id="memberSellerShopLink">
                                                            <span>판매자 페이지</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <dl class="admin-detail-grid">
                                                    <div>
                                                        <dt>회원명</dt>
                                                        <dd id="name" class="admin-highlight-target">-</dd>
                                                    </div>
                                                    <div>
                                                        <dt>아이디</dt>
                                                        <dd id="loginId" class="admin-highlight-target">-</dd>
                                                    </div>
                                                    <div>
                                                        <dt>닉네임</dt>
                                                        <dd id="nickName" class="admin-highlight-target">-</dd>
                                                    </div>
                                                    <div>
                                                        <dt>이메일</dt>
                                                        <dd id="email" class="admin-highlight-target">-</dd>
                                                    </div>
                                                    <div>
                                                        <dt>연락처</dt>
                                                        <dd id="phone" class="admin-highlight-target">-</dd>
                                                    </div>
                                                    <div>
                                                        <dt>성별</dt>
                                                        <dd id="gender">-</dd>
                                                    </div>
                                                    <div>
                                                        <dt>회원 유형</dt>
                                                        <dd id="role">-</dd>
                                                    </div>
                                                    <div>
                                                        <dt>회원 상태</dt>
                                                        <dd id="status">-</dd>
                                                    </div>
                                                    <div>
                                                        <dt>가입일</dt>
                                                        <dd id="createdAt">-</dd>
                                                    </div>
                                                    <div>
                                                        <dt>수정일</dt>
                                                        <dd id="updatedAt">-</dd>
                                                    </div>
                                                    <div>
                                                        <dt>내부 회원번호</dt>
                                                        <dd id="userId">-</dd>
                                                    </div>
                                                </dl>
                                            </div>
                                        </div>

                                        <div class="admin-detail-tab-panel" data-detail-panel="manage">
                                            <div class="admin-detail-manage">
                                                <div class="admin-detail-manage-section admin-detail-status-section">
                                                    <div class="admin-detail-section-head">
                                                        <h3>상태 관리</h3>
                                                    </div>
                                                    <div class="admin-detail-setting-row">
                                                        <label class="admin-detail-control">
                                                            <span>회원 상태</span>
                                                            <select class="admin-filter-control" id="statusControl">
                                                                <option value="active">활성</option>
                                                                <option value="suspended">정지</option>
                                                                <option value="withdrawn">탈퇴</option>
                                                            </select>
                                                        </label>
                                                    </div>
                                                    <textarea id="statusReason" class="admin-detail-memo admin-detail-status-reason"
                                                        rows="3" placeholder="상태 변경 사유를 입력하세요."></textarea>
                                                    <div class="admin-detail-section-actions">
                                                        <button type="button" class="admin-btn light" id="statusCancelButton">변경 취소</button>
                                                        <button type="button" class="admin-btn" id="statusChangeButton">상태 변경</button>
                                                    </div>
                                                </div>

                                                <div class="admin-detail-manage-section">
                                                    <div class="admin-detail-section-head">
                                                        <h3>관리 메모</h3>
                                                    </div>
                                                    <textarea id="adminMemoContent" class="admin-detail-memo" rows="5"
                                                        placeholder="회원 관리에 필요한 메모를 입력하세요."></textarea>

                                                    <div class="admin-detail-section-actions">
                                                        <button type="button" class="admin-btn light" id="adminMemoSaveButton">메모 저장</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </aside>
                    </section>

                    <div class="admin-pagination">
                        <div class="admin-pagination-pages">
                            <c:if test="${pagination.totalPage > 0}">
                                <c:if test="${pagination.hasPrev}">
                                    <a href="/admin/members?role=${role}&keyword=${keyword}&user_id=${user_id}&gender=${gender}&status=${status}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${pagination.prevPage}">
                                        
                                        이전
                                    </a>
                                </c:if>
                                <c:if test="${!pagination.hasPrev}">
                                    <span class="disabled">이전</span>
                                </c:if>

                                <c:forEach var="i" begin="${pagination.startPage}" end="${pagination.endPage}">
                                    <a href="/admin/members?role=${role}&keyword=${keyword}&user_id=${user_id}&gender=${gender}&status=${status}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${i}"
                                        class="${pagination.page == i ? 'active' : ''}">
                                        ${i}
                                    </a>
                                </c:forEach>

                                <c:if test="${pagination.hasNext}">
                                    <a href="/admin/members?role=${role}&keyword=${keyword}&user_id=${user_id}&gender=${gender}&status=${status}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${pagination.nextPage}">
                                        다음
                                    </a>
                                </c:if>
                                <c:if test="${!pagination.hasNext}">
                                    <span class="disabled">다음</span>
                                </c:if>
                            </c:if>
                        </div>
                        <span class="admin-filter-count">전체 ${totalCount}명</span>
                    </div>
                </main>
            </div>
        </body>

        </html>
