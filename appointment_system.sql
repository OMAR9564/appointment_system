-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Anamakine: localhost
-- Üretim Zamanı: 10 Eyl 2023, 15:18:06
-- Sunucu sürümü: 10.4.28-MariaDB
-- PHP Sürümü: 8.0.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `appointment_system`
--

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `appointments`
--

CREATE TABLE `appointments` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL,
  `surname` text NOT NULL,
  `phone` text NOT NULL,
  `doctorId` text NOT NULL,
  `locationId` text NOT NULL,
  `tempId` int(11) DEFAULT NULL,
  `date` text NOT NULL,
  `startHour` text NOT NULL,
  `endHour` text NOT NULL,
  `intervalId` text NOT NULL,
  `eventID` text NOT NULL,
  `status` text NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `appointments`
--

INSERT INTO `appointments` (`id`, `name`, `surname`, `phone`, `doctorId`, `locationId`, `tempId`, `date`, `startHour`, `endHour`, `intervalId`, `eventID`, `status`, `createdAt`) VALUES
(115, 'test', 'test', '(123) 123-1231', '1', '1', 431874, '2023-08-27', '10:00', '11:00', 'single', '6qorsgd6agdthib1b5fqb90hsg', 'Onaylanıyor', '2023-08-27 19:59:22'),
(116, 'Omer', 'Faruk', '(123) 123-1231', '1', '1', 608023, '2023-08-28', '13:00', '14:00', 'single', '7ojh2f22a76ol7te5cg81vr080', 'Onaylanıyor', '2023-08-27 19:59:22'),
(117, 'Ahmet', 'Ahmet', '(123) 123-1231', '2', '1', 525359, '2023-08-28', '10:00', '11:00', 'single', '1a0pf33dc3r51v44nshv0o96h8', 'Onaylanıyor', '2023-08-27 19:59:22'),
(118, 'Omer', 'Omer', '(123) 123-1231', '2', '2', 874818, '2023-08-28', '16:00', '17:00', 'single', 'jm644t6uobe93gt6gmed8voj14', 'Onaylanıyor', '2023-08-27 19:59:22'),
(119, 'Halit', 'Halit', '(234) 124-1241', '1', '2', 671369, '2023-08-28', '14:00', '15:00', 'single', '6pdts6bh8nru8i848sul7n0ug4', 'Onaylanıyor', '2023-08-27 19:59:22'),
(120, 'Azra', 'Azra', '(123) 123-1231', '2', '1', 989082, '2023-08-28', '11:00', '12:00', 'single', 't2jb8ph3b2qqcs43jr7bg41nd4', 'Onaylanıyor', '2023-08-27 19:59:22'),
(121, 'Rania', 'Rania', '(123) 123-1231', '2', '2', 874509, '2023-08-28', '14:00', '15:00', 'single', 'mni811mllcn4qm9l3h56j6l45c', 'Onaylanıyor', '2023-08-27 19:59:22'),
(123, '123', '123', '(123) 123-1231', '2', '1', 725780, '2023-08-28', '13:00', '14:00', 'single', 'tnoqlt5bcv1ipiv7qu0dq8t24g', 'Onaylanıyor', '2023-08-27 19:59:22'),
(125, 'test', '123123', '(123) 123-1231', '1', '2', 990456, '2023-08-28', '17:00', '18:00', 'single', '0hdtbboksu6lvppnf2m76dkous', 'Onaylandı', '2023-08-27 19:59:22'),
(133, 'testzz', 'xdf', '(123) 123-1231', '2', '1', 714630, '2023-08-28', '17:00', '18:00', 'single', 'veqag1irngq9rb6424rqaosr0k', 'Onaylanıyor', '2023-08-27 19:59:22'),
(134, 'test22222', 'etse', '(123) 123-1231', '2', '1', 763703, '2023-08-28', '12:00', '13:00', 'single', 'ndqi1q2jp4r63qf80f38jln44k', 'Onaylanıyor', '2023-08-27 19:59:22'),
(135, 'ppppppp', 'pppppp', '(123) 123-1231', '2', '1', 551119, '2023-08-28', '15:00', '16:00', 'single', '73g0unvnc1lrg3r0hk6va18qco', 'Onaylanıyor', '2023-08-27 19:59:22'),
(136, 'nnnnnn', '123123123', '(123) 123-1231', '2', '1', 391705, '2023-08-28', '15:00', '16:00', 'single', '347a1kv2iv94114aqg083701bs', 'Onaylanıyor', '2023-08-27 19:59:22'),
(137, 'Sabah', 'Saati', '(123) 123-1231', '1', '1', 879641, '2023-08-29', '09:00', '10:00', 'single', 'glgphf3hgl38teoh0bjqegf4pg', 'Onaylanıyor', '2023-08-28 06:39:46'),
(138, 'code', 'code', '(123) 123-1231', '1', '1', 100106, '2023-08-29', '10:00', '11:00', 'single', 'jn2cbat0dt96rngv4n77mgtnm0', 'Onaylandı', '2023-08-28 06:40:30'),
(139, 'Testqqqq', 'testqqq', '(123) 123-1231', '1', '1', 153938, '2023-08-29', '12:30', '14:00', 'couple', 'iooll1ssc1sebr1q4v3bm0tkis', 'Onaylandı', '2023-08-28 06:42:27'),
(140, 'teset', '1rae11', '(123) 123-1231', '2', '1', 598632, '2023-08-31', '09:30', '10:30', 'single', 'e26l0r4034an5hqs3uac9hkd4o', 'Onaylanıyor', '2023-08-28 06:43:34'),
(141, 'resrser', 'test', '(123) 123-1231', '1', '1', 308753, '2023-08-28', '10:00', '11:00', 'single', '8pef9hiebb5s9cpiv5bq3kmfk4', 'Onaylandı', '2023-08-28 07:02:26'),
(142, 'test', 'tset', '(123) 123-1231', '1', '1', 837753, '2023-09-02', '09:00', '10:00', 'single', '3vvpjetdvcudliq21g6dvdtrn0', 'Onaylandı', '2023-09-01 07:19:44'),
(143, '�mir', '�ak�r', '(123) 123-1231', '1', '1', 586226, '2023-09-02', '10:00', '11:00', 'single', 'mn5sv0j2b94nlmes5n9u9qqjr0', 'Onaylandı', '2023-09-01 07:22:20'),
(144, '�al��kan', 'Ka�an', '(123) 123-1231', '1', '1', 761688, '2023-09-02', '11:00', '12:00', 'single', 'p9ib3dd9fn52vq46rhn54lck1g', 'Onaylandı', '2023-09-01 07:23:35'),
(145, 'Kağan', 'Kağan', '(123) 123-1231', '1', '2', 130340, '2023-09-02', '12:00', '13:00', 'single', '2u2pve182j20i3rvqbv22378vg', 'Onaylandı', '2023-09-01 07:24:07'),
(146, 'test', 'test', '(213) 123-1231', '1', '1', 274242, '2023-09-02', '13:00', '14:00', 'single', '3497t0g8ouf4ugtj21tivfjfqk', 'Onaylandı', '2023-09-01 08:01:29'),
(148, 'Omer', 'FAruk', '(123) 123-1231', '1', '1', 574776, '2023-09-01', '09:00', '10:00', 'single', 'a9d8mtii8eq013h2vvpuidvft4', 'Onaylandı', '2023-09-01 13:49:50'),
(149, 'test', 'test', '(123) 123-1231', '1', '1', 723607, '2023-09-01', '11:00', '12:30', 'couple', 'c0ioc7sfkvcnl1dqs04jj8qsjc', 'Onaylandı', '2023-09-01 14:04:32'),
(150, 'terst', 'test', '(123) 123-1231', '1', '1', 145503, '2023-09-01', '12:30', '14:00', 'couple', 'pbneqv8pcg5imbr5g60g9nkpf8', 'Onaylandı', '2023-09-01 14:08:43'),
(151, 'dasf', 'adsf', '(123) 123-1231', '1', '1', 823830, '2023-09-01', '14:00', '15:00', 'single', 'cpe00knd0br14mrq66tmq637b8', 'Onaylandı', '2023-09-01 14:33:05'),
(152, 'afds', 'asdf', '(123) 123-1231', '3', '1', 610742, '2023-09-04', '09:00', '10:00', 'single', 'Error - com.google.api.client.googleapis.json.GoogleJsonResponseException: 404 Not Found\nPOST https://www.googleapis.com/calendar/v3/calendars/ID/events\n{\n  \"code\" : 404,\n  \"errors\" : [ {\n    \"domain\" : \"global\",\n    \"message\" : \"Not Found\",\n    \"reason\" : \"notFound\"\n  } ],\n  \"message\" : \"Not Found\"\n}', 'Onaylanıyor', '2023-09-02 11:01:29'),
(154, 'test', 'etst', '(123) 123-1231', '1', '1', 438332, '2023-09-04', '09:00', '10:00', 'single', 'ef36bilsi8tgacbam4495v5q7c', 'Onaylandı', '2023-09-02 11:53:41'),
(155, 'OmerFARuyk', '123123', '(123) 123-1231', '1', '1', 581621, '2023-09-02', '14:00', '15:00', 'single', 'u18rsm98ob9euj3p4e2kqqs5o8', 'Onaylandı', '2023-09-02 11:54:50'),
(157, 'test', 'test', '(123) 123-1231', '1', '1', 154785, '2023-09-04', '10:00', '11:00', 'single', 'Error - com.google.api.client.googleapis.json.GoogleJsonResponseException: 404 Not Found\nPOST https://www.googleapis.com/calendar/v3/calendars/38339efb491448da532c4d5ac23590c5975231b7fb849f38cc01f597cc0ff112@group.calendar.google.com/events\n{\n  \"code\" : 404,\n  \"errors\" : [ {\n    \"domain\" : \"global\",\n    \"message\" : \"Not Found\",\n    \"reason\" : \"notFound\"\n  } ],\n  \"message\" : \"Not Found\"\n}', 'Onaylandı', '2023-09-02 13:03:04'),
(158, 'test', 'test', '(123) 123-1231', '1', '1', 429499, '2023-09-04', '11:00', '12:00', 'single', 'Error - com.google.api.client.googleapis.json.GoogleJsonResponseException: 403 Forbidden\nPOST https://www.googleapis.com/calendar/v3/calendars/38339efb491448da532c4d5ac23590c5975231b7fb849f38cc01f597cc0ff112@group.calendar.google.com/events\n{\n  \"code\" : 403,\n  \"errors\" : [ {\n    \"domain\" : \"calendar\",\n    \"message\" : \"You need to have writer access to this calendar.\",\n    \"reason\" : \"requiredAccessLevel\"\n  } ],\n  \"message\" : \"You need to have writer access to this calendar.\"\n}', 'Onaylandı', '2023-09-02 13:05:47'),
(159, 'test', 'test', '(123) 123-1231', '1', '1', 707916, '2023-09-04', '12:00', '13:00', 'single', 'l9snbmjoqfqmfm21jhe25tovds', 'Onaylandı', '2023-09-02 13:11:35'),
(160, 'yyy', 'yyyy', '(123) 123-1231', '1', '1', 523449, '2023-09-04', '17:00', '18:00', 'single', 'm7lkof62vkofmnqv1k8c48b950', 'Onaylandı', '2023-09-02 13:12:20'),
(161, 'qqq', 'qqqq', '(123) 123-1231', '1', '2', 211232, '2023-09-04', '13:00', '14:00', 'single', '5nck7l0qm7rrba9qujsmqk2eq0', 'Onaylandı', '2023-09-02 13:16:55'),
(162, 'test', 'test', '(123) 123-1231', '1', '1', 946483, '2023-09-04', '14:00', '15:00', 'single', 'Error - com.google.api.client.googleapis.json.GoogleJsonResponseException: 404 Not Found\nPOST https://www.googleapis.com/calendar/v3/calendars/b94509cfa3c7765b0b8f2998646ce37c8d53b24765df5edc3b8da667d692f667@group.calendar.google.com/events\n{\n  \"code\" : 404,\n  \"errors\" : [ {\n    \"domain\" : \"global\",\n    \"message\" : \"Not Found\",\n    \"reason\" : \"notFound\"\n  } ],\n  \"message\" : \"Not Found\"\n}', 'Onaylandı', '2023-09-02 13:36:09'),
(163, 'test', 'test', '(123) 123-1231', '1', '1', 194287, '2023-09-04', '15:00', '16:00', 'single', 'mo16tuefvimlr98uquu7aqk8mc', 'Onaylandı', '2023-09-02 13:36:41'),
(164, 'test', 'test', '(123) 123-1231', '1', '1', 654238, '2023-09-04', '16:00', '17:00', 'single', 'Error - com.google.api.client.googleapis.json.GoogleJsonResponseException: 404 Not Found\nPOST https://www.googleapis.com/calendar/v3/calendars/b94509cfa3c7765b0b8f2998646ce37c8d53b24765df5edc3b8da667d692f667@group.calendar.google.com/events\n{\n  \"code\" : 404,\n  \"errors\" : [ {\n    \"domain\" : \"global\",\n    \"message\" : \"Not Found\",\n    \"reason\" : \"notFound\"\n  } ],\n  \"message\" : \"Not Found\"\n}', 'Onaylandı', '2023-09-02 14:09:44'),
(165, 'omar', 'alfarouk', '(531) 254-1234', '1', '1', 534872, '2023-09-11', '09:00', '10:00', 'single', 'rj1dm3u3jhnuvji7d5cfc02a7k', 'Onaylandı', '2023-09-10 10:30:31'),
(167, 'test', '111111', '(123) 123-1231', '1', '1', 616561, '2023-09-11', '10:00', '11:00', 'single', 'Error - com.google.api.client.googleapis.json.GoogleJsonResponseException: 404 Not Found\nPOST https://www.googleapis.com/calendar/v3/calendars/b94509cfa3c7765b0b8f2998646ce37c8d53b24765df5edc3b8da667d692f667@group.calendar.google.com/events\n{\n  \"code\" : 404,\n  \"errors\" : [ {\n    \"domain\" : \"global\",\n    \"message\" : \"Not Found\",\n    \"reason\" : \"notFound\"\n  } ],\n  \"message\" : \"Not Found\"\n}', 'Onaylandı', '2023-09-10 11:36:28'),
(168, '1211221', '12211212', '(112) 121-2121', '1', '1', 368033, '2023-09-11', '11:00', '12:00', 'single', 'Error - com.google.api.client.googleapis.json.GoogleJsonResponseException: 404 Not Found\nPOST https://www.googleapis.com/calendar/v3/calendars/b94509cfa3c7765b0b8f2998646ce37c8d53b24765df5edc3b8da667d692f667@group.calendar.google.com/events\n{\n  \"code\" : 404,\n  \"errors\" : [ {\n    \"domain\" : \"global\",\n    \"message\" : \"Not Found\",\n    \"reason\" : \"notFound\"\n  } ],\n  \"message\" : \"Not Found\"\n}', 'Onaylandı', '2023-09-10 11:38:33'),
(171, 'adf', 'asd', '(213) 123-1231', '1', '1', 345296, '2023-09-10', '09:00', '10:00', 'single', 'Error - com.google.api.client.googleapis.json.GoogleJsonResponseException: 404 Not Found\nPOST https://www.googleapis.com/calendar/v3/calendars/b94509cfa3c7765b0b8f2998646ce37c8d53b24765df5edc3b8da667d692f667@group.calendar.google.com/events\n{\n  \"code\" : 404,\n  \"errors\" : [ {\n    \"domain\" : \"global\",\n    \"message\" : \"Not Found\",\n    \"reason\" : \"notFound\"\n  } ],\n  \"message\" : \"Not Found\"\n}', 'Onaylandı', '2023-09-10 12:36:04'),
(172, 'kaka', 'kaka', '(123) 123-1231', '1', '1', 875361, '2023-09-11', '12:00', '13:00', 'single', 'v5npoi0ffb9vloko4kj8igthpg', 'Onaylandı', '2023-09-10 12:39:09'),
(173, 'test', 'test', '(123) 123-1231', '1', '1', 446689, '2023-09-10', '10:00', '11:00', 'single', 'j0v1mgmhurqt9ldufn0p66bloo', 'Onaylandı', '2023-09-10 12:39:37'),
(175, 'Ömer Faruk', 'You ', '(538) 502-8957', '1', '1', 189493, '2023-09-11', '14:00', '15:00', 'single', 'tfqgt6j2tbglmakrk3ikvvropg', 'Onaylandı', '2023-09-10 13:10:38');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `customer`
--

