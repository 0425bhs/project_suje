<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<div id="${param.modalId}" class="report-modal-bg">
    <form class="report-modal">
        <input type="hidden" id="${param.targetInputId}" name="target_id">
        <input type="hidden" id="${param.targetTypeInputId}" name="target_type" value="${param.targetType}">

        <div class="report-modal-head">
            <div>
                <strong>${param.title}</strong>
                <p>${param.description}</p>
            </div>

            <button type="button" class="report-close-btn">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>

        <div class="report-modal-body">
            <div class="report-field">
                <label for="${param.reportTypeId}">신고 사유</label>

                <select id="${param.reportTypeId}" name="report_type">
                    <option value="">신고 사유를 선택해주세요.</option>
                    <option value="ABUSE">욕설/비방</option>
                    <option value="SPAM">도배/스팸</option>
                    <option value="AD">광고/홍보성 내용</option>
                    <option value="PERSONAL_INFO">개인정보 노출</option>
                    <option value="IRRELEVANT">상품과 관련 없는 내용</option>
                    <option value="ETC">기타</option>
                </select>
            </div>

            <div class="report-field">
                <label for="${param.reasonId}">신고 내용</label>
                <textarea id="${param.reasonId}"
                          name="reason"
                          placeholder="${param.reasonPlaceholder}"></textarea>
            </div>
        </div>

        <div class="report-modal-actions">
            <button type="button" class="report-cancel-btn">취소</button>
            <button type="button" class="report-submit-btn">신고하기</button>
        </div>
    </form>
</div>