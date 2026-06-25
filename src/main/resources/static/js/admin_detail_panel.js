function setupAdminDetailPanel(options) {
    options = options || {};

    const master = document.getElementById('adminMasterDetail');
    const panel = document.getElementById('adminDetailPanel');

    if (!master || !panel) {
        return;
    }

    const content = panel.querySelector('.admin-detail-content');
    const rows = master.querySelectorAll('.admin-clickable-row');
    const buttons = master.querySelectorAll('.admin-detail-btn');
    const closeButtons = panel.querySelectorAll('.admin-detail-close');
    const fields = options.fields || {};
    const onOpen = options.onOpen;

    //마스터 패널에 클래스 추가(접혀짐)
    function setCollapsed(collapsed) {
        master.classList.toggle('is-collapsed', collapsed);
    }

    //아이디로 태그 찾아서 내부에 문자 넣기
    function setText(id, value) {
        const target = document.getElementById(id);
        const text = value == null ? '' : String(value);

        if (target) {
            target.textContent = text.trim() ? text : '-';
        }
    }

    //모든 행에 선택 클래스 제거
    function clearSelectedRows() {
        rows.forEach(function(row) {
            row.classList.remove('selected');
        });
    }

    //상세페이지 닫기
    function closeDetail() {
        panel.classList.remove('has-selection');

        if (content) {
            content.hidden = true;
        }

        setCollapsed(true);
        clearSelectedRows();
    }

    //상세페이지 열기
    function openDetail(row) {
        //이미 열려있는 행을 눌렀을 때 닫기
        if (row.classList.contains('selected') && !master.classList.contains('is-collapsed')) {
            closeDetail();
            return;
        }

        if (typeof onOpen === 'function') {
            onOpen(row);
        } else {
            Object.keys(fields).forEach(function(targetId) {
                setText(targetId, row.dataset[fields[targetId]]);
            });
        }

        clearSelectedRows();
        row.classList.add('selected');

        setCollapsed(false);
        panel.classList.add('has-selection');

        if (content) {
            content.hidden = false;
        }
    }

    //행을 눌렀을 때 상세페이지 열리는 이벤트 부여
    rows.forEach(function(row) {
        row.addEventListener('click', function() {
            openDetail(row);
        });
    });

    //상세 버튼을 눌렀을 때 상세페이지 여리는 이벤트 부여
    buttons.forEach(function(button) {
        button.addEventListener('click', function(event) {
            event.stopPropagation();
            const row = button.closest('.admin-clickable-row');

            if (row) {
                openDetail(row);
            }
        });
    });

    //닫기 버튼 이벤트 부여
    closeButtons.forEach(function(button) {
        button.addEventListener('click', closeDetail);
    });

    //ESC누르면 상세페이지 닫히게
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape' && panel.classList.contains('has-selection')) {
            closeDetail();
        }
    });
}
