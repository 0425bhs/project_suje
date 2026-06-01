window.onload = function () {

    const sideTitles = document.querySelectorAll(".category-side-title");

    sideTitles.forEach(function (title) {
        title.addEventListener("click", function () {

            const group = this.closest(".category-side-group");
            const sub = group.querySelector(".category-side-sub");

            if (sub == null) {
                return;
            }

            sub.classList.toggle("open");
            this.classList.toggle("active");
        });
    });

};