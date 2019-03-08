$(document).on('turbolinks:load' , function(){
    var search_list = $("#book-search-result")

    function appendBook(book) {
       var html = `<div class="col s6 offset-s6">
                    <div class="card horizontal book-info">
                        <div class="card-image book-info__img">
                          <img src="${book.volumeInfo.imageLinks.thumbnail}" alt="${book.volumeInfo.title}">
                        </div>
                      <div class="card-stacked">
                        <div class="card-content">
                          <div class="book-info__title">${book.volumeInfo.title}</div>
                          <div class="book-info__author">${book.volumeInfo.authors}</div>
                          <p>${book.volumeInfo.description}</p>
                          <a class="book-info__btn btn-floating halfway-fab waves-effect waves-light red"><i class="material-icons">add</i></a>
                        </div>
                        <div class="card-action">
                          <a href="${book.volumeInfo.infoLink}">詳細を見る</a>
                        </div>
                      </div>
                    </div>
                  </div>`

       search_list.append(html);
      }

      function appendBooknotimage(book) {
               var html = `<div class="col s6 offset-s6">
                    <div class="card horizontal book-info">
                        <div class="card-image book-info__img">
                          <img src="" alt="${book.volumeInfo.title}">
                        </div>
                      <div class="card-stacked">
                        <div class="card-content">
                          <div class="book-info__title">${book.volumeInfo.title}</div>
                          <div class="book-info__author">${book.volumeInfo.authors}</div>
                          <p>${book.volumeInfo.description}</p>
                          <a class="book-info__btn btn-floating halfway-fab waves-effect waves-light red"><i class="material-icons">add</i></a>
                        </div>
                        <div class="card-action">
                          <a href="${book.volumeInfo.infoLink}">詳細を見る</a>
                        </div>
                      </div>
                    </div>
                  </div>`
       search_list.append(html);
      }

  $("#book-search").on("click",function(){
    var input = $(".books-input").val();
    var url = "https://www.googleapis.com/books/v1/volumes?q=" + input
    $.getJSON(url, function(booksinfo) {
      $(".book-search-result").empty();
      if (booksinfo.length !== 0 &&  input.length !== 0){
        var books = booksinfo.items
        books.forEach(function(book){
          if (book.volumeInfo.imageLinks === undefined){
          appendBooknotimage(book)
          } else {
          appendBook(book)
          }
       });
      }
    });

   $("#book-search-result").on("click", ".book-info__btn" ,function(e){
    e.preventDefault();
    var title = $(this).parent().find(".card-title").text();
    var isbn = $(this).parent().attr('id');

    $.ajax({
      type: 'post',
      url: '/books.json',
      data: {
        book: {
          title : title,
          isbn13 : isbn,
          }
        },
      dataType: 'json'
    })
    .done(function(book){
      $("#book-search-result").empty();
      alert('本を登録しました');

      })
    .fail(function() {
      alert('本の登録に失敗しました');
    })

  });

  });
});
