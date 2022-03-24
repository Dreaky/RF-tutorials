## Robot Framework - Multiple environment settings ( Dynamic Variables )

Pri testovaní sa stretávame s množstvom premenných, či už použitých v testoch alebo konfiguráciách na pozadí. 
A presne tomuto problému, ako najefektívnejšie nastaviť premenné pre testy, sa budeme venovať v tomto manuáli. Na začiatok si 
priblížime problémové príklady aby sme lepšie pochopili finálne riešenie. 

Testovanie často vyžaduje použitie odlišných nastavení pre rôzne testovacie prostredia. Preto sme si to zvolili 
ako príklad na vysvetlenie. Používame python súbor pre nastavenie globálnych premenných, vid príklad 1.


### Príklad 1
```python
# filename variable.py
server_dev_url = 'dev.robot.com'
server_test_url = 'test.robot.com'
server_url = 'robot.com'

user_dev = 'ben@example.com'
user_test = 'ted@example.com'
user = 'john@example.com'
```
```robot
*** Test Cases ***
Test loging user on dev env
    Login into ${server_dev_url} with ${user_dev} 

Test loging user on test env
    Login into ${server_test_url} with ${user_test} 

Test loging user
    Login into ${server_test} with ${user} 
```
```commandline
robot --variablefile variable.py --test Test loging user on dev env .
```
V tomto prvom príklade vidíme hneď viacero zlých použití premenných a ich duplicity, 
rovnako aj duplicity testov. Ak to zhrnieme je to veľmi zlé riešenie z hľadiska udržateľnosti, 
bezpečnosti a tak isto aj čitateľnosti. Horšie je už len nepoužívať premenné vôbec.

### Príklad 2
```python
ENV = 'DEV'
server_url={
    'DEV': 'dev.robot.com',
    'TEST': 'test.robot.com',
    'PROD': 'robot.com',
}
user={
    'DEV': 'ben@example.com',
    'TEST': 'ted@example.com',
    'PROD': 'john@example.com',
}
```
```robot
*** Test Cases ***
Test loging user
    Login into ${server_url}[${ENV}] with ${user}[${ENV}] 
```
```commandline
robot --variablefile variable.py --variable ENV:TEST --test Test loging user .
```
Druhé riešenie je už o niečo lepšie, pretože pre testovanie na rôznych prostrediach 
(v našom príklade sú to DEV, TEST a PROD) nám stačí jeden test. Vyhli sme sa tak duplicitám testov, 
zvýšili sme čitateľnosť aj udržateľnosť, no stále máme v testoch preddefinovanú premennú EVN na DEV. 
Okrem tohto problému, vzniká väčší problém pri použití knižníc, kde napr. posielame ako parameter URL pre databázu,
keyvault, špeciálne prostredie, atď.

```robot
*** Settings ***
Library      DB_lib    ${server_url}[${ENV}]
```
Nastavenie databázovej knižnice je v tomto prípade vždy nastavené defaultnou hodnotu, pretože robot súbor sa 
načítava skôr než sa spúšťa test a tým pádom sa ako vstupný parameter ENV do databázovej knižnice posiela hodnota DEV. 
Ako to môžeme vidieť v príklade vyššie vo **_variables.py_** túto hodnotu nevieme zmeniť pred spustením testu, ak 
používame nastavenie cez príkazový riadok `--variable ENV:TEST`. Aj pokiaľ by bola defaultná hodnota prázdna, 
napr. `ENV=None` alebo `ENV=''` nepomôže nám to. Test by padol na tom, že nevie nájsť kľuč v hash mape `server_url`.

Pre tento problém má [Robot Framework špeciálne nastavenie premenných](https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#getting-variables-from-a-special-function), 
cez ktoré vieme náš problém veľmi elegantne vyriešiť. Avšak nie je veľmi dobre popísaný, ako ho správne použiť, 
aj preto vznikol tento manuál.

### Príklad 3
```python
test_configuration = {
    'DEV': {
        'server_url': 'dev.robot.com',
        'database_con': '...',
    },
    'TEST': {
        'server_url': 'test.robot.com',
        'database_con': '...',
    }
}
users = {
    'DEV': {
        'admin_username': 'admin007',
        'readonly_user': 'readonly',
    },
    'TEST': {
        'admin_username': 'test.admin',
        'readonly_user': 'readonly.user',
    }  
}

def get_variables(*args):
      env = args[0].upper()
      if env in test_configuration.keys():
          return test_configuration[env] | users[env]
      else:
          raise Exception('The defined ENVIRONMENT was not recognized for running tests!')
```
Pripravili sme si nový súbor pre premenné, kde vidíme zmenu pre používateľov, ale aj pre rôzne testovacie konfigurácie, 
ktorých je často veľký počet. Premenne nasleduje funkcia `get_variables`, ktorou si vieme nastaviť v Robot Frameworku 
čokoľvek čo potrebujeme. Od jednoduchých nastavení premenných typu: `premenna = args[0]` až po komplexné nastavenia
na základe rôznych funkcii.

Príklad použitia nových premenných:
```robot
*** Test Cases ***
Test loging user
    Login into ${server_url} with ${readonly_user} 
```
```commandline
robot --variablefile variable.py:TEST --test Test loging user .
```


V príklade je len jeden parameter na odlíšenie testovacieho prostredia. 
Môže ich byť však použitých aj viac, oddeľujú sa dvojbodkou `:` napr. `--variablefile taking_arguments.py:arg1:arg2`

### Ideál
Ak sa chceme priblížiť k ideálnemu stavu, vieme si nastavenia a používateľov uložiť do keyvault-u. 
Následne si ich načítať vo funkcii, ako napríklad naša get_variables() a nastaviť si takto bezpečne celú konfiguráciu testov. 
Prípadne poslať na vstup súboru s premennými viac parametrov na upresnenie konfigurácie testov.

Takéto nastavenie spĺňa všetky požiadavky, do zdrojového kódu sa nedostanú žiadne mená ani heslá 
( bezpečnostné riziko ), máme len jeden test s jedným názvom premennej pre rôzne prostredia ( čitateľnosť a udržateľnosť ).