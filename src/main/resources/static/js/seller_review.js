document.getElementById("productFilter").addEventListener("change", function () {
        const selectedProductId = this.value;
        const reviewCards = document.querySelectorAll(".seller-review-card");

        reviewCards.forEach(function (card) {
            const cardProductId = card.dataset.productId;

            if (selectedProductId === "all" || selectedProductId === cardProductId) {
                card.style.display = "block";
            } else {
                card.style.display = "none";
            }
        });
    });

    // 리뷰 신고
    document.querySelectorAll(".review-report-btn").forEach(function (btn) {
        btn.addEventListener("click", function () {
            const reviewId = this.dataset.reviewId;

            const reason = prompt("신고 사유를 입력하세요.");

            if (reason === null || reason.trim() === "") {
                return;
            }

            const params = new URLSearchParams();
            params.append("review_id", reviewId);
            params.append("reason", reason);

            fetch("/seller_review_report.do", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
                },
                body: params
            })
            .then(function (res) {
                return res.json();
            })
            .then(function (data) {
                if (data.result === "success") {
                    alert("리뷰 신고가 접수되었습니다.");
                } else if (data.result === "duplicate") {
                    alert("이미 신고한 리뷰입니다.");
                } else {
                    alert("신고 처리 중 오류가 발생했습니다.");
                }
            })
            .catch(function () {
                alert("서버 오류가 발생했습니다.");
            });
        });
    });