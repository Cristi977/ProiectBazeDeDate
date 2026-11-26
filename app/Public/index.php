<?php

declare(strict_types=1);

session_start();

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$viewsDir = dirname(__DIR__) . '/Views';

// Redirecționează utilizatorul către pagina specifică rolului său
function redirectByRole(string $rol): never
{
    $destinatie = match ($rol) {
        'admin'     => '/admin',
        'gestionar' => '/gestiune',
        'operator'  => '/productie',
        default     => '/login',
    };

    header("Location: $destinatie");
    exit;
}

// Blochează accesul dacă utilizatorul nu este logat sau nu are rolul permis
function requireRole(array $roluriPermise): void
{
    if (!isset($_SESSION['user_id'], $_SESSION['rol'])) {
        header('Location: /login');
        exit;
    }

    if (!in_array($_SESSION['rol'], $roluriPermise, true)) {
        http_response_code(403);
        exit('403 - Nu ai permisiunea să accesezi această pagină.');
    }
}

// Rutarea paginilor
switch ($uri) {
    case '/':
    case '/login':
        // Dacă e deja logat, îl trimitem direct pe pagina lui
        if (isset($_SESSION['user_id'], $_SESSION['rol'])) {
            redirectByRole($_SESSION['rol']);
        }
        require $viewsDir . '/auth.html';
        break;

    case '/logout':
        session_unset();
        session_destroy();
        header('Location: /login');
        exit;

    case '/admin':
        requireRole(['admin']);
        require $viewsDir . '/admin.php';
        break;

    case '/gestiune':
        requireRole(['admin', 'gestionar']);
        require $viewsDir . '/gestiune.php';
        break;

    case '/productie':
        requireRole(['admin', 'operator']);
        require $viewsDir . '/productie.php';
        break;

    default:
        http_response_code(404);
        echo '404 - Pagina nu a fost găsită.';
        break;
}