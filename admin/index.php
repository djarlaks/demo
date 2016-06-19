<?php
/**
 * Created by PhpStorm.
 * User: maxim
 * Date: 20.06.16
 * Time: 3:18
 */

include('../config.php');
include('../db.php');
$db = new DB();

$authorized = isset($_POST['login']) && isset($_POST['pass']) && ($_POST['login'] == 'admin') && ($_POST['pass'] == '123');

if (isset($_POST['action'])) {
    switch ($_POST['action']) {
        case 'moderate': {
            $id = (int)$_POST['id'];
            $accept = ($_POST['accept'] == 'true') ? 2 : 1;
            $sql = 'UPDATE `comments` SET `status`='. $accept .' WHERE `id`='. $id;
            $db->query($sql);
            break;
        }
        case 'save': {
            $id = (int)$_POST['id'];
            $text = str_replace('&#13;', '<br/>', filter_input(INPUT_POST, 'text', FILTER_SANITIZE_SPECIAL_CHARS));
            $sql = 'UPDATE `comments` SET `text`="'. $db->escape($text) .'", `edited`=1 WHERE `id`='. $id;
            $db->query($sql);
            break;
        }
        default:
            break;
    }
}

$template = 'login';
if ($authorized) {
    $template = 'main';
    $comments = $db->query('SELECT `id`, `name`, `email`, UNIX_TIMESTAMP(`timestamp`) as "timestamp", `image`, `text`, `status`, `edited` FROM `comments` ORDER BY `id` DESC');
}

include('./'. $template .'.tpl');