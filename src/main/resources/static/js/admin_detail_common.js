function openDetailPanel(master, rows, row) {
    //선택한 행에 클래스 부여(모든 행에서 클래스 지우고 선택된 거에 부여)
    rows.forEach((item) => {
        item.classList.remove("selected");
    });
    row.classList.add("selected");

    master.classList.remove("is-collapsed");
}

function closeDetailPanel(master, row) {
    master.classList.add("is-collapsed");
    row.classList.remove("selected");
}

function setText(id, value) {
    const target = document.getElementById(id);
    const text = value == null ? "" : String(value);

    target.textContent = text.trim() ? text : "-";
}