CREATE TABLE `customer` (
  `name` text NOT NULL,
  `surname` text NOT NULL,
  `phone` text NOT NULL,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dailyOCHour`
--

CREATE TABLE `dailyOCHour` (
  `id` int(11) NOT NULL,
  `day` text NOT NULL,
  `openingHour` text NOT NULL,
  `closingHour` text NOT NULL,
  `userId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `dailyOCHour`
--

INSERT INTO `dailyOCHour` (`id`, `day`, `openingHour`, `closingHour`, `userId`) VALUES
(1, '2023-08-30', '0', '0', 1),
(5, '2023-08-29', '0', '0', 2);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `doctorInfo`
--

CREATE TABLE `doctorInfo` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL,
  `userId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `doctorInfo`
--

INSERT INTO `doctorInfo` (`id`, `name`, `userId`) VALUES
(1, 'Uzm. Psk. Hilal Kara', 1),
(2, 'Uzm. Psk. Birsen ÇINAR', 2);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `locationInfo`
--

CREATE TABLE `locationInfo` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `locationInfo`
--

INSERT INTO `locationInfo` (`id`, `name`) VALUES
(1, 'Loya Psikolojik Danışmanlık Merkezi'),
(2, 'Online');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `reservationInfo`
--

CREATE TABLE `reservationInfo` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL,
  `hourInterval` text NOT NULL,
  `tagName` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `reservationInfo`
--

INSERT INTO `reservationInfo` (`id`, `name`, `hourInterval`, `tagName`) VALUES
(1, 'Bireysel Randevusu', '1', 'single'),
(2, 'Çift Randevusu', '1.30', 'couple');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `settings`
--

CREATE TABLE `settings` (
  `id` int(11) NOT NULL,
  `companyName` text NOT NULL DEFAULT 'Loya Psikolojik Danışmanlık Merkezi',
  `openingHour` text NOT NULL DEFAULT '09:00',
  `closingHour` text NOT NULL DEFAULT '18:00',
  `appointMessageBody` text NOT NULL DEFAULT 'Randevunuz başarılı bir şekilde alındı.',
  `appointMessageTitle` text NOT NULL DEFAULT 'Randevunuz Alındı.',
  `holiday` text NOT NULL DEFAULT 'Pazar',
  `calendarID` text NOT NULL DEFAULT 'ID',
  `userId` int(11) NOT NULL,
  `appointmentStatus` text NOT NULL DEFAULT 'Onaylanıyor'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `settings`
--

INSERT INTO `settings` (`id`, `companyName`, `openingHour`, `closingHour`, `appointMessageBody`, `appointMessageTitle`, `holiday`, `calendarID`, `userId`, `appointmentStatus`) VALUES
(1, 'Loya Psikolojik Danışmanlık Merkezi', '09:00', '18:00', 'Randevunuz Basirili Bir Sekilde Alindi.', 'Randevunuz Alindi.', 'Pazar', 'b94509cfa3c7765b0b8f2998646ce37c8d53b24765df5edc3b8da667d692f667@group.calendar.google.com', 1, 'Onaylandı'),
(2, 'Loya Psikolojik Danışmanlık Merkezi', '09:00', '18:00', 'Randevunuz başarılı bir şekilde alındı.', 'Randevunuz Alındı.', 'Pazar', 'dabb8218ed6224c0edc208dcc68b9c2e10820c7d46b27a04759f4025fe625490@group.calendar.google.com', 2, 'Onaylanıyor');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL,
  `surname` text NOT NULL,
  `username` text NOT NULL,
  `email` text NOT NULL,
  `pass` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `user`
--

INSERT INTO `user` (`id`, `name`, `surname`, `username`, `email`, `pass`) VALUES
(1, 'Hilal', 'KARA', 'hilalK', 'teknopluse12@gmail.com', 'PX3dV61j+maBL6mMD13rtQ=='),
(2, 'Birsen', 'ÇINAR', 'birsenC', 'birsen@birsen.com', 'PX3dV61j+maBL6mMD13rtQ==');

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `dailyOCHour`
--
ALTER TABLE `dailyOCHour`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `doctorInfo`
--
ALTER TABLE `doctorInfo`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `locationInfo`
--
ALTER TABLE `locationInfo`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `reservationInfo`
--
ALTER TABLE `reservationInfo`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `appointments`
--
ALTER TABLE `appointments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=176;

--
-- Tablo için AUTO_INCREMENT değeri `customer`
--
ALTER TABLE `customer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Tablo için AUTO_INCREMENT değeri `dailyOCHour`
--
ALTER TABLE `dailyOCHour`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Tablo için AUTO_INCREMENT değeri `doctorInfo`
--
ALTER TABLE `doctorInfo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Tablo için AUTO_INCREMENT değeri `locationInfo`
--
ALTER TABLE `locationInfo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Tablo için AUTO_INCREMENT değeri `reservationInfo`
--
ALTER TABLE `reservationInfo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Tablo için AUTO_INCREMENT değeri `settings`
--
ALTER TABLE `settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Tablo için AUTO_INCREMENT değeri `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
