# Работа с матрицами
Created вторник 15 Март 2016

**Работать можно с матрицами следующих типов:** числовая(*real*), целочисленая(*integer*), булевая(*boolean*), строковая(*string*), символьная(*char*).
**Основной класс:** HomerMatrix

##### Свойста
All — позволяет считать матрицу, или записать новую.
Rows — количество строк матрицы
Columns — количество столбцов матрицы
FirstRow — первая строка, аналог Row[1]
Row[i] — строка i
LastRow — последняя строка, аналог Row[Rows] и Row[-1]
FirstColumn — первый столбец, аналог Column[1]
Column[i] — столбец i, 0 — дефолтные значения для ячеек строк.
LastColumn — последний столбец, аналог Column[Columns] и Column[-1]
Cell[n,m] — ячейка
Preferences — настройки поведения класса
AddRow(write only) — Добавляет новую строку в конец матрицы, аналог InsertRow(Rows, Add) и InsertRow(-1, Add)
PushRow(write only) — Добавляет новую строку в начало матрицы, аналог InsertRow(1, Pull)
AddColumn(write only) — Добавляет новый столбец в конец матрицы, аналог InsertColumn(Columns, Add) и InsertColumn(-1, Add)
PushColumn(write only) — Добавляет новый столбец в начало матрицы, аналог InsertColumn(1, Pull)

##### Методы
ValidateIndex(**var** index:integer; cycled:boolean=Preferences[CycledIndex]) — интерпретирует отрицательные индексы(отсчитать i-тый элемент с конца), проверяет не находится ли индекс за пределами матрицы, если это произошло — возвращает ошибку(cycled=false), или зацикливает нумерацию(cycled=true).
InsertRow(index:integer, NewRow:Array, InsertFlag:InsertFlagList=Preferences[InsertBehavior]) 
InsertFlag=Pull: Вставить новую строку с указанным индексом. Строка с этим индексом должна существовать, старая строка и все последующие будут сдвинуты вниз.
InsertFlag=Add: Вставить новую строку **после** строки с указанным индексом. Строка с этим индексом должна существовать, все последующие строки будут сдвинуты вниз.
InsertColumn(index:integer, NewRow:Array, InsertFlag:InsertFlagList=Preferences[InsertBehavior]) 
InsertFlag=Pull: Вставить новый столбец с указанным индексом. Столбец с этим индексом должен существовать, старый столбец и все последующие будут сдвинуты вправо.
InsertFlag=Add: Вставить новый столбец **после** столбца с указанным индексом. Столбец с этим индексом должен существовать, все последующие столбцы будут сдвинуты вправо.


