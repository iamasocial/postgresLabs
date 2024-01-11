-- Active: 1704900343020@@127.0.0.1@5432@test@db
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
WHERE c.rating = 300 AND c.snum = s.snum;--// если речь идет о UNION, то никак :)


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
SELECT onum, amt FROM db.orders o, db.clients c
WHERE o.cnum = c.cnum AND c.city != 'London' AND amt > ANY(
    SELECT amt FROM db.orders oo, db.clients cl
    WHERE oo.cnum = cl.cnum AND cl.city = 'London'
) ORDER BY onum;


--6.9 Напишите предыдущий запрос с использованием MAX. // и MIN вероятно, иначе я хз как тогда делать
SELECT onum, amt FROM db.orders o, db.clients c
WHERE o.cnum = c.cnum AND c.city != 'London' AND
amt < (
    SELECT MAX(amt) FROM db.orders o, db.clients c
    WHERE o.cnum = c.cnum AND c.city = 'London'
) AND amt > (
    SELECT MIN(amt) FROM db.orders o, db.clients c
    WHERE o.cnum = c.cnum AND c.city = 'London'
) ORDER BY onum;


--7.1 Создайте объединение из двух запросов, которое показало бы имена,
--города и оценки всех заказчиков. Те из них, которые имеют поле
--rating=200 и более, должны, кроме того, иметь слова - "Высокий
--Рейтинг", а остальные должны иметь слова "Низкий Рейтинг".
SELECT cname, city, rating, 'Высокий рейтинг' FROM db.clients WHERE rating >= 200
UNION
SELECT cname, city, rating, 'Низкий рейтинг' FROM db.clients WHERE rating < 200;


--7.2 Напишите команду, которая вывела бы имена и номера каждого продавца и
--каждого заказчика, которые имеют больше чем один текущий
--заказ. Результат представьте в алфавитном порядке.
SELECT snum, sname FROM db.sellers s WHERE 1 < (
    SELECT COUNT(onum) FROM db.orders o WHERE o.snum = s.snum 
)
UNION
SELECT cnum, cname FROM db.clients c WHERE 1 < (
    SELECT COUNT(onum) FROM db.orders o WHERE o.cnum = c.cnum
)
ORDER BY sname;


--7.3 Сформируйте объединение из трех запросов. Первый выбирает поля
--snum всех продавцов в San Jose; второй, поля cnum всех заказчиков в
--San Jose; и третий - поля onum всех заказов на 3 октября.
--Сохраните дубликаты между последними двумя запросами, но
--устраните любую избыточность вывода между каждым из них и самым первым.
SELECT snum FROM db.sellers WHERE city = 'San Jose'
UNION
(
    SELECT cnum FROM db.clients WHERE city = 'San Jose'
    UNION ALL
    SELECT onum FROM db.orders WHERE odate = '1990-10-03'
);

--8.1 Напишите команду, которая поместила бы следующие значения в
--указанном заказе в таблицу Продавцов:

--city - San Jose,
--name - Bianco,
--comm - NULL,
--snum - 1100.
INSERT INTO db.sellers VALUES
(1100, 'Bianco', 'San Jose', NULL);
DELETE FROM db.sellers WHERE sname = 'Bianco';


--8.2 Напишите команду, которая удалила бы все заказы заказчика Clemens из таблицы Заказов.
DELETE FROM db.orders WHERE cnum = (
    SELECT cnum FROM db.clients WHERE cname = 'Clemens'
)


--8.3 Напишите команду, которая увеличила бы оценку всех заказчиков в Риме на 100.
UPDATE db.clients
SET rating = rating + 100
WHERE city = 'Rome';

UPDATE db.clients
SET rating = rating - 100
WHERE city = 'Rome';


--8.4 Продавец Serres оставил компанию. Переназначьте его заказчиков продавцу Motika.
UPDATE db.clients
SET snum = (
    SELECT snum FROM db.sellers WHERE sname = 'Motika'
) WHERE snum = (
    SELECT snum FROM db.sellers WHERE sname = 'Serres'
)

--9.1 Предположите, что имеется таблица Multicust с такими
--же именами столбцов, что и в таблице Продавцов. Напишите команду,
--которая вставила бы всех продавцов (из таблицы Продавцов), имеющих 
--более чем одного заказчика, в эту таблицу.
CREATE TABLE db.multicust
(
    snum INTEGER PRIMARY KEY,
    sname VARCHAR NOT NULL,
    city VARCHAR NOT NULL,
    comm DECIMAL
);

INSERT INTO db.multicust
SELECT * FROM db.sellers WHERE snum IN(
    SELECT snum FROM db.clients GROUP BY snum HAVING COUNT(cnum) > 1
);
SELECT * FROM db.multicust;
DELETE FROM db.multicust WHERE 1=1;

