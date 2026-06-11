window.addEventListener("load", function () {
    initBestCategoryActive();
});

function initBestCategoryActive() {
    const navLinks = document.querySelectorAll(".best-category-inner a");
    const sections = document.querySelectorAll(".best-category-section");

    if (navLinks.length === 0) {
        return;
    }

    let clickMoving = false;
    let clickTimer = null;

    function removeActive() {
        navLinks.forEach(function (link) {
            link.classList.remove("active");
        });
    }

    function setActiveLink(targetHref) {
        removeActive();

        const activeLink = document.querySelector('.best-category-inner a[href="' + targetHref + '"]');

        if (activeLink != null) {
            activeLink.classList.add("active");
        }
    }

    navLinks.forEach(function (link) {
        link.addEventListener("click", function () {
            const targetHref = link.getAttribute("href");

            setActiveLink(targetHref);

            clickMoving = true;

            if (clickTimer != null) {
                clearTimeout(clickTimer);
            }

            clickTimer = setTimeout(function () {
                clickMoving = false;
            }, 1000);
        });
    });

    function changeActiveByScroll() {
        if (clickMoving) {
            return;
        }

        if (window.scrollY < 80) {
            setActiveLink("#bestTop");
            return;
        }

        let currentHref = "#bestTop";

        /*
            기존보다 크게 잡아야 함.반려동물처럼 섹션 시작 위치가 살짝 아래에 멈추면 이전 카테고리인 공예가 active 되는 문제가 생김.
        */
        const checkPoint = 360;

        sections.forEach(function (section) {
            const sectionTop = section.getBoundingClientRect().top;

            if (sectionTop <= checkPoint) {
                currentHref = "#" + section.id;
            }
        });

        setActiveLink(currentHref);
    }

    window.addEventListener("scroll", changeActiveByScroll);

    changeActiveByScroll();
}