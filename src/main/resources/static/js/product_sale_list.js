
// 페이지 로딩
window.addEventListener("load", function () {
    updateSaleCountdown();
    setInterval(updateSaleCountdown, 1000); //타이머를 바로 한 번 계산해서 화면에 보여줘.

    initSaleFeatureSlider(); // 1초 마다 타이머를 다시 계산
});


function updateSaleCountdown() { //타이머 함수
    const saleHour = document.getElementById("saleHour");
    const saleMinute = document.getElementById("saleMinute");
    const saleSecond = document.getElementById("saleSecond");

    if (saleHour == null || saleMinute == null || saleSecond == null) {
        return;
    }

    const now = new Date();
    const end = new Date();

    end.setHours(23, 59, 59, 999);

    const diff = end - now;

    if (diff <= 0) {
        saleHour.innerText = "00";
        saleMinute.innerText = "00";
        saleSecond.innerText = "00";
        return;
    }

    const hour = Math.floor(diff / (1000 * 60 * 60));
    const minute = Math.floor((diff / (1000 * 60)) % 60);
    const second = Math.floor((diff / 1000) % 60);

    saleHour.innerText = String(hour).padStart(2, "0");
    saleMinute.innerText = String(minute).padStart(2, "0");
    saleSecond.innerText = String(second).padStart(2, "0");
}


//슬라이드 초기 설정
function initSaleFeatureSlider() {
    const track = document.getElementById("saleFeatureTrack");
    const prevBtn = document.getElementById("salePrevBtn");
    const nextBtn = document.getElementById("saleNextBtn");
    const dotsBox = document.getElementById("saleFeatureDots");

    if (!track || !prevBtn || !nextBtn || !dotsBox) {
        return;
    }


    //상품 카드
    const cards = track.querySelectorAll(".sale-feature-card");

    //상품이 없으면 버튼이랑 점을 숨김
    if (cards.length === 0) {
        prevBtn.style.display = "none";
        nextBtn.style.display = "none";
        dotsBox.style.display = "none";
        return;
    }

    let currentIndex = 0;

    //화면 크기별 몇 개 보여줄지
    function getViewCount() {
        if (window.innerWidth <= 900) return 2;
        if (window.innerWidth <= 1200) return 4;
        return 5;
    }

    function getGap() {
        return 14;
    }

    function getMaxIndex() {
        const viewCount = getViewCount();
        const max = cards.length - viewCount;
        return max > 0 ? max : 0;
    }

    function renderDots() {
        dotsBox.innerHTML = "";

        const maxIndex = getMaxIndex();

        if (maxIndex === 0) {
            dotsBox.style.display = "none";
            return;
        }

        dotsBox.style.display = "flex";

        for (let i = 0; i <= maxIndex; i++) {
            const dot = document.createElement("span");

            if (i === currentIndex) {
                dot.classList.add("active");
            }

            dot.addEventListener("click", function () {
                currentIndex = i;
                moveSlider();
            });

            dotsBox.appendChild(dot);
        }
    }

    function moveSlider() {
        const maxIndex = getMaxIndex();

        if (currentIndex < 0) currentIndex = 0;
        if (currentIndex > maxIndex) currentIndex = maxIndex;

        const cardWidth = cards[0].offsetWidth;
        const moveX = currentIndex * (cardWidth + getGap());

        track.style.transform = "translateX(-" + moveX + "px)";

        prevBtn.classList.toggle("disabled", currentIndex === 0);
        nextBtn.classList.toggle("disabled", currentIndex === maxIndex);

        if (maxIndex === 0) {
            prevBtn.style.display = "none";
            nextBtn.style.display = "none";
        } else {
            prevBtn.style.display = "flex";
            nextBtn.style.display = "flex";
        }

        const dots = dotsBox.querySelectorAll("span");
        dots.forEach(function (dot, index) {
            dot.classList.toggle("active", index === currentIndex);
        });
    }

    prevBtn.addEventListener("click", function () {
        if (currentIndex > 0) {
            currentIndex--;
            moveSlider();
        }
    });

    nextBtn.addEventListener("click", function () {
        if (currentIndex < getMaxIndex()) {
            currentIndex++;
            moveSlider();
        }
    });

    window.addEventListener("resize", function () {
        if (currentIndex > getMaxIndex()) {
            currentIndex = getMaxIndex();
        }
        renderDots();
        moveSlider();
    });

    renderDots();
    moveSlider();
}