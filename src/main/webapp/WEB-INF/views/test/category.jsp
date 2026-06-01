<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang='ko'>
<head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>Page Title</title>
    <script>
        function getChild(category_id) {
            fetch('/getChildCategories.do?parentId=' + category_id)
                .then(response => response.json())
                .then(data => { // data는 이제 Map 구조의 객체 {} 입니다.
                    const childArea = document.getElementById("childCategoryArea");
                    childArea.innerHTML = ""; 

                    // 1. Map에서 "list"라는 key로 담아 보낸 자바스크립트 배열을 꺼냅니다.
                    const childList = data.list; 

                    // 2. 안전하게 데이터가 비어있는지 체크
                    if (!childList || childList.length === 0) {
                        childArea.innerHTML = "<p style='color:gray;'>하위 카테고리가 없습니다.</p>";
                        return;
                    }

                    // 3. 꺼내온 '배열(childList)'에 .forEach()를 사용합니다.
                    childList.forEach(child => {
                        const btn = document.createElement("input");
                        btn.type = "button";
                        btn.value = child.name;
                        btn.onclick = function() { alert(child.name + ' 선택됨'); }; 
                        
                        childArea.appendChild(btn);
                    });
                })
                .catch(error => console.error("Error fetching child categories:", error));
        }
    </script>
</head>
<body>
    <h3>상위 카테고리</h3>
    <c:forEach var="category" items="${categories}">
        <input type="button" value="${category.name}" onclick="getChild('${category.category_id}')"/>
    </c:forEach>

    <hr/>

    <h3>하위 카테고리</h3>
    <div id="childCategoryArea">
        <p style="color: gray;">상위 카테고리를 선택하면 여기에 하위 항목이 나타납니다.</p>
    </div>
</body>
</html>