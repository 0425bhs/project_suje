document.addEventListener("DOMContentLoaded", function(){

    const productFilter = document.getElementById("productFilter");
    const tabs = document.querySelectorAll(".review-tab");

    const reportModal = document.getElementById("reviewReportModal");
    const reportReviewId = document.getElementById("reportReviewId");
    const reportType = document.getElementById("reviewReportType");
    const reportReason = document.getElementById("reviewReportReason");

    bindServerReviewFilter();
    bindReplyButtons();

    initReviewContentToggle();
    initReviewImageModal();
    bindReviewReportModal();

    function bindServerReviewFilter(){

        if(productFilter != null){

            productFilter.addEventListener("change", function(){

                const params =
                    new URLSearchParams(window.location.search);

                const productId = this.value;

                if(productId === ""){
                    params.delete("product_id");
                } else {
                    params.set("product_id", productId);
                }

                params.set("page", "1");

                if(!params.has("tab")){
                    params.set("tab", "all");
                }

                window.location.href =
                    "/seller_review_list.do?" + params.toString();
            });
        }


        // 전체 / 답글 대기 / 답글 완료 / 사진 리뷰 탭
        tabs.forEach(function(tab){

            tab.addEventListener("click", function(){

                const params =
                    new URLSearchParams(window.location.search);

                params.set("tab", this.dataset.tab);

                params.set("page", "1");

                window.location.href =
                    "/seller_review_list.do?" + params.toString();
            });
        });
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

    function bindReviewReportModal(){
        document.querySelectorAll(".review-report-btn").forEach(function(btn){
            btn.addEventListener("click", function(event){
                event.preventDefault();
                event.stopPropagation();

                const reviewId = this.dataset.targetId || this.dataset.reviewId || "";

                if(reportReviewId != null){
                    reportReviewId.value = reviewId;
                }

                if(reportType != null){
                    reportType.value = "";
                }

                if(reportReason != null){
                    reportReason.value = "";
                }

                openReviewReportModal();
            });
        });

        document.querySelectorAll(".review-report-close-btn, .review-report-cancel-btn").forEach(function(btn){
            btn.addEventListener("click", function(){
                closeReviewReportModal();
            });
        });

        const submitBtn = document.querySelector(".review-report-submit-btn");

        if(submitBtn != null){
            submitBtn.addEventListener("click", function(){
                submitReviewReport();
            });
        }

        if(reportModal != null){
            reportModal.addEventListener("click", function(event){
                if(event.target === reportModal){
                    closeReviewReportModal();
                }
            });
        }

        window.addEventListener("keydown", function(event){
            if(event.key === "Escape"){
                closeReviewReportModal();
            }
        });
    }

    function openReviewReportModal(){
        if(reportModal != null){
            reportModal.classList.add("active");
            reportModal.classList.add("open");
        }
    }

    function closeReviewReportModal(){
        if(reportModal != null){
            reportModal.classList.remove("active");
            reportModal.classList.remove("open");
        }
    }

    function submitReviewReport(){
        if(reportReviewId == null || reportType == null || reportReason == null){
            alert("신고 정보를 찾을 수 없습니다.");
            return;
        }

        const reviewId = reportReviewId.value.trim();
        const type = reportType.value.trim();
        const reason = reportReason.value.trim();

        if(reviewId === ""){
            alert("리뷰 정보를 찾을 수 없습니다.");
            return;
        }

        if(type === ""){
            alert("신고 사유를 선택해주세요.");
            reportType.focus();
            return;
        }

        if(reason === ""){
            alert("신고 내용을 입력해주세요.");
            reportReason.focus();
            return;
        }

        fetch("/report.do", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
            },
            body: new URLSearchParams({
                target_type: "REVIEW",
                target_id: reviewId,
                report_type: type,
                reason: reason
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
                alert("신고가 접수되었습니다.");
                closeReviewReportModal();
            } else if(data.result === "login"){
                alert("로그인이 필요합니다.");
                location.href = "/login.do";
            } else if(data.result === "empty"){
                alert("신고 사유와 내용을 입력해주세요.");
            } else {
                alert("신고 접수에 실패했습니다.");
            }
        })
    }

});