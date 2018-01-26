$(function(){
    $('.book-delete').click(function(){
       var bookId =  this.dataset.id;
      var book = document.querySelector(`.post[data-id="${bookId}"]`);
        $.ajax({
            url:'/book/' + bookId + '/delete',
            type:'GET',
            data:{
                'id':$(bookId).val(),
                },
            success: function(json) {
                console.log(book)
                $(book).slideUp('fast');
            }
        });
    }),
    $('.list-delete').click(function(){
      var listId =  this.dataset.id;
      var list = document.querySelector(`.book-list[data-id="${listId}"]`);
        $.ajax({
            url:'/list/' + listId + '/delete',
            type:'GET',
            data:{
                'id':$(listId).val(),
                },
            success: function(json) {
                console.log(list)
                $(list).slideUp('fast');
            }
        });
    }),
    $('.star').click(function(){
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
                        'color':'#848484'
                    }
                    );
                }else{
                    console.log('B');
                $(star).css(
                    {
                        'color':'red'
                    } 
                    );
                }
            }
        })
    });
});