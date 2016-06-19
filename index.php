<?php
/**
 * Created by PhpStorm.
 * User: Maxim Bogdanov
 * Date: 19.06.16
 * Time: 15:10
 */

ini_set('display_errors', 1);
error_reporting(E_ALL);

include('./config.php');
include('./db.php');

$db = new DB();

// Обработка POST
$name = false;
$email = false;
$text = false;

if (count($_POST)) {
    $name = filter_input(INPUT_POST, 'name', FILTER_SANITIZE_STRING);
    $email = filter_input(INPUT_POST, 'email', FILTER_VALIDATE_EMAIL); // в идеале сделать проверку MX записи домена, в данном варианте игнорирует некоторые домены
    $text = str_replace('&#13;', '<br/>', filter_input(INPUT_POST, 'text', FILTER_SANITIZE_SPECIAL_CHARS));
}

$file = (isset($_FILES['file']) && in_array($_FILES['file']['type'], $acceptedEncodes)) ? $_FILES['file'] : false;
if ($file) {
    $filename = md5($file['name']);
    while (file_exists($fileDir . $filename)) {
        $filename = md5($filename);
    }
    $filePath = $fileDir . $filename;
    $file = (move_uploaded_file($file['tmp_name'], $filePath)) ? $filename : false;

    $imageinfo = getimagesize($fileDir . $filename);
    $width = $imageinfo[0];
    $height = $imageinfo[1];
    if ($width > IMAGE_MAX_WIDTH || $height > IMAGE_MAX_HEIGHT) {
        $k = ($width / $height > IMAGE_MAX_WIDTH / IMAGE_MAX_WIDTH) ? $width / IMAGE_MAX_WIDTH : $height / IMAGE_MAX_HEIGHT;
        $newWidth = round($width / $k);
        $newHeight = round($height / $k);
        switch ($imageinfo[2]) {
            case IMG_GIF:
                $sourceImage = imagecreatefromgif($filePath);
                break;
            case IMG_JPG:
                $sourceImage = imagecreatefromjpeg($filePath);
                break;
            default:
                $sourceImage = imagecreatefrompng($filePath);
                break;
        }
        $destImage = imagecreatetruecolor($newWidth, $newHeight);
        imagesavealpha($destImage, true);
        imagefill($destImage, 0, 0, imagecolorallocatealpha($destImage, 0, 0, 0, 127));
        if (imagecopyresampled($destImage, $sourceImage, 0, 0, 0, 0, $newWidth, $newHeight, $width, $height)) {
            unset($sourceImage);
            if (!imagepng($destImage, $filePath)) {
                $file = false;
                unlink($filePath);
            };
            unset($destImage);
        }
        else {
            $file = false;
        }
    }
}

if ($name && $email && $text) {
    $sql = 'INSERT INTO `comments` VALUES(NULL, "'. $db->escape($name) .'", "'. $db->escape($email) .'", NULL, '.
        ($file ? ('"'. $file .'"') : 'NULL') .', "'. $db->escape($text) .'", 0, 0)';
    $db->query($sql);
}


// Подготовка к выводу
$sort = 'date';
$order = 'desc';
if (isset($_GET['sort'])) {
    $sort = $_GET['sort'];
    $order = (isset($_GET['desc'])) ? 'desc' : 'asc';
}
$sqlsort = ($sort == 'name' || $sort == 'email') ? $sort : 'timestamp';
$comments = $db->query('SELECT `name`, `email`, UNIX_TIMESTAMP(`timestamp`) as "timestamp", `image`, `text`, `edited` FROM `comments` WHERE `status`=2 ORDER BY `'. $sqlsort .'` '. $order);
if ($comments === false) $comments = [];


// Вывод
include('main.tpl');
