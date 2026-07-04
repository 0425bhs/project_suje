// 상세 패널 열기(행을 누르면 동작)
function openDetailPanel(master, rows, row) {
    rows.forEach((item) => {
        item.classList.remove("selected");
    });
    row.classList.add("selected");

    master.classList.remove("is-collapsed");
}

// 상세 패널 닫기(동일한 행을 또 누를 때, 
// 닫기 버튼/ESC를 눌렀을 때는 closeSelectedDetailPanel를 통해 동작)
function closeDetailPanel(master, row) {
    master.classList.add("is-collapsed");

    if (row) {
        row.classList.remove("selected");
    }
}

//DB에서 가져온 값을 상세 패널에 출력(입력된 id의 태그의 내부에 value를 출력)
function setText(id, value) {
    const target = document.getElementById(id);

    if (!target) {
        return;
    }

    const text = value == null ? "" : String(value);

    target.textContent = text.trim() ? text : "없음";
}

// 상세 패널 제목 영역에 제목과 보조 정보를 출력
function setDetailTitleBlock(titleId, metaId, title, meta) {
    setText(titleId, title);
    setText(metaId, meta);
}

// 상세 패널 제목 옆 상태 배지 출력
function setDetailStatusBadge(id, status, label) {
    const badge = document.getElementById(id);

    if (!badge) {
        return;
    }

    const statusText = status == null ? "" : String(status);
    const statusClass = statusText.toLowerCase();

    badge.className = "admin-detail-status-badge";

    if (statusClass) {
        badge.classList.add(statusClass);
    }

    setText(id, label || statusText);
}

function loadAdminDetailMemo(targetType, targetId, memoContent) {
    if (!targetType || !targetId || !memoContent) {
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

            memoContent.value = data.memoList && data.memoList.length > 0
                ? data.memoList[0].content || ""
                : "";
        });
}

function getAdminActionLabel(actionType) {
    switch (String(actionType || "").toUpperCase()) {
        case "ANSWER":
            return "답변 저장";
        case "STATUS_CHANGE":
            return "상태 변경";
        default:
            return "관리 작업";
    }
}

const ADMIN_ACTION_LOG_PREVIEW_SIZE = 3;

function createAdminActionStatusBadge(status, label) {
    const badge = document.createElement("span");
    const statusClass = String(status || "").toLowerCase();

    badge.className = "admin-detail-action-log-status-badge";

    if (statusClass) {
        badge.classList.add(statusClass);
    }

    badge.textContent = label || "없음";

    return badge;
}

function ensureAdminActionLogSection() {
    const managePanel = document.querySelector(".admin-detail-manage");
    const statusSection = document.querySelector(".admin-detail-status-section");

    if (!managePanel || !statusSection) {
        return null;
    }

    let section = managePanel.querySelector(".admin-detail-action-log-section");

    if (!section) {
        section = document.createElement("div");
        section.className = "admin-detail-manage-section admin-detail-action-log-section";

        const head = document.createElement("div");
        head.className = "admin-detail-section-head";

        const title = document.createElement("h3");
        title.textContent = "최근 관리 내역";

        const moreLink = document.createElement("a");
        moreLink.className = "admin-detail-action-log-more";
        moreLink.textContent = "더보기";
        moreLink.hidden = true;

        head.append(title, moreLink);

        const list = document.createElement("div");
        list.className = "admin-detail-action-log-list";

        section.append(head, list);
        statusSection.insertAdjacentElement("afterend", section);
    }

    return section.querySelector(".admin-detail-action-log-list");
}

