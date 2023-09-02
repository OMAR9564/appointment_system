
const currentDate = new Date();
let currentMonth = currentDate.getMonth();
let currentMonthName = getMonthName(currentMonth);
let currentYear = currentDate.getFullYear();
const calendarBody = document.querySelector(".calendar-body");
const daysContainer = document.querySelector(".days");
const currentMonthEl = document.querySelector("#current-month");
const prevMonthBtn = document.querySelector("#prev-month-btn");
const nextMonthBtn = document.querySelector("#next-month-btn");
const selectedDayEl = document.querySelector("#selected-day");
const hourButtonsContainer = document.querySelector(".hour-buttons");
// Add event listeners to previous and next month buttons
prevMonthBtn.addEventListener("click", showPrevMonth);
nextMonthBtn.addEventListener("click", showNextMonth);

let selectedOption = null
let _formatedDate = null;
function saveSelectedOption() {
    selectedOption = document.getElementById("add-interval").value;

    console.log("Seçilen seçenek:", selectedOption);
}

document.getElementById("add-interval").addEventListener("change", saveSelectedOption);

// Show the current month's calendar
fetchAndShowMonth(currentMonth, currentYear);
function fetchAndShowMonth(month, year) {
    fetch('../../../days.json', {
        method: 'GET',
        headers: {
            'Cache-Control': 'no-cache',  // Tarayıcı önbelleği devre dışı bırakılıyor
            'Pragma': 'no-cache'  // Eski HTTP/1.0 önbellek yönetimi için
        }
    })
        .then(response => response.json())
        .then(data => {
            let specialDays = [0,0];
            specialDays = data.grayedOutDays;
            showMonthWithSpecialDays(month, year, specialDays);
        })
        .catch(error => {
            console.error("Fetch hatası:", error);
        });

}

// Function to show the calendar for a given month and year
function showMonthWithSpecialDays(month, year, specialDays) {
    // Clear any existing days from the calendar
    daysContainer.innerHTML = "";

    // Set the header to show the current month and year
    currentMonthEl.innerHTML = `${getMonthName(month)} ${year}`;

    // Get the number of days in the month
    const numDays = getNumDaysInMonth(month, year);

    // Get the index of the first day of the month (0-6, Sun-Sat)
    const firstDayIndex = new Date(year, month, 1).getDay();

    // Günleri içeren bir dizi


    // Add empty day elements for days before the first day of the month
    for (let i = 1; i < firstDayIndex; i++) {
        const emptyDayEl = document.createElement("div");
        emptyDayEl.classList.add("day");
        daysContainer.appendChild(emptyDayEl);
    }

    // Add day elements for each day of the month
    for (let j = 1; j <= numDays; j++) {
        const dayEl = document.createElement("div");
        dayEl.classList.add("day");
        dayEl.innerHTML = j;

        const date = new Date(year, month, j);
        if (!isDateInCurrentMonth(date)) {
            dayEl.classList.add("disabled"); // Add the "disabled" class to non-current month days
            dayEl.style.pointerEvents = "none"; // Disable pointer events for non-current month days
        }
        const dayOfWeek = date.getDay();
        console.log(dayOfWeek);
        // Pazar ve Pazartesi günleri için etkileşimi devre dışı bırak
        if (specialDays.includes(dayOfWeek)) {
            dayEl.classList.add("disabled");
            dayEl.style.pointerEvents = "none";
        }

        if (year === currentDate.getFullYear() && month === currentDate.getMonth() && j === currentDate.getDate()) {
            dayEl.classList.add("today"); // Add the "today" class to the current day element
        }
        if (new Date(year, month, j) < new Date()) {
            dayEl.classList.add("disabled"); //Add the "disabled" class
        }
        //open today date for admins
        if (year === currentDate.getFullYear() && month === currentDate.getMonth() && j === currentDate.getDate()) {
            dayEl.classList.remove("disabled");
            dayEl.style.pointerEvents = "auto";
            dayEl.addEventListener("click", (event) => selectDay(event, firstDayIndex));

        }
        else {
            dayEl.addEventListener("click", (event) => selectDay(event, firstDayIndex));

        }
        daysContainer.appendChild(dayEl);
    }

    // Add empty day elements for days after the last day of the month
    const lastDayIndex = new Date(year, month, numDays).getDay();
    for (let i = lastDayIndex + 1; i < 7; i++) {
        const emptyDayEl = document.createElement("div");
        emptyDayEl.classList.add("day");
        daysContainer.appendChild(emptyDayEl);
    }

    // Set the selected day to today's date
    const today = new Date();
    if (month === today.getMonth() && year === today.getFullYear()) {
        selectDay(today.getDate(), firstDayIndex);
    }
}


// Function to show the previous month's calendar
function showPrevMonth() {
    if (currentMonth === 0) {
        currentMonth = 11;
        currentYear--;
    } else {
        currentMonth--;
    }
    fetchAndShowMonth(currentMonth, currentYear);
}

