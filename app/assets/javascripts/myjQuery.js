function ajaxContent1(){
    $('#bodyContentDiv').fadeOut(500, ajaxCall1);
    $('#bodyContentDiv').fadeIn(500);
}

function ajaxContent2(){
    // $( "#login" ).fadeToggle( "slow", "linear" );
    $("input[name='web_form_submit']").click(function(){
   $('#example_box').arcticmodal();
});

}

$(document).ready(function(){
  $("#anker").click(function(){
    $('#collapse1').fadeOut(500, ajaxCall2);
    $('#collapse1').fadeIn(500);
  });
})


// function replace1(){
//     $("#login").replaceWith("SDSDSFSD");
// }
//
function ajaxCall1() {
    $('#bodyContentDiv').html('Content1');
}

function ajaxCall2() {
     $('#register').append("<form  id='register' class='form-horizontal' action='/register' method='post'><input type='hidden'  name='authenticity_token' value='<%= form_authenticity_token %>'><div class='group-form'><label for='name'>Name:</label><input type='text' class='form-control' name='name' id='name' placeholder='Name'></div><div class='group-form'></form>");
}
