$(window).on('load resize', function () {
    // navbarの高さを取得する
    var height = $('.navbar').height();
    // bodyのpaddingにnavbarの高さを設定する
    $('body').css('padding-top', height);
});