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
        $( "#loginform" ).hide();
        $( "#registerform" ).show();
      }
    });

    $(document).on('click', '#modalregisteranker', function(){
      if ($('#registerform').is(":visible")) {
        $( "#registerform" ).hide();
        $( "#loginform" ).show();
      }
    });

  }

})
