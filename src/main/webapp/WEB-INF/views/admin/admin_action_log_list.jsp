<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 처리 내역</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
    <script src="/js/admin_detail_common.js"></script>
</head>
<body>
<div class="admin-board">
    <jsp:include page="admin_sidebar.jsp">
        <jsp:param name="activeMenu" value="actionLogs" />
        <jsp:param name="sidebarTitle" value="관리자 센터" />
    </jsp:include>

    <main class="admin-main admin-main-fixed">
        <header class="admin-main-header">
            <div>
                <span class="admin-page-label">ACTION LOGS</span>
                <h1>처리 내역</h1>
            </div>
        </header>

        <div class="admin-fixed-list-layout">
        <div class="admin-filter-box admin-filter-modern admin-action-log-filter">
            <form class="admin-filter-form" action="/admin/action-logs" method="get">
                <div class="admin-filter-main-row">
                    <div class="admin-filter-tabs">
                        <a href="/admin/action-logs?targetType=all&actionType=${actionType}&status=${status}&targetId=${targetId}&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                           class="${targetType eq 'all' ? 'active' : ''}">전체</a>
                        <a href="/admin/action-logs?targetType=MEMBER&actionType=${actionType}&status=${status}&targetId=${targetId}&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                           class="${targetType eq 'MEMBER' ? 'active' : ''}">회원</a>
                        <a href="/admin/action-logs?targetType=SELLER&actionType=${actionType}&status=${status}&targetId=${targetId}&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                           class="${targetType eq 'SELLER' ? 'active' : ''}">판매자</a>
                        <a href="/admin/action-logs?targetType=PRODUCT&actionType=${actionType}&status=${status}&targetId=${targetId}&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                           class="${targetType eq 'PRODUCT' ? 'active' : ''}">상품</a>
                        <a href="/admin/action-logs?targetType=INQUIRY&actionType=${actionType}&status=${status}&targetId=${targetId}&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                           class="${targetType eq 'INQUIRY' ? 'active' : ''}">문의</a>
                        <a href="/admin/action-logs?targetType=REPORT&actionType=${actionType}&status=${status}&targetId=${targetId}&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                           class="${targetType eq 'REPORT' ? 'active' : ''}">신고</a>
                        <a href="/admin/action-logs?targetType=ORDER&actionType=${actionType}&status=${status}&targetId=${targetId}&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                           class="${targetType eq 'ORDER' ? 'active' : ''}">주문</a>
                    </div>

                    <div class="admin-search-wrap">
                        <input type="text" id="keyword" class="admin-search" name="keyword"
                               placeholder="관리자, 사유, 대상번호, 상태 검색" value="${keyword}">
                        <span class="admin-search-icon" aria-hidden="true"></span>
                    </div>
                    <button type="submit" class="admin-btn admin-search-submit">검색</button>
                    <button type="button" class="admin-btn light admin-filter-toggle ${not empty startDate || not empty endDate ? 'is-open' : ''}">상세 검색</button>
                    <select class="admin-filter-control admin-sort-control" id="sort" name="sort">
                        <option value="latest" ${sort eq 'latest' ? 'selected' : ''}>최신순</option>
                        <option value="oldest" ${sort eq 'oldest' ? 'selected' : ''}>오래된순</option>
                        <option value="target" ${sort eq 'target' ? 'selected' : ''}>대상순</option>
                        <option value="admin" ${sort eq 'admin' ? 'selected' : ''}>관리자순</option>
                    </select>
                    <select id="pageSize" class="admin-filter-control admin-page-size-control" name="size">
                        <option value="10" ${pagination.size == 10 ? 'selected' : ''}>10개씩</option>
                        <option value="30" ${pagination.size == 30 ? 'selected' : ''}>30개씩</option>
                        <option value="50" ${pagination.size == 50 ? 'selected' : ''}>50개씩</option>
                    </select>
                </div>

                <div class="admin-filter-detail-row ${not empty startDate || not empty endDate ? 'is-open' : ''}">
                    <label class="admin-filter-field admin-filter-date-range">
                        <span>처리일 범위</span>
                        <input type="date" class="admin-filter-control" name="startDate" value="${startDate}">
                        <em>~</em>
                        <input type="date" class="admin-filter-control" name="endDate" value="${endDate}">
                    </label>
                    <button type="submit" class="admin-btn admin-filter-submit">적용</button>
                </div>

                <input type="hidden" name="targetType" value="${targetType}">
                <input type="hidden" name="actionType" value="${actionType}">
                <input type="hidden" name="status" value="${status}">
                <input type="hidden" name="targetId" value="${targetId}">
                <c:if test="${targetType ne 'all' || actionType ne 'all' || status ne 'all' || not empty targetId || not empty keyword || not empty startDate || not empty endDate}">
                    <div class="admin-filter-applied">
                        <span class="admin-filter-applied-label">적용된 조건:</span>
                        <c:if test="${targetType ne 'all'}">
                            <a class="admin-filter-chip" href="/admin/action-logs?targetType=all&actionType=${actionType}&status=${status}&targetId=${targetId}&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                대상:
                                <c:choose>
                                    <c:when test="${targetType eq 'MEMBER'}">회원</c:when>
                                    <c:when test="${targetType eq 'SELLER'}">판매자</c:when>
                                    <c:when test="${targetType eq 'PRODUCT'}">상품</c:when>
                                    <c:when test="${targetType eq 'INQUIRY'}">문의</c:when>
                                    <c:when test="${targetType eq 'REPORT'}">신고</c:when>
                                    <c:when test="${targetType eq 'ORDER'}">주문</c:when>
                                </c:choose>
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <c:if test="${actionType ne 'all'}">
                            <a class="admin-filter-chip" href="/admin/action-logs?targetType=${targetType}&actionType=all&status=${status}&targetId=${targetId}&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                작업: ${actionType eq 'ANSWER' ? '답변 저장' : '상태 변경'}
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <c:if test="${status ne 'all'}">
                            <a class="admin-filter-chip" href="/admin/action-logs?targetType=${targetType}&actionType=${actionType}&status=all&targetId=${targetId}&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                상태:
                                <c:choose>
                                    <c:when test="${status eq 'PENDING'}">대기</c:when>
                                    <c:when test="${status eq 'APPROVED'}">승인/판매중</c:when>
                                    <c:when test="${status eq 'REJECTED'}">반려</c:when>
                                    <c:when test="${status eq 'ACTIVE'}">활성</c:when>
                                    <c:when test="${status eq 'SUSPENDED'}">정지</c:when>
                                    <c:when test="${status eq 'WITHDRAWN'}">탈퇴</c:when>
                                    <c:when test="${status eq 'HIDDEN'}">숨김</c:when>
                                    <c:when test="${status eq 'WAITING'}">미답변</c:when>
                                    <c:when test="${status eq 'ANSWERED'}">답변완료</c:when>
                                    <c:when test="${status eq 'PROCESSED'}">처리완료</c:when>
                                    <c:when test="${status eq 'PAID'}">결제완료</c:when>
                                    <c:when test="${status eq 'PREPARING'}">배송준비</c:when>
                                    <c:when test="${status eq 'SHIPPING'}">배송중</c:when>
                                    <c:when test="${status eq 'DELIVERED'}">배송완료</c:when>
                                    <c:when test="${status eq 'CANCELLED'}">취소</c:when>
                                    <c:otherwise>알 수 없음</c:otherwise>
                                </c:choose>
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <c:if test="${not empty targetId}">
                            <a class="admin-filter-chip" href="/admin/action-logs?targetType=${targetType}&actionType=${actionType}&status=${status}&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                대상번호: ${targetId}
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <c:if test="${not empty keyword}">
                            <a class="admin-filter-chip" href="/admin/action-logs?targetType=${targetType}&actionType=${actionType}&status=${status}&targetId=${targetId}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                검색어: ${keyword}
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <c:if test="${not empty startDate || not empty endDate}">
                            <a class="admin-filter-chip" href="/admin/action-logs?targetType=${targetType}&actionType=${actionType}&status=${status}&targetId=${targetId}&keyword=${keyword}&sort=${sort}&size=${pagination.size}&page=1">
                                처리일: ${startDate} ~ ${endDate}
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <a class="admin-filter-clear" href="/admin/action-logs">전체 해제</a>
                    </div>
                </c:if>
                <input type="hidden" name="page" value="1">
            </form>
        </div>

        <section class="admin-card admin-list-panel">
            <div class="admin-table-wrap">
                <table class="admin-table">
                    <thead>
                    <tr>
                        <th>번호</th>
                        <th>관리자</th>
                        <th>대상</th>
                        <th>작업</th>
                        <th>변경</th>
                        <th>사유</th>
                        <th>일시</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty actionLogList}">
                            <tr>
                                <td colspan="7">처리 내역이 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="log" items="${actionLogList}" varStatus="loop">
                                <c:choose>
                                    <c:when test="${log.target_type eq 'MEMBER'}">
                                        <c:set var="targetHref" value="/admin/members?user_id=${log.target_id}&page=1" />
                                    </c:when>
                                    <c:when test="${log.target_type eq 'SELLER'}">
                                        <c:set var="targetHref" value="/admin/sellers?seller_id=${log.target_id}&page=1" />
                                    </c:when>
                                    <c:when test="${log.target_type eq 'PRODUCT'}">
                                        <c:set var="targetHref" value="/admin/products?product_id=${log.target_id}&page=1" />
                                    </c:when>
                                    <c:when test="${log.target_type eq 'INQUIRY'}">
                                        <c:set var="targetHref" value="/admin/inquiries?status=all&page=1" />
                                    </c:when>
                                    <c:when test="${log.target_type eq 'REPORT'}">
                                        <c:set var="targetHref" value="/admin/reports?status=all&page=1" />
                                    </c:when>
                                    <c:when test="${log.target_type eq 'ORDER'}">
                                        <c:set var="targetHref" value="/admin/orders?keyword=${log.target_id}&page=1" />
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="targetHref" value="" />
                                    </c:otherwise>
                                </c:choose>
                                <tr class="${empty targetHref ? '' : 'admin-clickable-row'}" data-href="${targetHref}">
                                    <td>${pagination.offset + loop.index + 1}</td>
                                    <td>${empty log.admin_name ? '관리자' : log.admin_name}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${log.target_type eq 'MEMBER'}">회원 #${log.target_id}</c:when>
                                            <c:when test="${log.target_type eq 'SELLER'}">판매자 #${log.target_id}</c:when>
                                            <c:when test="${log.target_type eq 'PRODUCT'}">상품 #${log.target_id}</c:when>
                                            <c:when test="${log.target_type eq 'INQUIRY'}">문의 #${log.target_id}</c:when>
                                            <c:when test="${log.target_type eq 'REPORT'}">신고 #${log.target_id}</c:when>
                                            <c:when test="${log.target_type eq 'ORDER'}">주문 #${log.target_id}</c:when>
                                            <c:otherwise>기타 #${log.target_id}</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${log.action_type eq 'ANSWER'}">답변 저장</c:when>
                                            <c:otherwise>상태 변경</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="admin-action-log-change">
                                            <span class="admin-status ${fn:toLowerCase(log.before_status)}">
                                                ${empty log.beforeStatusLabel ? '없음' : log.beforeStatusLabel}
                                            </span>
                                            <span class="admin-action-log-arrow">→</span>
                                            <span class="admin-status ${fn:toLowerCase(log.after_status)}">
                                                ${empty log.afterStatusLabel ? '없음' : log.afterStatusLabel}
                                            </span>
                                        </div>
                                    </td>
                                    <td class="left">${empty log.memo ? '없음' : log.memo}</td>
                                    <td>${log.created_at}</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </section>

        <div class="admin-pagination">
            <div class="admin-pagination-pages">
                <c:choose>
                    <c:when test="${pagination.hasPrev}">
                        <a href="/admin/action-logs?targetType=${targetType}&actionType=${actionType}&status=${status}&targetId=${targetId}&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${pagination.prevPage}">이전</a>
                    </c:when>
                    <c:otherwise>
                        <span class="disabled">이전</span>
                    </c:otherwise>
                </c:choose>

                <c:if test="${pagination.totalPage > 0}">
                    <c:forEach var="i" begin="${pagination.startPage}" end="${pagination.endPage}">
                        <a href="/admin/action-logs?targetType=${targetType}&actionType=${actionType}&status=${status}&targetId=${targetId}&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${i}"
                           class="${pagination.page == i ? 'active' : ''}">
                            ${i}
                        </a>
                    </c:forEach>
                </c:if>

                <c:choose>
                    <c:when test="${pagination.hasNext}">
                        <a href="/admin/action-logs?targetType=${targetType}&actionType=${actionType}&status=${status}&targetId=${targetId}&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${pagination.nextPage}">다음</a>
                    </c:when>
                    <c:otherwise>
                        <span class="disabled">다음</span>
                    </c:otherwise>
                </c:choose>
            </div>
            <span class="admin-filter-count">전체 ${totalCount}건</span>
        </div>
        </div>
    </main>
</div>
</body>
</html>
