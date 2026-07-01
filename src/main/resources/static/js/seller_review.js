document.addEventListener("DOMContentLoaded", function(){

    const productFilter = document.getElementById("productFilter");
    const tabs = document.querySelectorAll(".review-tab");
    const reviewCards = document.querySelectorAll(".seller-review-card");

    let currentTab = "all";

    updateReviewCounts();
    applyFilter();
    bindReplyButtons();

    initReviewContentToggle();
    initReviewImageModal();

    if(productFilter != null){
        productFilter.addEventListener("change", function(){
            applyFilter();
        });
    }

    tabs.forEach(function(tab){
        tab.addEventListener("click", function(){
            tabs.forEach(function(item){
                item.classList.remove("active");
            });

            this.classList.add("active");
            currentTab = this.dataset.tab;

            applyFilter();
        });
    });

    function applyFilter(){
        const selectedProductId = productFilter == null ? "all" : productFilter.value;

        reviewCards.forEach(function(card){
            const cardProductId = card.dataset.productId;
            const isReplied = card.dataset.replied === "true";
            const hasPhoto = card.dataset.hasPhoto === "true";

            let productMatched = selectedProductId === "all" || selectedProductId === cardProductId;
            let tabMatched = true;

            if(currentTab === "waiting"){
                tabMatched = !isReplied;
            }

            if(currentTab === "completed"){
                tabMatched = isReplied;
            }

            if(currentTab === "photo"){
                tabMatched = hasPhoto;
            }

            if(productMatched && tabMatched){
                card.style.display = "block";
            } else {
                card.style.display = "none";
            }
        });
    }

    function updateReviewCounts(){
        let totalCount = reviewCards.length;
        let waitingCount = 0;
        let completedCount = 0;
        let photoCount = 0;

        reviewCards.forEach(function(card){
            const isReplied = card.dataset.replied === "true";
            const hasPhoto = card.dataset.hasPhoto === "true";

            if(isReplied){
                completedCount++;
            } else {
                waitingCount++;
            }

            if(hasPhoto){
                photoCount++;
            }
        });

        setText("totalReviewCount", totalCount + "개");
        setText("waitingReviewCount", waitingCount);
        setText("completedReviewCount", completedCount);
        setText("photoReviewCount", photoCount);

        setText("waitingTabCount", "(" + waitingCount + ")");
        setText("completedTabCount", "(" + completedCount + ")");
        setText("photoTabCount", "(" + photoCount + ")");
    }

    function setText(id, value){
        const target = document.getElementById(id);

        if(target != null){
            target.textContent = value;
        }
    }

    function bindReplyButtons(){

        // 답글 작성 / 답글 수정 버튼
        document.querySelectorAll(".reply-write-btn").forEach(function(btn){
            btn.addEventListener("click", function(){
                const reviewId = this.dataset.reviewId;

                const view = document.getElementById("replyView-" + reviewId);
                const form = document.getElementById("replyForm-" + reviewId);
                const textarea = document.getElementById("replyContent-" + reviewId);

                if(form == null){
                    alert("답글 입력 폼을 찾을 수 없습니다.");
                    return;
                }

                if(view != null){
                    view.style.display = "none";
                }

                form.style.display = "block";

                if(textarea != null){
                    textarea.focus();
                }
            });
        });

        // 취소 버튼
        document.querySelectorAll(".reply-cancel-btn").forEach(function(btn){
            btn.addEventListener("click", function(){
                const reviewId = this.dataset.reviewId;

                const view = document.getElementById("replyView-" + reviewId);
                const form = document.getElementById("replyForm-" + reviewId);

                if(form != null){
                    form.style.display = "none";
                }

                if(view != null){
                    view.style.display = "block";
                }
            });
        });

        // 등록 버튼
        document.querySelectorAll(".reply-submit-btn").forEach(function(btn){
            btn.addEventListener("click", function(){
                const reviewId = this.dataset.reviewId;
                const textarea = document.getElementById("replyContent-" + reviewId);

                if(textarea == null){
                    alert("답글 입력창을 찾을 수 없습니다.");
                    return;
                }

                const replyContent = textarea.value.trim();

                if(replyContent === ""){
                    alert("답글 내용을 입력하세요.");
                    textarea.focus();
                    return;
                }

                fetch("/seller_review_reply.do", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
                    },
                    body: new URLSearchParams({
                        review_id: reviewId,
                        reply_content: replyContent
                    })
                })
                .then(function(response){
                    if(!response.ok){
                        throw new Error("서버 응답 오류");
                    }

                    return response.json();
                })
                .then(function(data){
                    if(data.result === "success"){
                        alert("답글이 등록되었습니다.");
                        location.reload();
                    } else if(data.result === "login"){
                        alert("로그인이 필요합니다.");
                        location.href = "/login.do";
                    } else if(data.result === "empty"){
                        alert("답글 내용을 입력하세요.");
                    } else {
                        alert("답글 등록에 실패했습니다.");
                    }
                })
                .catch(function(error){
                    console.error(error);
                    alert("답글 등록 중 오류가 발생했습니다.");
                });
            });
        });
    }

    function initReviewContentToggle(){
        const reviewContents = document.querySelectorAll(".js-review-content");

        reviewContents.forEach(function(content){
            const toggleBtn = content.nextElementSibling;

            if(toggleBtn == null || !toggleBtn.classList.contains("review-toggle-btn")){
                return;
            }

            const limitHeight = 150;

            if(content.scrollHeight > limitHeight){
                content.classList.add("is-collapsed");
                toggleBtn.style.display = "inline-flex";
            }

            toggleBtn.addEventListener("click", function(){
                const isCollapsed = content.classList.contains("is-collapsed");

                if(isCollapsed){
                    content.classList.remove("is-collapsed");
                    toggleBtn.innerHTML = '접어보기 <i class="bi bi-chevron-up"></i>';
                } else {
                    content.classList.add("is-collapsed");
                    toggleBtn.innerHTML = '펼쳐보기 <i class="bi bi-chevron-down"></i>';
                }
            });
        });
    }

    function initReviewImageModal(){
        const modal = document.getElementById("reviewImageModal");
        const modalImg = document.getElementById("reviewImageModalImg");
        const counter = document.getElementById("reviewImageCounter");
        const closeBtn = document.getElementById("reviewImageModalClose");
        const prevBtn = document.getElementById("reviewImagePrev");
        const nextBtn = document.getElementById("reviewImageNext");

        if(modal == null || modalImg == null || counter == null || closeBtn == null || prevBtn == null || nextBtn == null){
            return;
        }

        let currentImages = [];
        let currentIndex = 0;

        document.querySelectorAll(".review-photo-item").forEach(function(button){
            button.addEventListener("click", function(){
                const reviewId = this.dataset.reviewId;
                const startIndex = Number(this.dataset.imgIndex);

                currentImages = getReviewImages(reviewId);
                currentIndex = startIndex;

                openReviewImageModal();
            });
        });

        closeBtn.addEventListener("click", closeReviewImageModal);

        const dim = modal.querySelector(".review-image-modal-dim");

        if(dim != null){
            dim.addEventListener("click", closeReviewImageModal);
        }

        prevBtn.addEventListener("click", function(){
            if(currentIndex <= 0){
                return;
            }

            currentIndex--;
            renderReviewImage();
        });

        nextBtn.addEventListener("click", function(){
            if(currentIndex >= currentImages.length - 1){
                return;
            }

            currentIndex++;
            renderReviewImage();
        });

        document.addEventListener("keydown", function(event){
            if(!modal.classList.contains("active")){
                return;
            }

            if(event.key === "Escape"){
                closeReviewImageModal();
            }

            if(event.key === "ArrowLeft"){
                prevBtn.click();
            }

            if(event.key === "ArrowRight"){
                nextBtn.click();
            }
        });

        function getReviewImages(reviewId){
            const dataList = document.querySelectorAll(
                '.review-modal-data[data-review-id="' + reviewId + '"]'
            );

            return Array.from(dataList)
                .sort(function(a, b){
                    return Number(a.dataset.imgIndex) - Number(b.dataset.imgIndex);
                })
                .map(function(item){
                    return item.dataset.imgUrl;
                });
        }

        function openReviewImageModal(){
            if(currentImages.length === 0){
                return;
            }

            modal.classList.add("active");
            document.body.style.overflow = "hidden";

            renderReviewImage();
        }

        function closeReviewImageModal(){
            modal.classList.remove("active");
            document.body.style.overflow = "";
            modalImg.src = "";
        }

        function renderReviewImage(){
            modalImg.src = currentImages[currentIndex];
            counter.textContent = (currentIndex + 1) + " / " + currentImages.length;

            prevBtn.disabled = currentIndex === 0;
            nextBtn.disabled = currentIndex === currentImages.length - 1;
        }
    }

});