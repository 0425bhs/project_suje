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
    const text = value == null ? "" : String(value);

    target.textContent = text.trim() ? text : "-";
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

function clearAdminKeywordHighlight(root) {
    if (!root) {
        return;
    }

    root.querySelectorAll("mark.admin-highlight").forEach((mark) => {
        mark.replaceWith(document.createTextNode(mark.textContent));
    });
}

function highlightAdminKeyword(root = document) {
    if (!root) {
        return;
    }

    const keywordInput = document.querySelector(".admin-filter-modern .admin-search[name='keyword']");
    const keyword = keywordInput ? keywordInput.value.trim() : "";
    const targets = [
        ...(root.matches && root.matches(".admin-highlight-target") ? [root] : []),
        ...root.querySelectorAll(".admin-highlight-target")
    ];

    clearAdminKeywordHighlight(root);

    if (!keyword || !targets.length) {
        return;
    }

    const keywordLower = keyword.toLowerCase();

    targets.forEach((target) => {
        const walker = document.createTreeWalker(target, NodeFilter.SHOW_TEXT, {
            acceptNode(node) {
                const parent = node.parentElement;

                if (!node.nodeValue.trim() || !parent || parent.closest("mark")) {
                    return NodeFilter.FILTER_REJECT;
                }

                return node.nodeValue.toLowerCase().includes(keywordLower)
                    ? NodeFilter.FILTER_ACCEPT
                    : NodeFilter.FILTER_REJECT;
            }
        });
        const matchedNodes = [];

        while (walker.nextNode()) {
            matchedNodes.push(walker.currentNode);
        }

        matchedNodes.forEach((node) => {
            const text = node.nodeValue;
            const textLower = text.toLowerCase();
            const fragment = document.createDocumentFragment();
            let cursor = 0;
            let matchIndex = textLower.indexOf(keywordLower, cursor);

            while (matchIndex !== -1) {
                if (matchIndex > cursor) {
                    fragment.appendChild(document.createTextNode(text.slice(cursor, matchIndex)));
                }

                const mark = document.createElement("mark");
                mark.className = "admin-highlight";
                mark.textContent = text.slice(matchIndex, matchIndex + keyword.length);
                fragment.appendChild(mark);

                cursor = matchIndex + keyword.length;
                matchIndex = textLower.indexOf(keywordLower, cursor);
            }

            if (cursor < text.length) {
                fragment.appendChild(document.createTextNode(text.slice(cursor)));
            }

            node.parentNode.replaceChild(fragment, node);
        });
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

document.addEventListener("DOMContentLoaded", () => {
    highlightAdminKeyword();
});

document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll("[data-auto-submit='true']").forEach((control) => {
        control.addEventListener("change", () => {
            const form = control.closest("form");

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
});

// ESC를 눌렀을 때 상세패널 -> 상세 검색 순으로 닫기
document.addEventListener("keydown", (event) => {
    if (event.key !== "Escape" || event.isComposing) {
        return;
    }

    if (closeSelectedDetailPanel()) {
        event.preventDefault();
        return;
    }

    if (closeAdminAdvancedFilters()) {
        event.preventDefault();
    }
});
