-- *FLO CASE STUDY* --
SELECT * FROM FLO;
-- 1.
-- Kaç farklý müþterinin alýþveriþ yaptýðýný gösteriniz
SELECT COUNT(DISTINCT(master_id)) FROM FLO;

-- 2.
-- Toplam yapýlan alýþveriþ sayýsý ve ciroyu getiriniz
SELECT 
SUM(order_num_total_ever_online + order_num_total_ever_offline) AS TOPLAM_ALISVERIS,
SUM(customer_value_total_ever_offline + customer_value_total_ever_online) AS TOPLAM_CIRO
FROM FLO

-- 3.
-- Alýþveriþ baþýna ortalama ciroyu getirecek sorguyu yazýnýz.
SELECT 
SUM(customer_value_total_ever_offline + customer_value_total_ever_online) / 
SUM(order_num_total_ever_offline + order_num_total_ever_online) AS ORTALAMA_CIRO
FROM FLO

-- 4.
-- En son alýþveriþ yapýlan kanal (last_order_channel) üzerinden yapýlan alýþveriþlerin
-- toplam ciro ve alýþveriþ sayýlarýný getiriniz
SELECT
last_order_channel,
SUM(customer_value_total_ever_offline + customer_value_total_ever_online) AS TOPLAM_CIRO,
SUM(order_num_total_ever_online + order_num_total_ever_offline) AS TOPLAM_ALISVERIS,
COUNT(*) AS "TRANSACTION"
FROM FLO
GROUP BY last_order_channel
ORDER BY TOPLAM_CIRO DESC;

-- 5.
-- Store type kýrýlýmýnda elde edilne toplam ciroyu getiriniz
SELECT
store_type,
SUM(customer_value_total_ever_offline + customer_value_total_ever_online) AS TOPLAM_CIRO
FROM FLO
GROUP BY store_type
ORDER BY TOPLAM_CIRO DESC;

