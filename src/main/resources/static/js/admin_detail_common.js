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

// 검색어 강조 효과(하이라이트) 삭제
function clearAdminKeywordHighlight(root) {
    if (!root) {
        return;
    }

    root.querySelectorAll("mark.admin-highlight").forEach((mark) => {
        mark.target.replaceChildren(fragment);(document.createTextNode(mark.textContent));
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

// html 호출 이후에 키워드 하이라이트 강조
document.addEventListener("DOMContentLoaded", () => {
    highlightAdminKeyword();
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