function renderAdminActionLogList(logList) {
    const list = ensureAdminActionLogSection();

    if (!list) {
        return;
    }

    const section = list.closest(".admin-detail-action-log-section");
    const moreLink = section ? section.querySelector(".admin-detail-action-log-more") : null;
    const targetType = list.dataset.targetType;
    const targetId = list.dataset.targetId;

    list.replaceChildren();

    if (moreLink) {
        moreLink.hidden = true;
        moreLink.removeAttribute("href");
    }

    if (moreLink && targetType && targetId) {
        moreLink.href = "/admin/action-logs?targetType=" + encodeURIComponent(targetType)
            + "&targetId=" + encodeURIComponent(targetId)
            + "&page=1";
        moreLink.hidden = false;
    }

    if (!logList || !logList.length) {
        const empty = document.createElement("p");
        empty.className = "admin-detail-action-log-empty";
        empty.textContent = "최근 관리 내역이 없습니다.";
        list.appendChild(empty);
        return;
    }

    logList.slice(0, ADMIN_ACTION_LOG_PREVIEW_SIZE).forEach((log) => {
        const item = document.createElement("div");
        item.className = "admin-detail-action-log-item";

        const top = document.createElement("div");
        top.className = "admin-detail-action-log-top";

        const action = document.createElement("strong");
        action.textContent = getAdminActionLabel(log.action_type);

        const date = document.createElement("span");
        date.className = "admin-detail-action-log-date";
        date.textContent = log.created_at || "없음";

        top.append(action, date);

        const status = document.createElement("p");
        status.className = "admin-detail-action-log-status";

        const beforeStatus = createAdminActionStatusBadge(log.before_status, log.beforeStatusLabel);
        const arrow = document.createElement("span");
        arrow.className = "admin-detail-action-log-arrow";
        arrow.textContent = "→";
        const afterStatus = createAdminActionStatusBadge(log.after_status, log.afterStatusLabel);

        status.append(beforeStatus, arrow, afterStatus);

        const meta = document.createElement("p");
        meta.className = "admin-detail-action-log-meta";
        meta.textContent = (log.admin_name || "관리자") + " · " + (log.memo || "없음");

        item.append(top, status, meta);
        list.appendChild(item);
    });
}

function loadAdminActionLogs(targetType, targetId) {
    const list = ensureAdminActionLogSection();

    if (!targetType || !targetId || !list) {
        return;
    }

    list.dataset.targetType = targetType;
    list.dataset.targetId = targetId;
    const actionLogSection = list.closest(".admin-detail-action-log-section");
    const moreLink = actionLogSection ? actionLogSection.querySelector(".admin-detail-action-log-more") : null;

    if (moreLink) {
        moreLink.hidden = true;
        moreLink.removeAttribute("href");
    }

    list.textContent = "불러오는 중...";

    fetch("/admin/action-logs/recent?target_type=" + encodeURIComponent(targetType)
        + "&target_id=" + encodeURIComponent(targetId))
        .then(res => res.json())
        .then(data => {
            if (!data.success) {
                list.textContent = data.message || "관리 내역을 불러오지 못했습니다.";
                return;
            }

            renderAdminActionLogList(data.actionLogList);
        });
}

