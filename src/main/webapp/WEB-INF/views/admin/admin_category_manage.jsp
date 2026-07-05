<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 카테고리 관리</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const categoryModal = document.getElementById("categoryModal");
            const categoryForm = document.getElementById("categoryForm");
            const modalTitle = document.getElementById("categoryModalTitle");
            const submitButton = document.getElementById("categorySubmitButton");
            const actionInput = document.getElementById("categoryAction");
            const idInput = document.getElementById("categoryId");
            const nameInput = document.getElementById("categoryName");
            const parentInput = document.getElementById("categoryParentId");
            const messageBox = document.getElementById("categoryModalMessage");

            function openModal(mode, data = {}) {
                actionInput.value = mode;
                idInput.value = data.categoryId || "";
                idInput.disabled = mode === "create";
                nameInput.value = data.categoryName || "";
                parentInput.value = data.parentId || "";
                messageBox.textContent = "";

                if (mode === "create") {
                    modalTitle.textContent = data.parentId ? "하위 카테고리 등록" : "대분류 등록";
                    submitButton.textContent = "등록";
                } else {
                    modalTitle.textContent = "카테고리 수정";
                    submitButton.textContent = "수정";
                }

                categoryModal.classList.add("is-open");
                nameInput.focus();
            }

            function closeModal() {
                categoryModal.classList.remove("is-open");
                categoryForm.reset();
                messageBox.textContent = "";
            }

            function postForm(url, formData) {
                return fetch(url, {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
                    },
                    body: new URLSearchParams(formData)
                }).then(response => response.json());
            }

            document.querySelectorAll("[data-category-create]").forEach((button) => {
                button.addEventListener("click", () => {
                    openModal("create", {
                        parentId: button.dataset.parentId || ""
                    });
                });
            });

            document.querySelectorAll("[data-category-edit]").forEach((button) => {
                button.addEventListener("click", () => {
                    openModal("update", {
                        categoryId: button.dataset.categoryId,
                        categoryName: button.dataset.categoryName,
                        parentId: button.dataset.parentId || ""
                    });
                });
            });

            document.querySelectorAll("[data-category-delete]").forEach((button) => {
                button.addEventListener("click", () => {
                    const categoryName = button.dataset.categoryName;

                    if (!confirm("'" + categoryName + "' 카테고리를 삭제할까요?")) {
                        return;
                    }

                    postForm("/admin/categories/delete", {
                        category_id: button.dataset.categoryId
                    }).then((data) => {
                        if (!data.success) {
                            alert(data.message || "삭제할 수 없습니다.");
                            return;
                        }

                        location.reload();
                    });
                });
            });

            categoryForm.addEventListener("submit", (event) => {
                event.preventDefault();

                const url = actionInput.value === "update"
                    ? "/admin/categories/update"
                    : "/admin/categories/create";

                const formData = new FormData(categoryForm);

                if (!formData.get("name").trim()) {
                    messageBox.textContent = "카테고리명을 입력해주세요.";
                    nameInput.focus();
                    return;
                }

                submitButton.disabled = true;
                messageBox.textContent = "";

                postForm(url, formData).then((data) => {
                    if (!data.success) {
                        messageBox.textContent = data.message || "처리 중 오류가 발생했습니다.";
                        return;
                    }

                    location.reload();
                }).finally(() => {
                    submitButton.disabled = false;
                });
            });

            document.querySelectorAll("[data-modal-close]").forEach((button) => {
                button.addEventListener("click", closeModal);
            });

            categoryModal.addEventListener("click", (event) => {
                if (event.target === categoryModal) {
                    closeModal();
                }
            });

            document.querySelectorAll("[data-category-parent-toggle]").forEach((parent) => {
                parent.addEventListener("click", (event) => {
                    if (event.target.closest(".admin-category-actions")) {
                        return;
                    }

                    const group = parent.closest(".admin-category-group");

                    if (!group) {
                        return;
                    }

                    const willOpen = !group.classList.contains("is-open");

                    document.querySelectorAll(".admin-category-group.is-open").forEach((openGroup) => {
                        if (openGroup === group) {
                            return;
                        }

                        openGroup.classList.remove("is-open");

                        const openToggle = openGroup.querySelector(".admin-category-toggle");

                        if (openToggle) {
                            openToggle.setAttribute("aria-expanded", "false");
                        }
                    });

                    group.classList.toggle("is-open", willOpen);
                    const toggle = parent.querySelector(".admin-category-toggle");

                    if (toggle) {
                        toggle.setAttribute("aria-expanded", String(willOpen));
                    }
                });
            });
        });
    </script>
