<!-- login#auth view template of lnserver
     Please add your license header here.
     This file is generated automatically by GNU Artanis. -->

<@include header.tpl %>

<div class="container" id="main-content">


    <h3>EMACS</h3><br>

    If you are pulling your tweets from a plain text file <a href="https://calibre-ebook.com/">Calibre</a> can help with the conversion from other formats.<br> If you are familiar with <a href="https://www.gnu.org/software/emacs/">EMACS</a>, you may find the code snippet below useful. To use:
    <br><br>
    <ol>
	<li>Modify the snippet as desired e.g. if you are pulling quotes from the Bible, substitute "--The Bible, King James Version" for "--JG Ballard, Kingdom....". This will automatically append the source to each tweet.
	    <li>Open your init.el file and paste the snippet in. Restart EMACS.
		<li>Open your corpus of text. It must be plain text.
		    <li>Open a buffer called destination.txt i.e. C-x C-f destination.txt
			<li>Switch back to your text of interest. As you read through the text highlight a quote you would like to tweet. F6 to add it to destination.txt along with a reference (if desired) and and indication of the image (random in all cases - change manually if desired)
			    <li>At any time you can press F7, deleting all text in the corpus before the cursor. This serves as a bookmark for the next time you commence screeing for tweets. Make backups!
    </ol>


    <table class="table">                                                                  
	<thead><tr><th>Key</th> <th>Function</th></tr></thead>
	<tbody>
	    <tr><td>F6</td><td>Copy highlighted area + source + image indicator to destination.txt and save.</td></tr>
	    <tr><td>F7</td> <td>Delete from the beginning of the document to the cursor and save.</td></tr>
	</tbody>
    </table>
    <br><br>

    Code snippet suitable for inclusion in your Emacs initialization file e.g. ~/.emacs.d/init.el:
    <br><br>


    --------8<-----------Code snippet----------->8-----------------------
    <br>
    <pre><code>
(global-set-key (kbd "<f6>") 'copy-content)

	(defun copy-content()
	(interactive)
	(current-buffer)
	(copy-region-as-kill  (region-beginning) (region-end))
	(set-buffer "destination.txt")
	
	(yank)
	(insert " --J.G. Ballard, Kingdom Come (2006)\nkingdomcome.jpeg\n")
	(save-buffer 64))

	(global-set-key (kbd "<f7>") 'delete-to-top)

	(defun delete-to-top()
	(interactive)
	(current-buffer)
	(delete-region (point-min) (point) ) 
	(save-buffer 64))
    </code></pre>
    <br>

    --------8<-----------END Code snippet----------->8-------------------


</div>



<@include footer.tpl %>
