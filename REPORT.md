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

