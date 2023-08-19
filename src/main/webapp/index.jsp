<%@ page import="com.bya.Helper" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="com.bya.ConSql" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.bya.GetInfo" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%--
  Created by IntelliJ IDEA.
  User: omerfaruk
  Date: 27.02.2023
  Time: 12:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>

<%
    Boolean appointmentMade = null;
    String requestStr = null;
    String discroption = null;
/*
    String selectedDate = null;
*/
    ArrayList<GetInfo> locationNames = new ArrayList<>();
    ArrayList<GetInfo> doctorInfo = new ArrayList<>();
    ArrayList<GetInfo> rezervationInfo = new ArrayList<>();
    ArrayList<GetInfo> companyName = new ArrayList<>();
    ArrayList<GetInfo> messageBody = new ArrayList<>();
    ArrayList<GetInfo> messageTitle = new ArrayList<>();


    String locationsQuery = "SELECT * FROM locationInfo";
    String doctorsQuery = "SELECT * FROM `doctorInfo`";
    String rezervationQuery = "SELECT * FROM `reservationInfo`";
    String companyNameQuery = "SELECT companyName FROM settings";
    String appointMessageBody = "SELECT appointMessageBody FROM settings";
    String appointMessageTitle = "SELECT appointMessageTitle FROM settings";


    ConSql conSql = new ConSql();
    locationNames = conSql.getInfos(locationsQuery);
    doctorInfo = conSql.getInfos(doctorsQuery);
    rezervationInfo = conSql.getRezervationInfos(rezervationQuery);
    companyName = conSql.getSettingName(companyNameQuery);
    messageBody = conSql.getSettingName(appointMessageBody);
    messageTitle = conSql.getSettingName(appointMessageTitle);
    String appointmentMadeStr = messageBody.get(0).getName();
    String appointmentNotMadeStr = "Randevunuzu Olustururken Bir Hata Olustu!!\nLutfen Daha Sonra Deneyin.";

    String appointmentMadeHeader = messageTitle.get(0).getName();
    String appointmentNotMadeHeader = "Bir Hata Olustu!!";

    String locName = "";

    String companyNameTitle = companyName.get(0).getName();


    requestStr = request.getParameter("message");
    discroption = request.getParameter("dic");
    if (discroption == null) {
        discroption = ""; // Varsayılan değeri boş bir dize olarak atadık
    }
    if (requestStr != null && requestStr.equals("true")) {
        appointmentMade = true;
    } else {
        if (discroption.length() != 0) {
            appointmentNotMadeStr = discroption;
        }
        appointmentMade = false;
    }


%>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%out.println(companyNameTitle);%></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="style/style.css">
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"
            integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3"
            crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.min.js"
            integrity="sha384-cuYeSxntonz0PPNlHhBs68uyIAVpIIOZZ5JqeqvYYIcEL727kskC66kF92t6Xl2V"
            crossorigin="anonymous"></script>


    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>