//filtering days to only this month and the next 30 days
function isDateInCurrentMonth(date) {
    const currentDate = new Date();
    const thirtyDaysFromNow = new Date();
    thirtyDaysFromNow.setDate(currentDate.getDate() + 30);

    return date >= currentDate && date <= thirtyDaysFromNow;
}

// Function to show the next month's calendar
function showNextMonth() {
    if (currentMonth === 11) {
        currentMonth = 0;
        currentYear++;
    } else {
        currentMonth++;
    }
    fetchAndShowMonth(currentMonth, currentYear);
}

let selectedDate = null;
let selectedHour = null;


function selectDay(event, firstDayIndex) {
    // const hours = ["09:00-10:00", "10:00-11:00", "11:00-12:00", "12:00-13:00", "13:00-14:00", "14:00-15:00", "15:00-16:00", "16:00-17:00", "17:00-18:00"];
    // Remove the active class from any previously selected day
    const activeDayEl = document.querySelector(".day.active");
    if (activeDayEl) {
        activeDayEl.classList.remove("active");
    }


// Add the active class to the selected day
    const selectedDayEl = event ? event.target : document.querySelector(`.day:not(.empty):nth-child(${currentDate.getDate() + firstDayIndex})`);
    selectedDayEl.classList.add("active");

// Show the selected day's date and hours
    const selectedDate = new Date(currentYear, currentMonth, selectedDayEl.innerHTML);
    const selectedDayStr = `${selectedDayEl.innerHTML} ${getMonthName(currentMonth)} ${currentYear}`;
    document.querySelector("#selected-date").innerHTML = selectedDayStr;
    const warningMessage = document.getElementById("warning-message")
    const formattedDate = formatDate(selectedDate);
    const intervalType = document.getElementById("interval-type");
    var selectDoctor = document.getElementById("doctor-name").value;

    _formatedDate = formattedDate;
// Sonucu kontrol etmek için
    console.log("Selected Doctor: " + selectDoctor);

    var hours = []; // Boş bir dizi oluşturun

    var xhttp = new XMLHttpRequest();
    var url = "/get_available_hours" + "?selectedDate=" + encodeURIComponent(formattedDate) + "&selectedOption=" + encodeURIComponent(selectedOption) + "&selectedDoktor=" + encodeURIComponent(selectDoctor);
    xhttp.open("GET", url, true);
    xhttp.send();
    xhttp.onreadystatechange = function () {
        if (this.readyState === 4 && this.status === 200) {
            var hoursList = JSON.parse(this.responseText);
            var hoursContainer = document.getElementById("saatler");
            hoursContainer.innerHTML = ""; // Temizleme

            for (var i = 0; i < hoursList.length; i++) {
                var hourItem = document.createElement("li");
                hourItem.textContent = hoursList[i].appHour;
                hoursContainer.appendChild(hourItem);
                console.log(hoursList[i]);
                // hourlist'e saatleri ekleyelim
                hours.push(hoursList[i].appHour);

            }
            console.log(intervalType.value);
            if (hours.length === 0 && intervalType.value !== "") {
                let temp = "Maalesef, bugün için uygun randevu seçeneği bulunmamaktadır. Lütfen başka bir tarih seçmeyi deneyin.";
                warningMessage.textContent = temp;
                warningMessage.style.display = "inline";

            } else if ((hours.length === 0 && intervalType.value === "")) {
                let temp = "Önce gerekli bilgileri doldurmanız gerekir.";
                warningMessage.textContent = temp;
                warningMessage.style.display = "inline";

            } else {
                warningMessage.style.display = "none";
            }
        }
        console.log(hours.length);
        for (let i = 0; i < hours.length; i++) {
            console.log("om");
            const hourButtonEl = document.createElement("button");
            hourButtonEl.classList.add("hour-button");
            hourButtonEl.innerHTML = hours[i];
            hourButtonsContainer.appendChild(hourButtonEl);

            // Add event listener to select the hour
            hourButtonEl.addEventListener("click", () => {

                const selectedHour = hours[i];
                const selectedDateTime = new Date(currentYear, currentMonth, selectedDayEl.innerHTML, selectedHour);
                const selectedDateTimeStr = `${selectedDayEl.innerHTML} ${getMonthName(currentMonth)} ${currentYear}, ${selectedHour}`;
                const selectedYear = `${currentYear}`;
                const selectedMonth = `${getMonthName(currentMonth)}`;
                document.querySelector("#selected-date").innerHTML = selectedDateTimeStr;


                // Set the selected date and time to the hidden input element
                document.querySelector("#selected-year").value = selectedYear;
                document.querySelector("#selected-month").value = selectedMonth;
                document.querySelector("#selected-dayIn").value = selectedDayEl.innerHTML;
                document.querySelector("#selected-hour").value = selectedHour;

                // Remove the active class from any previously selected hour
                const activeHourEl = document.querySelector(".hour-button.active");
                if (activeHourEl) {
                    activeHourEl.classList.remove("active");
                }

                // Add the active class to the selected hour
                hourButtonEl.classList.add("active");

                // Show the "randevu al" button
                const randevuAlBtn = document.querySelector("#schedule-appointment");

                // Check if all input fields are not empty before showing the button
                const yearInput = document.querySelector("#selected-year").value;
                const monthInput = document.querySelector("#selected-month").value;
                const dayInput = document.querySelector("#selected-dayIn").value;
                const hourInput = document.querySelector("#selected-hour").value;
                const nameInput = document.querySelector("#name-input").value;
                const surnameInput = document.querySelector("#surname-input").value;


                if (yearInput !== "" && monthInput !== "" && dayInput !== "" && hourInput !== "" && nameInput !== "" && surnameInput !== "") {
                    randevuAlBtn.style.display = "inline";
                    console.log("om222er");

                    warningMessage.style.display = "none";

                } else {
                    randevuAlBtn.style.display = "none";

                    let temp = "Önce gerekli bilgileri doldurmanız gerekir.";
                    warningMessage.textContent = temp;
                    console.log("om222er");
                    warningMessage.style.display = "inline";
                }

            });


        }
    };


// Clear any existing hour buttons from the container
    hourButtonsContainer.innerHTML = "";


// Add hour buttons for each hour of the selected day

    function formatDate(inputDate) {
        const date = new Date(inputDate);
        const day = String(date.getDate()).padStart(2, '0');
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const year = date.getFullYear();
        return `${year}-${month}-${day}`;
    }

    console.log("omer")


    document.querySelector("#calendar").addEventListener("click", () => {
        // Clear the selected date and time

        document.querySelector("#selected-year").value = "";
        document.querySelector("#selected-month").value = "";
        document.querySelector("#selected-dayIn").value = "";
        document.querySelector("#selected-hour").value = "";
    });
    const hourButtons = document.querySelector(".hour-button");

    hourButtons.forEach(function (button) {
        button.addEventListener("click", function () {

            const activeHourEl = document.querySelector(".hour-button.active");
            if (activeHourEl) {
                activeHourEl.classList.remove("active");
            }
            button.classList.add("active");
            // Check if both date and hour are selected
            const selectedDateEl = document.querySelector("#selected-date");
            const selectedHourEl = document.querySelector(".hour-button.active");
            const randevuAlBtn = document.querySelector("#schedule-appointment");

            if (selectedDateEl.innerHTML !== "" && selectedHourEl !== null) {
                randevuAlBtn.style.display = "inline";
            } else {
                randevuAlBtn.style.display = "none";
            }
        });
    });


}


