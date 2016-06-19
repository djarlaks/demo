<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Форма обратной связи</title>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous" />
    <link rel="stylesheet" href="style.css" />
</head>
<body>

<div class="container sort">
    <div class="btn-group" role="group">
        <button type="button" class="btn btn-default" sort="date">По дате&emsp;<span class="glyphicon glyphicon-sort-by-order" aria-hidden="true"></span><span class="glyphicon glyphicon-sort-by-order-alt" aria-hidden="true"></span></button>
        <button type="button" class="btn btn-default" sort="name">По имени&emsp;<span class="glyphicon glyphicon-sort-by-alphabet" aria-hidden="true"></span><span class="glyphicon glyphicon-sort-by-alphabet-alt" aria-hidden="true"></span></button>
        <button type="button" class="btn btn-default" sort="email">По email&emsp;<span class="glyphicon glyphicon-sort-by-alphabet" aria-hidden="true"></span><span class="glyphicon glyphicon-sort-by-alphabet-alt" aria-hidden="true"></span></button>
    </div>
</div>

<div class="container">
    <?php foreach ($comments as $comment) { ?>
    <div class="comment">
        <span class="name"><?php echo($comment['name']); ?></span>&emsp;<span class="email"><?php echo($comment['email']); ?></span><br/>
        <span class="time"><?php echo(date('d.m.Y H:i:s', $comment['timestamp'])); ?></span><br/>
        <?php
            if ($comment['image']) {
                echo('<img src="'. $fileDir . $comment['image'] .'" /><br/>');
            }
        ?>
        <div class="message">
            <?php echo($comment['text']); ?>
        </div>
    </div>
    <?php } ?>
</div>

<div class="container review">
    <form method="POST" action="./" enctype="multipart/form-data" class="form feedback" role="form" data-toggle="validator">
        <div class="form-group">
            <label class="control-label" for="name">Имя</label>
            <input type="text" class="form-control" id="name" name="name" required />
        </div>
        <div class="form-group">
            <label class="control-label" for="email">Email</label>
            <input type="email" class="form-control" id="email" name="email" required />
        </div>
        <div class="form-group">
            <label class="control-label" for="text">Сообщение</label>
            <textarea class="form-control" id="text" name="text" required ></textarea>
        </div>
        <div class="form-group">
            <label class="control-label" for="file">Изображение</label>
            <input type="file" class="form-control" id="file" name="file" accept="image/*" />
            <div class="help-block with-errors">Допустимые форматы: JPG, GIF, PNG</div>
        </div>
        <div class="form-group">
            <button type="submit" class="btn btn-default" id="preview">Предварительный просмотр</button>
            <button type="submit" class="btn btn-primary" id="submit">Отправить</button>
        </div>
</div>

<div class="container" id="view">

</div>

<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
<script src="https://1000hz.github.io/bootstrap-validator/dist/validator.min.js"></script>
<script type="text/javascript">
    imgUrl = '';
    shouldPostForm = true;

    $('input#file').change(function(e) {
        imgUrl = URL.createObjectURL(e.target.files[0]);
    });

    $('form').validator().on('submit', function (e) {
        if (!e.isDefaultPrevented() && !shouldPostForm) {
            e.preventDefault();
        }
        shouldPostForm = true;
    });

    $('button#preview').click(function() {
        shouldPostForm = false;
        var div = $('div#view');
        div.empty();
        if (!$(this).hasClass('disabled')) {
            var d = new Date();
            var html = '<div class="comment">';
            html += '<span class="name">' + $('input#name').val() + '</span>&emsp;<span class="email">' + $('input#email').val() + '</span><br/>';
            html += '<span class="time">' + d.toLocaleDateString() + ' ' + d.toLocaleTimeString() + '</span><br/>';
            if (imgUrl) html += '<img src="' + imgUrl + '" /><br/>';
            html += '<div class="message">' + $('textarea#text').val().replace(/\n/g, '<br/>') + '</div>';
            html += '</div>';
            div.html(html);
        }
    });

    $('div.sort button').click(function() {
        var btn = $(this);
        var sort = btn.attr('sort');
        location.href = location.origin + '/?sort=' + $(this).attr('sort') + ((btn.attr('order') == 'asc') ? '&desc' : '');
    });

    sort = function (sort, order) {
        var btn = $('.sort button[sort="' + sort + '"]');
        if (!btn.length) btn = $('.sort button').eq(0);
        btn.removeClass('btn-default').addClass('btn-primary').attr('order', (order == 'desc') ? order : 'asc');
    };
    sort(<?php echo('"'. $sort .'", "'. $order .'"'); ?>);

</script>
</body>
</html>