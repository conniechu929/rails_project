$(document).ready(function(){
    // $("#login").click(function(){
    //   $("#content").append("<div class=‘container'><div class=‘login'><form  id='login' class='form-horizontal' action='/login' method='post'><input type='hidden'  name='authenticity_token' value='<%= form_authenticity_token %>'><div class='group-form'><label for='email'>Email:</label><input type='text' class='form-control' name='email' id='email' placeholder='Email'></div> <div class='group-form' ><label for='password'>Password:</label><input type='text' class='form-control' name='password' id='password' placeholder='Password'></div><div class='btn'><input type='submit' value='Login'></div><hr><a id='loginanker'>Haven't registered yet? Click here!</a></form></div> <div hidden class=‘registration'>asdasdasdasd</div></div>");
    //   console.log('APPENDED');
    // });
     $(document).on('click', '#loginanker', function(){
       $( "#login" ).trigger( "click" );
       console.log("OLOLO1");
     });

     $(document).on('click', '#registeranker', function(){
       $( "#login" ).trigger( "click" );
       console.log("OLOLO2");
     });
})