function initAdminDetailManage(options) {
    const statusControl = document.querySelector(".admin-detail-status-control");
    const statusChangeButton = document.querySelector(".admin-detail-status-change");
    const statusCancelButton = document.querySelector(".admin-detail-status-section .admin-btn.light");
    const statusReason = document.querySelector(".admin-detail-status-reason");
    const memoContent = document.querySelector(".admin-detail-memo:not([data-admin-memo-ignore='true']):not(.admin-detail-status-reason)");
    const memoSaveButton = memoContent
        ? memoContent.closest(".admin-detail-manage-section").querySelector(".admin-detail-section-actions .admin-btn")
        : null;

    const config = options || {};
    const statusLabels = config.statusLabels || {};
    let selectedId = null;
    let selectedStatus = "";
    let selectedRow = null;

    function statusLabel(status) {
        const key = String(status || "").toUpperCase();
        return statusLabels[key] || (status ? "알 수 없음" : "없음");
    }

    function renderStatus(status) {
        const statusText = String(status || "");
        const label = statusLabel(statusText);

        selectedStatus = statusText;

        if (statusControl) {
            statusControl.value = statusText;
        }

        if (statusChangeButton) {
            statusChangeButton.disabled = true;
        }

        if (config.statusBadgeId) {
            setDetailStatusBadge(config.statusBadgeId, statusText, label);
        }

        setText("status", label);

        if (selectedRow) {
            const rowStatus = selectedRow.querySelector(".admin-status");

            if (rowStatus) {
                rowStatus.className = "admin-status " + statusText.toLowerCase();
                rowStatus.textContent = label;
            }
        }
    }

    if (statusControl && statusChangeButton && config.statusUrl) {
        statusChangeButton.disabled = true;

        statusControl.addEventListener("change", () => {
            statusChangeButton.disabled = statusControl.value === selectedStatus;
        });

        statusChangeButton.addEventListener("click", () => {
            if (!selectedId) {
                return;
            }

            fetch(config.statusUrl, {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: encodeURIComponent(config.idParam) + "=" + encodeURIComponent(selectedId)
                    + "&status=" + encodeURIComponent(statusControl.value)
                    + "&memo=" + encodeURIComponent(statusReason ? statusReason.value : "")
            })
            .then(res => res.json())
            .then(data => {
                if (!data.success) {
                    alert(data.message || "상태 변경에 실패했습니다.");
                    return;
                }

                renderStatus(data.status || statusControl.value);
                loadAdminActionLogs(config.targetType, selectedId);

                if (statusReason) {
                    statusReason.value = "";
                }
            });
        });
    }

    if (statusCancelButton && statusControl) {
        statusCancelButton.addEventListener("click", () => {
            statusControl.value = selectedStatus;

            if (statusChangeButton) {
                statusChangeButton.disabled = true;
            }

            if (statusReason) {
                statusReason.value = "";
            }
        });
    }

    if (memoSaveButton && memoContent) {
        memoSaveButton.addEventListener("click", () => {
            if (!selectedId || !config.targetType) {
                return;
            }

            fetch("/admin/memos", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: "target_type=" + encodeURIComponent(config.targetType)
                    + "&target_id=" + encodeURIComponent(selectedId)
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

    return {
        setTarget(id, status, row) {
            selectedId = id;
            selectedRow = row || null;

            if (statusControl && status != null) {
                renderStatus(status);
            }

            if (memoContent && config.targetType) {
                loadAdminDetailMemo(config.targetType, id, memoContent);
            }

            if (config.targetType) {
                loadAdminActionLogs(config.targetType, id);
            }

            if (statusReason) {
                statusReason.value = "";
            }
        }
    };
}

// 상세 검색 조건 창이 열려있고 상세 검색 버튼이 활성화되어 있으면
// 상세 검색 조건 창을 닫고 상세 검색 버튼을 비활성화
function closeAdminAdvancedFilters() {
    const openFilter = document.querySelector(".admin-filter-detail-row.is-open");
    const openToggle = document.querySelector(".admin-filter-toggle.is-open");

    if (!openFilter && !openToggle) {
        return false;
    }

    if (openFilter) {
        openFilter.classList.remove("is-open");
    }

    if (openToggle) {
        openToggle.classList.remove("is-open");
    }

    return true;
}

// 상세 패널 닫기(상세 패널의 닫기 버튼이나 ESC버튼을 통해 실행)
// (master 요소와 선택된 행을 찾아 closeDetailPanel 실행)
function closeSelectedDetailPanel() {
    const master = document.getElementById("adminMasterDetail");

    if (!master || master.classList.contains("is-collapsed")) {
        return false;
    }

    closeDetailPanel(master, master.querySelector(".admin-clickable-row.selected"));

    return true;
}

// 검색어 강조 효과(하이라이트) 삭제
function clearAdminKeywordHighlight(root) {
    if (!root) {
        return;
    }

    root.querySelectorAll("mark.admin-highlight").forEach((mark) => {
        mark.replaceWith(document.createTextNode(mark.textContent));
    });
}

// 검색어 강조 효과(하이라이트) 부여
function highlightAdminKeyword(root = document) {
    if (!root) {
        return;
    }

    const keywordInput = document.getElementById("keyword");
    const keyword = keywordInput ? keywordInput.value.trim() : "";
    // targets : 강조할 대상 영역
    const targets = root.querySelectorAll(".admin-highlight-target");

    clearAdminKeywordHighlight(root);

    if (!keyword || !targets.length) {
        return;
    }

    const keywordLower = keyword.toLowerCase();

    targets.forEach((target) => {
        const text = target.textContent;
        const textLower = text.toLowerCase();

        // 태그를 만들기 위한 fragment(조립)
        const fragment = document.createDocumentFragment();
        let cursor = 0;
        // 강조 영역의 텍스트에서 검색어 위치 찾기
        let matchIndex = textLower.indexOf(keywordLower);

        // matchIndex가 -1이면 존재하지 않아서 return;
        if (matchIndex === -1) {
            return;
        }

        // matchIndex가 -1이 아니면(강조할 영역에서 강조할 텍스트를 찾으면)
        // -1일 때까지 반복(여러 번 발견할 수 있으니)
        while (matchIndex !== -1) {
            // 강조할 영역의 텍스트에서 cursor(0)부터 강조할 텍스트 위치까지 잘라서
            // 일반 텍스트로 fragment에 추가
            fragment.appendChild(document.createTextNode(text.slice(cursor, matchIndex)));

            // mark라는 태그에 text의 강조할 텍스트를 넣고 fragment에 추가
            const mark = document.createElement("mark");
            mark.className = "admin-highlight";
            mark.textContent = text.slice(matchIndex, matchIndex + keyword.length);
            fragment.appendChild(mark);

            // 강조할 텍스트의 다음 위치로 matchIndex를 변경하고
            // while문을 통해 다음 강조할 텍스트 찾기
            cursor = matchIndex + keyword.length;
            matchIndex = textLower.indexOf(keywordLower, cursor);
        }

        //강조할 텍스트 이후에 글자를 fragment에 추가
        fragment.appendChild(document.createTextNode(text.slice(cursor)));

        //강조할 텍스트 영역에 fragment(문자조립)을 추가
        target.replaceChildren(fragment);
    });
}

// 상세 패널의 닫기 버튼을 눌렀을 때 상세 패널 닫기 이벤트 부여
document.addEventListener("DOMContentLoaded", () => {
    const closeButtons = document.querySelectorAll(".admin-detail-close");

    if (!closeButtons.length) {
        return;
    }

    closeButtons.forEach((closeButton) => {
        closeButton.addEventListener("click", () => {
            closeSelectedDetailPanel();
        });
    });
});

// 상세 검색 조건 창, 상세 검색 버튼 누르면 보이고 닫히는 토글 이벤트 부여
document.addEventListener("DOMContentLoaded", () => {
    const filter = document.querySelector(".admin-filter-detail-row");
    const toggle = document.querySelector(".admin-filter-toggle");

    if (!toggle || !filter) {
        return;
    }

    toggle.addEventListener("click", () => {
        const isOpen = filter.classList.toggle("is-open");

        toggle.classList.toggle("is-open", isOpen);
    });
});

// 상세 패널 정보/관리 탭 전환 이벤트 부여(확인필요)
document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll(".admin-detail-tab").forEach((tab) => {
        tab.addEventListener("click", () => {
            const detailPanel = tab.closest(".admin-detail-panel");
            const tabName = tab.dataset.detailTab;

            if (!detailPanel || !tabName) {
                return;
            }

            detailPanel.querySelectorAll(".admin-detail-tab").forEach((item) => {
                item.classList.toggle("active", item === tab);
            });

            detailPanel.querySelectorAll(".admin-detail-tab-panel").forEach((panel) => {
                panel.classList.toggle("active", panel.dataset.detailPanel === tabName);
            });
        });
    });
});

// html 호출 이후에 키워드 하이라이트 강조
document.addEventListener("DOMContentLoaded", () => {
    highlightAdminKeyword();
});

document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll(".admin-clickable-row[data-href]").forEach((row) => {
        row.addEventListener("click", (event) => {
            if (event.target.closest("a, button, input, select, textarea")) {
                return;
            }

            const href = row.dataset.href;

            if (href) {
                window.location.href = href;
            }
        });
    });
});