-- 6.
-- Yýl kýrýlýmýnda alýþveriþ sayýlarýný getiriniz (first_order_Date'e göre)
SELECT 
DATENAME(YEAR, first_order_date) AS "YEAR",
SUM(order_num_total_ever_offline + order_num_total_ever_online) AS TOPLAM_ALSIVERIS
FROM FLO
GROUP BY DATENAME(YEAR, first_order_date)
ORDER BY 2 DESC;

-- 7.
-- En son alýþveriþ yapýlan kanal kýrýlýmýnda alýþveriþ baþýna ortalama ciroyu, toplam ciro ve 
-- alýþveriþ sayýsýný hesaplayýnýz
SELECT
last_order_channel,
SUM(customer_value_total_ever_offline + customer_value_total_ever_online) AS TOPLAM_CIRO,
SUM(order_num_total_ever_offline + order_num_total_ever_online) AS TOPLAM_SIPARIS,
SUM(customer_value_total_ever_offline + customer_value_total_ever_online) / 
	SUM(order_num_total_ever_offline + order_num_total_ever_online) AS ORTALAMA_CIRO
FROM FLO
GROUP BY last_order_channel
ORDER BY ORTALAMA_CIRO DESC;

-- 8. 
-- Son 12 ayda en çok ilgi gören kategoriyi getiriniz
SELECT TOP 1
interested_in_categories_12,
COUNT(*) AS FREKANS
FROM FLO
GROUP BY interested_in_categories_12
ORDER BY 2 DESC;

-- 9.
-- En çok tercih edilen store_type bilgisini getirin
SELECT TOP 1
store_type,
COUNT(store_type) AS store_type_num
FROM FLO
GROUP BY store_type
ORDER BY 2 DESC;

-- 10.
-- En son alýþveriþ yapýlan kanal (last_order_channel) bazýnda, en çok ilgi gören kategoriyi
-- ve bu kategoriden ne kadarlýk alýþveriþ yapýldýðýný gösteriniz
SELECT TOP 1
last_order_channel,
interested_in_categories_12,
COUNT(*) AS ISLEM_SAYISI
FROM FLO
GROUP BY last_order_channel, interested_in_categories_12
ORDER BY 1, 3 desc;

-- 11.
-- En çok alýþveriþ yapan kiþini ID'sini getirin
SELECT TOP 1
master_id
FROM FLO
GROUP BY master_id
ORDER BY SUM(order_num_total_ever_offline + order_num_total_ever_online) desc;

-- 12.
-- En çok alýþveriþ yapan kiþinin alýþveriþ baþýna ortalama cirosunu ve alýþveriþ yapma
-- gün ortalaamsýný (alýþveirþ sýklýðý/frekansý) getirin
SELECT TOP 1
master_id,
SUM(order_num_total_ever_offline + order_num_total_ever_online) AS TOPLAM_SIPARIS,
ROUND(SUM(customer_value_total_ever_offline + customer_value_total_ever_online) / 
	SUM(order_num_total_ever_offline + order_num_total_ever_online), 2) AS ORTALAMA_CIRO,
SUM(customer_value_total_ever_offline + customer_value_total_ever_online) AS TOPLAM_CIRO
FROM FLO
GROUP BY master_id
ORDER BY 2 DESC;

-- 13.
-- En çok alýþveriþ yapan (ciro bazýnda) ilk 100 kiþinin alýþveriþ yapma gün ortalamasýný (frekans) getirin
SELECT  
	D.master_id,
    D.TOPLAM_CIRO,
	D.TOPLAM_SIPARIS_SAYISI,
    ROUND((D.TOPLAM_CIRO / D.TOPLAM_SIPARIS_SAYISI),2) AS SIPARIS_BASINA_ORTALAMA,
	DATEDIFF(DAY, first_order_date, last_order_date) AS ILK_SN_ALVRS_GUN_FRK,
	ROUND((DATEDIFF(DAY, first_order_date, last_order_date)/ D.TOPLAM_SIPARIS_SAYISI ), 1) AS ALISVERIS_GUN_ORT	 
FROM
	(SELECT TOP 100 
	 master_id, 
	 first_order_date, 
	 last_order_date,
	 SUM(customer_value_total_ever_offline + customer_value_total_ever_online) AS TOPLAM_CIRO,
	 SUM(order_num_total_ever_offline + order_num_total_ever_online) AS TOPLAM_SIPARIS_SAYISI
	 FROM FLO 
	 GROUP BY master_id, first_order_date, last_order_date
	 ORDER BY TOPLAM_CIRO DESC) AS D;


-- 14.
-- En son alýþveriþ yapýlan kanal kýrýlýmýnda en çok alýþveriþ yapan müþteriyi getirin
SELECT DISTINCT(last_order_channel),
	
	(SELECT TOP 1
	 master_id FROM FLO
	 WHERE last_order_channel = F.last_order_channel
	 GROUP BY master_id
	 ORDER BY SUM(customer_value_total_ever_offline + customer_value_total_ever_online) DESC) AS "ENÇOK_ALIÞVERIÞ_YAPAN_MÜÞTERÝ",

	 (SELECT TOP 1
	  SUM(customer_value_total_ever_offline + customer_value_total_ever_online) 
	  FROM FLO
	  WHERE last_order_channel = F.last_order_channel
	  GROUP BY master_id
	  ORDER BY SUM(customer_value_total_ever_offline + customer_value_total_ever_online) DESC) AS TOTAL_CIRO

FROM FLO AS F

-- 15.
-- En son alýþveriþ yapan kiþini ID'sini getirin
-- Max son tarihte birden fazla alýþveriþ yapan ID bulunmakta, bunlarý da getiriniz)
SELECT
master_id,
last_order_date
FROM FLO
WHERE last_order_date = (SELECT MAX(last_order_date) FROM FLO)
--WHERE last_order_date = '2021-05-30'


-- 16.
-- En son alýþveirþ yapan (lod, lod online ve lod_offline) kiþinin ID'sini getirin
SELECT 
master_id,
last_order_date, last_order_date_offline, last_order_date_online
FROM FLO
WHERE last_order_date = (SELECT MAX(last_order_date) FROM FLO) AND
last_order_date_offline = (SELECT MAX(last_order_date_offline) FROM FLO) AND
last_order_date_online = (SELECT MAX(last_order_date_online) FROM FLO)