</head>
<body>
<div class="admin-board">
    <jsp:include page="admin_sidebar.jsp">
        <jsp:param name="activeMenu" value="categories" />
        <jsp:param name="sidebarTitle" value="카테고리 관리" />
    </jsp:include>

    <main class="admin-main admin-main-fixed">
        <header class="admin-main-header">
            <div>
                <span class="admin-page-label">CATEGORY MANAGEMENT</span>
                <h1>카테고리 관리</h1>
            </div>
            <div class="admin-header-actions">
                <button type="button" class="admin-btn" data-category-create>대분류 등록</button>
            </div>
        </header>

        <div class="admin-fixed-list-layout">
            <section class="admin-card admin-list-panel admin-category-panel">
                <div class="admin-category-layout">
                    <c:forEach var="parent" items="${parentCategoryList}">
                        <article class="admin-category-group">
                            <div class="admin-category-parent" data-category-parent-toggle>
                                <button type="button"
                                        class="admin-category-toggle"
                                        aria-expanded="false">
                                    <span class="admin-category-arrow" aria-hidden="true"></span>
                                    <span class="admin-category-title">
                                        <strong>${parent.name}</strong>
                                        <span>#${parent.category_id}</span>
                                    </span>
                                </button>
                                <div class="admin-category-actions">
                                    <button type="button"
                                            class="admin-btn light"
                                            data-category-create
                                            data-parent-id="${parent.category_id}">
                                        하위 등록
                                    </button>
                                    <button type="button"
                                            class="admin-btn light"
                                            data-category-edit
                                            data-category-id="${parent.category_id}"
                                            data-category-name="${parent.name}"
                                            data-parent-id="">
                                        수정
                                    </button>
                                    <button type="button"
                                            class="admin-btn light danger"
                                            data-category-delete
                                            data-category-id="${parent.category_id}"
                                            data-category-name="${parent.name}">
                                        삭제
                                    </button>
                                </div>
                            </div>

                            <div class="admin-category-child-list">
                                <c:set var="hasChild" value="false" />
                                <c:forEach var="child" items="${childCategoryList}">
                                    <c:if test="${child.parent_id == parent.category_id}">
                                        <c:set var="hasChild" value="true" />
                                        <div class="admin-category-child">
                                            <div class="admin-category-child-name">
                                                <span>${child.name}</span>
                                                <em>#${child.category_id}</em>
                                            </div>
                                            <div class="admin-category-actions">
                                                <button type="button"
                                                        class="admin-btn light"
                                                        data-category-edit
                                                        data-category-id="${child.category_id}"
                                                        data-category-name="${child.name}"
                                                        data-parent-id="${parent.category_id}">
                                                    수정
                                                </button>
                                                <button type="button"
                                                        class="admin-btn light danger"
                                                        data-category-delete
                                                        data-category-id="${child.category_id}"
                                                        data-category-name="${child.name}">
                                                    삭제
                                                </button>
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>

                                <c:if test="${!hasChild}">
                                    <div class="admin-category-empty">
                                        하위 카테고리 없음
                                    </div>
                                </c:if>
                            </div>
                        </article>
                    </c:forEach>

                    <c:if test="${empty parentCategoryList}">
                        <div class="admin-category-empty admin-category-empty-large">
                            등록된 카테고리가 없습니다.
                        </div>
                    </c:if>
                </div>
            </section>

            <div class="admin-pagination">
                <div class="admin-pagination-pages">
                    <c:if test="${pagination.totalPage > 0}">
                        <c:if test="${pagination.hasPrev}">
                            <a href="/admin/categories?size=${pagination.size}&page=${pagination.prevPage}">이전</a>
                        </c:if>
                        <c:if test="${!pagination.hasPrev}">
                            <span class="disabled">이전</span>
                        </c:if>

                        <c:forEach var="i" begin="${pagination.startPage}" end="${pagination.endPage}">
                            <a href="/admin/categories?size=${pagination.size}&page=${i}"
                               class="${pagination.page == i ? 'active' : ''}">
                                ${i}
                            </a>
                        </c:forEach>

                        <c:if test="${pagination.hasNext}">
                            <a href="/admin/categories?size=${pagination.size}&page=${pagination.nextPage}">다음</a>
                        </c:if>
                        <c:if test="${!pagination.hasNext}">
                            <span class="disabled">다음</span>
                        </c:if>
                    </c:if>
                </div>
                <span class="admin-filter-count">
                    대분류 ${totalCount}개 · 소분류 ${childTotalCount}개
                </span>
            </div>
        </div>
    </main>
</div>

<div class="admin-modal" id="categoryModal" aria-hidden="true">
    <div class="admin-modal-panel">
        <div class="admin-modal-head">
            <h2 id="categoryModalTitle">카테고리 등록</h2>
            <button type="button" class="admin-modal-close" data-modal-close aria-label="닫기">&times;</button>
        </div>

        <form id="categoryForm" class="admin-modal-form">
            <input type="hidden" name="category_id" id="categoryId">
            <input type="hidden" id="categoryAction" value="create">

            <label class="admin-modal-field">
                <span>카테고리명</span>
                <input type="text" name="name" id="categoryName" maxlength="100" autocomplete="off">
            </label>

            <label class="admin-modal-field">
                <span>상위 카테고리</span>
                <select name="parent_id" id="categoryParentId">
                    <option value="">대분류</option>
                    <c:forEach var="parentCategory" items="${allParentCategoryList}">
                        <option value="${parentCategory.category_id}">${parentCategory.name}</option>
                    </c:forEach>
                </select>
            </label>

            <p class="admin-modal-message" id="categoryModalMessage"></p>

            <div class="admin-modal-actions">
                <button type="button" class="admin-btn light" data-modal-close>취소</button>
                <button type="submit" class="admin-btn" id="categorySubmitButton">등록</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
