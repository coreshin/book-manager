var mult = function(num,str){
    var p = "";
    for(var i = 0;i < num;i++){
        p += str;
    }
    return p;
}

$(function(){
    $('.list-add').click(function(){
        var listName = $('input[name="name"]').val();
        $.ajax({
            url:'/lists',
            type:'POST',
            data:{
                'name':listName,
                },
            success: function(json) {
                console.log('add new list')
                $('li#new-list').before('<li class="list-group-item book-list" data-id="'+ json.id + '"><a class="sentence" href="/list/'+ json.id + '">' + listName + '</a><i class="fa fa-times-circle list-delete" data-id="'+ json.id + '"></i></li>');
                $('#ModalWindow1').trigger('close');
            }
        });
    }),
    $(document).on("click", ".list-delete", function(){
        var listId =  this.dataset.id;
        var list = document.querySelector(`.book-list[data-id="${listId}"]`);
        $.ajax({
            url:'/list/' + listId + '/delete',
            type:'GET',
            data:{
                'id':$(listId).val(),
                },
            success: function(json) {
                console.log('list-' + listId + ' has deleted')
                $(list).slideUp('fast');
            }
        });
    }),
    $('.book-add').click(function(){
        var bookList = $('select[name="list"]').val();
        var bookTitle = $('input[name="title"]').val();
        var bookAuthor = $('input[name="author"]').val();
        var bookYear = $('select[name="year"]').val();
        var bookMonth = $('select[name="month"]').val();
        var bookDay = $('select[name="day"]').val();
        var bookRate= $('input[name="rate"]').val();
        var bookComment = $('textarea[name="comment"]').val();
        $.ajax({
            url:'/books',
            type:'POST',
            data:{
                'list':bookList,
                'title':bookTitle,
                'author':bookAuthor,
                'year':bookYear,
                'month':bookMonth,
                'day':bookDay,
                'rate':bookRate,
                'comment':bookComment
                },
            success: function(json) {
                console.log('add new book')
                $('.new-post').before('<div class="panel-body post" data-id="' + json.id + '"><div class="post-button"><a class="heart hvr-grow" data-id="'+ json.id + '" style="color:#848484;"><i class="fa fa-heart"></i></a><a class="book-edit" aria-pressed="true" href="/books/' + json.id + '/edit"><i class="fa fa-pencil-square-o"></i></a><a class="book-delete" aria-pressed="true" data-id="' + json.id + '"><i class="fa fa-times"></i></a></div><h3>' + bookTitle + '<br><small class="sentence text-muted left-dash">' + bookAuthor + '</small></h3><blockquote class="blockquote sentence" style="border: none;"><p class="sentence">' +mult(bookRate,'<span class="rate-star">★</span>') + '</p><p class="mb-0">' + bookComment.replace("\n","<br/>") + '</p><p class="text-muted">' + json.date + '</p></blockquote></div>');
                $('#ModalWindow2').trigger('close');
            }
        });
    }),
    $(document).on("click", ".book-delete", function(){
       var bookId =  this.dataset.id;
       var book = document.querySelector(`.post[data-id="${bookId}"]`);
        $.ajax({
            url:'/book/' + bookId + '/delete',
            type:'GET',
            data:{
                'id':$(bookId).val(),
                },
            success: function(json) {
                console.log('book-' + bookId + ' has deleted')
                $(book).slideUp('fast');
            }
        });
    }),
    $(document).on("click", ".heart", function(){
       var bookId = this.dataset.id;
       var star = this;
        $.ajax({
            url:'/books/' + bookId + '/star',
            type:'GET',
            data:{
                'id':$(bookId).val(),
                },
            dataType: 'json',
            success: function(book) {
                if (book.star){ 
                console.log('A');
                $(star).css(
                    {
                        'color':'#e0245e'
                    }
                    );
                }else{
                console.log('B');
                $(star).css(
                    {
                        'color':'#848484'
                    } 
                    );
                }
            }
        })
    });
});