-- 17.
-- Son 3 ayda sipariþ veren ama son 2 haftadýr sipariþ vermeyen müþterilerin MASTER_ÝD leri
-- FLO
SELECT DISTINCT(master_id), last_order_date
FROM FLO
WHERE 
DATEDIFF(MONTH, last_order_date, '2021-05-30') < 3
AND
DATEDIFF(DAY, last_order_date, '2021-05-30') >= 15
ORDER BY last_order_date ASC

-- 18.
-- Son 6 ayda sipariþ veren ama son 2 haftadýr sipariþ vermeyen müþterilerin client_id'leri
-- FLO
SELECT 
master_id, last_order_date
FROM FLO
WHERE
DATEDIFF(MONTH, last_order_date, '2021-05-30') <= 6 AND
DATEDIFF(WEEK, last_order_date, '2021-05-30') > 2
ORDER BY last_order_date DESC;


-- 19.
-- Günlük olarak müþterilerin tüm zamanlardaki ilk sipariþlerinin ortalama cirolarýný getiriniz
WITH FirstOrderData AS
	
	(SELECT
	master_id,
	MIN(first_order_date) AS FIRST_ORDER_DATE,
	SUM(customer_value_total_ever_offline + customer_value_total_ever_online) AS TOTAL_CUSTOMER_VALUE
	FROM FLO
	GROUP BY master_id)

SELECT
	master_id, FIRST_ORDER_DATE,
	TOTAL_CUSTOMER_VALUE / DATEDIFF(DAY, FIRST_ORDER_DATE, GETDATE()) AS DAILY_AVERAGE_CUSTOMER_VALUE
FROM FirstOrderData

-- 19.
-- Günlük olarak müþterilerin tüm zamanlardaki ilk sipariþlerinin ortalama cirolarýný getiriniz
-- FLO
SELECT
master_id,
MIN(first_order_date) AS ILK_SIPARIS_TARIHI,
SUM(customer_value_total_ever_offline + customer_value_total_ever_online) / DATEDIFF(DAY, MIN(first_order_date), GETDATE()) AS GUNLUK_ORTALAMA_CIRO
FROM FLO
GROUP BY master_id


-- 20. 
-- Her bir order_channel'daki customer_value_total_ever_online deðerini ve o order_channeldaki en yüksek ve en düþük cvteo deðerlerini göster
SELECT order_channel, customer_value_total_ever_online,
MAX(customer_value_total_ever_online) OVER (PARTITION BY order_channel) AS MAX_VALUE,
MIN(customer_value_total_ever_online) OVER (PARTITION BY order_channel) AS MIN_VALUE
FROM FLO;


--21.
-- Her bir aya göre(last_month) toplam sipariþ sayýsýný, min, max ve avg sipariþ sayýlarýný göster
SELECT
last_month,
SUM(customer_value_total_ever_offline + customer_value_total_ever_online) AS TOPLAM,
MIN(customer_value_total_ever_offline + customer_value_total_ever_online) AS MIN,
MAX(customer_value_total_ever_offline + customer_value_total_ever_online) AS MAX,
AVG(customer_value_total_ever_offline + customer_value_total_ever_online) AS ORTALAMA
FROM FLO
GROUP BY last_month;


SELECT
last_month, customer_value_total_ever_offline, customer_value_total_ever_online,
AVG(customer_value_total_ever_offline + customer_value_total_ever_online) OVER (PARTITION BY last_month) AS ORTALAMA,
SUM(customer_value_total_ever_offline + customer_value_total_ever_online) OVER (PARTITION BY last_month) AS TOPLAM,
customer_value_total_ever_online - AVG(customer_value_total_ever_offline + customer_value_total_ever_online) OVER (PARTITION BY last_month) AS ONLINE_FARK,
customer_value_total_ever_offline - AVG(customer_value_total_ever_offline + customer_value_total_ever_online) OVER (PARTITION BY last_month) AS OFFLINE_FARK
FROM FLO;

