function openDetailPanel(master, rows, row) {
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

document.addEventListener("DOMContentLoaded", () => {
    const master = document.getElementById("adminMasterDetail");
    const closeButton = document.querySelector(".admin-detail-close");

    if (!master || !closeButton) {
        return;
    }

    closeButton.addEventListener("click", () => {
        const selectedRow = master.querySelector(".admin-clickable-row.selected");

        master.classList.add("is-collapsed");

        if (selectedRow) {
            selectedRow.classList.remove("selected");
        }
    });
});
