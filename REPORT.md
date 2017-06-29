# Report

## Korte beschrijving app

Met deze app kan je makkelijk fotos delen met vrienden. Je kan via de app fotos maken of via de library fotos kiezen. In deze app kan je eigen account onderhouden en daarnaast makkelijk vrienden uitnodigen via de app. De app maakt gebruik van Firebase Database om alle user informatie op te slaan en gebruikt Firebase Storage voor de fotos.

## Design app
Hieronder worden de verschillende viewcontrollers en functionaliteiten besproken die de app maken tot wat deze is.

### LogInViewController
De LogInView is de eerste view waar je in komt als je de app opstart. In deze controller kan je als je al een log-in hebt inloggen door gebruik te maken van de daarvoor aangegeven textfields en log-in button. Daarnaast is er ook nog een mogelijkheid om naar de viewcontroller te gaan waar een nieuwe user een account aan kan maken.

### NewAccountViewController
Deze view kan je bereiken door op de "Create Account"-button te drukken in de log-in view. In deze view kan je door middel van je voor-, achternaam, email en wachtwoord een nieuw account aanmaken. Hierbij is het belangrijk dat het email adress, wat de nieuwe user gebruikt, uniek is. Dus kort gezegd de opgegeven email mag niet in de database voorkomen. Als aan deze eis is voldaan, wordt de user ingelogd met zijn/haar nieuwe account

### GroupViewController
Dit is de eerste view die een user ziet als hij/zij is ingelogd. In deze view is een tableview te zien waarin alle groepen worden geladen, die hij/zij zelf heeft gemaakt of waar hij/zij in is toegevoegd door een andere user. Tevens is er in deze view een log-out button, waarmee alle viewcontroller op de stack wordt weggegooid, de user-info wordt vergeten en er weer wordt teruggegaan naar de log-in view. Tevens is er een textfield met een add button te vinden. Met deze button kan je een groep toevoegen als een naam is ingevoegd. Het is niet mogelijk voor een user op 2 keer een groep aan te maken met dezelfde naam.

### PictureCollectionViewController
Deze view wordt bereikt wanneer er in de GroupViewController op een tableViewCell wordt geklikt. Tevens is deze view de eerste controller van de tabbarcontroller. In deze view worden alle fotos afgebeeld dit opgeslagen zijn in de gekozen groep. Deze fotos zitten in een collectionview. Daarnaast is er onderaan de view een add button die naar een volgende view leidt, waarin een nieuwe foto kan worden toegevoegd.

### NewMemberViewController
Deze view wordt bereikt vanuit de tabbar. In deze view kan de current user een nieuwe member toevoegen aan de gekozen groep. Deze member wordt toegevoegd op basis van een email adress.

### PictureViewController
Deze view wordt bereikt door op de add-button te klikken van de PictureCollectionViewController. In deze view zijn 2 buttons, eentje voor de camera en eentje voor de library, om een foto te kiezen. Als deze gekozen is wordt deze weergegeven in de ImageView op dezelfde view. Daarnaast is er een textfield om een beschrijving toe te voegen voor de foto en daarnaast een save button. Wanneer deze save button is geklikt, wordt gecheckt of er een beshrijving is en daarna wordt de foto toegevoegd aan de storage van Firebase en wordt de downloadurl samen met de beschrijving toegevoegd aan de database

### SelectedPictureViewController
Deze view wordt bereikt door op een collectionViewCell te klikken. In deze view wordt de aangeklikte foto vergroot afgebeeld samen met de beschrijving onder aan de view.

### Databasehelper
De databasehelper is een class waarin verschillende functies zitten die worden aangeroepen door de viewcontrollers.

functies: logIn, checkMail, setGroups, removeUsers, removeGroup, getGroupKey, refreshData & alertUser

