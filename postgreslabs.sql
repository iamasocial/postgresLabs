-- Active: 1704800582835@@127.0.0.1@5432@test@db
CREATE DATABASE psqlLabs;

CREATE SCHEMA IF NOT EXISTS db;

CREATE TABLE db.sellers
(
    snum INTEGER PRIMARY KEY,
    sname VARCHAR NOT NULL,
    city VARCHAR NOT NULL,
    comm DECIMAL
)

CREATE TABLE db.clients
(
    cnum INTEGER PRIMARY KEY,
    cname VARCHAR NOT NULL,
    city VARCHAR NOT NULL,
    rating INTEGER NOT NULL,
    snum INTEGER NOT NULL,
    FOREIGN KEY(snum) REFERENCES db.sellers(snum)
)

CREATE TABLE db.orders
(
    onum INTEGER PRIMARY KEY,
    amt NUMERIC NOT NULL DEFAULT 0,
    odate DATE NOT NULL,
    cnum INTEGER NOT NULL,
    snum INTEGER NOT NULL,
    --
    FOREIGN KEY(cnum) REFERENCES db.clients(cnum),
    FOREIGN KEY(snum) REFERENCES db.sellers(snum)
)

INSERT INTO db.sellers VALUES
(1001, 'Peel', 'London', .12),
(1002, 'Serres', 'San Jose', .13),
(1004, 'Motika', 'London', .11),
(1007, 'Rifkin', 'Barcelona', .15),
(1003, 'Axelrod', 'New York', .10);

INSERT INTO db.clients VALUES
(2001, 'Hoffman', 'London', 100, 1001),
(2002, 'Giovanni', 'Rome', 200, 1003),
(2003, 'Liu', 'San Jose', 200, 1002),
(2004, 'Grass', 'Berlin', 300, 1002),
(2006, 'Clemens', 'London', 100, 1001),
(2008, 'Cisneros', 'San Jose', 300, 1007),
(2007, 'Pereira', 'Rome', 100, 1004)

INSERT INTO db.orders VALUES
(3001, 18.69, '10-03-1990', 2008, 1007),
(3003, 767.19, '10-03-1990', 2001, 1001),
(3002, 1900.10, '10-03-1990', 2007, 1004),
(3005, 5160.45, '10-03-1990', 2003, 1002),
(3006, 1098.16, '10-03-1990', 2008, 1007),
(3009, 1713.23, '10-04-1990', 2002, 1003),
(3007, 75.75, '10-04-1990', 2004, 1002),
(3008, 4723.00, '10-05-1990', 2006, 1001),
(3010, 1309.95, '10-06-1990', 2004, 1002),
(3011, 9891.88, '10-06-1990', 2006, 1001)

SELECT * FROM db.orders;
SELECT * FROM db.sellers;
SELECT * FROM db.clients;

DROP TABLE db.orders;
DROP TABLE db.clients;
DROP TABLE db.sellers;
DROP SCHEMA db CASCADE;

--LABS
--1.1 Напишите два запроса, которые могли бы вывести все заказы на 3 или 4 октября 1990.
SELECT * FROM db.orders WHERE odate = '1990-10-03';
SELECT * FROM db.orders WHERE odate = '1990-10-04';


--1.2 Напишите запрос, который выберет всех заказчиков, обслуживаемых продавцами Peel или Motika.
--(Подсказка: из наших типовых таблиц поле snum связывает вторую таблицу с первой.)
SELECT * FROM db.clients WHERE snum IN(SELECT snum FROM db.sellers WHERE sname IN('Motika', 'Peel'));


--1.3 Напишите запрос, который может вывести всех заказчиков, 
--чьи имена начинаются с буквы, попадающей в диапазон от A до G
SELECT * FROM db.clients WHERE cname BETWEEN 'A%' AND 'H%';


--1.4 Напишите запрос, который выберет всех пользователей, чьи имена начинаются с буквы C.
SELECT * FROM db.clients WHERE cname LIKE 'C%';


--1.5 Напишите запрос, который выберет все заказы, имеющие нулевые значения или NULL в поле amt (сумма).
SELECT * FROM db.orders WHERE amt IS NULL OR amt = 0;


--2.1 Напишите запрос, который сосчитал бы все суммы продаж на 3 октября.
SELECT SUM(amt) FROM db.orders WHERE odate = '1990-10-03';