-- 22.
-- kategori ve store_type kýrýlýma göre , last_order_date azalan olacak þekilde bir ROW_NUMBER oluþturunuz
SELECT 
ROW_NUMBER() OVER (PARTITION BY order_channel, interested_in_categories_12, store_type ORDER BY last_order_date DESC) AS ROW_NUM,
*
FROM FLO

-- 23.
-- YUKARIDAKÝ PROBLEME EK OLARAK onteo + onteo >= 40 olmalý ve her kategorinin 1. elemanýný getir (unýtprice pahalý olanlar yani)
SELECT * FROM
(
SELECT
ROW_NUMBER() OVER(PARTITION BY order_channel, interested_in_categories_12, store_type ORDER BY last_order_date DESC) AS ROW_NUM,
*
FROM FLO
WHERE order_num_total_ever_offline + order_num_total_ever_online >= 40
) 
AS SUB
WHERE SUB.ROW_NUM = 1 

--24.
-- Yukarýdaki iþlemi ROW_NUMBER yerine Rank ve Dense_Rank kullanarak gerçekleþtiriniz ancak order_num_total_ever_online deðeri en yüksek olanlarý alýnýz
-- Ek olarak customer segment yeni olanlar içni sadece bu iþlemi gerçekleþtiriniz.
SELECT RANK, order_channel, order_num_total_ever_online, interested_in_categories_12, store_type FROM
(
SELECT 
RANK() OVER(PARTITION BY order_channel, interested_in_categories_12, store_type ORDER BY order_num_total_ever_online DESC) AS "RANK",
*
FROM FLO
WHERE customer_segment = 'yeni'
) AS SUB
WHERE SUB.RANK = 1;


SELECT * FROM
(
SELECT 
DENSE_RANK() OVER(PARTITION BY order_channel, interested_in_categories_12, store_type ORDER BY order_num_total_ever_online DESC) AS "RANK",
*
FROM FLO
WHERE customer_segment = 'yeni'
) AS SUB
WHERE SUB.RANK = 1;



SELECT 
ROW_NUMBER() OVER(PARTITION BY order_channel, interested_in_categories_12, store_type ORDER BY order_num_total_ever_online DESC) AS "ROW_NUM",
RANK() OVER(PARTITION BY order_channel, interested_in_categories_12, store_type ORDER BY order_num_total_ever_online DESC) as "RANK",
DENSE_RANK() OVER(PARTITION BY order_channel, interested_in_categories_12, store_type ORDER BY order_num_total_ever_online DESC) as "DENSE_RANK",
order_channel, order_num_total_ever_online, interested_in_categories_12, store_type
FROM FLO;

-- 25.
-- 
SELECT 
SUM(order_num_total_ever_online + order_num_total_ever_offline) OVER (PARTITION BY order_channel, store_type, customer_segment) AS "TOTAL",
NTILE(20) OVER(ORDER BY order_num_total_ever_online + order_num_total_ever_offline DESC) AS "NTILE",
*
from FLO


SELECT * FROM
(
SELECT 
ROW_NUMBER() OVER (PARTITION BY order_channel, store_type, customer_segment 
ORDER BY customer_value_total_ever_offline + customer_value_total_ever_online DESC) AS "ROW_NUM",

RANK() OVER(PARTITION BY order_channel, store_type, customer_segment
ORDER BY customer_value_total_ever_offline + customer_value_total_ever_online DESC) AS "RANK",

DENSE_RANK() OVER(PARTITION BY order_channel, store_type, customer_segment
ORDER BY customer_value_total_ever_offline + customer_value_total_ever_online DESC) AS "DENSE_RANK",

order_channel, order_num_total_ever_online, order_num_total_ever_offline,
customer_value_total_ever_offline, customer_value_total_ever_online,

SUM(order_num_total_ever_online + order_num_total_ever_offline) 
OVER (PARTITION BY order_channel, store_type, customer_segment) AS TOTAL_ORDER,

SUM(customer_value_total_ever_offline + customer_value_total_ever_online) 
OVER (PARTITION BY order_channel, store_type, customer_segment) AS TOTAL_VALUE,
store_type, customer_segment

FROM FLO
WHERE order_num_total_ever_offline >= 10
) AS SUB
ORDER BY SUB.order_channel