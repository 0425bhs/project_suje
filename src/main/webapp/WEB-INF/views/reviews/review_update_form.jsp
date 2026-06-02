<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang='kor'>
<head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>Page Title</title>
    <script>
        window.onload = () => {
            let rating = document.getElementById("rating");
            console.log(rating);
            rating.value = '${review.rating}';
        }

        function send(f) {
            let content = f.content.value.trim();

            if (content === "") {
                alert("내용을 입력해주세요.");
                return;
            }

            f.action = "/review_update_form.do";
            f.method = "post";

            f.submit();    
        }
    </script>
</head>

<body>
    <form>
        <input type="hidden" name="review_id" value="${review.review_id}"/>
        <table border="1">
            <caption>리뷰 작성</caption>
            <tr>
                <th>상품 이미지</th>
                <td><img src="${review.image_s}" /></td>
            </tr>
            <tr>
                <th>상품 이름</th>
                <td>${review.product_name}</td>
            </tr>
            <tr>
                <th>리뷰 내용</th>
                <td>
                    <textarea name="content" placeholder="리뷰 내용을 작성해주세요.">${review.content}</textarea>
                </td>
            </tr>
            <tr>
                <th>별점</th>
                <td>
                    <select id="rating" name="rating">
                        <option value="">별점</option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <input type="button" value="작성" onclick="send(this.form)"/>
                    <input type="button" value="취소" onclick="history.back()"/>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>

