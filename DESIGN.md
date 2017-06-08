# Design Document
PAYD
## Implementatie van functies and classes
In deze app wordt gebruik gemaakt van 1 extra class. De class voor alle mogelijke functionaliteiten die nodig zijn om gebruikers te checken en aan te melden. Deze class wordt de 'users'-class genoemd. Verder zijn er per viewcontroller nog een aantal functies nodig.

![](doc/UIsketches.JPG)
![](doc/diagram.JPG)

In de bovenstaande foto's is te zien welke functies voor welke controller nodig zijn en wat deze functies doen.

## Databases en frameworks
Voor deze app wordt gebruik gemaakt van de Firebase van Google. De Firebase wordt gebruikt om alle data op te slaan en om ervoor te zorgen dat als de app wordt geopend alle data uit de realtime database kan worden opgehaald. Om alle benodigde data op te slaan wordt de volgende datastructuur aangehouden. Om ervoor te zorgen dat de gebruiker vanuit een groep ook weer terug kan naar alle groepen, wordt na het inloggen gebruik gemaakt van een navigationcontroller. Daarna wordt voor de drie verschillende pagina's gebruik gemaakt van een tabbarcontroller. Verder is de logincontroller de initial view van de app.

## Updates
De logout-knop komt onder de tableview samen met de addgroup-knop. En daarnaast worde nde logincontroller and de newaccountcontroller geen deel van een tabbarcontroller.

![](doc/datastructure.JPG)
