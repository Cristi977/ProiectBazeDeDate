<?php

declare(strict_types=1);

session_start();
header('Content-Type: application/json; charset=UTF-8');

// Încarcă autoloader-ul Composer
$autoload = dirname(__DIR__) . '/vendor/autoload.php';
if (file_exists($autoload)) {
    require_once $autoload;
}

// Citește datele indiferent dacă vin din JSON (fetch) sau FormData ($_POST)
$rawInput = file_get_contents('php://input');
$jsonData = json_decode($rawInput, true);
$input = is_array($jsonData) ? $jsonData : $_POST;

$action = $_GET['action'] ?? $input['action'] ?? '';

function jsonResponse(array $data, int $status = 200): never
{
    http_response_code($status);
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
    exit;
}

function requireApiRole(array $roluriPermise): void
{
    if (!isset($_SESSION['user_id'], $_SESSION['rol'])) {
        jsonResponse(['success' => false, 'error' => 'Neautentificat.'], 401);
    }

    if (!in_array($_SESSION['rol'], $roluriPermise, true)) {
        jsonResponse(['success' => false, 'error' => 'Acces interzis pentru acest rol.'], 403);
    }
}

function getRedirectPath(string $rol): string
{
    return match ($rol) {
        'admin'     => '/admin',
        'gestionar' => '/gestiune',
        'operator'  => '/productie',
        default     => '/login',
    };
}

switch ($action) {
    case 'login':
        $email = trim((string)($input['email'] ?? $input['username'] ?? ''));
        $parola = (string)($input['password'] ?? $input['parola'] ?? '');

        if ($email === '' || $parola === '') {
            jsonResponse(['success' => false, 'error' => 'Completează email-ul și parola.'], 400);
        }

        // TODO: Conectează interogarea reală din Models/Utilizator.php
        // Exemplu Eloquent: $user = \App\Models\Utilizator::with('rol')->where('email', $email)->first();
        // Exemplu PDO:      $user = Utilizator::findByEmail($email);
        $user = null;

        if (!$user || !password_verify($parola, $user->parola)) {
            jsonResponse(['success' => false, 'error' => 'Date de autentificare invalide.'], 401);
        }

        // Regenerează ID-ul sesiunii la autentificare pentru securitate
        session_regenerate_id(true);

        $numeRol = $user->rol->nume ?? 'operator'; // adaptează după numele coloanei din tabela roluri
        $_SESSION['user_id'] = $user->id;
        $_SESSION['rol'] = $numeRol;

        jsonResponse([
            'success'  => true,
            'rol'      => $numeRol,
            'redirect' => getRedirectPath($numeRol),
        ]);
        break;

    case 'logout':
        session_unset();
        session_destroy();
        jsonResponse(['success' => true, 'redirect' => '/login']);
        break;

    case 'me':
        if (!isset($_SESSION['user_id'], $_SESSION['rol'])) {
            jsonResponse(['success' => false, 'authenticated' => false], 401);
        }
        jsonResponse([
            'success'       => true,
            'authenticated' => true,
            'user_id'       => $_SESSION['user_id'],
            'rol'           => $_SESSION['rol'],
        ]);
        break;

    // Exemplu de endpoint protejat pentru pasul următor
    case 'get_stocuri':
        requireApiRole(['admin', 'gestionar']);
        // $stocuri = Stoc::all();
        jsonResponse(['success' => true, 'data' => []]);
        break;

    default:
        jsonResponse(['success' => false, 'error' => 'Acțiune necunoscută.'], 400);
}