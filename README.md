<h1>Skiddle Events</h1>

<p>This application gathers events using the Skiddle Web API: <a href="https://github.com/Skiddle/web-api" target="_blank">SkiddleWebAPI</a>.</p>

<h3>RxCoreLocation</h3>
<p>Before we can get events from the API I needed to know the users current location. I did this by subscribing RxCoreLocation's didUpdateLocation observable. <p>
<p>If the user hasn't granted their location no events will be emitted and an error message will appear.</p>

<h3>RxGesture</h3>
<p>In this app I use a coordinator to pass viewModels to different viewControllers. I used RxGesture to subscribe to a tap of a UICollectionViewCell's contentView, I also used a throttle to limit the amount of values emitted.</p>

<h3>URLSession Reactive Extension</h3>
<p>I extended the URLSession to revolve around this app. e.g. call to a certain URLSession function to return array of data entities.</p>

<h4>Foundations and frameworks used</h4>
<p>SwiftyJSON, RxAlamoFire, URLSession(Custom Rx Extension), Kingfisher, RxSwift, RxCocoa, RxGesture, RxCoreLocation, NSObject_Rx, </p>