</head>
<body>
<div class="container">
    <div class="row mt-4">
        <div class="col-md-12 text-center">
            <h2> Randevu Alma Sistemi</h2>
        </div>
    </div>
    <div class="row">
        <div class="col-md-6">
            <div class="form-group">
                <label for="name-input">Adınız:</label>
                <input type="text" class="form-control" id="name-input" name="name-input" maxlength="20" required
                       oninput="blockSpecialChars()">
            </div>
            <div class="form-group">
                <label for="surname-input">Soyadınız:</label>
                <input type="text" class="form-control" id="surname-input" name="surname-input" maxlength="20" required
                       oninput="blockSpecialChars1()">
            </div>
            <div class="form-group">
                <label for="phone-input">Telefon Numaranız:</label>
                <input type="tel" class="form-control" id="phone-input" name="phone-input" required>
            </div>

            <div class="form-group">
                <label for="doctor-select">Doktor seçin:</label>
                <select class="form-control" id="doctor-select">
                    <option value="" selected hidden>Seçin</option>
                    <%
                        for (int i = 0; i < doctorInfo.size(); i++) {
                    %>
                    <option value=<% out.println("doctor" + doctorInfo.get(i).getId());%>>
                        <%out.println(doctorInfo.get(i).getName());%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </div>
            <div class="form-group">
                <label for="apptype-select">Randevu tipi seçin:</label>
                <select class="form-control" id="apptype-select">
                    <option value="" selected hidden>Seçin</option>
                    <%
                        for (int i = 0; i < rezervationInfo.size(); i++) {
                    %>
                    <option value= <%out.println((rezervationInfo.get(i).getRezervationNameTag()));%>>
                        <%out.println(rezervationInfo.get(i).getRezervationName());%>
                    </option>
                    <%}%>
                </select>
            </div>

            <div class="form-group">
                <label for="location-select">Yer:</label>
                <select class="form-control" id="location-select">
                    <option value="" selected hidden>Seçin</option>
                    <%
                        for (int i = 0; i < locationNames.size(); i++) {
                    %>
                    <option value=<%out.println("loc" + (locationNames.get(i).getId()));%>>
                        <%out.println(locationNames.get(i).getName());%>
                    </option>
                    <%
                        }
                    %>
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
                        <div class="weekday">Pzt</div>
                        <div class="weekday">Sal</div>
                        <div class="weekday">Çar</div>
                        <div class="weekday">Per</div>
                        <div class="weekday">Cum</div>
                        <div class="weekday">Cmt</div>
                        <div class="weekday">Paz</div>

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
                <p class="fw-bolder" id="warning-message" name="warning-message">Önce gerekli bilgileri doldurmanız
                    gerekir.</p>

                <form method="post" onsubmit="return validateForm()" action="/take_appoint.jsp" id="form">
                    <input type="hidden" id="selected-year" name="selected-year" value="">
                    <input type="hidden" id="selected-month" name="selected-month" value="">
                    <input type="hidden" id="selected-dayIn" name="selected-dayIn" value="">
                    <input type="hidden" id="selected-hour" name="selected-hour" value="">
                    <input type="hidden" id="cust-name" name="cust-name" value="">
                    <input type="hidden" id="cust-surname" name="cust-surname" value="">
                    <input type="hidden" id="cust-phone" name="cust-phone" value="">
                    <input type="hidden" id="doctor-name" name="doctor-name" value="">
                    <input type="hidden" id="loc-name" name="loc-name" value="">
                    <input type="hidden" id="interval-type" name="interval-type" value="">
                    <input type="hidden" id="page-name" name="page-name" value="index.jsp">



                    <input type="submit" class="btn btn-primary btn-lg " id="schedule-appointment"
                           name="schedule-appointment" onclick="clearInput()" value="Randevu Al">

                </form>

            </div>

            <!-- Button trigger modal -->
            <button type="button" id="sucsessModalBtn" class="btn btn-primary" data-bs-toggle="modal"
                    data-bs-target="#sucsessModal" hidden="hidden">
                Launch demo modal
            </button>

            <!-- Modal -->
            <div class="modal fade" id="sucsessModal" tabindex="-1" aria-labelledby="sucsess-modal" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h1 class="modal-title fs-5" id="sucsess-modal">
                                <%
                                    if (appointmentMade) {
                                        out.println(appointmentMadeHeader);
                                    } else {
                                        out.println(appointmentNotMadeHeader);
                                    }
                                %>
                            </h1>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <%
                                if (appointmentMade) {
                                    out.println(appointmentMadeStr);
                                } else {
                                    out.println(appointmentNotMadeStr);
                                }
                            %>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Kapat</button>
                        </div>
                    </div>
                </div>
            </div>


            <div class="row row-cols-4" style="margin-right: 11px;padding-top: 5px;">
                <div class="col-10">
                    <div class=" form-floating mt-2" style="padding-right: 0px;">
                        <input type="text" class="form-control" id="floatingInputGrid" placeholder="xxx-xxx">
                        <label for="floatingInputGrid">Randevu duzeltmek icin kodu giriniz</label>
                    </div>
                </div>
                <div class="col-2" style="padding-top: 5px;padding-left: -1px;padding-right: 15px;margin-right: 0px;">
                    <button type="button" class="btn btn-info mt-2 btn-lg">Info</button>
                </div>
            </div>

            <%
                Helper helper = new Helper();
                //helper.JsonFileWriter();
                Cookie cookie = null;
                Cookie[] cookies = null;

                String omarfaruk = null;

                String firstNameCo = null;
                String lastNameCo = null;
                String firstNameWithSpaceCo = null;
                String lastNamWithSpaceCo = null;
                String appointDayCo = null;
                String appointTimeCo = null;
                String locNameCo = null;
                String appointIdCo = null;


                cookies = request.getCookies();

                if (cookies != null) {
                    for (int i = 0; i < cookies.length; i++) {
                        cookie = cookies[i];
                        if (cookie.getName().equals("firN")) {
                            firstNameCo = URLDecoder.decode(cookie.getValue(), "UTF-8");
                        }
                        if (cookie.getName().equals("lasN")) {
                            lastNameCo = URLDecoder.decode(cookie.getValue(), "UTF-8");
                        }
                        if (cookie.getName().equals("appD")) {
                            appointDayCo = cookie.getValue();
                        }
                        if (cookie.getName().equals("appT")) {
                            appointTimeCo = cookie.getValue();
                        }
                        if (cookie.getName().equals("locN")) {
                            locNameCo = cookie.getValue();
                        }
                        if (cookie.getName().equals("appId")) {
                            appointIdCo = cookie.getValue();
                        }
                    }
                }
                if (firstNameCo != null && lastNameCo != null && appointDayCo != null && appointTimeCo != null && locNameCo != null) {
                    helper = new Helper();
                    firstNameWithSpaceCo = firstNameCo.replace("-", " ");
                    lastNamWithSpaceCo = lastNameCo.replace("-", " ");

//                    String rds = String.valueOf(helper.randNum());
//                    helper.insertRandomNumToTxt(rds, "dsafasf");
                    for (int i = 0; i < locationNames.size(); i++) {

                        if (locNameCo.equals(Integer.toString(locationNames.get(i).getId()))) {
                            locName = locationNames.get(i).getName();

                        }
                        i++;
                        if (locNameCo.equals(Integer.toString(locationNames.get(i).getId()))) {
                            locName = locationNames.get(i).getName();
                        }
                    }
            %>


            <ol class="list-group list-group-numbered mt-5">
                <li class="list-group-item d-flex justify-content-between align-items-start">
                    <div class="ms-2 me-auto">
                        <div class="fw-bold"><%out.println(firstNameWithSpaceCo + " " + lastNamWithSpaceCo);%></div>
                        <%out.println("Ayın " + appointDayCo + helper.monthEki(Integer.parseInt(appointDayCo))); %> <br>
                        <%out.println(" Saat " + appointTimeCo);%>
                    </div>
                    <span class="badge bg-primary rounded-pill me-2"><%out.println(appointIdCo);%></span>
                    <br>
                    <span class="badge bg-success rounded-pill"><%out.println(locName);%></span>

                </li>

            </ol>
            <%}%>


        </div>
    </div>
</div>
<ul id="saatler" style="display: none;">

</ul>


</div>
<script src="js/script.js"></script>
<script>

    <% if (requestStr != null && requestStr.length() > 1) { %>
    clickButton();
    <% } %>

    function clickButton() {
        var myButton = document.getElementById("sucsessModalBtn");
        myButton.click();
    }

    const custnNameIn = document.getElementById('name-input');
    const custnSurnameIn = document.getElementById('surname-input');
    const custnPhoneIn = document.getElementById('phone-input');


    const custnNameHid = document.getElementById('cust-name');
    const custnSurnameHid = document.getElementById('cust-surname');
    const custnPhoneHid = document.getElementById('cust-phone');


    custnNameIn.value = "";
    custnSurnameIn.value = "";
    custnPhoneIn.value = "";


    custnNameIn.addEventListener('input', function () {
        custnNameHid.value = this.value;
    });
    custnSurnameIn.addEventListener('input', function () {
        custnSurnameHid.value = this.value;
    });
    custnPhoneIn.addEventListener('input', function () {
        custnPhoneHid.value = this.value;
    });
    custnNameHid.value = "";
    custnSurnameHid.value = "";
    custnPhoneHid.value = "";


    let phoneInput = document.getElementById("phone-input");
    phoneInput.addEventListener("input", function () {
        let phone = phoneInput.value;
        // Rakamları temizle
        phone = phone.replace(/\D/g, '');

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
    phoneInput.addEventListener("keypress", function (e) {
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
    document.getElementById("doctor-select").onchange = function () {
        // Seçilen seçeneğin değerini alın
        let selectedValue = this.value;

        // Değerin başka bir input öğesine atanması
        document.getElementById("doctor-name").value = selectedValue;
    };
    document.getElementById("location-select").onchange = function () {
        // Seçilen seçeneğin değerini alın
        let selectedValue = this.value;

        // Değerin başka bir input öğesine atanması
        document.getElementById("loc-name").value = selectedValue;
    };
    document.getElementById("apptype-select").onchange = function () {
        // Seçilen seçeneğin değerini alın
        let selectedValue = this.value;

        // Değerin başka bir input öğesine atanması
        document.getElementById("interval-type").value = selectedValue;
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

    // Günleri içeren bir dizi
    let specialDays = [];

    fetch('days.json')
        .then(response => response.json())
        .then(data => {
            specialDays = data.grayedOutDays;
            console.log(specialDays[0]);
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


    const inputField = document.getElementById('input-field');
    const submitButton = document.getElementById('submit-button');
    const outputContainer = document.getElementById('output-container');
    const errorMessage = document.getElementById('error-message');

    function checkInput() {
        const input = inputField.value.trim();
        if (/[^A-Za-z\s]/.test(input)) {
            errorMessage.textContent = "Metin yalnızca harfler ve boşluklar içermelidir.";
        } else {
            errorMessage.textContent = "";
            outputContainer.innerHTML = "<p>Girilen metin: " + input + "</p>";
        }
    }

    inputField.addEventListener('input', checkInput);


</script>
</body>
</html>