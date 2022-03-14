## Robot Framework - Multiple environment settings ( Dynamic Variables )

Nastavnie testov si casto krat vyzaduje pouzitie roznych nastaveni pre odlisne testovacie prostredia.
Vieme si to nastavit cez premenne globalne premenne a vyhnut sa tak samostatne definovaym premmenym, vid priklad. 

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
V tomto prvom priklade vidime hned viacero zlych pouziti premennych a ich duplikovanie, rovnako aj duplikovanie testov.

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
Druhe riesenie je uz o nieco lepsie, pretoze pre odtestovanie roznych prostredi (v nasom priklade su to DEV, TEST a PROD) nam staci jeden test. 
Vyhli sme sa tak duplikovaniu testov no stale mame v testoch defaultne definovanu premennu EVN na DEV. 
Okrem tohto problemu, vacsi problem vznika pri pouziti kniznic kde napr posielame ako parameter URL pre databazu, keyvault, specialne prostredie, atd.

```robot
*** Settings ***
Library      DB_lib    ${server_url}[${ENV}]
```
Nastavnie databazovej kniznice je v tomto pripade vzdy nastavene na defaulnu hodnotu, pretoze robot file sa nacitava skor nez sa spusta test a 
tym padom sa ako vstupny parameter ENV do databazovej kniznice posiela hodnota DEV. Ako to mozme vidiet v priklade vyssie vo **_variables.py_**
Tato hodnota nevie byt zmenena pred spustenim testu ak pozuivame nastavenie cez prikazovy riadok `--variable ENV:TEST`. Aj pokial by bola defaultna 
hodnota prazdna, napr. `ENV=None` alebo `ENV=''` nepomoze nam to. Test by padol na tom ze nevie najst kluc v hash mape `server_url`.

Pre tento problem ma [Robot Framework specialne nastavenie premennych](https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#getting-variables-from-a-special-function), 
cez ktore vieme nas problem velmi elegantne vyriesit. 

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
Pripravili sme si novy variable file kde vidime zmenu pre pouzivatelov ale aj rozne testovacie konfiguracie, ktorych je casto dost vela.
Premenne nasleduje funkcia `get_variables` ktorou si vieme nastavit v Robot Frameworku cokolvek co potrebujeme. Od jednoduchych nastaveni 
premennych typu: `premenna = args[0]` az po komplikovane nastavenia na zaklade roznych funkcii. 

Priklad pouzitia novych premmennych: 
```robot
*** Test Cases ***
Test loging user
    Login into ${server_url} with ${readonly_user} 
```
```commandline
robot --variablefile variable.py:TEST --test Test loging user .
```
V priklade je len jeden parameter na odlisenie testovacieho prostredia. 
Moze ich byt vsak pouzito aj viacej, oddelene su dvojbodkov `:` napr. `--variablefile taking_arguments.py:arg1:arg2`

Ak sa ccheme priblizit k idealnemu stavu, vieme si nastavenia a pozuivatelov ulozit niekde do keyvault-u. Nasledne si ich nacitat v nejakej funkcii a nastavit si takto bezpecne celu konfiguraciu testov.