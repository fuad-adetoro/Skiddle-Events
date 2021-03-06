<h1>Skiddle Events</h1>

<p>This application gathers events using the Skiddle Web API: <b><a href="https://github.com/Skiddle/web-api" target="_blank">SkiddleWebAPI</a></b>.</p>

<p>I once made a dating app called 'Downtown'. Downtown presented events to users and allowed them to join the event to see who else was going. Using the same API I was able to make a small version of the app using RxSwift and a different design pattern, MVVM (previously used MVC).</p>

<h3>RxCoreLocation</h3>
<p>Before we can get events from the API I needed to know the users current location. I did this by subscribing to <b>RxCoreLocation</b>'s <b>didUpdateLocation</b> observable. <p>
<p>If the user hasn't granted their location no events will be emitted and an error message will appear.</p>

<h3>Custom Reactive URLSession functions</h3>
<p>I extended the <b>URLSession</b> to revolve around this app, e.g. a call to a custom <b>URLSession</b> function will return an array of an object (such as [JSON] or [Event]).</p>

<h3>Custom RxReachability</h3>
<p>Using SystemConfiguration & RxSwift to observe the users current network availability.</p>

<h3>Frameworks used</h3>
<p>
&bull; SwiftyJSON <br> &bull; RxAlamoFire <br> &bull; Kingfisher <br> &bull; RxSwift <br> &bull; RxCocoa <br> &bull; RxCoreLocation <br> &bull; NSObject_Rx
</p>
