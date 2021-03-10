# [SZRCAI](https://szrcai.ru/) <img src="https://szrcai.ru/source/logo/logo.png" width="93" height="50" align="right">

### Задача

Реализовать приложение для построения кратчайшего маршрута через заданные географические точки. 

### Описание

Приложение представляет собой карту с возможностью добавления точек.
<br/>На карте точки отображаются в виде маркеров (pin).

После добавления хотя бы 3 точек должны появляться кнопки:

**Построить граф**

По нажатию на которую будет строиться граф возможных переходов между точками по правилу:
```
вершины соединены ребрами при условии, что расстояние между вершинами не более 5км.
```
```
Вершины должны быть нанесены на карту в виде пунктирных линий.
```

**Очистить карту**
```
По нажатию на которую будет происходить удаление всех точек на карте.
```
После построения графа добавлять новые точки на карте уже нельзя, но можно выбрать две точки из имеющихся:
**Точку старта** и **Точку финиша**. Когда точки выбраны, появляется кнопка **«Построить маршрут»**, по нажатию на которую происходит поиск кратчайшего маршрута, если маршрут найден, то он должен визуализироваться на карте красной линией, если нет — выдаваться сообщение, что маршрут не удалось построить.

### Примечание
Можно использовать любую картографическую библиотеку для отображения карты, отрисовки точек и линий.