--2.2 Напишите запрос, который сосчитал бы число различных не-NULL-значений 
--поля city в таблице Заказчиков
SELECT COUNT(DISTINCT city) FROM db.clients WHERE city IS NOT NULL;


--2.3 Напишите Zапрос, который выбрал бы наименьшую сумму для каждого Zаказчика.
SELECT cnum, min(amt) FROM db.orders GROUP BY cnum;


--2.4 Напишите запрос, который выбирал бы в алфавитном порядке заказчиков,
--чьи имена начинаются с буквы G.
SELECT * FROM db.clients WHERE cname LIKE 'G%'ORDER BY cname ASC;


--2.5 Напишите запрос, который выбрал бы высший рейтинг в каждом городе.
SELECT city, MAX(rating) FROM db.clients GROUP BY city;


--2.6 Напишите запрос, который сосчитал бы число заказчиков, регистрирующих каждый день свои заказы.
--(Если продавец имел более одного заказа в данный день, он должен учитываться только один раз.)
-- Без внятного тз - результат хз
SELECT odate, COUNT(DISTINCT snum) FROM db.orders GROUP BY odate;


--3.1 Предположим, что каждый продавец имеет 12% комиссионных. Напишите запрос к таблице Заказов,
--который выведет номер заказа, номер продавца и сумму комиссионных продавца по этому заказу.
SELECT onum, snum, amt*0.12 comm FROM db.orders;


--3.2 Напишите запрос к таблице Заказчиков, который мог бы найти высший рейтинг в каждом городе.
--Вывод должен быть в такой форме:
-- For the city (city), the highest rating is: (rating).
--p.s. vs code вместо значений максимального рейтинга выводит function(){return Math.max.apply(null,this)}, а через консоль все работает как и задумывалось :/
SELECT 'For the city ', city, 'the highest rating is: ', MAX(rating), '.'
FROM db.clients GROUP BY city;


--3.3 Напишите запрос, который выводил бы список заказчиков в нисходящем порядке.
--Вывод поля оценки/рейтинга (rating) должен сопровождаться именем заказчика и его номером.
SELECT cname, cnum, rating FROM db.clients ORDER BY rating DESC;


--3.4  Напишите запрос, который выводил бы общие заказы на каждый день
--и помещал результаты в нисходящем порядке.
-- что такое "общие заказы?"
--Если "общик заказ на каждый день" = сумма всех заказов за день, то вот запрос
SELECT SUM(amt), odate FROM db.orders GROUP BY odate ORDER BY SUM(amt) DESC;


--4.1 Напишите запрос, который вывел бы список номеров заказов
--сопровождающихся именем заказчика, который создавал эти заказы.
SELECT onum, cname FROM db.orders o, db.clients c WHERE o.cnum = c.cnum;


--4.2 Напишите запрос, который выдавал бы имена продавца и заказчика
--для каждого заказа после номера заказа.
SELECT onum, sname, cname FROM db.orders o, db.sellers s, db.clients c
WHERE o.snum = s.snum AND o.cnum = c.cnum;


--4.3 Напишите запрос, который выводил бы всех заказчиков,
--обслуживаемых продавцом с комиссионными выше 12%.
--Выведите имя заказчика, имя продавца и ставку комиссионных продавца.
SELECT cname , sname, comm FROM db.clients c, db.sellers s
WHERE c.snum = s.snum AND s.comm > 0.12;


--4.4 Напишите запрос, который вычислил бы сумму комиссионных продавца 
--для каждого заказа заказчика с оценкой выше 100.
SELECT onum, amt*comm komissiya, cname, rating
FROM db.orders o, db.sellers s, db.clients c
WHERE c.rating > 100 AND o.cnum = c.cnum AND o.snum = s.snum
ORDER BY onum


--5.1 Напишите запрос, который использовал бы подзапрос для получения
--всех заказов для заказчика с именем Cisneros. Предположим, что вы не знаете
--номера этого заказчика, указываемого в поле cnum.
SELECT onum, amt FROM db.orders o
WHERE o.cnum = (SELECT cnum FROM db.clients c WHERE c.cname = 'Cisneros')


--5.2 Напишите запрос, который вывел бы имена и оценки всех заказчиков,
--имеющих усреднённые заказы(???).
--возможно, усредненный закад = средняя цена заказа, но вывод пустой, т.к нет заказов на сумму 2665,84
SELECT cname, rating FROM db.clients c, db.orders o
WHERE o.amt = (SELECT AVG(amt) FROM db.orders);


