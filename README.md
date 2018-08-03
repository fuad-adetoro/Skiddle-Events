<h1>Skiddle Events</h1>

<p>This application gathers events using the Skiddle Web API: <b><a href="https://github.com/Skiddle/web-api" target="_blank">SkiddleWebAPI</a></b>.</p>

<h3>RxCoreLocation</h3>
<p>Before we can get events from the API I needed to know the users current location. I did this by subscribing to <b>RxCoreLocation</b>'s <b>didUpdateLocation</b> observable. <p>
<p>If the user hasn't granted their location no events will be emitted and an error message will appear.</p>

<h3>URLSession Reactive Extension</h3>
<p>I extended the <b>URLSession</b> to revolve around this app. e.g. call to a certain <b>URLSession</b> function returns an array of data entities.</p>

<h3>RxCocoa</h3>
<p>I used the reactive extension of <b>UICollectionView</b> to display items and to notify me when a user selects an item.</p>

<h3>Foundations and frameworks used</h3>
<p>
&bull; SwiftyJSON <br> &bull; RxAlamoFire <br> &bull; URLSession(Custom Reactive Extension) <br> &bull; Kingfisher <br> &bull; RxSwift <br> &bull; RxCocoa <br> &bull; RxCoreLocation <br> &bull; NSObject_Rx
</p>
