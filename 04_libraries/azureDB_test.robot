*** Settings ***
Library   azureDB.py

*** Test Cases ***
Test select to database
    [Documentation]  In every call to database creating new connection,
    ...  because we use many of databases to validation and crete own class for each db is to
    ${result}=  Select From Database   DB name
    ...  SELECT * FROM table_name WHERE id=${variable}
