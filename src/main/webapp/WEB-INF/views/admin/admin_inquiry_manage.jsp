<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <title>관리자 센터 - 고객센터 문의 관리</title>
            <link rel="stylesheet" href="/css/admin/admin_common.css">
            <link rel="stylesheet" href="/css/admin/admin_detail_panel.css">
            <script src="/js/admin_detail_common.js"></script>
            <script>
                document.addEventListener("DOMContentLoaded", () => {
                    const master = document.getElementById("adminMasterDetail");
                    const rows = document.querySelectorAll(".admin-clickable-row");
                    const statusLabels = {
                        WAITING: "미답변",
                        ANSWERED: "답변완료"
                    };
                    let selectedInquiryId = "";
                    let selectedInquiryRow = null;
                    const managePanel = initAdminDetailManage({
                        targetType: "INQUIRY",
                        statusUrl: "/admin/inquiries/status",
                        idParam: "inquiry_id",
                        statusBadgeId: "inquiryDetailStatusBadge",
                        statusLabels
                    });

                    rows.forEach((row) => {
                        //모든 행에 클릭 이벤트 부여
                        row.addEventListener("click", () => {
                            //상세 패널이 열려있고 이미 선택된 행을 눌렀을 때
                            if (!master.classList.contains("is-collapsed") && row.classList.contains("selected")) {
                                closeDetailPanel(master, row);
                                return;
                            }

                            openDetailPanel(master, rows, row);

                            //상세 패널 내용 변경
                            const inquiryId = row.dataset.inquiryId;
                            selectedInquiryId = inquiryId;
                            selectedInquiryRow = row;

                            fetch("/admin/inquiries/detail?inquiry_id=" + encodeURIComponent(inquiryId))
                                .then(res => res.json())
                                .then(data => {
                                    const inquiry = data.inquiry;
                                    const typeLabels = {
                                        SERVICE: "서비스 이용",
                                        ACCOUNT: "회원/계정",
                                        PAYMENT: "결제 오류",
                                        SELLER: "판매자 센터",
                                        POLICY: "운영 정책",
                                        ETC: "기타"
                                    };
                                    const statusKey = String(inquiry.status || "").toUpperCase();
                                    const typeKey = String(inquiry.inquiry_type || "").toUpperCase();
                                    const statusLabel = statusLabels[statusKey] || "알 수 없음";
                                    const typeLabel = typeLabels[typeKey] || "알 수 없음";

                                    setDetailTitleBlock(
                                        "inquiryDetailTitle",
                                        "inquiryDetailMeta",
                                        inquiry.title || "문의 상세",
                                        (inquiry.user_name || "-") + " · " + (typeLabel || "-")
                                    );
                                    setDetailStatusBadge("inquiryDetailStatusBadge", inquiry.status, statusLabel);
                                    setText("userName", inquiry.user_name);
                                    setText("inquiryType", typeLabel);
                                    setText("title", inquiry.title);
                                    setText("content", inquiry.content);
                                    setText("status", statusLabel);
                                    setText("createdAt", inquiry.created_at);
                                    setText("answer", inquiry.answer);
                                    setText("answeredAt", inquiry.answered_at);
                                    const answerInput = document.getElementById("inquiryAnswerInput");
                                    if (answerInput) {
                                        answerInput.value = inquiry.answer || "";
                                    }
                                    managePanel.setTarget(inquiry.inquiry_id, statusKey, row);

                                    document.getElementById("inquiryMemberLink").href =
                                        "/admin/members?user_id=" + encodeURIComponent(inquiry.user_id);
                                    document.getElementById("inquiryMemberInquiriesLink").href =
                                        "/admin/inquiries?user_id=" + encodeURIComponent(inquiry.user_id);

                                    highlightAdminKeyword(document.getElementById("adminDetailPanel"));
                                })
                        });
                    });

                    const answerSaveButton = document.getElementById("inquiryAnswerSave");
                    if (answerSaveButton) {
                        answerSaveButton.addEventListener("click", () => {
                            const answerInput = document.getElementById("inquiryAnswerInput");

                            if (!selectedInquiryId || !answerInput) {
                                return;
                            }

                            const body = new URLSearchParams();
                            body.append("inquiry_id", selectedInquiryId);
                            body.append("answer", answerInput.value);

                            fetch("/admin/inquiries/answer", {
                                method: "POST",
                                headers: {
                                    "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
                                },
                                body
                            })
                            .then(res => res.json())
                            .then(data => {
                                if (!data.success) {
                                    alert(data.message || "답변 저장에 실패했습니다.");
                                    return;
                                }

                                const inquiry = data.inquiry;
                                const statusLabel = statusLabels[inquiry.status] || "알 수 없음";

                                setText("answer", inquiry.answer);
                                setText("answeredAt", inquiry.answered_at);
                                setText("status", statusLabel);
                                setDetailStatusBadge("inquiryDetailStatusBadge", inquiry.status, statusLabel);
                                managePanel.setTarget(inquiry.inquiry_id, inquiry.status, selectedInquiryRow);

                                if (selectedInquiryRow) {
                                    selectedInquiryRow.dataset.status = inquiry.status;
                                    const statusCell = selectedInquiryRow.querySelector(".admin-status");
                                    if (statusCell) {
                                        statusCell.className = "admin-status answered";
                                        statusCell.textContent = "답변";
                                    }
                                }
                            });
                        });
                    }
                });
            </script>
        </head>

        <body>
            <div class="admin-board">
                <jsp:include page="admin_sidebar.jsp">
                    <jsp:param name="activeMenu" value="inquiries" />
                    <jsp:param name="sidebarTitle" value="고객센터 문의 관리" />
                </jsp:include>

                <main class="admin-main admin-main-fixed">
                    <header class="admin-main-header">
                        <div>
                            <span class="admin-page-label">INQUIRY MANAGEMENT</span>
                            <h1>고객센터 문의 관리</h1>
                        </div>
                    </header>

                    <div class="admin-fixed-list-layout">
            <div class="admin-filter-box admin-filter-modern">
                        <form class="admin-filter-form" action="/admin/inquiries" method="get">
                            <div class="admin-filter-main-row">
                                <div class="admin-filter-tabs">
                                    <a href="/admin/inquiries?status=all&keyword=${keyword}&user_id=${user_id}&inquiryType=${inquiryType}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                                        class="${status eq 'all' ? 'active' : ''}">전체</a>
                                    <a href="/admin/inquiries?status=waiting&keyword=${keyword}&user_id=${user_id}&inquiryType=${inquiryType}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                                        class="${status eq 'waiting' ? 'active' : ''}">미답변</a>
                                    <a href="/admin/inquiries?status=answered&keyword=${keyword}&user_id=${user_id}&inquiryType=${inquiryType}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                                        class="${status eq 'answered' ? 'active' : ''}">답변완료</a>
                                </div>

                                <div class="admin-search-wrap">
                                    <input type="text" id="keyword" class="admin-search" name="keyword"
                                        placeholder="문의 제목, 작성자 검색" value="${keyword}">
                                    <span class="admin-search-icon" aria-hidden="true"></span>
                                </div>
                                <button type="submit" class="admin-btn admin-search-submit">검색</button>
                                <button type="button" class="admin-btn light admin-filter-toggle">상세 검색</button>
                                <select class="admin-filter-control admin-sort-control" id="sort" name="sort">
                                    <option value="latest" ${sort eq 'latest' ? 'selected' : ''}>최신순</option>
                                    <option value="oldest" ${sort eq 'oldest' ? 'selected' : ''}>오래된순</option>
                                    <option value="title" ${sort eq 'title' ? 'selected' : ''}>제목순</option>
                                </select>
                                <select id="pageSize" class="admin-filter-control admin-page-size-control" name="size">
                                    <option value="10" ${pagination.size == 10 ? 'selected' : ''}>10개씩</option>
                                    <option value="30" ${pagination.size == 30 ? 'selected' : ''}>30개씩</option>
                                    <option value="50" ${pagination.size == 50 ? 'selected' : ''}>50개씩</option>
                                </select>
                            </div>

                            <div class="admin-filter-detail-row">
                                <label class="admin-filter-field">
                                    <span>상태</span>
                                    <select class="admin-filter-control" name="status">
                                        <option value="all" ${status eq 'all' ? 'selected' : ''}>전체</option>
                                        <option value="waiting" ${status eq 'waiting' ? 'selected' : ''}>미답변</option>
                                        <option value="answered" ${status eq 'answered' ? 'selected' : ''}>답변완료</option>
                                    </select>
                                </label>
                                <label class="admin-filter-field">
                                    <span>문의 유형</span>
                                    <select class="admin-filter-control" name="inquiryType">
                                        <option value="all" ${inquiryType eq 'all' ? 'selected' : ''}>전체</option>
                                        <option value="SERVICE" ${inquiryType eq 'SERVICE' ? 'selected' : ''}>서비스 이용</option>
                                        <option value="ACCOUNT" ${inquiryType eq 'ACCOUNT' ? 'selected' : ''}>회원/계정</option>
                                        <option value="PAYMENT" ${inquiryType eq 'PAYMENT' ? 'selected' : ''}>결제 오류</option>
                                        <option value="SELLER" ${inquiryType eq 'SELLER' ? 'selected' : ''}>판매자 센터</option>
                                        <option value="POLICY" ${inquiryType eq 'POLICY' ? 'selected' : ''}>운영 정책</option>
                                        <option value="ETC" ${inquiryType eq 'ETC' ? 'selected' : ''}>기타</option>
                                    </select>
                                </label>
                                <label class="admin-filter-field admin-filter-date-range">
                                    <span>작성일 범위</span>
                                    <input type="date" class="admin-filter-control" name="startDate" value="${startDate}">
                                    <em>~</em>
                                    <input type="date" class="admin-filter-control" name="endDate" value="${endDate}">
                                </label>
                                <button type="submit" class="admin-btn admin-filter-submit">적용</button>
                            </div>

                            <c:if test="${status ne 'all' || not empty keyword || not empty user_id || inquiryType ne 'all' || not empty startDate || not empty endDate}">
                                <div class="admin-filter-applied">
                                    <span class="admin-filter-applied-label">적용된 조건:</span>
                                    <c:if test="${status ne 'all'}">
                                        <a class="admin-filter-chip"
                                            href="/admin/inquiries?status=all&keyword=${keyword}&user_id=${user_id}&inquiryType=${inquiryType}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                            상태: ${status eq 'waiting' ? '미답변' : '답변완료'}
                                            <span aria-hidden="true">&times;</span>
                                        </a>
                                    </c:if>
                                    <c:if test="${not empty keyword}">
                                        <a class="admin-filter-chip" href="/admin/inquiries?status=${status}&user_id=${user_id}&inquiryType=${inquiryType}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                            검색어: ${keyword}
                                            <span aria-hidden="true">&times;</span>
                                        </a>
                                    </c:if>
                                    <c:if test="${not empty user_id}">
                                        <a class="admin-filter-chip" href="/admin/inquiries?status=${status}&keyword=${keyword}&inquiryType=${inquiryType}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                            회원:
                                            <c:choose>
                                                <c:when test="${not empty filterUser}">
                                                    ${filterUser.name} · ${filterUser.login_id}
                                                </c:when>
                                                <c:otherwise>${user_id}</c:otherwise>
                                            </c:choose>
                                            <span aria-hidden="true">&times;</span>
                                        </a>
                                    </c:if>
                                    <c:if test="${inquiryType ne 'all'}">
                                        <a class="admin-filter-chip" href="/admin/inquiries?status=${status}&keyword=${keyword}&user_id=${user_id}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                            문의 유형:
                                            <c:choose>
                                                <c:when test="${inquiryType eq 'SERVICE'}">서비스 이용</c:when>
                                                <c:when test="${inquiryType eq 'ACCOUNT'}">회원/계정</c:when>
                                                <c:when test="${inquiryType eq 'PAYMENT'}">결제 오류</c:when>
                                                <c:when test="${inquiryType eq 'SELLER'}">판매자 센터</c:when>
                                                <c:when test="${inquiryType eq 'POLICY'}">운영 정책</c:when>
                                                <c:otherwise>기타</c:otherwise>
                                            </c:choose>
                                            <span aria-hidden="true">&times;</span>
                                        </a>
                                    </c:if>
                                    <c:if test="${not empty startDate || not empty endDate}">
                                        <a class="admin-filter-chip" href="/admin/inquiries?status=${status}&keyword=${keyword}&user_id=${user_id}&inquiryType=${inquiryType}&sort=${sort}&size=${pagination.size}&page=1">
                                            작성일: ${startDate} ~ ${endDate}
                                            <span aria-hidden="true">&times;</span>
                                        </a>
                                    </c:if>
                                    <a class="admin-filter-clear" href="/admin/inquiries">전체 해제</a>
                                </div>
                            </c:if>

                            <input type="hidden" name="user_id" value="${user_id}">
                            <input type="hidden" name="page" value="1">
                        </form>
                    </div>

                    <section class="admin-master-detail admin-master-detail-filtered is-collapsed" id="adminMasterDetail">
                        <div class="admin-card admin-list-panel">
                            <div class="admin-table-wrap">
                                <table class="admin-table">
                                    <thead>
                                        <tr>
                                            <th>번호</th>
                                            <th>문의 유형</th>
                                            <th>제목</th>
                                            <th>작성자</th>
                                            <th>상태</th>
                                            <th>작성일</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:if test="${empty inquiryList}">
                                            <tr>
                                                <td colspan="6">문의 목록이 없습니다.</td>
                                            </tr>
                                        </c:if>
                                        <c:forEach var="inquiry" items="${inquiryList}" varStatus="loop">
                                            <tr class="admin-clickable-row" data-inquiry-id="${inquiry.inquiry_id}">
                                                <td>${pagination.offset + loop.index + 1}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${inquiry.inquiry_type eq 'SERVICE'}">서비스 이용
                                                        </c:when>
                                                        <c:when test="${inquiry.inquiry_type eq 'ACCOUNT'}">회원/계정
                                                        </c:when>
                                                        <c:when test="${inquiry.inquiry_type eq 'PAYMENT'}">결제 오류
                                                        </c:when>
                                                        <c:when test="${inquiry.inquiry_type eq 'SELLER'}">판매자 센터
                                                        </c:when>
                                                        <c:when test="${inquiry.inquiry_type eq 'POLICY'}">운영 정책
                                                        </c:when>
                                                        <c:when test="${inquiry.inquiry_type eq 'ETC'}">기타</c:when>
                                                    </c:choose>
                                                </td>
                                                <td class="left admin-highlight-target"><strong>${inquiry.title}</strong></td>
                                                <td class="admin-highlight-target">${inquiry.user_name}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${inquiry.status eq 'WAITING'}">
                                                            <span class="admin-status waiting">미답변</span>
                                                        </c:when>

                                                        <c:when test="${inquiry.status eq 'ANSWERED'}">
                                                            <span class="admin-status answered">답변</span>
                                                        </c:when>
                                                    </c:choose>
                                                </td>
                                                <td>${inquiry.created_at}</td>
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
                                                    <h2 id="inquiryDetailTitle">문의 상세</h2>
                                                    <span class="admin-detail-status-badge" id="inquiryDetailStatusBadge">-</span>
                                                </div>
                                                <p id="inquiryDetailMeta">목록에서 문의를 선택하세요.</p>
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
                                                <dl class="admin-detail-grid">
                                        <div>
                                            <dt>작성자</dt>
                                            <dd id="userName" class="admin-highlight-target">-</dd>
                                        </div>
                                        <div>
                                            <dt>문의 종류</dt>
                                            <dd id="inquiryType">-</dd>
                                        </div>
                                        <div>
                                            <dt>제목</dt>
                                            <dd id="title" class="admin-highlight-target">-</dd>
                                        </div>
                                        <div>
                                            <dt>내용</dt>
                                            <dd id="content" class="admin-highlight-target">-</dd>
                                        </div>
                                        <div>
                                            <dt>상태</dt>
                                            <dd id="status">-</dd>
                                        </div>
                                        <div>
                                            <dt>작성일</dt>
                                            <dd id="createdAt">-</dd>
                                        </div>
                                        <div>
                                            <dt>답변일</dt>
                                            <dd id="answeredAt">-</dd>
                                        </div>
                                        <div>
                                            <dt>답변 내용</dt>
                                            <dd id="answer" class="admin-highlight-target">-</dd>
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
                                                            <span>문의 상태</span>
                                                            <select class="admin-filter-control admin-detail-status-control">
                                                            <option value="WAITING">미답변</option>
                                                            <option value="ANSWERED">답변완료</option>
                                                            </select>
                                                        </label>
                                                    </div>
                                                    <textarea class="admin-detail-memo admin-detail-status-reason"
                                                        rows="3" placeholder="상태 변경 사유를 입력하세요."></textarea>
                                                    <div class="admin-detail-section-actions">
                                                        <button type="button" class="admin-btn light">변경 취소</button>
                                                        <button type="button" class="admin-btn admin-detail-status-change">상태 변경</button>
                                                    </div>
                                                </div>

                                                <div class="admin-detail-manage-section">
                                                    <div class="admin-detail-section-head">
                                                        <h3>답변 관리</h3>
                                                    </div>
                                                    <textarea id="inquiryAnswerInput" class="admin-detail-memo" rows="7"
                                                        data-admin-memo-ignore="true"
                                                        placeholder="회원에게 전달할 답변을 입력하세요."></textarea>
                                                    <div class="admin-detail-section-actions">
                                                        <button type="button" class="admin-btn" id="inquiryAnswerSave">답변 저장</button>
                                                    </div>
                                                </div>

                                                <div class="admin-detail-manage-section">
                                                    <div class="admin-detail-section-head">
                                                        <h3>관리 메모</h3>
                                                    </div>
                                                    <textarea class="admin-detail-memo" rows="5"
                                                        placeholder="관리 중 필요한 메모를 입력하세요."></textarea>
                                                    <div class="admin-detail-section-actions">
                                                        <button type="button" class="admin-btn light">메모 저장</button>
                                                    </div>
                                                </div>

                                                <div class="admin-detail-manage-section">
                                                    <div class="admin-detail-section-head">
                                                        <h3>바로가기</h3>
                                                    </div>
                                                    <div class="admin-detail-link-list">
                                                        <a href="#" id="inquiryMemberLink">
                                                            <span>회원 관리</span>
                                                        </a>
                                                        <a href="#" id="inquiryMemberInquiriesLink">
                                                            <span>회원 문의</span>
                                                        </a>
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
                                    <a
                                        href="/admin/inquiries?status=${status}&keyword=${keyword}&user_id=${user_id}&inquiryType=${inquiryType}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${pagination.prevPage}">
                                        이전
                                    </a>
                                </c:if>
                                <c:if test="${!pagination.hasPrev}">
                                    <span class="disabled">이전</span>
                                </c:if>

                                <c:forEach var="i" begin="${pagination.startPage}" end="${pagination.endPage}">
                                <a href="/admin/inquiries?status=${status}&keyword=${keyword}&user_id=${user_id}&inquiryType=${inquiryType}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${i}"
                                        class="${pagination.page == i ? 'active' : ''}">
                                        ${i}
                                    </a>
                                </c:forEach>

                                <c:if test="${pagination.hasNext}">
                                    <a
                                        href="/admin/inquiries?status=${status}&keyword=${keyword}&user_id=${user_id}&inquiryType=${inquiryType}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${pagination.nextPage}">
                                        다음
                                    </a>
                                </c:if>
                                <c:if test="${!pagination.hasNext}">
                                    <span class="disabled">다음</span>
                                </c:if>
                            </c:if>
                        </div>
                        <span class="admin-filter-count">전체 ${totalCount}건</span>
                    </div>
            </div>
                </main>
            </div>
        </body>

        </html>
