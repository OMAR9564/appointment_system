<%--
  Created by IntelliJ IDEA.
  User: omerfaruk
  Date: 23.08.2023
  Time: 12:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Giriş Sayfası</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.5.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://unicons.iconscout.com/release/v2.1.9/css/unicons.css">
    <link rel="stylesheet" href="assets/css/loginPage.css" />

</head>



<body>
<div class="section">
    <div class="container">
        <div class="row full-height justify-content-center">
            <div class="col-12 text-center align-self-center py-5">
                <div class="section pb-5 pt-5 pt-sm-2 text-center">
                    <h6 class="mb-0 pb-3"><span onclick="toggleCheckbox('login')">Giriş Yap</span><span onclick="toggleCheckbox('foregetPass')">Şifremi Unuttum</span></h6>
                    <input class="checkbox" type="checkbox" id="reg-log" name="reg-log" />
                    <label for="reg-log"></label>
                    <div class="card-3d-wrap mx-auto">
                        <div class="card-3d-wrapper">
                            <div class="card-front">
                                <div class="center-wrap">
                                    <div class="section text-center">
                                        <h4 class="mb-4 pb-3">Giriş Yap</h4>
                                        <p id="errorMessageArea"></p>
                                        <form action="adminSqlCon.jsp" method="POST" id="loginform">
                                            <div class="form-group">
                                                <input type="text" name="logeuser" id="logeuser" class="form-style validate-input" placeholder="Kullanıcı Adınız"
                                                       autocomplete="off" required >
                                                <i class="input-icon uil uil-user"></i>
                                            </div>
                                            <div class="form-group mt-2">
                                                <input type="password" name="logpass" id="logpass" class="form-style validate-input" placeholder="Şifreniz"
                                                       autocomplete="off" required="true">
                                                <input type="text" value="login" name="iam" hidden>
                                                <input type="text" value="loginPage.jsp" name="page"
                                                       hidden>
                                                <i class="input-icon uil uil-lock-alt"></i>
                                            </div>
                                            <a href="#" class="btn mt-4" onclick="document.getElementById('loginform').submit();">Giriş Yap</a>
                                            <div class="form-check form-switch mt-3">
                                                <style>

                                                    .form-check-input{
                                                        filter: hue-rotate(2grad);
                                                    }

                                                </style>
                                                <input style="left: auto;" class="form-check-input " id="rememberMe" name="rememberMe" type="checkbox" id="flexSwitchCheckDefault" checked="false">
                                                <label class="form-check-label" for="flexSwitchCheckDefault">Beni Hatırla</label>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            <div style= "height: 100%;"class="card-back">
                                <div class="center-wrap">
                                    <div class="section text-center">
                                        <h4 class="mb-4 pb-3">Şifremi Unuttum</h4>
                                        <p class="wrong-pass"></p>
                                        <form action="adminSqlCon.jsp" method="POST" id="forgetPassForm">
                                            <div class="form-group">
                                                <input type="email" name="logemail" class="form-style validate-input" placeholder="E-Postanız"
                                                       autocomplete="off" required >
                                                <i class="input-icon uil uil-at"></i>
                                            </div>
                                            <div class="form-group mt-2">
                                                <input type="text" name="logeuser" class="form-style validate-input" placeholder="Kullanıcı Adınız"
                                                       autocomplete="off" required>
                                                <i class="input-icon uil uil-user"></i>
                                            </div>
                                            <a href="#" class="btn mt-4" onclick="document.getElementById('loginform').submit();">Şifremi Gönder</a>
                                            <div class="form-check form-switch mt-3">
                                                <style>

                                                    .form-check-input{
                                                        filter: hue-rotate(2grad);
                                                    }

                                                </style>

                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>

</html>

<script>
    function toggleCheckbox(status) {
        const checkbox = document.getElementById("reg-log");

        if (status === "login"){
            checkbox.checked = false;
        }
        else if (status === "foregetPass" ){
            checkbox.checked = true;
        }
    }

    function getQueryParam(name) {
        const urlParams = new URLSearchParams(window.location.search);
        return urlParams.get(name);
    }

    if (getQueryParam("message") === "false" && getQueryParam("dic")) {
        const errorMessage = decodeURIComponent(getQueryParam("dic"));
        const errorMessageArea = document.getElementById("errorMessageArea");
        const styledErrorMessage = "‼️ " + errorMessage + " ‼️";
        errorMessageArea.textContent = styledErrorMessage;
        errorMessageArea.style.color = "red";
    }

    const inputElements = document.querySelectorAll('.validate-input');

    inputElements.forEach(input => {
        input.addEventListener('input', function () {
            const inputValue = this.value;
            if (inputValue.length > 0 && inputValue[0] === ' ') {
                this.value = inputValue.trimStart();
            }
        });
    });
</script>