--9.2 Напишите команду, которая удаляла бы всех заказчиков не имеющих текущих заказов.
DELETE FROM db.clients WHERE cnum NOT IN(
    SELECT cnum FROM db.orders
);


--9.3 Напишите команду, которая увеличила бы на двадцать процентов комиссионные
--всех продавцов, имеющих сумму текущих заказов выше $3,000.
UPDATE db.sellers
SET comm = comm + 0.2
WHERE snum IN(
    SELECT snum FROM db.orders GROUP BY snum HAVING SUM(amt) > 3000
);

SELECT * FROM db.sellers;

UPDATE db.sellers
SET comm = comm - 0.2
WHERE snum IN(
    SELECT snum FROM db.orders GROUP BY snum HAVING SUM(amt) > 3000
);


--10.1 Напишите предложение CREATE TABLE, которое вывело бы нашу таблицу Заказчиков.
--почему это в 10 лабе, а не в нулевой?
CREATE TABLE db.clients
(
    cnum INTEGER PRIMARY KEY,
    cname VARCHAR NOT NULL,
    city VARCHAR NOT NULL,
    rating INTEGER NOT NULL,
    snum INTEGER NOT NULL,
    FOREIGN KEY(snum) REFERENCES db.sellers(snum)
)


--10.2 Напишите команду, которая давала бы возможность пользователю
--быстро извлекать заказы, сгруппированные по датам, из таблицы Заказов.
SELECT * FROM db.orders ORDER BY odate;

--10.3 Если таблица Заказов уже создана, как вы можете заставить поле
--onum быть уникальным (если допустить что все текущие значения уникальны)?
ALTER TABLE db.orders ADD CONSTRAINT onum_unique UNIQUE (onum);


--10.4 Создайте индекс, который разрешал бы каждому продавцу быстро
--отыскивать его заказы, сгруппированные по датам.
CREATE UNIQUE INDEX snum_index ON db.orders (snum);


--10.5 Предположим, что каждый продавец имеет только одного заказчика 
--с данной оценкой. Введите команду, которая его извлечет.
SELECT cname
FROM db.clients a
WHERE cnum = (
    SELECT cnum FROM db.clients b
    WHERE b.rating = 100 AND b.snum = (
        SELECT snum FROM db.sellers WHERE sname = 'Serres'
    )
)


--11.1 Создайте таблицу Заказов так, чтобы все значения полей onum, а также
--все комбинации полей cnum и snum, отличались друг от друга и чтобы
--значения NULL исключались из поля даты.
CREATE TABLE db.ordersV2
(
    onum INTEGER PRIMARY KEY,
    amt DECIMAL,
    odate DATE NOT NULL,
    cnum INTEGER,
    snum INTEGER,
    FOREIGN KEY (cnum) REFERENCES db.clients(cnum),
    FOREIGN KEY (snum) REFERENCES db.sellers(snum),
    CONSTRAINT unique_cnum_and_snum UNIQUE (cnum, snum)
);


--11.2 Создайте таблицу Продавцов так, чтобы комиссионные по умолчанию
--составляли 10%, не разрешались значения NULL, поле snum являлось первичным ключом
--и чтобы все имена были в алфавитном порядке между A и M включительно
--(учитывая, что все имена будут напечатаны в верхнем регистре).
CREATE TABLE db.sellersV2
(
    snum INTEGER PRIMARY KEY,
    sname VARCHAR NOT NULL CHECK (sname BETWEEN 'A' AND 'M'),
    city VARCHAR NOT NULL,
    comm DECIMAL DEFAULT .1
);

--11.3 Создайте таблицу Заказов учётом того, что поле onum
--больше, чем поле cnum, а cnum больше, чем snum. Запрещены значения
--NULL в любом из этих трех полей.
CREATE TABLE db.ordersV3
(
    onum INTEGER PRIMARY KEY,
    amt DECIMAL,
    odate DATE NOT NULL,
    cnum INTEGER NOT NULL CHECK (cnum < onum),
    snum INTEGER NOT NULL CHECK (snum < cnum),
    FOREIGN KEY (cnum) REFERENCES db.clients(cnum),
    FOREIGN KEY (snum) REFERENCES db.sellers(snum),
    CONSTRAINT unique_cnum_and_snum UNIQUE (cnum, snum)
)

--11.4 Создайте таблицу с именем Cityorders. Она должна содержать такие же
--поля onum, amt и snum, что и таблица Заказов, и такие же поля
--cnum и city, что и таблица Заказчиков, так что заказ каждого
--заказчика будет вводиться в эту таблицу вместе с его городом.
--Поле оnum будет первичным ключом Cityorders. Все поля в Cityorders
--должны иметь ограничения при сравнении с таблицами Заказчиков и
--Заказов. Допускается, что родительские ключи в этих таблицах уже
--имеют соответствующие ограничения.
CREATE TABLE db.cityorders (
    onum INTEGER REFERENCES db.orders(onum) PRIMARY KEY,
    amt DECIMAL REFERENCES db.orders(amt),
    snum INTEGER REFERENCES db.orders(snum),
    cnum INTEGER REFERENCES db.customers(cnum),
    city VARCHAR REFERENCES db.customers(city)
);


