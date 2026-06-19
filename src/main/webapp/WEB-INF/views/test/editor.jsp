<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Toast UI Editor 예시</title>

    <link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css">
    <script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

    <style>
        /* Toast UI 툴바 안에 들어가는 커스텀 버튼 */
        .toastui-editor-defaultUI-toolbar button.custom-toolbar-btn {
            width: 32px !important;
            height: 32px !important;
            padding: 0 !important;
            margin: 0 !important;
            border: none !important;
            background: transparent !important;
            border-radius: 3px !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            cursor: pointer !important;
            color: #555 !important;
        }

        .toastui-editor-defaultUI-toolbar button.custom-toolbar-btn:hover {
            background-color: #e9ecef !important;
            color: #222 !important;
        }

        .toastui-editor-defaultUI-toolbar button.custom-toolbar-btn svg {
            width: 18px;
            height: 18px;
            stroke: currentColor;
            fill: none;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
        }
    </style>
</head>

<body>

    <form action="${pageContext.request.contextPath}/editor/submit.do"
          method="post"
          onsubmit="return submitToastForm();">

        <div id="toastEditor"></div>

        <input type="hidden" id="toastContent" name="content">

        <br>
        <button type="submit">등록</button>
    </form>

    <script>
        let toastEditor;

        function createIconButton(iconSvg, title, clickEvent) {
            const button = document.createElement("button");

            button.type = "button";
            button.title = title;
            button.className = "custom-toolbar-btn";
            button.innerHTML = iconSvg;

            button.addEventListener("mousedown", function (e) {
                e.preventDefault();
            });

            button.addEventListener("click", function (e) {
                e.preventDefault();
                clickEvent();
            });

            return button;
        }

        const undoIcon =
            '<svg viewBox="0 0 24 24">' +
                '<path d="M9 14L4 9L9 4"></path>' +
                '<path d="M5 9H15C18 9 20 11 20 14C20 17 18 19 15 19H11"></path>' +
            '</svg>';

        const redoIcon =
            '<svg viewBox="0 0 24 24">' +
                '<path d="M15 14L20 9L15 4"></path>' +
                '<path d="M19 9H9C6 9 4 11 4 14C4 17 6 19 9 19H13"></path>' +
            '</svg>';

        const mediaIcon =
            '<svg viewBox="0 0 24 24">' +
                '<rect x="3" y="5" width="14" height="14" rx="2"></rect>' +
                '<path d="M17 9L21 7V17L17 15Z"></path>' +
                '<path d="M8 9L13 12L8 15Z"></path>' +
            '</svg>';

        const undoButton = createIconButton(undoIcon, "되돌리기", function () {
            toastEditor.exec("undo");
            toastEditor.focus();
        });

        const redoButton = createIconButton(redoIcon, "다시 실행", function () {
            toastEditor.exec("redo");
            toastEditor.focus();
        });

        const mediaButton = createIconButton(mediaIcon, "영상 삽입", function () {
            insertMedia();
        });

        toastEditor = new toastui.Editor({
            el: document.querySelector("#toastEditor"),
            height: "500px",
            initialEditType: "wysiwyg",
            previewStyle: "vertical",
            placeholder: "내용을 입력하세요.",

            customHTMLSanitizer: function (html) {
                return html;
            },

            toolbarItems: [
                [
                    {
                        name: "undoButton",
                        tooltip: "되돌리기",
                        el: undoButton
                    },
                    {
                        name: "redoButton",
                        tooltip: "다시 실행",
                        el: redoButton
                    }
                ],
                ["heading", "bold", "italic", "strike"],
                ["hr", "quote"],
                ["ul", "ol", "task"],
                ["table", "image", "link"],
                [
                    {
                        name: "mediaButton",
                        tooltip: "영상 삽입",
                        el: mediaButton
                    }
                ],
                ["code", "codeblock"]
            ]
        });

        function insertMedia() {
            const mediaUrl = prompt("유튜브 주소 또는 mp4 영상 주소를 입력하세요.");

            if (mediaUrl == null || mediaUrl.trim() === "") {
                return;
            }

            const url = mediaUrl.trim();
            let mediaHtml = "";

            const youtubeId = getYoutubeId(url);

            if (youtubeId !== "") {
                mediaHtml =
                    '<p></p>' +
                    '<div style="position:relative; padding-bottom:56.25%; height:0; overflow:hidden; max-width:100%;">' +
                        '<iframe ' +
                            'src="https://www.youtube.com/embed/' + youtubeId + '" ' +
                            'style="position:absolute; top:0; left:0; width:100%; height:100%;" ' +
                            'frameborder="0" ' +
                            'allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" ' +
                            'allowfullscreen>' +
                        '</iframe>' +
                    '</div>' +
                    '<p></p>';
            } else if (isVideoFile(url)) {
                mediaHtml =
                    '<p></p>' +
                    '<video controls style="max-width:100%; width:700px;">' +
                        '<source src="' + escapeHtml(url) + '">' +
                    '</video>' +
                    '<p></p>';
            } else {
                alert("유튜브 주소 또는 mp4/webm/ogg 영상 주소만 입력하세요.");
                return;
            }

            const currentHtml = toastEditor.getHTML();
            toastEditor.setHTML(currentHtml + mediaHtml);
            toastEditor.focus();
        }

        function getYoutubeId(url) {
            const regExp = /(?:youtube\.com\/(?:watch\?v=|embed\/|shorts\/)|youtu\.be\/)([^&?\/]+)/;
            const match = url.match(regExp);

            if (match && match[1]) {
                return match[1];
            }

            return "";
        }

        function isVideoFile(url) {
            return /\.(mp4|webm|ogg)(\?.*)?$/i.test(url);
        }

        function escapeHtml(str) {
            return str
                .replaceAll("&", "&amp;")
                .replaceAll("<", "&lt;")
                .replaceAll(">", "&gt;")
                .replaceAll('"', "&quot;")
                .replaceAll("'", "&#039;");
        }

        function submitToastForm() {
            const content = toastEditor.getHTML().trim();

            if (content === "" || content === "<p><br></p>") {
                alert("내용을 입력하세요.");
                return false;
            }

            document.getElementById("toastContent").value = content;
            return true;
        }
    </script>
    

</body>
</html>