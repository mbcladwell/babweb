<!-- login#auth view template of lnserver
     Please add your license header here.
     This file is generated automatically by GNU Artanis. -->

<@include header.tpl %>
<div class="container" id="main-content">

    <h3>FAQs</h3>
    
    <H4> How long can a tweet be? </h4>

    As long as you wish. The bot will break up your tweet into as many as needed 280 character tweets and create a thread.
    <br><br>
    <h4> How frequently can I tweet?</h4>

    We schedule your tweets using crontab which limits you to 1 tweet per minute.  Keep in mind that you are trying to achieve exposure without annoying followers.  A good starting point is 1 tweet every 15-30 minutes.

    <br><br><h4> Can I change the tweeting frequency?</h4>

    Yes our software is fully configurable. If we are hosting your bot here at build-a-bot you can contact us daily to change tweeting frequency until you identify a desirable frequency. 

    <br><br><h4> Should I host my own bot?</h4>

    Only if you have access to your own networked server and are comfortable working at the terminal on Linux.  We can get you up and running on Amazon web services if desired.

    <br><br><h4> Who uses this service?</h4>

    Politicians running for office, entrepreneurs advertising their product, influencers trying to influence are typical customers. You may already be an unsuspecting target of one of our bots!

    <br><br><h4> Can I see an example of a bot in action?</h4>

    Yes, check out the <a href="https://twitter.com/eddiebbot">@eddiebbot</a> which tweets quotations from Edward Bernays classic user's manual <i>Propaganda</i>. Follow the bot to learn how you are being manipulated!




</div>



<@include footer.tpl %>