--5.3 Напишите запрос, который выбрал бы общую сумму всех приобретений
--в заказах для каждого продавца, у которого эта общая сумма больше,
--чем сумма наибольшего заказа в таблице.
SELECT SUM(amt) sum, snum FROM db.orders
GROUP BY snum
HAVING SUM(amt) > (SELECT MAX(amt) FROM db.orders)


--5.4 Напишите команду SELECT, использующую соотнесенный подзапрос,
--которая выберет имена и номера всех заказчиков
--с максимальными для их городов оценками.
SELECT cnum, cname FROM db.clients
WHERE (rating, city) IN (
    SELECT MAX(rating), city FROM db.clients GROUP BY city
);


--5.5 Напишите два запроса, которые выберут всех продавцов (по их имени и номеру),
--имеющих в своих городах заказчиков, которых они не обслуживают.
--1) Один запрос - с использованием объединения,
SELECT DISTINCT s.snum, s.sname FROM db.sellers s, db.clients c
WHERE s.city = c.city AND c.snum != s.snum ORDER BY snum;


--2) а другой - с соотнесённым подзапросом. Которое из решений будет более изящным?
SELECT DISTINCT s.snum, s.sname
FROM db.sellers s
WHERE s.snum != ANY (
    SELECT c.snum
    FROM db.clients c
    WHERE s.city = c.city
) ORDER BY snum;


--6.1 Напишите запрос, который использовал бы оператор EXISTS для извлечения всех продавцов,
--имеющих заказчиков с оценкой 300.
SELECT snum, sname FROM db.sellers s
WHERE EXISTS(
    SELECT 1 FROM db.clients c WHERE c.rating = 300 AND c.snum = s.snum
);


--6.2 Как бы вы решили предыдущую проблему, используя объединение?
SELECT s.snum, s.sname FROM db.sellers s, db.clients c
WHERE c.rating = 300 AND c.snum = s.snum;


--6.3 Напишите запрос, использующий оператор EXISTS, который выберет
--всех продавцов с заказчиками, размещёнными в их городах, которые ими не обслуживаются.
SELECT DISTINCT s.snum, s.sname
FROM db.sellers s
WHERE EXISTS (
    SELECT 1
    FROM db.clients c
    WHERE s.city = c.city AND c.snum != s.snum
);


--6.4 Напишите запрос, который извлекал бы из таблицы Заказчиков каждого заказчика,
--назначенного продавцу, который в данный момент имеет по крайней мере ещё одного заказчика
--(кроме заказчика, которого вы выберете) с заказами в таблице Заказов
--(подсказка: это может быть похоже на структуру в примере с нашим трехуровневым подзапросом).
SELECT cname, cnum FROM db.clients c
WHERE EXISTS(
    SELECT cname FROM db.clients cl
    WHERE c.snum = cl.snum AND c.cnum != cl.cnum AND
    EXISTS(
        SELECT onum FROM db.orders o
        WHERE cl.cnum = o.cnum
    )
);


--6.5 Напишите запрос, который выбирал бы всех заказчиков, чьи оценки равны или больше,
--чем любая (ANY) оценка заказчика Serres. // я не сравнивал оценки покупателей Serres
--с оценками покупателей Serres, потому что зачем? Понятно же, что их рейтинг
--будет >= их же рейтинга
SELECT c.cnum, c.cname, c.rating FROM db.clients c, db.sellers s
WHERE c.snum = s.snum AND s.sname != 'Serres'
AND c.rating >= ANY(
    SELECT cl.rating FROM db.clients cl, db.sellers s
    WHERE cl.snum = s.snum AND s.sname = 'Serres'
);


--6.6 Что будет выведено вышеупомянутой командой? // А команды-то нет:(


--6.7Напишите запрос, использующий ANY или ALL, который находил бы всех продавцов,
--которые не имеют никаких заказчиков, живущих в их городе.
SELECT s.snum, s.sname, s.city FROM db.sellers s
WHERE s.snum != ALL(
    SELECT c.snum FROM db.clients c
    WHERE c.city = s.city
);


--6.8  Напишите запрос, который выбирал бы все заказы с суммой, больше, чем любая
--(в обычном смысле) для заказчиков в Лондоне.