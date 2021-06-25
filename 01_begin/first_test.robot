*** Settings ***
Documentation   Simple test to open eset home page
Library         Browser

*** Test Cases ***
Test succesfully opened eset home page
    Open Browser  url=https://www.eset.com/  browser=firefox
