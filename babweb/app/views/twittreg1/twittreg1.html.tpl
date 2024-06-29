<!-- login#auth view template of lnserver
     Please add your license header here.
     This file is generated automatically by GNU Artanis. -->

<@include header.tpl %>

<h2>Authorize @eddiebbot to use your Twitter account</h2><br>

Click on this link: <a href=<%= uri %> target="_blank" rel="noopener noreferrer">Authorize @eddiebbot</a> to open a second tab where you can instruct Twitter to give @eddiebbot authority to tweet on your behalf.<br><br>


Once you have obtained your PIN, return to this page and enter the PIN in the box below and press submit:<br><br>

<form action="/getpin" method="post">
   
  <input type="text" id="pin" name="pin">
 
      <button  type="submit">Submit</button>

</form>

<br>
Note that you can revoke access at any time. @eddiebbot will tweet only, and only tweet tweets that you provide.

<@include footer.tpl %>
