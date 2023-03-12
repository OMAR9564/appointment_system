<%--
  Created by IntelliJ IDEA.
  User: omerfaruk
  Date: 27.02.2023
  Time: 12:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Psikoloji Uzmanı Randevu Sistemi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

    <link rel="stylesheet" href="style/style.css">



</head>
<body>
<div class="container">
    <div class="row mt-4" >
        <div class="col-md-12 text-center">
            <h2> Randevu Alma Sistemi</h2>
        </div>
    </div>
    <div class="row">
        <div class="col-md-6">
            <div class="form-group">
                <label for="name-input">Adınız:</label>
                <input type="text" class="form-control" id="name-input" name="name-input" required>
            </div>

            <div class="form-group">
                <label for="surname-input">Soyadınız:</label>
                <input type="text" class="form-control" id="surname-input" name="surname-input" required>
            </div>
            <div class="form-group">
                <label for="phone-input">Telefon Numaranız:</label>
                <input type="tel" class="form-control" id="phone-input" name="phone-input"  required>
            </div>

            <div class="form-group">
                <label for="doctor-select">Doktor seçin:</label>
                <select class="form-control" id="doctor-select">
                    <option value="" selected  hidden>Seçin</option>
                    <option value="doktor1" >Doktor 1</option>
                    <option value="doktor2">Doktor 2</option>
                </select>
            </div>
            <div class="form-group">
                <label for="location-select">Yer:</label>
                <select class="form-control" id="location-select">
                    <option value="" selected hidden>Seçin</option>
                    <option value="loc1">Loya</option>
                    <option value="loc2">Online</option>
                </select>
            </div>
            <div class="calendar">
                <div class="calendar-header">
                    <button id="prev-month-btn">&lt;</button>
                    <h2 id="current-month"></h2>
                    <button id="next-month-btn">&gt;</button>
                </div>
                <div class="calendar-body">
                    <div class="weekdays">
                        <div class="weekday">Paz</div>
                        <div class="weekday">Pzt</div>
                        <div class="weekday">Sal</div>
                        <div class="weekday">Çar</div>
                        <div class="weekday">Per</div>
                        <div class="weekday">Cum</div>
                        <div class="weekday">Cmt</div>
                    </div>
                    <div class="days"></div>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="hours">
                <h3 id="selected-date"></h3>

                <h2 id="selected-day"></h2>
                <div class="hour-buttons"></div>

                <form method="post" action="/take_appoint.jsp" ID="form">
                    <input type="hidden" id="selected-year" name="selected-year" value="">
                    <input type="hidden" id="selected-month" name="selected-month" value="">
                    <input type="hidden" id="selected-dayIn" name="selected-dayIn" value="">
                    <input type="hidden" id="selected-hour" name="selected-hour" value="">
                    <input type="hidden" id="cust-name" name="cust-name" value="">
                    <input type="hidden" id="cust-surname" name="cust-surname" value="">
                    <input type="hidden" id="cust-phone" name="cust-phone" value="">
                    <input type="hidden" id="doctor-name" name="doctor-name" value="">
                    <input type="hidden" id="loc-name" name="loc-name" value="">




                    <input type="submit" class="btn btn-primary btn-lg " id="schedule-appointment" name="schedule-appointment" onclick="clearInput()" value="Randevu Al">

                </form>

            </div>
        </div>
    </div>

</div>
<script src="js/script.js"></script>
<script>
    const custnNameIn = document.getElementById('name-input');
    const custnSurnameIn = document.getElementById('surname-input');
    const custnPhoneIn = document.getElementById('phone-input');


    const custnNameHid = document.getElementById('cust-name');
    const custnSurnameHid = document.getElementById('cust-surname');
    const custnPhoneHid = document.getElementById('cust-phone');


    custnNameIn.value = "";
    custnSurnameIn.value = "";
    custnPhoneIn.value = "";


    custnNameIn.addEventListener('input', function() {
        custnNameHid.value = this.value;
    });
    custnSurnameIn.addEventListener('input', function() {
        custnSurnameHid.value = this.value;
    });
    custnPhoneIn.addEventListener('input', function() {
        custnPhoneHid.value = this.value;
    });
    custnNameHid.value = "";
    custnSurnameHid.value = "";
    custnPhoneHid.value = "";




    // Telefon numarası girdisini alın
    let phoneInput = document.getElementById("phone-input");

    // Herhangi bir değişiklik olduğunda otomatik olarak formatlayın
    phoneInput.addEventListener("input", function() {
        let phone = phoneInput.value;

        // Rakamları temizle
        phone = phone.replace(/\D/g, '');

        // Telefon numarasının formatını belirleyin
        let phoneFormatted = "";
        if (phone.length > 0) {
            phoneFormatted = "(";
            phoneFormatted += phone.substr(0, 3);
            phoneFormatted += ") ";

            if (phone.length > 3) {
                phoneFormatted += phone.substr(3, 3);

                if (phone.length > 6) {
                    phoneFormatted += "-";
                    phoneFormatted += phone.substr(6);
                } else {
                    phoneFormatted += phone.substr(6);
                }
            } else {
                phoneFormatted += phone.substr(3);
            }
        }

        // Yeni formatlı telefon numarasını gösterin
        phoneInput.value = phoneFormatted;
    });

    // Sadece rakam girişine izin ver
    phoneInput.addEventListener("keypress", function(e) {
        // Sadece sayı tuşlarına izin ver (0-9 arası ASCII kodları 48-57 arasındadır)
        if (e.charCode < 48 || e.charCode > 57) {
            e.preventDefault();
        }

        // En fazla 10 rakam girilebilir
        if (phoneInput.value.length >= 14) {
            e.preventDefault();
        }
    });


    // Select öğesi değiştiğinde çalışacak fonksiyonu tanımlayın
    document.getElementById("doctor-select").onchange = function() {
        // Seçilen seçeneğin değerini alın
        let selectedValue = this.value;

        // Değerin başka bir input öğesine atanması
        document.getElementById("doctor-name").value = selectedValue;
    };
    document.getElementById("location-select").onchange = function() {
        // Seçilen seçeneğin değerini alın
        let selectedValue = this.value;

        // Değerin başka bir input öğesine atanması
        document.getElementById("loc-name").value = selectedValue;
    };


    //Önceki ve bugün tarihler için gri renkli bir arka plan
    const today = new Date();
    const days = daysContainer.querySelectorAll(".day");
    days.forEach(day => {
        const dayDate = new Date(year, month, day.textContent);
        if (dayDate < today) {
            day.classList.add("past");
        }
    });

    //Önceki aylara geçiş butonunu gizlemek
    if (currentMonth === 0) {
        prevMonthBtn.style.display = "none";
    } else {
        prevMonthBtn.style.display = "block";
    }

    //Bu ayın sonrasına geçiş butonunu göstermek
    if (currentMonth === 11) {
        nextMonthBtn.style.display = "none";
    } else {
        nextMonthBtn.style.display = "block";
    }
</script>
</body>
</html>