// Initialize the calendar on page load
fetchAndShowMonth(currentMonth, currentYear);

// Select today's date and hours by default
selectDay();
selectHour();

function getDayOfWeek(year, month, day) {
    const date = new Date(year, month, day);
    return date.getDay();
}

// Add event listener to reset button to clear any active selection
const resetBtn = document.querySelector("#reset-btn");
resetBtn.addEventListener("click", () => {
    const activeDayEl = document.querySelector(".day.active");
    if (activeDayEl) {
        activeDayEl.classList.remove("active");
    }

    const activeHourEl = document.querySelector(".hour-button.active");
    if (activeHourEl) {
        activeHourEl.classList.remove("active");
    }

    document.querySelector("#selected-date").innerHTML = "";
    hourButtonsContainer.innerHTML = "";
});

// Function to get the number of days in a given month and year
function getNumDaysInMonth(month, year) {
    return new Date(year, month + 1, 0).getDate();
}


// Function to get the name of a month from its index (0-11)
function getMonthName(monthIndex) {
    const monthNames = [
        "Ocak",
        "Şubat",
        "Mart",
        "Nisan",
        "Mayıs",
        "Haziran",
        "Temmuz",
        "Ağustos",
        "Eylül",
        "Ekim",
        "Kasım",
        "Aralık"
    ];
    return monthNames[monthIndex];
}
function validateForm() {
    var selectedYear = document.getElementById("selected-year").value;
    var selectedMonth = document.getElementById("selected-month").value;
    var selectedDayIn = document.getElementById("selected-dayIn").value;
    var custName = document.getElementById("cust-name").value;
    var custSurname = document.getElementById("cust-surname").value;
    var doctorName = document.getElementById("doctor-name").value;
    var locName = document.getElementById("loc-name").value;
    var intervalType = document.getElementById("interval-type").value;

    if (checkForSpecialChars(selectedYear) || checkForSpecialChars(selectedMonth)
        || checkForSpecialChars(selectedDayIn) || checkForSpecialChars(custName)
        || checkForSpecialChars(custSurname) || checkForSpecialChars(doctorName)
        || checkForSpecialChars(locName) || checkForSpecialChars(intervalType)) {
        var temp = "Lütfen özel karakter kullanmayın.";
        var warningMessage = document.getElementById("warning-message");
        warningMessage.style.display = "inline";
        warningMessage.textContent = temp;
        return false;
    } else {
        var warningMessage = document.getElementById("warning-message");
        warningMessage.style.display = "none";
    }

    return true; // Form gönderilir
}