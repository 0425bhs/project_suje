function initReportModal(options) {
    const modal = document.getElementById(options.modalId);
    const targetIdInput = document.getElementById(options.targetInputId);
    const targetTypeInput = document.getElementById(options.targetTypeInputId);
    const reportType = document.getElementById(options.reportTypeId);
    const reportReason = document.getElementById(options.reasonId);

    if (modal == null) {
        return;
    }

    const openButtons = document.querySelectorAll(options.openButtonSelector);
    const closeButtons = modal.querySelectorAll(".report-close-btn, .report-cancel-btn");
    const submitBtn = modal.querySelector(".report-submit-btn");

    openButtons.forEach(function (button) {
        button.addEventListener("click", function (event) {
            event.preventDefault();
            event.stopPropagation();

            const targetId =
                button.dataset.targetId ||
                button.dataset.qnaId ||
                button.dataset.reviewId ||
                "";

            if (targetId === "") {
                alert("신고 대상을 찾을 수 없습니다.");
                return;
            }

            if (targetIdInput != null) {
                targetIdInput.value = targetId;
            }

            if (targetTypeInput != null) {
                targetTypeInput.value = options.targetType;
            }

            if (reportType != null) {
                reportType.value = "";
            }

            if (reportReason != null) {
                reportReason.value = "";
            }

            modal.classList.add("open");
            modal.classList.add("active");
        });
    });

    closeButtons.forEach(function (button) {
        button.addEventListener("click", function () {
            closeReportModal(modal);
        });
    });

    modal.addEventListener("click", function (event) {
        if (event.target === modal) {
            closeReportModal(modal);
        }
    });

    document.addEventListener("keydown", function (event) {
        if (event.key === "Escape") {
            closeReportModal(modal);
        }
    });

    if (submitBtn != null) {
        submitBtn.addEventListener("click", function () {
            submitReport(options, modal);
        });
    }
}

function closeReportModal(modal) {
    if (modal == null) {
        return;
    }

    modal.classList.remove("open");
    modal.classList.remove("active");
}

function submitReport(options, modal) {
    const targetIdInput = document.getElementById(options.targetInputId);
    const targetTypeInput = document.getElementById(options.targetTypeInputId);
    const reportType = document.getElementById(options.reportTypeId);
    const reportReason = document.getElementById(options.reasonId);

    const targetId = targetIdInput == null ? "" : targetIdInput.value.trim();
    const targetType = targetTypeInput == null ? options.targetType : targetTypeInput.value.trim();
    const reportTypeValue = reportType == null ? "" : reportType.value.trim();
    const reason = reportReason == null ? "" : reportReason.value.trim();

    if (targetId === "") {
        alert("신고 대상을 찾을 수 없습니다.");
        return;
    }

    if (reportTypeValue === "") {
        alert("신고 사유를 선택해주세요.");

        if (reportType != null) {
            reportType.focus();
        }

        return;
    }

    if (reason === "") {
        alert("신고 내용을 입력해주세요.");

        if (reportReason != null) {
            reportReason.focus();
        }

        return;
    }

    fetch("/seller_qna_report.do", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
        },
        body: new URLSearchParams({
            target_type: targetType,
            target_id: targetId,
            report_type: reportTypeValue,
            reason: reason
        })
    })
    .then(function (response) {
        if (!response.ok) {
            throw new Error("서버 응답 오류");
        }

        return response.json();
    })
    .then(function (data) {
        if (data.result === "success") {
            alert("신고가 접수되었습니다.");
            closeReportModal(modal);
        } else if (data.result === "login") {
            alert("로그인이 필요합니다.");
            location.href = "/login.do";
        } else if (data.result === "empty") {
            alert("신고 사유와 내용을 입력해주세요.");
        } else {
            alert("신고 접수에 실패했습니다.");
        }
    })
    .catch(function (error) {
        console.error(error);
        alert("신고 접수 중 오류가 발생했습니다.");
    });
}