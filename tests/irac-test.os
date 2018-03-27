﻿#Использовать "../src"
#Использовать asserts
#Использовать fs
#Использовать tempfiles

Перем ЮнитТест;
Перем АгентКластера;
Перем ВременныйКаталог;

Процедура Инициализация()
	
	АдресСервера = "localhost";
	ПортСервера = 1545;

	АгентКластера = Новый АгентКластера(АдресСервера, ПортСервера, "8.3");

	Лог = Логирование.ПолучитьЛог("ktb.lib.irac");
	Лог.УстановитьУровень(УровниЛога.Отладка);

КонецПроцедуры

// Функция возвращает список тестов для выполнения
//
// Параметры:
//	Тестирование	
Функция ПолучитьСписокТестов(Тестирование) Экспорт
	
	ЮнитТест = Тестирование;
	
	СписокТестов = Новый Массив;
	СписокТестов.Добавить("ТестДолжен_ПодключитьсяКСерверуАдминистрирования");
	СписокТестов.Добавить("ТестДолжен_ПолучитьСписокКластеров");
	СписокТестов.Добавить("ТестДолжен_ПолучитьСписокМенеджеров");
	СписокТестов.Добавить("ТестДолжен_ПолучитьСписокСерверовКластера");
	СписокТестов.Добавить("ТестДолжен_ПолучитьСписокРабочихПроцессов");
	СписокТестов.Добавить("ТестДолжен_ПолучитьСписокБазНаСервере");
	СписокТестов.Добавить("ТестДолжен_ПолучитьСписокСеансовКластера");
	СписокТестов.Добавить("ТестДолжен_ПолучитьСписокСоединенийКластера");

	Возврат СписокТестов;
	
КонецФункции

// Процедура выполняется после запуска теста
//
Процедура ПослеЗапускаТеста() Экспорт

	Если ЗначениеЗаполнено(ВременныйКаталог) Тогда

		Утверждения.ПроверитьИстину(НайтиФайлы(ВременныйКаталог, "*").Количество() = 0,
			"Во временном каталоге " + ВременныйКаталог + " не должно остаться файлов");
	
		ВременныеФайлы.УдалитьФайл(ВременныйКаталог);

		Утверждения.ПроверитьИстину(Не ФС.КаталогСуществует(ВременныйКаталог), "Временный каталог должен быть удален");

		ВременныйКаталог = "";

	КонецЕсли;

КонецПроцедуры // ПослеЗапускаТеста()

// Процедура - тест
//
Процедура ТестДолжен_ПодключитьсяКСерверуАдминистрирования() Экспорт
	
	СтрокаПроверки = "localhost:1545";
	ДлинаСтроки = СтрДлина(СтрокаПроверки);

	Утверждения.ПроверитьРавенство(Лев(АгентКластера.ОписаниеПодключения(), ДлинаСтроки), СтрокаПроверки);

КонецПроцедуры // ТестДолжен_ПодключитьсяКСерверуАдминистрирования()

// Процедура - тест
//
Процедура ТестДолжен_ПолучитьСписокКластеров() Экспорт
    
	Кластеры = АгентКластера.Кластеры().Список();

	Утверждения.ПроверитьБольше(Кластеры.Количество(), 0, "Не удалось получить список кластеров");

КонецПроцедуры // ТестДолжен_ПолучитьСписокКластеров()

// Процедура - тест
//
Процедура ТестДолжен_ПолучитьСписокМенеджеров() Экспорт
    
	Кластеры = АгентКластера.Кластеры().Список();

	Для Каждого Кластер Из Кластеры Цикл
		Менеджеры = Кластер.Менеджеры().Список();
		Прервать;
	КонецЦикла;

	Утверждения.ПроверитьБольше(Менеджеры.Количество(), 0, "Не удалось получить список менеджеров");

КонецПроцедуры // ТестДолжен_ПолучитьСписокМенеджеров()

// Процедура - тест
//
Процедура ТестДолжен_ПолучитьСписокСерверовКластера() Экспорт
	
	Кластеры = АгентКластера.Кластеры().Список();
	
	Для Каждого Кластер Из Кластеры Цикл
		Серверы = Кластер.Серверы().Список();
		Прервать;
	КонецЦикла;

	Утверждения.ПроверитьБольше(Серверы.Количество(), 0, "Не удалось получить список серверов кластера");
	
КонецПроцедуры // ТестДолжен_ПолучитьСписокСерверовКластера()

// Процедура - тест
//
Процедура ТестДолжен_ПолучитьСписокРабочихПроцессов() Экспорт
	
	Кластеры = АгентКластера.Кластеры().Список();
	
	Для Каждого Кластер Из Кластеры Цикл
		Процессы = Кластер.РабочиеПроцессы().Список();
		Прервать;
	КонецЦикла;

	Утверждения.ПроверитьБольше(Процессы.Количество(), 0, "Не удалось получить список рабочих процессов");
	
КонецПроцедуры // ТестДолжен_ПолучитьСписокРабочихПроцессов()

// Процедура - тест
//
Процедура ТестДолжен_ПолучитьСписокБазНаСервере() Экспорт
    
	Кластеры = АгентКластера.Кластеры().Список();
	
	Для Каждого Кластер Из Кластеры Цикл
		ИБ = Кластер.ИнформационныеБазы().Список();
		Прервать;
	КонецЦикла;
	
	Утверждения.ПроверитьБольше(ИБ.Количество(), 0, "Не удалось получить список информационных баз");

КонецПроцедуры // ТестДолжен_ПолучитьСписокБазНаСервере()

// Процедура - тест
//
Процедура ТестДолжен_ПолучитьСписокСеансовКластера() Экспорт
    
	Кластеры = АгентКластера.Кластеры().Список();
	
	Для Каждого Кластер Из Кластеры Цикл
		Сеансы = Кластер.Сеансы().Список();
		Прервать;
	КонецЦикла;
	
	Утверждения.ПроверитьБольше(Сеансы.Количество(), 0, "Не удалось получить список сеансов");

КонецПроцедуры // ТестДолжен_ПолучитьСписокСеансовКластера()

// Процедура - тест
//
Процедура ТестДолжен_ПолучитьСписокСоединенийКластера() Экспорт
    
	Кластеры = АгентКластера.Кластеры().Список();
	
	Для Каждого Кластер Из Кластеры Цикл
		Соединения = Кластер.Соединения().Список();
		Прервать;
	КонецЦикла;
	
	Утверждения.ПроверитьБольше(Соединения.Количество(), 0, "Не удалось получить список соединений");

КонецПроцедуры // ТестДолжен_ПолучитьСписокСоединенийКластера()

//////////////////////////////////////////////////////////////////////////////////////
// Инициализация

Инициализация();
