@echo off
chcp 65001 >nul
echo Compilation des annotations et du test...

REM Définir les variables pour les chemins
set "BUILD_DIR=build\classes"
set "SERVLET_JAR=jakarta.servlet-api_5.0.0.jar"
set "TEST_DIR=D:\xampp\tomcat\webapps\testFramework"
set "MAIN_CLASS=testFramework.TestFramework"

REM Créer les répertoires de build s'ils n'existent pas
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"

REM Vérifier si le fichier JAR existe
if not exist "%SERVLET_JAR%" (
    echo Erreur : Le fichier %SERVLET_JAR% est introuvable dans %CD%.
    echo Veuillez placer le fichier JAR dans le répertoire courant ou spécifier son chemin complet.
    pause
    exit /b 1
)

REM Nettoyer le répertoire de build
echo Nettoyage du répertoire de build...
if exist "%BUILD_DIR%\*.*" rmdir /S /Q "%BUILD_DIR%"
mkdir "%BUILD_DIR%"

REM Compilation des annotations
echo Compilation des annotations...
javac -d "%BUILD_DIR%" framework\annotation\*.java
if errorlevel 1 (
    echo Erreur de compilation des annotations!
    pause
    exit /b 1
)

REM Compilation des servlets
echo Compilation des servlets...
javac -classpath "%SERVLET_JAR%;%BUILD_DIR%" -d "%BUILD_DIR%" framework\servlet\*.java
if errorlevel 1 (
    echo Erreur de compilation des servlets!
    pause
    exit /b 1
)

REM Compilation du test
echo Compilation du test...
if not exist "%TEST_DIR%\TestFramework.java" (
    echo Erreur : Le fichier TestFramework.java est introuvable dans %TEST_DIR%.
    pause
    exit /b 1
)
javac -classpath "%BUILD_DIR%;%SERVLET_JAR%" -d "%BUILD_DIR%" "%TEST_DIR%\TestFramework.java"
if errorlevel 1 (
    echo Erreur de compilation du test!
    pause
    exit /b 1
)

echo Compilation réussie!
echo.
echo Pour tester les annotations, exécutez la commande suivante depuis %CD% :
echo java -cp "%BUILD_DIR%;%SERVLET_JAR%" %MAIN_CLASS%
echo.
pause