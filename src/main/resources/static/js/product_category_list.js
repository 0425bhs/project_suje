window.onload = function () {
    const categoryButtons = document.querySelectorAll(".category-title-btn");

    categoryButtons.forEach(function (btn) {
        btn.addEventListener("click", function () {
            const group = this.parentElement;

            group.classList.toggle("open");
        });
    });
};