function send(f) {
    let id = f.id.value;
    let pwd = f.pwd.value;

    if (id == '') {
        alert("id");
        return;
    }
    if (pwd == '') {
        alert("pwd");
        return;
    }

    let formData = new FormData(f);
    fetch("/login.do", { method: "post", body: formData }).then(res => res.json()).then(data => {
        if (data.param == 'id') {
            alert("없는 아이디");
        } else if (data.param == 'pwd') {
            alert("비번 불일치");
        } else {
            location.href = "/user_view.do?idx=" + data.idx;
        }
    })
}