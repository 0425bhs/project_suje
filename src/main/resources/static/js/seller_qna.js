document.addEventListener("DOMContentLoaded", function(){

    const productFilter = document.getElementById("productFilter");
    const qnaTypeFilter = document.getElementById("qnaTypeFilter");
    const qnaSearchInput = document.getElementById("qnaSearchInput");
    const qnaResetBtn = document.getElementById("qnaResetBtn");

    const tabs = document.querySelectorAll(".qna-tab");
    const sortTabs = document.querySelectorAll(".qna-sort-tab");

    const qnaCards = document.querySelectorAll(".qna-list-item, .seller-qna-card");
    const qnaNoResult = document.getElementById("qnaNoResult");

    const reportModal = document.getElementById("qnaReportModal");
    const reportQnaId = document.getElementById("reportQnaId");
    const reportType = document.getElementById("reportType");
    const reportReason = document.getElementById("reportReason");

    const answerForm = document.getElementById("answerForm");
    const answerQnaId = document.getElementById("answerQnaId");
    const answerTextarea = document.getElementById("answerTextarea");
    const answerCount = document.getElementById("answerCount");
    const answerClearBtn = document.getElementById("answerClearBtn");
    const answerSubmitBtn = document.getElementById("answerSubmitBtn");
    const answerModeText = document.getElementById("answerModeText");

    let currentTab = "all";

    updateQnaCounts();
    bindTabs();
    bindFilters();
    bindQnaSelect();
    bindDetailAnswerForm();
    bindSortTabs();
    bindAnswerClear();
    bindAnswerCount();
    bindReportModal();
    applyFilter();

    /*
        탭
    */
    function bindTabs(){
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
    }

    /*
        필터 / 검색 / 초기화
    */
    function bindFilters(){
        if(productFilter != null){
            productFilter.addEventListener("change", function(){
                applyFilter();
            });
        }

        if(qnaTypeFilter != null){
            qnaTypeFilter.addEventListener("change", function(){
                applyFilter();
            });
        }

        if(qnaSearchInput != null){
            qnaSearchInput.addEventListener("input", function(){
                applyFilter();
            });
        }

        if(qnaResetBtn != null){
            qnaResetBtn.addEventListener("click", function(){
                if(productFilter != null){
                    productFilter.value = "all";
                }

                if(qnaTypeFilter != null){
                    qnaTypeFilter.value = "all";
                }

                if(qnaSearchInput != null){
                    qnaSearchInput.value = "";
                }

                tabs.forEach(function(item){
                    item.classList.remove("active");
                });

                const allTab = document.querySelector(".qna-tab[data-tab='all']");

                if(allTab != null){
                    allTab.classList.add("active");
                }

                currentTab = "all";
                applyFilter();
            });
        }
    }

    function bindSortTabs(){
        sortTabs.forEach(function(tab){
            tab.addEventListener("click", function(){
                sortTabs.forEach(function(item){
                    item.classList.remove("active");
                });

                tab.classList.add("active");

                sortQnaList(tab.dataset.sort);
                selectFirstVisibleCard();
            });
        });

        sortQnaList("latest");
    }

    function sortQnaList(sortType){
        const listWrap = document.querySelector(".qna-list-scroll");

        if(listWrap == null){
            return;
        }

        const cards = Array.from(document.querySelectorAll(".qna-list-item"));

        cards.sort(function(a, b){
            const aTime = getQnaTime(a);
            const bTime = getQnaTime(b);

            if(sortType === "oldest"){
                return aTime - bTime;
            }

            return bTime - aTime;
        });

        cards.forEach(function(card){
            listWrap.appendChild(card);
        });
    }

    function getQnaTime(card){
        const rawDate = card.dataset.createdRaw || card.dataset.createdAt || "";

        const time = new Date(rawDate.replace(/\./g, "-")).getTime();

        if(isNaN(time)){
            return 0;
        }

        return time;
    }

    /*
        필터 적용
    */
    function applyFilter(){
        const selectedProductId = productFilter == null ? "all" : productFilter.value;
        const selectedQnaType = qnaTypeFilter == null ? "all" : qnaTypeFilter.value;
        const keyword = qnaSearchInput == null ? "" : qnaSearchInput.value.trim().toLowerCase();

        let visibleCount = 0;

        qnaCards.forEach(function(card){
            const cardProductId = card.dataset.productId;
            const cardQnaType = card.dataset.qnaType;
            const isAnswered = card.dataset.answered === "true";
            const searchText = (card.dataset.searchText || "").toLowerCase();

            let productMatched = selectedProductId === "all" || selectedProductId === cardProductId;
            let typeMatched = selectedQnaType === "all" || selectedQnaType === cardQnaType;
            let keywordMatched = keyword === "" || searchText.includes(keyword);

            let tabMatched = true;

            if(currentTab === "waiting"){
                tabMatched = !isAnswered;
            }

            if(currentTab === "completed"){
                tabMatched = isAnswered;
            }

            const visible = productMatched && typeMatched && keywordMatched && tabMatched;

            if(visible){
                card.classList.remove("qna-hidden");
                card.style.display = "";
                visibleCount++;
            } else {
                card.classList.add("qna-hidden");
                card.style.display = "none";
            }
        });

        if(qnaNoResult != null){
            if(visibleCount === 0 && qnaCards.length > 0){
                qnaNoResult.classList.add("active");
                qnaNoResult.style.display = "block";
            } else {
                qnaNoResult.classList.remove("active");
                qnaNoResult.style.display = "";
            }
        }

        const activeSortTab = document.querySelector(".qna-sort-tab.active");
        const sortType = activeSortTab == null ? "latest" : activeSortTab.dataset.sort;

        sortQnaList(sortType);
        selectFirstVisibleCard();
    }

    /*
        카운트
    */
    function updateQnaCounts(){
        let totalCount = qnaCards.length;
        let waitingCount = 0;
        let completedCount = 0;

        qnaCards.forEach(function(card){
            const isAnswered = card.dataset.answered === "true";

            if(isAnswered){
                completedCount++;
            } else {
                waitingCount++;
            }
        });

        setText("totalQnaCount", totalCount + "개");
        setText("waitingQnaCount", waitingCount + "개");
        setText("completedQnaCount", completedCount + "개");

        setText("allTabCount", "(" + totalCount + ")");
        setText("waitingTabCount", "(" + waitingCount + ")");
        setText("completedTabCount", "(" + completedCount + ")");
    }

    function setText(id, value){
        const target = document.getElementById(id);

        if(target != null){
            target.textContent = value;
        }
    }

    /*
        왼쪽 문의 목록 클릭하면 오른쪽 상세 패널 변경
    */
    function bindQnaSelect(){
        qnaCards.forEach(function(card){
            card.addEventListener("click", function(event){
                /*
                    신고 버튼 클릭 시 상세 선택 방지
                */
                if(event.target.closest(".qna-report-btn") != null){
                    return;
                }

                qnaCards.forEach(function(item){
                    item.classList.remove("active");
                });

                card.classList.add("active");
                updateDetailPanel(card);
            });
        });

        const firstCard = document.querySelector(".qna-list-item.active, .seller-qna-card.active") || qnaCards[0];

        if(firstCard != null){
            firstCard.classList.add("active");
            updateDetailPanel(firstCard);
        }
    }

    function selectFirstVisibleCard(){
        const activeVisibleCard = document.querySelector(".qna-list-item.active:not(.qna-hidden), .seller-qna-card.active:not(.qna-hidden)");

        if(activeVisibleCard != null){
            updateDetailPanel(activeVisibleCard);
            return;
        }

        qnaCards.forEach(function(card){
            card.classList.remove("active");
        });

        const firstVisibleCard = document.querySelector(".qna-list-item:not(.qna-hidden), .seller-qna-card:not(.qna-hidden)");

        if(firstVisibleCard != null){
            firstVisibleCard.classList.add("active");
            updateDetailPanel(firstVisibleCard);
        } else {
            clearDetailPanel();
        }
    }

    /*
        상세 패널 채우기
    */
    function updateDetailPanel(card){
        if(card == null){
            return;
        }

        const qnaId = card.dataset.qnaId || "";
        const productId = card.dataset.productId || "";
        const isAnswered = card.dataset.answered === "true";

        const title = card.dataset.title || getCardTitle(card);
        const productName = card.dataset.productName || getCardProductName(card);
        const optionName = card.dataset.optionName || "";
        const writerName = card.dataset.writerName || getCardWriterName(card);
        const createdAt = card.dataset.createdAt || getCardDate(card);
        const question = card.dataset.question || getCardQuestion(card);
        const answer = card.dataset.answer || getCardAnswer(card);
        const image = card.dataset.image || getCardImage(card);

        const typeText = card.dataset.typeText || getTypeText(card.dataset.qnaType);
        const typeClass = card.dataset.typeClass || getTypeClass(card.dataset.qnaType);

        const detailImage = document.getElementById("detailImage");
        const detailTypeBadge = document.getElementById("detailTypeBadge");
        const detailStatusBadge = document.getElementById("detailStatusBadge");
        const detailTitle = document.getElementById("detailTitle");
        const detailProductName = document.getElementById("detailProductName");
        const detailOptionName = document.getElementById("detailOptionName");
        const detailWriterName = document.getElementById("detailWriterName");
        const detailCreatedAt = document.getElementById("detailCreatedAt");
        const detailQuestionDate = document.getElementById("detailQuestionDate");
        const detailQuestion = document.getElementById("detailQuestion");
        const detailProductLink = document.getElementById("detailProductLink");
        const detailReportBtn = document.getElementById("detailReportBtn");

        if(detailImage != null){
            detailImage.src = image;
        }

        if(detailTypeBadge != null){
            detailTypeBadge.className = "qna-type-badge " + typeClass;
            detailTypeBadge.textContent = typeText;
        }

        if(detailStatusBadge != null){
            if(isAnswered){
                detailStatusBadge.className = "detail-status completed";
                detailStatusBadge.innerHTML = '<i class="bi bi-check-lg"></i> 답변 완료';
            } else {
                detailStatusBadge.className = "detail-status waiting";
                detailStatusBadge.innerHTML = '<i class="bi bi-hourglass-split"></i> 답변 대기';
            }
        }

        if(detailTitle != null){
            detailTitle.textContent = title;
        }

        if(detailProductName != null){
            detailProductName.textContent = productName;
        }

        if(detailOptionName != null){
            if(optionName.trim() !== ""){
                detailOptionName.textContent = "옵션 : " + optionName;
                detailOptionName.style.display = "inline";
            } else {
                detailOptionName.textContent = "";
                detailOptionName.style.display = "none";
            }
        }

        if(detailWriterName != null){
            detailWriterName.textContent = writerName;
        }

        if(detailCreatedAt != null){
            detailCreatedAt.textContent = createdAt;
        }

        if(detailQuestionDate != null){
            detailQuestionDate.textContent = createdAt;
        }

        if(detailQuestion != null){
            detailQuestion.textContent = question;
        }

        if(answerQnaId != null){
            answerQnaId.value = qnaId;
        }

        if(answerTextarea != null){
            answerTextarea.value = answer;
            updateAnswerCount();
        }

        if(answerSubmitBtn != null){
            answerSubmitBtn.textContent = isAnswered ? "답변 수정" : "답변 등록";
        }

        if(answerModeText != null){
            answerModeText.textContent = isAnswered ? "답변 수정" : "답변 등록";
        }

        if(detailProductLink != null){
            detailProductLink.href = "/product_detail.do?product_id=" + productId;
        }

        if(detailReportBtn != null){
            detailReportBtn.dataset.qnaId = qnaId;
        }

        const answerWaitingView = document.getElementById("answerWaitingView");
        const answerCompleteView = document.getElementById("answerCompleteView");
        const detailAnswerText = document.getElementById("detailAnswerText");

        if(detailAnswerText != null){
            detailAnswerText.textContent = answer;
        }

        if(answerForm != null){
            answerForm.classList.remove("active");
        }

        if(answerWaitingView != null){
            answerWaitingView.classList.toggle("hidden", isAnswered);
        }

        if(answerCompleteView != null){
            answerCompleteView.classList.toggle("hidden", !isAnswered);
        }
    }

    function clearDetailPanel(){
        setText("detailTitle", "조건에 맞는 문의가 없습니다.");
        setText("detailProductName", "");
        setText("detailOptionName", "");
        setText("detailWriterName", "");
        setText("detailCreatedAt", "");
        setText("detailQuestionDate", "");
        setText("detailQuestion", "");

        if(answerQnaId != null){
            answerQnaId.value = "";
        }

        if(answerTextarea != null){
            answerTextarea.value = "";
            updateAnswerCount();
        }
    }

    function bindDetailAnswerForm(){
        const writeBtn = document.getElementById("detailAnswerWriteBtn");
        const editBtn = document.getElementById("detailAnswerEditBtn");

        if(writeBtn != null){
            writeBtn.addEventListener("click", function(){
                openDetailAnswerForm(false);
            });
        }

        if(editBtn != null){
            editBtn.addEventListener("click", function(){
                openDetailAnswerForm(true);
            });
        }

        if(answerForm == null){
            return;
        }

        answerForm.addEventListener("submit", function(event){
            event.preventDefault();

            if(answerQnaId == null || answerTextarea == null){
                alert("답변 정보를 찾을 수 없습니다.");
                return;
            }

            submitAnswer(answerQnaId.value, answerTextarea);
        });
    }

    function submitAnswer(qnaId, textarea){
        if(textarea == null){
            alert("답변 입력창을 찾을 수 없습니다.");
            return;
        }

        const answerContent = textarea.value.trim();

        if(qnaId == null || qnaId === ""){
            alert("문의 정보를 찾을 수 없습니다.");
            return;
        }

        if(answerContent === ""){
            alert("답변 내용을 입력하세요.");
            textarea.focus();
            return;
        }

        fetch("/seller_qna_answer.do", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
            },
            body: new URLSearchParams({
                qna_id: qnaId,
                answer: answerContent
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
                alert("답변이 등록되었습니다.");
                location.reload();
            } else if(data.result === "login"){
                alert("로그인이 필요합니다.");
                location.href = "/login.do";
            } else if(data.result === "empty"){
                alert("답변 내용을 입력하세요.");
            } else {
                alert("답변 등록에 실패했습니다.");
            }
        })
        .catch(function(error){
            console.error(error);
            alert("답변 등록 중 오류가 발생했습니다.");
        });
    }

    /*
        답변 글자 수
    */
    function bindAnswerCount(){
        if(answerTextarea == null){
            return;
        }

        answerTextarea.addEventListener("input", function(){
            updateAnswerCount();
        });

        updateAnswerCount();
    }

    function updateAnswerCount(){
        if(answerTextarea == null || answerCount == null){
            return;
        }

        answerCount.textContent = answerTextarea.value.length;
    }

    function bindAnswerClear(){
        if(answerClearBtn == null){
            return;
        }

        answerClearBtn.addEventListener("click", function(){
            closeDetailAnswerForm();
        });
    }

    function openDetailAnswerForm(isEdit){
        const answerWaitingView = document.getElementById("answerWaitingView");
        const answerCompleteView = document.getElementById("answerCompleteView");
        const answerForm = document.getElementById("answerForm");

        if(answerWaitingView != null){
            answerWaitingView.classList.add("hidden");
        }

        if(answerCompleteView != null){
            answerCompleteView.classList.add("hidden");
        }

        if(answerForm != null){
            answerForm.classList.add("active");
        }

        if(answerSubmitBtn != null){
            answerSubmitBtn.textContent = isEdit ? "답변 수정" : "답변 등록";
        }

        if(answerModeText != null){
            answerModeText.textContent = isEdit ? "답변 수정 중" : "답변 작성 중";
        }

        if(answerTextarea != null){
            answerTextarea.focus();
            updateAnswerCount();
        }
    }

    function closeDetailAnswerForm(){
        const activeCard = document.querySelector(".qna-list-item.active, .seller-qna-card.active");

        if(activeCard != null){
            updateDetailPanel(activeCard);
        }
    }

    function bindReportModal(){
        document.querySelectorAll(".qna-report-btn").forEach(function(btn){
            btn.addEventListener("click", function(event){
                event.stopPropagation();

                const qnaId = this.dataset.qnaId;

                if(reportQnaId != null){
                    reportQnaId.value = qnaId;
                }

                if(reportType != null){
                    reportType.value = "";
                }

                if(reportReason != null){
                    reportReason.value = "";
                }

                openReportModal();
            });
        });

        document.querySelectorAll(".qna-report-close-btn, .qna-report-cancel-btn").forEach(function(btn){
            btn.addEventListener("click", function(){
                closeReportModal();
            });
        });

        const submitBtn = document.querySelector(".qna-report-submit-btn");

        if(submitBtn != null){
            submitBtn.addEventListener("click", function(){
                submitReport();
            });
        }

        if(reportModal != null){
            reportModal.addEventListener("click", function(event){
                if(event.target === reportModal){
                    closeReportModal();
                }
            });
        }

        window.addEventListener("keydown", function(event){
            if(event.key === "Escape"){
                closeReportModal();
            }
        });
    }

    function openReportModal(){
        if(reportModal != null){
            reportModal.classList.add("active");
            reportModal.classList.add("open");
        }
    }

    function closeReportModal(){
        if(reportModal != null){
            reportModal.classList.remove("active");
            reportModal.classList.remove("open");
        }
    }

    function submitReport(){
        if(reportQnaId == null || reportType == null || reportReason == null){
            alert("신고 정보를 찾을 수 없습니다.");
            return;
        }

        const qnaId = reportQnaId.value.trim();
        const type = reportType.value.trim();
        const reason = reportReason.value.trim();

        if(qnaId === ""){
            alert("문의 정보를 찾을 수 없습니다.");
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

        fetch("/seller_qna_report.do", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
            },
            body: new URLSearchParams({
                target_type: "QNA",
                target_id: qnaId,
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
                closeReportModal();
            } else if(data.result === "login"){
                alert("로그인이 필요합니다.");
                location.href = "/login.do";
            } else if(data.result === "empty"){
                alert("신고 사유와 내용을 입력해주세요.");
            } else {
                alert("신고 접수에 실패했습니다.");
            }
        })
        .catch(function(error){
            console.error(error);
            alert("신고 접수 중 오류가 발생했습니다.");
        });
    }

    /*
        기존 구조가 남아있을 때 대비용 값 추출 함수들
    */
    function getCardTitle(card){
        const title = card.querySelector(".qna-title, .qna-list-info h3");

        return title == null ? "문의 내용" : title.textContent.trim();
    }

    function getCardProductName(card){
        const product = card.querySelector(".qna-product-line strong, .qna-list-info p");

        return product == null ? "" : product.textContent.trim();
    }

    function getCardWriterName(card){
        const writer = card.querySelector(".qna-user-line span, .qna-list-sub span:first-child");

        return writer == null ? "" : writer.textContent.trim();
    }

    function getCardDate(card){
        const date = card.querySelector(".qna-write-date");

        return date == null ? "" : date.textContent.trim();
    }

    function getCardQuestion(card){
        const question = card.querySelector(".qna-content, .qna-detail-question");

        return question == null ? "" : question.textContent.trim();
    }

    function getCardAnswer(card){
        const answer = card.querySelector(".answer-complete-content");

        return answer == null ? "" : answer.textContent.trim();
    }

    function getCardImage(card){
        const image = card.querySelector("img");

        if(image == null){
            return "/images/no_image.png";
        }

        return image.getAttribute("src") || "/images/no_image.png";
    }

    function getTypeText(type){
        if(type === "DELIVERY"){
            return "배송 문의";
        }

        if(type === "ORDER"){
            return "주문 문의";
        }

        if(type === "CANCEL"){
            return "취소/환불 문의";
        }

        if(type === "ETC"){
            return "기타 문의";
        }

        return "상품 문의";
    }

    function getTypeClass(type){
        if(type === "DELIVERY"){
            return "delivery";
        }

        if(type === "ORDER"){
            return "order";
        }

        if(type === "CANCEL"){
            return "cancel";
        }

        if(type === "ETC"){
            return "etc";
        }

        return "product";
    }

});