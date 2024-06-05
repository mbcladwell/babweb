<!-- login#auth view template of lnserver
     Please add your license header here.
     This file is generated automatically by GNU Artanis. -->

<@include header.tpl %>
<div class="container" id="main-content">
    <h2>Upload Tweets and Optional Images</h2>

    <br>Review the <a href="./tweets"> required format</a> for tweets.
    <br><br>

    <form action="./getcontent" method="post" enctype="multipart/form-data">
	<table>
	    <tr class="spaceUnder"><td align="right">Select formatted tweets<br> file (1MB limit):</td><td><input class="form-control" type="file" name="file1" id="file1"></td><td>required</td></tr>
	    <tr></tr>
	    <tr class="spaceUnder"><td align="right">Select <span style="color:red">random</span> images compressed<br> file in .zip format:</td><td><input class="form-control" type="file" name="file2" id="file2"></td><td>(optional)</td></tr>
	    <tr class="spaceUnder"><td align="right">Select <span style="color:red">specific</span> images compressed<br> file in .zip format:</td><td> <input class="form-control" type="file" name="file3" id="file3"></td><td>(optional)</td></tr> 

	</table>
	<button type="submit" id="submit" value="submit">Submit files</button>
    </form>


    <br><br>
    <span id="myText" style="color:red"></span>
    
    
</div>



<@include footer.tpl %>
