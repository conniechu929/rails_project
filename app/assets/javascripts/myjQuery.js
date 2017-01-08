$(document).ready(function(){
  $(document).on('click', '#loginanker', function(){
    $( "#collapse1" ).slideToggle(300);
    $( "#collapse2" ).slideToggle(500);
  });

  $(document).on('click', '#registeranker', function(){
    $( "#collapse2" ).slideToggle(300);
    $( "#collapse1" ).slideToggle(500);
  });

  $(document).on('click', '#login', function(){
    if ($('#collapse2').is(":visible")) {
      $( "#collapse2" ).slideToggle(300);
    }
    else {
      $( "#collapse1" ).slideToggle(300);
    }
  });

  $(document).on('click', '#logoutBtn', function(){
    $( "#logout" ).submit();
  });

  $(document).on('click', '#home', function(){
    location.reload();
  });

  $(document).on('click', '.placeAnker', function(){
    var address = $(this).siblings('input').val();
    var source = "https://www.google.com/maps/embed/v1/place?key=AIzaSyDBvzq5WsidARhAZ0821MB1iAMTPnHiamI&q="+ address +"";
    $("iframe").attr("src", source);
    var modal = document.getElementById("myModal");
    var btn = document.getElementById("myBtn");
    var span = document.getElementsByClassName("close")[0];

    btn.onclick = function(){
      $(".modal").fadeIn();
      // modal.style.display = "block";
    }

    span.onclick = function(){
      $(".modal").fadeOut();
    }

    window.onclick = function(event){
      if(event.target == modal){
        $(".modal").fadeOut();
      }
    }

    $(document).keydown(function(e) {
    // ESCAPE key pressed
      if (e.keyCode == 27) {
          $(".modal").fadeOut();
      }
    })

    $( "#myBtn" ).trigger( "click" );
  });

  if(login){
    var modal = document.getElementById("myModal");
    var btn = document.getElementById("myBtn");
    var span = document.getElementsByClassName("close")[0];

    btn.onclick = function(){
      modal.style.display = "block";
    }

    span.onclick = function(){
      modal.style.display = "none";
    }

    window.onclick = function(event){
      if(event.target == modal){
        modal.style.display = "none";
      }
    }
    $( "#myBtn" ).trigger( "click" );

    $(document).on('click', '#modalloginanker', function(){
      if ($('#loginform').is(":visible")) {
        $( "#loginform" ).slideToggle(300);
        $( "#registerform" ).slideToggle(500);
      }
    });

    $(document).on('click', '#modalregisteranker', function(){
      if ($('#registerform').is(":visible")) {
        $( "#registerform" ).slideToggle(300);
        $( "#loginform" ).slideToggle(500);
      }
    });

  }
})
