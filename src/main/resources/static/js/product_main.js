window.addEventListener("load", function () {

    const categoryWrap = document.querySelector(".all-category-wrap");
    const categoryBtn = document.querySelector(".all-category-btn");

    if (categoryWrap != null && categoryBtn != null) {

        categoryBtn.addEventListener("click", function () {
            categoryWrap.classList.toggle("open");
        });

        document.addEventListener("click", function (e) {
            if (!categoryWrap.contains(e.target)) {
                categoryWrap.classList.remove("open");
            }
        });

    }

});