// 페이지 수 변경 SELECT가 변경시 page를 1로 변경후 submit
document.addEventListener("DOMContentLoaded", () => {
    const pageSize = document.getElementById("pageSize");

    if (!pageSize) {
        return;
    }

    pageSize.addEventListener("change", () => {

        const form = pageSize.closest("form");

        if (!form) {
            return;
        }

        const pageInput = form.querySelector("input[name='page']");

        if (pageInput) {
            pageInput.value = "1";
        }

        form.submit();
    });
});

// 조회 수 변경 SELECT가 변경시 page를 1로 변경후 submit
document.addEventListener("DOMContentLoaded", () => {
    const sort = document.getElementById("sort");

    if (!sort) {
        return;
    }

    sort.addEventListener("change", () => {

        const form = sort.closest("form");

        if (!form) {
            return;
        }

        const pageInput = form.querySelector("input[name='page']");

        if (pageInput) {
            pageInput.value = "1";
        }

        form.submit();
    });
});

// ESC를 눌렀을 때 상세패널 -> 상세 검색 순으로 닫기
document.addEventListener("keydown", (event) => {
    if (event.key !== "Escape" || event.isComposing) {
        return;
    }

    if (closeAdminAdvancedFilters()) {
        event.preventDefault();
        return;
    }

    if (closeSelectedDetailPanel()) {
        event.preventDefault();
    }

});
