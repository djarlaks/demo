<!DOCTYPE html>
<html lang="ru" xmlns="http://www.w3.org/1999/html">
<head>
    <meta charset="UTF-8">
    <title>Панель администрирования</title>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous" />
    <link rel="stylesheet" href="style.css" />
</head>
<body>

<form id="moderate" method="POST" action="./">
    <input type="hidden" name="login" value="admin" />
    <input type="hidden" name="pass" value="123" />
    <input type="hidden" name="action" value="moderate" />
    <input type="hidden" name="id" />
    <input type="hidden" name="accept" />
</form>
<form id="save" method="POST" action="./">
    <input type="hidden" name="login" value="admin" />
    <input type="hidden" name="pass" value="123" />
    <input type="hidden" name="action" value="save" />
    <input type="hidden" name="id" />
    <input type="hidden" name="text" />
</form>

<div class="table-responsive">
    <table class="comments table table-striped">
        <tr>
            <th></th>
            <th>Отправитель</th>
            <th>Текст</th>
            <th>Статус</th>
            <th></th>
        </tr>

        <?php foreach ($comments as $comment) { ?>
        <tr id="<?php echo($comment['id']); ?>">
            <td><?php if ($comment['image']) echo('<img src="/files/'. $comment['image'] .'" />'); ?></td>
            <td>
                <h4><?php echo($comment['name']); ?></h4>
                <span class="email"><?php echo($comment['email']); ?></span>
            </td>
            <td><?php echo($comment['text']); ?></td>
            <td <?php if (!$comment['status']) echo('class="moderate"'); ?>>
                <span class="status"><?php echo(($comment['status'] == 2) ? 'Принят' : 'Отклонен'); ?></span>
                <div class="moderate">
                    <a href="#" class="accept" accept="true">Принять</a><br/>
                    <a href="#" class="accept" accept="false">Отклонить</a>
                </div>
            </td>
            <td>
                <a href="#" class="edit"><span class="glyphicon glyphicon-pencil"></span></a>
                <a href="#" class="save"><span class="glyphicon glyphicon-ok"></span></a>
                <a href="#" class="cancel"><span class="glyphicon glyphicon-remove"></span></a>
            </td>
        </tr>
        <?php } ?>
    </table>
</div>

<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
<script type="text/javascript">
    $('a.accept').click(function(e) {
        var link = $(this);
        $('form#moderate input[name="accept"]').val(link.attr('accept'));
        $('form#moderate input[name="id"]').val(link.parent().parent().parent().attr('id'));
        $('form#moderate').submit();
        e.preventDefault();
    });

    $('a.edit').click(function(e) {
        var parent = $(this).parent();
        parent.parent().addClass('edit');
        var textContainer = parent.prev().prev();
        var text = textContainer.text();
        textContainer.html('<textarea>' + text + '</textarea>');
        e.preventDefault();
    });

    $('a.save').click(function(e) {
        var tr = $(this).parent().parent();
        $('form#save input[name="text"]').val(tr.find('textarea').val());
        $('form#save input[name="id"]').val(tr.attr('id'));
        $('form#save').submit();
        e.preventDefault();
    });

    $('a.cancel').click(function(e) {
        var tr = $(this).parent().parent();
        tr.removeClass('edit');
        var textarea = tr.find('textarea').eq(0);
        textarea.parent().html(textarea.html());
        e.preventDefault();
    });
</script>
</body>
</html>