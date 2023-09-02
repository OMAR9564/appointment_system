<%@ page import="com.bya.Helper" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="com.bya.ConSql" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.bya.GetInfo" %>
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
/*
    String selectedDate = null;
*/
    ArrayList<GetInfo> locationNames = new ArrayList<>();
    ArrayList<GetInfo> doctorInfo = new ArrayList<>();
    ArrayList<GetInfo> rezervationInfo = new ArrayList<>();
    ArrayList<GetInfo> companyName = new ArrayList<>();
    ArrayList<GetInfo> messageBody = new ArrayList<>();
    ArrayList<GetInfo> messageTitle = new ArrayList<>();
    ArrayList<GetInfo> holiday = new ArrayList<>();


    String locationsQuery = "SELECT * FROM locationInfo";
    String doctorsQuery = "SELECT * FROM `doctorInfo`";
    String rezervationQuery = "SELECT * FROM `reservationInfo`";
    String companyNameQuery = "SELECT companyName FROM settings";
    String appointMessageBody = "SELECT appointMessageBody FROM settings";
    String appointMessageTitle = "SELECT appointMessageTitle FROM settings";
    String holidayQuery = "SELECT holiday FROM settings";


    ConSql conSql = new ConSql();
    locationNames = conSql.getInfos(locationsQuery);
    doctorInfo = conSql.getInfos(doctorsQuery);
    rezervationInfo = conSql.getRezervationInfos(rezervationQuery);
    companyName = conSql.getSettingName(companyNameQuery);
    messageBody = conSql.getSettingName(appointMessageBody);
    messageTitle = conSql.getSettingName(appointMessageTitle);
    holiday = conSql.getSettingName(holidayQuery);

    String appointmentMadeStr = messageBody.get(0).getName();
    String appointmentNotMadeStr = "Randevu oluştururken bir hata oluştu! \nLütfen daha sonra deneyin.";

    String appointmentMadeHeader = messageTitle.get(0).getName();
    String appointmentNotMadeHeader = "Bir Hata Oluştu";

    String holidayName = holiday.get(0).getName();

    String locName = "";

    String companyNameTitle = companyName.get(0).getName();

    String requestStr = request.getParameter("message");
    String discroption = (request.getParameter("dic"));



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
                <input type="text" class="form-control validate-input" id="name-input" name="name-input" maxlength="20"
                       required
                       oninput="blockSpecialChars('name-input')">
            </div>
            <div class="form-group">
                <label for="surname-input">Soyadınız:</label>
                <input type="text" class="form-control validate-input" id="surname-input" name="surname-input"
                       maxlength="20" required
                       oninput="blockSpecialChars('surname-input')">
            </div>
            <div class="form-group">
                <label for="phone-input">Telefon Numaranız:</label>
                <input type="tel" class="form-control validate-input" id="phone-input" name="phone-input" required>
            </div>

            <div class="form-group">
                <label for="doctor-select">Doktor seçin:</label>
                <select class="form-control validate-input" id="doctor-select">
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
                <select class="form-control validate-input" id="apptype-select">
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
                <select class="form-control validate-input" id="location-select">
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
                    <div class="modal-content" style="border-radius: 15px;">
                        <div class="modal-header">
                            <h1 id="sucsess-modal" class="modal-title fs-5" style="margin-left: -10px;">
                                <%
                                    if (appointmentMade) {
                                %>

                                <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" class="bi bi-check-lg text-success"
                                     width="30" height="30" viewBox="0 0 10 17">
                                    <path d="M12.736 3.97a.733.733 0 0 1 1.047 0c.286.289.29.756.01 1.05L7.88 12.01a.733.733 0 0 1-1.065.02L3.217 8.384a.757.757 0 0 1 0-1.06.733.733 0 0 1 1.047 0l3.052 3.093 5.4-6.425a.247.247 0 0 1 .02-.022Z"></path>
                                </svg>


                                <%
                                    out.println(appointmentMadeHeader);
                                } else {

                                %>

                                <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor"
                                     class="bi bi-exclamation-lg text-danger" viewBox="0 0 10 17">
                                    <path d="M7.005 3.1a1 1 0 1 1 1.99 0l-.388 6.35a.61.61 0 0 1-1.214 0L7.005 3.1ZM7 12a1 1 0 1 1 2 0 1 1 0 0 1-2 0Z"/>
                                </svg>


                                <%
                                        out.println(appointmentNotMadeHeader);
                                    }
                                %>
                            </h1>
                        </div>
                        <div class="modal-body">
                            <p class="text-center">
                                <%
                                    if (appointmentMade) {
                                %>
                                <svg xmlns="http://www.w3.org/2000/svg" width="21" height="21" fill="currentColor" class="bi bi-check2-circle text-success" viewBox="0 0 16 16">
                                    <path d="M2.5 8a5.5 5.5 0 0 1 8.25-4.764.5.5 0 0 0 .5-.866A6.5 6.5 0 1 0 14.5 8a.5.5 0 0 0-1 0 5.5 5.5 0 1 1-11 0z"/>
                                    <path d="M15.354 3.354a.5.5 0 0 0-.708-.708L8 9.293 5.354 6.646a.5.5 0 1 0-.708.708l3 3a.5.5 0 0 0 .708 0l7-7z"/>
                                </svg>
                                <%
                                    out.println(appointmentMadeStr);

                                %>
                            </p>
                            <%
                            } else {

                            %>
                            <p class="text-center">
                                <svg xmlns="http://www.w3.org/2000/svg" width="21" height="21" fill="currentColor" class="bi bi-x-circle text-danger" viewBox="0 0 16 16">
                                    <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                                    <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>
                                </svg>
                                <%
                                        out.println(appointmentNotMadeStr);
                                    }
                                %>
                            </p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Kapat</button>
                        </div>
                    </div>
                </div>
            </div>


            <%--<div class="row row-cols-4" style="margin-right: 11px;padding-top: 5px;">
                <div class="col-10">
                    <div class=" form-floating mt-2" style="padding-right: 0px;">
                        <input type="text" class="form-control validate-input" id="floatingInputGrid"
                               placeholder="xxx-xxx">
                        <label for="floatingInputGrid">Randevu duzeltmek icin kodu giriniz</label>
                    </div>
                </div>
                <div class="col-2" style="padding-top: 5px;padding-left: -1px;padding-right: 15px;margin-right: 0px;">
                    <button type="button" class="btn btn-info mt-2 btn-lg">Info</button>
                </div>
            </div>--%>

            <%
                Helper helper = new Helper();
                helper.writeJsonFile(holidayName);
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
                        locName = locName.replace("Merkezi", "Mer.");
                    }
            %>


            <div class="list-group list-group-numbered mt-5">
                <div class="list-group-item d-flex justify-content-between align-items-start" style="border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.2);">
                    <div class="ms-2 me-auto">
                        <div class="fw-bold"><%out.println(firstNameWithSpaceCo + " " + lastNamWithSpaceCo);%></div>
                        <%out.println("Ayın " + appointDayCo + helper.monthEki(Integer.parseInt(appointDayCo))); %> <br>
                        <%out.println(" Saat " + appointTimeCo);%>
                    </div>
<%--
                    <span class="badge bg-primary rounded-pill me-2"><%out.println(appointIdCo);%></span>
--%>
                    <br>
                    <span class="badge bg-success rounded-pill" style="vertical-align: baseline; text-align: right;"><%out.println(locName);%></span>

                </div>

            </div>

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
    phoneInput.addEventListener("input", function (event) {
        let phone = phoneInput.value;

        // Parantez içerisindeki karakterleri sil
        if (event.inputType === "deleteContentBackward" && phone.charAt(phone.length - 1) === ")") {
            phone = phone.substring(0, phone.length - 2);
        }

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
</body>
</html>