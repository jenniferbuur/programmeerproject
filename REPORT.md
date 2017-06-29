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