- logIn: Deze functie checkt of het wachtwoord van de user die probeert in te loggen correct is. Hierbij is al gecheckt of de email al in de database staat. Als het wachtwoord correct is stuurt de functie een notification naar het notificationcenter. Als hij fout is wordt de user gealarmeerd.
- checkMail: Deze functie checkt, gegeven de ingegeven mail bij de logIn view of de newAccount view, of de email in de database staat. Zo ja dan wordt de logIn functie aangeroepen. Als dit niet het geval is wordt de user gealarmeerd met een pop-up.
- setGroups: Deze functie zoekt in elke groep in de database of er een member is die gelijk is aan de current user. Hierdoor worden de groepen up-to-date gehouden. Dus als een andere user de current user zou toevoegen worden alle groepen meteen up-to-date gehouden als deze de groupViewController opnieuw laadt.
- removeUserinfo: Deze functie wordt aangeroepen tijdens het uitloggen. Bij deze functie wordt alle current user informatie vergeten.
- removeGroup: Deze functie verwijderd een groep als een user dat aangeeft door op delete te drukken bij de groepen. In eerste instantie wordt dat gekeken hoeveel members er in de groep zitten. Als dit 1 member is (dus de current user) dan wordt de hele groep verwijderd samen met de fotos. Als dit niet een is wordt alleen de member uit de groep verwijderd. Kort gezegd de laatste die de groep verlaat verwijderd de hele groep uit de database.
- getGroupKey: Deze functie zoekt de groupkey (elke groep heeft deze) op uit de database zodat deze op kan wordt geslagen in de current user info. Als deze groupkey geladen is wordt een notificatie gestuurd naar het notification center. Als deze aankomt dan worden pas fotos opgehaald uit de database, want anders loopt het asynchroom en werkt het niet.
- refreshData: Deze functie haalt op basis van de vooraf vastgestelde groupkey de momenten op uit de database. Deze momenten bestaan uit downloadurls voor de fotos en beschrijvingen. Als alles geladen is wordt de collectionview opnieuw geladen. Zodat er geen problemen ontstaan met asynchroniteit.
- alertUser: Deze functie laat een pop-up scherm zien met een OK-button om de users te waarschuwen als er iets fout gaat.

### Userinfo:
De userinfo is een struct die door alle viewcontroller kunnen worden aangeroepen. In de userinfo worden alle belangrijke elementen opgeslagen. Zoals de user email (is een key om alle userinfo makkelijk uit de database te kunnen halen) en de groupkey als deze wordt aangeroepen wordt deze hier ook in opgeslagen. Daarnaast worden ook de groups, downloadurls, description, picturekey.

## Process
Deze 4 weken zijn er verschillende belangrijke beslissingen gemaakt na het vaststellen van het initiele idee voor de app. Deze beslissing zijn gemaakt op basis van onvoorziene bijkomstigheden. Zo is, na het presenteren van mijn eerste voorstel voor mijn app, mij aangeraden om iets vernieuwends te bedenken. Het eerste idee was een soort van WieBetaaltWat-app te maken, maar dit was niet vernieuwend genoeg. Dus daarom heb ik bedacht om een soort dagboek-app te maken voor groepen vrienden etc. Dit omdat het idee om groepen met users te koppelen wat ontstond bij het eerste idee, ik wel graag wilde houden. 
Naast het veranderen van mijn idee voor mijn app heb ik ook lang nagedacht over mijn database. Het is namelijk best moeilijk om groepen met users te koppelen zonder heel veel nodes te moeten maken. Ik heb besloten dat ik 2 databases heb gemaakt. 1 Database voor de users en 1 Database voor de groepen. Voor elke groep en elke users is er een aparte key. Zodat in de users database een groepen nodes gemaakt kan worden voor de groepen waarin dan all groepkeys worden opgeslagen die keys die dus in de groepen database de verschillende groepen representateren. En vice versa voor de groepen database. Daarin zijn voor elke groep members opgeslagen met hun userkey als waarde, die key is dus hetzelfde als de key voor de user in de users database. Nadat dit geïmplementeerd was bleek dat het gebruik van keys super makkelijk is om te refereren. Dus het is een goede beslissing geweest.
Daarnaast heb ik best lang problemen gehad met het schrijven in de database. Want of data kwam niet in de goede node of de data overschreef andere data. Dit gebeurde vooral bij het uitnodigen van nieuwe groepsleden. Daarom heb ik besloten dat, in plaats van ook meteeen een nieuwe user aanmaken als het uitnodigde groepslid nog geen account heeft, ik alleen een member toevoeg aan de desbetreffende groep en dan voor elke user de groepen ophaal uit de groepen database in plaats van de groepen van de desbetreffende user. Dit voorkomt ook meteen het probleem dat de groepen niet kloppen bij een bestaande user als deze wordt toegevoegd.
Tevens heb ik er nog overnagedacht om nog een chatfunctie te implementeren, maar dit heb ik uiteindelijk neit gedaan omdat ik hiervoor niet genoeg tijd had.
Als laatste ging het proces verder best soepel ik heb uiteindelijk ervoor gekozen om een struct te maken in een aparte class om daar alle userinfo in op te slaan zodat ik niet altijd firebase moet aanroepen om de data op te halen.
Als ik meer tijd had gehad, had ik de chatfunctie geïmplementeerd. Ik was hier al mee begonnen, maar had er dus niet genoeg tijd voor. Daarnaast had ik willen proberen om mijn database nog beter op te stellen zodat het makkelijker is om ale data op te halen. Ten derde zou ik graag een videofunctie willen hebben. Om op de beslissingen terug te komen, had ik graag de database willen opschonen. Want door middel van de keys zijn een aantal dingen dubbel, wat misschien niet nodig is.

