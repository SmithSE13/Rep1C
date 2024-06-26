﻿
#Область ОбработчикиСобытийФормы

&НаКлиенте
Асинх Процедура ПриОткрытии(Отказ)
	
	УстановитьЗначенияПереключателейПоУмолчанию();
	
	Ждать УстановитьПутиСохраненияФайлов();

	Ждать ПрочитатьСохраненныеНастройки();
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ВсегдаСохранятьНастройки Или ЗавершениеРаботы Тогда
		СохранитьНастройкиВФайл();
		Возврат;
	КонецЕсли;

	Оповещение = Новый ОписаниеОповещения("СохранитьНастройкиЗавершение", ЭтаФорма);
	ПоказатьВопрос(Оповещение, "Сохранить настройки подключения?", РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	
	Оповещение = Новый ОписаниеОповещения("СохранитьФайлТелаЗапросаЗавершение", ЭтаФорма);
	ПоказатьВопрос(Оповещение, "Сохранить файл тела запроса?", РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПутьДляСохраненияФайлаНастроекОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложениеАсинх(ПутьДляСохраненияФайлаНастроек);
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьДляСохраненияФайлаТелаЗапросаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложениеАсинх(ПутьДляСохраненияФайлаТелаЗапроса);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательМоделейПриИзменении(Элемент)

	Если ПереключательМоделей = "КраткийПересказ" Тогда
		Объект.ЗадачаДляНейросети = "Краткий пересказ";
	КонецЕсли;
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательРежимовПриИзменении(Элемент)
	
	НастроитьЭлементыФормы();
	ОчиститьРеквизитыФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательКомандПриИзменении(Элемент)
	
	Если ПереключательКоманд = "completionAsync" Тогда
		ПереключательРежимов = "Промт";
		ПереключательМоделей = "YandexGPTLite";
	КонецЕсли;
	
	НастроитьЭлементыФормы();
	ОчиститьРеквизитыФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПолучитьIAMТокен(Команда)
		
	Ответ = НоваяАвторизация();
	
	Если Ответ = Неопределено Тогда
		Возврат;
	ИначеЕсли Ответ.КодСостояния <> 200 Тогда
		ОписаниеОтветаНейросети = Ответ.ПолучитьТелоКакСтроку();
		Возврат;
	КонецЕсли;
	
	Ответ = Ответ.ПолучитьТелоКакСтроку();
	
	Данные = JsonВКоллекцию(Ответ, Ложь);
	Данные.Свойство("iamToken", Объект.IAMТокен);

КонецПроцедуры

&НаКлиенте
Процедура ПолучитьOAuthТокен(Команда)

	URL = URLСервиса();
	ЗапуститьПриложениеАсинх(URL);

КонецПроцедуры

&НаКлиенте
Асинх Процедура ЗапроситьОтвет(Команда)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеЗапросаПользователя = СокрЛП(ОписаниеЗапросаПользователя);
	Если ОписаниеЗапросаПользователя = "" Тогда
		СообщитьПользователю("Заполните, пожалуйста.", "ОписаниеЗапросаПользователя");
		Возврат;
	КонецЕсли;
		
	НастроитьЭлементыФормы();
	Элементы.ГруппаОсновныеНастройкиМоделиГенерации.Скрыть();
	
	Соединение = НовоеHTTPСоединение();	
	Если Соединение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьФайлТелаЗапроса();
	Если Не Ждать ЕстьФайл(ПутьДляСохраненияФайлаТелаЗапроса) Тогда
		СообщитьПользователю("Не удалось подготовить файл тела запроса.", "ПутьДляСохраненияФайлаТелаЗапроса");
		Возврат;
	КонецЕсли;
	
	Запрос = Новый HTTPЗапрос("/foundationModels/v1/" + ПереключательКоманд);
	ТелоЗапроса = Новый ДвоичныеДанные(ПутьДляСохраненияФайлаТелаЗапроса);
	Запрос.УстановитьТелоИзДвоичныхДанных(ТелоЗапроса);
	Запрос.Заголовки.Вставить("Content-Type", "application/json");
	Запрос.Заголовки.Вставить("Authorization", "Bearer " + Объект.IAMТокен);
	Если Не ЛогироватьЗапросы Тогда
		Запрос.Заголовки.Вставить("x-data-logging-enabled", Ложь);
	КонецЕсли;
	
	Ответ = РезультатЗапроса(Соединение, Запрос);
	Если Ответ = Неопределено Тогда
		Возврат;
	ИначеЕсли Ответ.КодСостояния <> 200 Тогда
		ОписаниеОтветаНейросети = Ответ.ПолучитьТелоКакСтроку();
		Возврат;
	КонецЕсли;
	
	Если ПереключательКоманд = "completion" Тогда
		ТелоОтвета = JsonВКоллекцию(Ответ.ПолучитьТелоКакСтроку(), Ложь);
		РазобратьОтветКомандыCompletion(ТелоОтвета);
	ИначеЕсли ПереключательКоманд = "completionAsync" Тогда
		РазобратьОтветКомандыСompletionAsync(Ответ.ПолучитьТелоКакСтроку());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапросНаПолучениеИнформацииОбОперации(Команда)
	
	Если ОтветКомандыСompletionAsync = "" Тогда
		СообщитьПользователю("Сначала сделайте запрос.", "ОписаниеЗапросаПользователя");
		Возврат;
	КонецЕсли;
	
	Соединение = НовоеHTTPСоединение();
	Если Соединение = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Запрос = Новый HTTPЗапрос("/operations/" + id);
	Запрос.Заголовки.Вставить("Authorization", "Bearer " + Объект.IAMТокен);
	Если Не ЛогироватьЗапросы Тогда
		Запрос.Заголовки.Вставить("x-data-logging-enabled", Ложь);
	КонецЕсли;
	
	Ответ = РезультатЗапроса(Соединение, Запрос);
	Если Ответ = Неопределено Тогда
		Возврат;
	ИначеЕсли Ответ.КодСостояния <> 200 Тогда
		ОписаниеОтветаНейросети = Ответ.ПолучитьТелоКакСтроку();
		Возврат;
	КонецЕсли;

	ТелоОтвета = JsonВКоллекцию(Ответ.ПолучитьТелоКакСтроку(), Ложь, Истина);
	done = ТелоОтвета.Получить("done");
	Если done = Истина Тогда
		response = ТелоОтвета.Получить("response");
		Если response <> Неопределено Тогда
			РазобратьМассивAlternatives(response.Получить("alternatives"), Истина);
		Иначе
			error = ТелоОтвета.Получить("error");
			ОписаниеОтветаНейросети = ?(error <> Неопределено, error.Получить("message"), 
												"<Ответ не определён. Необходимо проверить API.>");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СохранитьНастройкиЗавершение(Результат, Параметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		СохранитьНастройкиВФайл();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		УдалитьФайлНастроек();
	Иначе
		//
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайлТелаЗапросаЗавершение(Результат, Параметры) Экспорт

	Если Результат = КодВозвратаДиалога.Нет Тогда
		УдалитьФайлТелаЗапроса();
	Иначе
		//
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция НоваяАвторизация()
		
	Запрос = Новый HTTPЗапрос("/iam/v1/tokens");
	
	ПараметрыАвторизации = Новый Структура;
	ПараметрыАвторизации.Вставить("yandexPassportOauthToken", Объект.OAuthТокен);
	
	ПараметрыАвторизации = КоллекциюВJson(ПараметрыАвторизации);
	
	Запрос.УстановитьТелоИзСтроки(ПараметрыАвторизации);
	
	Запрос.Заголовки.Вставить("Content-Type", "application/json");
	
	Ответ = Неопределено;
	Попытка
		Соединение = Новый HTTPСоединение("iam.api.cloud.yandex.net", 443, , , , , Новый ЗащищенноеСоединениеOpenSSL);
		Ответ = Соединение.ВызватьHTTPМетод("POST", Запрос);
	Исключение
		ОписаниеОтветаНейросети = ОписаниеОшибки();
	КонецПопытки;

	Возврат Ответ;
	
КонецФункции

&НаКлиенте
Функция НовоеHTTPСоединение()

	Соединение = Неопределено;
	Попытка
		Соединение = Новый HTTPСоединение("llm.api.cloud.yandex.net", 443, , , , , Новый ЗащищенноеСоединениеOpenSSL);
	Исключение
		ОписаниеОтветаНейросети = ОписаниеОшибки();
	КонецПопытки;
	
	Возврат Соединение;

КонецФункции

&НаКлиенте
Функция РезультатЗапроса(Соединение, Запрос, ИмяМетода = "POST")

	Ответ = Неопределено;
	Попытка
		Ответ = Соединение.ВызватьHTTPМетод(ИмяМетода, Запрос);
	Исключение
		ОписаниеОтветаНейросети = ОписаниеОшибки();
	КонецПопытки;
	
	Возврат Ответ;
	
КонецФункции

&НаКлиенте
Процедура СообщитьПользователю(Текст, Поле)
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = Текст;
	Сообщение.Поле = Поле;
	Сообщение.УстановитьДанные(Элементы.Найти(Поле));
	Сообщение.Сообщить();

КонецПроцедуры

&НаКлиенте
Функция JsonВКоллекцию(JSON, ЭтоФайл, ВСоответствие = Ложь)

	ЧтениеJSON = Новый ЧтениеJSON;
	Если ЭтоФайл Тогда
		ЧтениеJSON.ОткрытьФайл(JSON);
	Иначе
		ЧтениеJSON.УстановитьСтроку(JSON);
	КонецЕсли;
	Коллекция = ПрочитатьJSON(ЧтениеJSON, ВСоответствие);
	ЧтениеJSON.Закрыть();
	
	Возврат Коллекция;
	
КонецФункции

&НаКлиенте
Функция КоллекциюВJson(Коллекция, ЗаписьВФайл = Ложь, ИмяФайла = "")
	
	ЗаписьJSON = Новый ЗаписьJSON;
	Если ЗаписьВФайл Тогда
		ЗаписьJSON.ОткрытьФайл(ИмяФайла);	
	Иначе
		ЗаписьJSON.УстановитьСтроку();
	КонецЕсли;
	
	ЗаписатьJSON(ЗаписьJSON, Коллекция);
		
	Возврат ЗаписьJSON.Закрыть();
	
КонецФункции

&НаКлиенте
Асинх Функция УстановитьПутиСохраненияФайлов()
	
	Каталог = Ждать КаталогВременныхФайловАсинх();
	ПутьДляСохраненияФайлаТелаЗапроса = Каталог + "телоЗапроса.json";	
	ПутьДляСохраненияФайлаНастроек 	  = Каталог + "сохраненныеДанные.json";
	
КонецФункции

&НаКлиенте
Процедура УстановитьЗначенияПереключателейПоУмолчанию()
	
	ПереключательМоделей = "YandexGPTLite";
	ПереключательРежимов = "Промт";
	ПереключательКоманд = "completion";
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройкиВФайл()

	Настройки = Новый Структура;
	Настройки.Вставить("ИдентификаторКаталога", Объект.ИдентификаторКаталога);
	Настройки.Вставить("OAuthТокен", Объект.OAuthТокен);
	Настройки.Вставить("IAMТокен", Объект.IAMТокен);
	Настройки.Вставить("ЗадачаДляНейросети", Объект.ЗадачаДляНейросети);
	
	Настройки.Вставить("ВсегдаСохранятьНастройки", ВсегдаСохранятьНастройки);
	
	Настройки.Вставить("temperature", temperature);
	Настройки.Вставить("stream", stream);
	Настройки.Вставить("maxTokens", maxTokens);
	Настройки.Вставить("ЛогироватьЗапросы", ЛогироватьЗапросы);
	
	Настройки.Вставить("ПереключательМоделей", ПереключательМоделей);
	Настройки.Вставить("ПереключательРежимов", ПереключательРежимов);
	Настройки.Вставить("ПереключательКоманд", ПереключательКоманд);
	
	КоллекциюВJson(Настройки, Истина, ПутьДляСохраненияФайлаНастроек);

КонецПроцедуры

&НаКлиенте
Асинх Функция ПрочитатьСохраненныеНастройки()

	Если Ждать ЕстьФайл(ПутьДляСохраненияФайлаНастроек) Тогда
		Настройки = JsonВКоллекцию(ПутьДляСохраненияФайлаНастроек, Истина);
		ЗаполнитьЗначенияСвойств(Объект, Настройки);
		ЗаполнитьЗначенияСвойств(ЭтаФорма, Настройки);
	Иначе
		temperature = 0.1;
		maxTokens = "1000";
	КонецЕсли;

КонецФункции

&НаКлиенте
Процедура ЗаполнитьФайлТелаЗапроса()

	Данные = ДанныеСompletionOptions();
	СформироватьMessages(Данные);	
	КоллекциюВJson(Данные, Истина, ПутьДляСохраненияФайлаТелаЗапроса);
		
КонецПроцедуры

&НаКлиенте
Функция ДанныеСompletionOptions()
	
	Если ПереключательМоделей = "YandexGPTLite" Тогда
		МодельСтрокаUri = "/yandexgpt-lite";
	ИначеЕсли ПереключательМоделей = "КраткийПересказ" Тогда
		МодельСтрокаUri = "/summarization";
	КонецЕсли;

	Данные = Новый Структура;
	Данные.Вставить("modelUri", "gpt://" + Объект.ИдентификаторКаталога + МодельСтрокаUri);
	
	СompletionOptions = Новый Структура;
	СompletionOptions.Вставить("stream", stream);
	СompletionOptions.Вставить("temperature", temperature);
	СompletionOptions.Вставить("maxTokens", maxTokens);
	
	Данные.Вставить("completionOptions", СompletionOptions);

	Возврат Данные; 

КонецФункции

&НаКлиенте
Процедура СформироватьMessages(СтруктураДанных)

	messagesПользователяМассив = Новый Массив;
	
	Если ПереключательМоделей = "YandexGPTLite" Тогда
		
		messagesПользователяМассив.Добавить(РольТекст("system", Объект.ЗадачаДляНейросети));
		
		Если ПереключательРежимов = "Промт" Тогда
			
			messagesПользователяМассив.Добавить(РольТекст("user", ОписаниеЗапросаПользователя));
			
		ИначеЕсли ПереключательРежимов = "Чат" Тогда
			
			Если messagesПользователяJson = "" Тогда
				messagesПользователяМассив.Добавить(РольТекст("user", ОписаниеЗапросаПользователя));
				messagesПользователяJson = КоллекциюВJson(messagesПользователяМассив);
			Иначе
				messagesПользователяМассив = JsonВКоллекцию(messagesПользователяJson, Ложь);
				messagesПользователяМассив.Добавить(JsonВКоллекцию(messageАссистентаJson, Ложь));
				messagesПользователяМассив.Добавить(РольТекст("user", ОписаниеЗапросаПользователя));
				messagesПользователяJson = КоллекциюВJson(messagesПользователяМассив);
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ПереключательМоделей = "КраткийПересказ" Тогда
		messagesПользователяМассив.Добавить(РольТекст("user", ОписаниеЗапросаПользователя));
	КонецЕсли;

	СтруктураДанных.Вставить("messages", messagesПользователяМассив);
	
КонецПроцедуры

&НаКлиенте
Асинх Процедура УдалитьФайлТелаЗапроса()

	Если Ждать ЕстьФайл(ПутьДляСохраненияФайлаТелаЗапроса) Тогда
		УдалитьФайлыАсинх(ПутьДляСохраненияФайлаТелаЗапроса);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Асинх Процедура УдалитьФайлНастроек()
	
	Если Ждать ЕстьФайл(ПутьДляСохраненияФайлаНастроек) Тогда
		УдалитьФайлыАсинх(ПутьДляСохраненияФайлаНастроек);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Асинх Функция ЕстьФайл(ИмяФайла)

	Файл = Новый Файл(ИмяФайла);
	ЕстьФайл = Ждать Файл.СуществуетАсинх();
	Возврат ЕстьФайл;
	
КонецФункции

&НаКлиенте
Процедура НастроитьЭлементыФормы()

	Если Не ЗначениеЗаполнено(Объект.ИдентификаторКаталога) 
					Или Не ЗначениеЗаполнено(Объект.OAuthТокен) 
						Или Не ЗначениеЗаполнено(Объект.IAMТокен) Тогда	
		Элементы.ГруппаАвторизация.Показать();
	Иначе
		Элементы.ГруппаАвторизация.Скрыть();
	КонецЕсли;

	Элементы.ДекорацияКоманда.Заголовок = Элементы.ПереключательКоманд.СписокВыбора.НайтиПоЗначению(ПереключательКоманд);

	Элементы.ГруппаАсинхронно.Видимость = ПереключательКоманд = "completionAsync";
	
	Элементы.ГруппаПараметры.Видимость = Не ПереключательКоманд = "completionAsync";

	Элементы.ПереключательРежимов.Видимость = Истина;
	Если ПереключательМоделей = "КраткийПересказ" Тогда
		
		Элементы.ОписаниеЗапросаПользователя.Заголовок = "Статья к пересказу";
		Элементы.ПереключательРежимов.Видимость = Ложь;
		Элементы.ЗадачаДляНейросети.Видимость = Ложь;
		Элементы.ДекорацияМодель.Заголовок = Элементы.ПереключательМоделей.СписокВыбора.НайтиПоЗначению(ПереключательМоделей);
		Элементы.ДекорацияРежим.Заголовок = "";
		
	ИначеЕсли ПереключательМоделей = "YandexGPTLite" Тогда
		
		Элементы.ОписаниеЗапросаПользователя.Заголовок = "Запрос пользователя";
		
		ЭтоКомандаСompletionAsync = ПереключательКоманд = "completionAsync";
		Элементы.ПереключательМоделей.Доступность = Не ЭтоКомандаСompletionAsync;
		Элементы.ПереключательРежимов.Доступность = Не ЭтоКомандаСompletionAsync;
		
		Элементы.ЗадачаДляНейросети.Видимость = Истина;
		Элементы.ДекорацияМодель.Заголовок = Элементы.ПереключательМоделей.СписокВыбора.НайтиПоЗначению(ПереключательМоделей);
		Элементы.ДекорацияРежим.Заголовок = Элементы.ПереключательРежимов.СписокВыбора.НайтиПоЗначению(ПереключательРежимов);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьРеквизитыФормы()

	messagesПользователяJson = "";
	messageАссистентаJson = "";
	ОтветКомандыСompletionAsync = "";
	
	ОписаниеЗапросаПользователя = "";
	ОписаниеОтветаНейросети = "";

КонецПроцедуры

&НаКлиенте
Функция РольТекст(Роль, Текст)

	Возврат Новый Структура("role, text", Роль, Текст);

КонецФункции
		
&НаКлиенте
Процедура РазобратьОтветКомандыCompletion(Данные)

	result = Неопределено;
	Данные.Свойство("result", result);
	
	alternatives = Неопределено;
	result.Свойство("alternatives", alternatives);
	result.Свойство("modelVersion", modelVersion);
	
	usage = Неопределено;
	result.Свойство("usage", usage);
	ЗаполнитьЗначенияСвойств(ЭтаФорма, usage);

	РазобратьМассивAlternatives(alternatives);
	
КонецПроцедуры

&НаКлиенте
Процедура РазобратьОтветКомандыСompletionAsync(JsonСтрока)	

	ОтветКомандыСompletionAsync = JsonСтрока;
	
	СтруктураОтвета = JsonВКоллекцию(ОтветКомандыСompletionAsync, Ложь);
	СтруктураОтвета.Свойство("id", id);
	
	ОписаниеОтветаНейросети = JsonСтрока;
	
КонецПроцедуры

&НаКлиенте
Процедура РазобратьМассивAlternatives(Массив, ЭтоМассивСоответствий = Ложь)

	messageАссистента = Неопределено;
	
	Если Не ЭтоМассивСоответствий Тогда
		
		Если ТипЗнч(Массив) = Тип("Массив") И Массив.Количество() > 0 Тогда
			Для каждого Структура Из Массив Цикл
				Структура.Свойство("message", messageАссистента);
				Структура.Свойство("status", status);			
			КонецЦикла;
		КонецЕсли;
		ОписаниеОтветаНейросети = messageАссистента.text;
	Иначе
		
		Если ТипЗнч(Массив) = Тип("Массив") И Массив.Количество() > 0 Тогда
			Для каждого Соответствие Из Массив Цикл
				messageАссистента = Соответствие.Получить("message");
				status = Соответствие.Получить("status");			
			КонецЦикла;
		КонецЕсли;
		ОписаниеОтветаНейросети = messageАссистента.Получить("text");
	КонецЕсли;
	
	Если ПереключательРежимов = "Чат" Тогда
		messageАссистентаJson = КоллекциюВJson(messageАссистента)
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Функция URLСервиса()

	Возврат "https://oauth.yandex.ru/authorize?response_type=token&client_id=1a6990aa636648e9b2ef855fa7bec2fb";

КонецФункции
	
#КонецОбласти