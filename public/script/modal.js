$(function() {
    // スクロールバーの幅を取得して調整するためのCSSをヘッダーに追加
    var width = window.innerWidth - document.body.clientWidth;
    var newStyle = document.createElement('style');
    document.head.appendChild(newStyle);
    newStyle.sheet.insertRule('body.enabled_modal { overflow: hidden; }', 0);
    newStyle.sheet.insertRule('body.enabled_modal #Main, body.enabled_modal #Header, body.enabled_modal #Footer, body.enabled_modal .fixedlay { padding-right: ' + (width) + 'px; }', 1);
    // モーダルウィンドウを開く処理
    $(document).on('open', '.modalwindow', function() {
        $(this).addClass('is_visible').show().animate({
            opacity: 1
        }, 200).scrollTop(0);
        $('body').addClass('enabled_modal');
    });
    // モーダルウィンドウを閉じる処理
    $(document).on('close', '.modalwindow:not(.lock)', function() {
        $(this).removeClass('is_visible').animate({
            opacity: 0
        }, 200, function() {
            $(this).hide();
            $('body').removeClass('enabled_modal');
        });
    });
    // data-openmodalをクリックした時 → 開く処理
    $(document).on('click', '[data-openmodal]', function(e) {
        var targetID = $(this).attr('data-openmodal');
        $('#' + targetID).trigger('open');
    });
    // data-closemodalをクリックした時 → 閉じる処理
    $(document).on('click', '[data-closemodal]', function(e) {
        var targetID = $(this).attr('data-closemodal');
        $('#' + targetID).trigger('close');
    });
    // オーバーレイをクリックした時 → 閉じる処理
    $(document).on('click', '.modalwindow:not(.no_overlay_close)', function(e) {
        if (e.currentTarget === e.target) {
            $(this).trigger('close');
        }
    });
});