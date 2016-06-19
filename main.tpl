<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Форма обратной связи</title>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous" />
    <link rel="stylesheet" href="style.css" />
</head>
<body>

<div class="container">
    <div class="comment">
        <span class="name">Иван Петров</span>&emsp;<span class="email">ivan.petrov@mail.ru</span><br/>
        <span class="time">19.06.2016 18:41</span>
        <div class="message">
            Многострочное<br/>
            очень<br/>
            длинное<br/>
            сообщение
        </div>
    </div>
</div>

<div class="container review">
    <form method="POST" enctype="multipart/form-data" class="form feedback" role="form" data-toggle="validator">
        <div class="form-group">
            <label class="control-label" for="name">Имя</label>
            <input type="text" class="form-control" id="name" required />
        </div>
        <div class="form-group">
            <label class="control-label" for="email">Email</label>
            <input type="email" class="form-control" id="email" required />
        </div>
        <div class="form-group">
            <label class="control-label" for="text">Сообщение</label>
            <textarea class="form-control" id="text" required ></textarea>
        </div>
        <div class="form-group">
            <label class="control-label" for="file">Изображение</label>
            <input type="file" class="form-control" id="file" accept="image/*" />
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

    $('input#file').change(function(e) {
        imgUrl = URL.createObjectURL(e.target.files[0]);
    });

    $('form').validator().on('submit', function (e) {
        if (!e.isDefaultPrevented()) {
            e.preventDefault();
        }
    });

    $('button#preview').click(function() {
        var div = $('div#view');
        div.empty();
        if (!$(this).hasClass('disabled')) {
            var html = '<div class="comment">';
            html += '<span class="name">' + $('input#name').val() + '</span>&emsp;<span class="email">' + $('input#email').val() + '</span><br/>';
            html += '<span class="time">' + (new Date()).toLocaleDateString() + '</span><br/>';
            if (imgUrl) html += '<img src="' + imgUrl + '" /><br/>';
            html += '<div class="message">' + $('textarea#text').val().replace(/\n/g, '<br/>') + '</div>';
            html += '</div>';
            div.html(html);
        }
    });

</script>
</body>
</html>