--11.5 Усложним проблему. Переопределите таблицу Заказов следующим
--образом: добавьте новый столбец с именем prev, который будет
--идентифицирован для каждого заказа, поле onum предыдущего
--заказа для этого текущего заказчика.
--Выполните это с использованием внешнего ключа, ссылающегося на
--саму таблицу Заказов.
--Внешний ключ должен ссылаться также на поле cnum заказчика,
--обеспечивающее определенную предписанную связь между текущим порядком и ссылаемым.
ALTER TABLE db.orders
ADD COLUMN prev INTEGER REFERENCES db.orders(onum);
UPDATE db.orders o
SET prev = (
    SELECT MAX(onum) FROM db.orders o2 WHERE o2.cnum = o.cnum and o2.onum < 0.onum
);


--12.1 Создайте представление, которое показывало бы всех заказчиков, имеющих
--самые высокие рейтинги.
CREATE VIEW db.highRating AS
    SELECT * FROM db.clients WHERE rating = (
        SELECT MAX(rating) FROM db.clients
    );
SELECT * FROM db.highRating;
DROP VIEW db.highRating;


--12.2 Создайте представление, которое показывало бы номер продавца в каждом городе.
CREATE VIEW db.sellerCity AS
    SELECT city, snum FROM db.sellers;
SELECT * FROM db.sellerCity;
DROP VIEW db.sellerCity


--12.3 Создайте представление, которое показывало бы усреднённый и общий заказы для каждого
--продавца после его имени. Предполагается, что все имена уникальны.
CREATE VIEW db.sellerStat AS
    SELECT snum, ROUND(AVG(amt), 2), SUM(amt) FROM db.orders GROUP BY snum;
SELECT * FROM db.sellerStat;
DROP VIEw db.sellerStat;


--12.4 Создайте представление, которое показывало бы каждого продавца с несколькими заказчиками.
CREATE VIEW db.multiclient AS
    SELECT snum FROM db.orders GROUP BY snum HAVING count(cnum) > 1;
SELECT * FROM db.multiclient;
DROP VIEW db.multiclient;


--12.5 Какое из этих представлений - модифицируемое? // #2
-- #1 CREATE VIEW Dailyorders
--              AS SELECT DISTINCT cnum, snum, onum,
--              odate
--                FROM Orders;

--        #2 CREATE VIEW Custotals
--              AS SELECT cname, SUM (amt)
--                 FROM Orders, Customers
--                 WHERE Orders.cnum = customer.cnum
--                 GROUP BY cname;

--        #3 CREATE VIEW Thirdorders
--              AS SELECT *
--                 FROM Dailyorders
--                 WHERE odate = 10/03/1990;

--        #4 CREATE VIEW Nullcities
--              AS SELECT snum, sname, city
--                 FROM Salespeople
--                 WHERE city IS NULL
--                    OR sname BETWEEN 'A' AND 'MZ';


-- 12.6 Создайте представление таблицы Продавцов с именем Commissions
--    (Комиссионные). Это представление должно включать только поля
--    comm и snum. С помощью этого представления можно будет вводить
--    или изменять комиссионные, но только для значений между .10 и .20.
CREATE VIEW db.Commissions AS
    SELECT comm, snum FROM db.sellers;
SELECT * FROM db.commissions;
DROP VIEW db.commissions;


--12.7 Некоторые SQL-реализации имеют встроенную константу, представляющую текущую дату,
--    иногда называемую " CURDATE ". 
--    Слово CURDATE может, следовательно, использоваться в операторе SQL
--    и заменяться текущей датой, когда его значение станет доступным, с помощью таких
--    команд как SELECT или INSERT. Мы будем использовать
--    представление таблицы Заказов с именем Entryorders для вставки строк
--    в таблицу Заказов. Создайте таблицу заказов так, чтобы CURDATE
--    автоматически вставлялась в поле odate, если не указано другое значение.
--    Затем создайте представление Entryorders так, чтобы значения не могли быть указаны.
CREATE TABLE db.entryorders
(
    onum INTEGER PRIMARY KEY,
    amt DECIMAL,
    odate DATE NOT NULL DEFAULT current_date,
    cnum INTEGER NOT NULL CHECK (cnum < onum),
    snum INTEGER NOT NULL CHECK (snum < cnum),
    FOREIGN KEY (cnum) REFERENCES db.clients(cnum),
    FOREIGN KEY (snum) REFERENCES db.sellers(snum),
    CONSTRAINT unique_cnum_and_snum UNIQUE (cnum, snum)
);
SELECT * FROM db.entryorders;
DROP TABLE db.entryorders;