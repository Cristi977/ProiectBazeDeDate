<?php

declare(strict_types=1);

header('Content-Type: text/html; charset=UTF-8');

readfile(dirname(__DIR__) . '/Views/auth.html');

#   Daca php da eroare
#   ruleaza $php = "C:\laragon\bin\php\php-8.3.37-Win32-vs16-x64\php.exe"
#   sau unde se afla executabilul tau php