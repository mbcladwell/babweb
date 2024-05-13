<!-- login#auth view template of lnserver
     Please add your license header here.
     This file is generated automatically by GNU Artanis. -->

<@include header.tpl %>

<div class="container" id="main-content">
    <h2>Image Preparation</h2>

    Tweet images are optional. Tweets without images should use the image indicator "none" (see the <a href="tweets.php">tweets</a> page for more information on tweet submission).

    There are three options when specifying an image:<br>
    <table class="table">                                                                  
	<thead><tr><th>Specifier</th><th>Description</th></tr></thead>
	<tbody>
	    <tr><td>none</td><td>No image will be provided</td></tr>
	    <tr><td>random</td><td>a random image will be selected from a pool of images</td></tr>
	    <tr><td>myimage.jpeg</td><td>a specific image is provided and will be attached to the tweet or to the first tweet of a thread.<br> Build-A-Bot recognizes images with the extensions .jpg, .jpeg, or .png</td></tr>
	</tbody>
    </table>
    <br><br>
    If you want the bot to randomly select an image from a pool of images, gather the pool of images in a single directory. Zip the files into an archive and submit with your tweets on the submission page.<br><br>
    If you wish to assign specific images to tweets, you must indicate the name of the image after the tweet and supply all specific images in a separate zip file, to be simultaneously uploaded with the random pool images.<br><br>
    It is OK to have tweets with no, random or specific images in the tweets file, but random and specific images must be submitted in separate zip files.Name them randoms.zip and specifics.zip so you choose the correct archive when submitting. <br><br>
    Images in the specifics zip file will not be used as part of the random pool.<br><br>

    <h4>How to create Zip files</h4>

    Links below provide instructions for various platforms:<br><br>

    <a href="https://support.microsoft.com/en-us/windows/zip-and-unzip-files-8d28fa72-f2f9-712f-67df-f80cf89fd4e5">Windows</a><br>
    <a href="https://support.apple.com/guide/mac-help/zip-and-unzip-files-and-folders-on-mac-mchlp2528/mac">Mac</a><br>
    <a href="https://phoenixnap.com/kb/how-to-zip-a-file-in-linux">Linux</a><br>
    

</div>


<@include footer.tpl %>
