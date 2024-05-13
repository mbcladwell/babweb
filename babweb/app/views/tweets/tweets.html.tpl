<!-- login#auth view template of lnserver
     Please add your license header here.
     This file is generated automatically by GNU Artanis. -->

<@include header.tpl %>
<div class="container" id="main-content">

    <H3>Tweet preparation</H3>
    
    Formatting your tweets for Build-A-Bot is easy and can be done with a simple text editor like Notepad. Tweets are collected in a single plain text file. After composing your tweet hit return, provide an image indicator, hit return and repeat for the next tweet. Here is an example of a text file properly formated for the Build-A-Bot tweet processor:
    <br><br>
    <img src="text.png"/>
    <img src="text2.png"/>
    <br><br>

    <h4> Image indicators</h4>

    There are three options when specifying an image:
    <table class="table">                                                                  
	<thead><tr><th>Specifier</th><th>Description</th></tr></thead>
	<tbody>
	    <tr><td>none</td><td>No image will be provided</td></tr>
	    <tr><td>random</td><td>a random image will be selected from a pool of images</td></tr>
	    <tr><td>myimage.jpeg</td><td>a specific image is provided and will be attached to the tweet or to the first tweet of a thread.<br> Build-A-Bot recognizes images with the extensions .jpg, .jpeg, or .png</td></tr>
	</tbody>
    </table>
    <br><br>

    <h4><a href="./images">Image preparation</a></h4><br><br>

    <h4>Tweet Corpus</h4>

    If you are pulling tweets from a corpus e.g. the <a href="https://twitter.com/eddiebbot">@eddiebbot</a> bot tweets text from <i>Propaganda</i> by Edward Bernays, check out the <a href="./emacs">emacs</a> page for a code snippet that can streamline the process - presuming you are comfortable with <a href="https://www.gnu.org/software/emacs/">EMACS</a> that is!


</div>                                                            



<@include footer.tpl %>
