document.addEventListener("DOMContentLoaded", function(){

    const productFilter = document.getElementById("productFilter");
    const tabs = document.querySelectorAll(".qna-tab");
    const qnaCards = document.querySelectorAll(".seller-qna-card");

    let currentTab = "all";

    updateQnaCounts();
    applyFilter();
    bindAnswerButtons();
    initQnaContentToggle();

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

        qnaCards.forEach(function(card){
            const cardProductId = card.dataset.productId;
            const isAnswered = card.dataset.answered === "true";

            let productMatched = selectedProductId === "all" || selectedProductId === cardProductId;
            let tabMatched = true;

            if(currentTab === "waiting"){
                tabMatched = !isAnswered;
            }

            if(currentTab === "completed"){
                tabMatched = isAnswered;
            }

            if(productMatched && tabMatched){
                card.style.display = "block";
            } else {
                card.style.display = "none";
            }
        });
    }

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
        setText("waitingQnaCount", waitingCount);
        setText("completedQnaCount", completedCount);

        setText("waitingTabCount", "(" + waitingCount + ")");
        setText("completedTabCount", "(" + completedCount + ")");
    }

    function setText(id, value){
        const target = document.getElementById(id);

        if(target != null){
            target.textContent = value;
        }
    }

    function bindAnswerButtons(){

        document.querySelectorAll(".answer-write-btn").forEach(function(btn){
            btn.addEventListener("click", function(){
                const qnaId = this.dataset.qnaId;
                const card = this.closest(".seller-qna-card");

                if(card == null){
                    alert("문의 카드를 찾을 수 없습니다.");
                    return;
                }

                openAnswerForm(card, qnaId, "");
            });
        });

        document.querySelectorAll(".answer-edit-btn").forEach(function(btn){
            btn.addEventListener("click", function(){
                const qnaId = this.dataset.qnaId;
                const card = this.closest(".seller-qna-card");

                if(card == null){
                    alert("문의 카드를 찾을 수 없습니다.");
                    return;
                }

                const answerContentBox = card.querySelector(".answer-complete-content");
                const oldAnswer = answerContentBox == null ? "" : answerContentBox.textContent.trim();

                openAnswerForm(card, qnaId, oldAnswer);
            });
        });
    }

    function openAnswerForm(card, qnaId, oldAnswer){

        const answerBox = card.querySelector(".seller-answer-box");

        if(answerBox == null){
            alert("답변 영역을 찾을 수 없습니다.");
            return;
        }

        const waitingBox = answerBox.querySelector(".answer-waiting-box");
        const completeBox = answerBox.querySelector(".answer-complete-box");

        if(waitingBox != null){
            waitingBox.style.display = "none";
        }

        if(completeBox != null){
            completeBox.style.display = "none";
        }

        const oldForm = answerBox.querySelector(".qna-answer-form");

        if(oldForm != null){
            oldForm.remove();
        }

        const form = document.createElement("div");
        form.className = "qna-answer-form";

        form.innerHTML = `
            <textarea class="qna-answer-textarea" placeholder="고객 문의에 대한 답변을 입력하세요."></textarea>

            <div class="qna-answer-form-buttons">
                <button type="button" class="qna-answer-submit-btn">답변 등록</button>
                <button type="button" class="qna-answer-cancel-btn">취소</button>
            </div>
        `;

        answerBox.appendChild(form);

        const textarea = form.querySelector(".qna-answer-textarea");
        const submitBtn = form.querySelector(".qna-answer-submit-btn");
        const cancelBtn = form.querySelector(".qna-answer-cancel-btn");

        textarea.value = oldAnswer;
        textarea.focus();

        submitBtn.addEventListener("click", function(){
            submitAnswer(qnaId, textarea);
        });

        cancelBtn.addEventListener("click", function(){
            form.remove();

            const isAnswered = card.dataset.answered === "true";

            if(isAnswered){
                if(completeBox != null){
                    completeBox.style.display = "block";
                }
            } else {
                if(waitingBox != null){
                    waitingBox.style.display = "block";
                }
            }
        });
    }

    function submitAnswer(qnaId, textarea){

        if(textarea == null){
            alert("답변 입력창을 찾을 수 없습니다.");
            return;
        }

        const answerContent = textarea.value.trim();

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

    function initQnaContentToggle(){

        const qnaContents = document.querySelectorAll(".qna-content");

        qnaContents.forEach(function(content){

            const limitHeight = 150;

            if(content.scrollHeight <= limitHeight){
                return;
            }

            content.classList.add("is-collapsed");

            const toggleBtn = document.createElement("button");
            toggleBtn.type = "button";
            toggleBtn.className = "qna-toggle-btn";
            toggleBtn.innerHTML = '펼쳐보기 <i class="bi bi-chevron-down"></i>';

            content.insertAdjacentElement("afterend", toggleBtn);

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

});