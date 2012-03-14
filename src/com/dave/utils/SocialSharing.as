package com.dave.utils
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.net.navigateToURL;
	import flash.events.*;
	import flash.net.URLRequest;
	
	public class SocialSharing
	{
		protected static var _instance:SocialSharing;
		
		private var info:Dictionary;
		
		public function SocialSharing(lock:Class)
		{
			if (lock!=SingletonLock) {
				throw new Error("Invalid Singleton access. Please use SocialSharing.instance");
			}
			info = new Dictionary(true);
		}

		public static function get instance():SocialSharing {
			if (_instance==null) {
				SocialSharing._instance = new SocialSharing(SingletonLock);
			}
			return SocialSharing._instance;
		}
		
		
		public function myspace(url:String,title:String,window:String="_blank"):void
		{
			if(!url)return;
			navigateToURL(new URLRequest('http://www.myspace.com/Modules/PostTo/Pages/?t='+escape(title)+'&c=&u='+escape(url)),window);
		}
		
		
		public function handleMyspace(obj:Sprite,url:String,title:String,window:String="_blanke"):void
		{
			if(!info["myspace"])info["myspace"]=new Dictionary();
			info["myspace"][obj]={url:url,title:title,window:window};
			obj.addEventListener(MouseEvent.CLICK,onMyspace);
		}
		
		
		private function onMyspace(e:*):void
		{
			var obj:* =e.currentTarget;
			var params:Object=info["myspace"][obj];
			myspace(params.url,params.title,params.window);
		}
		
		
		public function stumbleupon(url:String,window:String="_blank"):void
		{
			if(!url)return;
			navigateToURL(new URLRequest('http://www.stumbleupon.com/submit?url='+escape(url)),window);
		}
		
		
		public function handleStumbleUpon(obj:Sprite,url:String,window:String="_blank"):void
		{
			if(!info['su'])info['su']=new Dictionary();
			info['su'][obj]={url:url,window:window};
			obj.addEventListener(MouseEvent.CLICK,onStumbleUpon);
		}
		
		
		private function onStumbleUpon(e:*):void
		{
			var obj:* =e.currentTarget;
			var params:Object=info["su"][obj];
			stumbleupon(params.url,params.window);
		}
		
		
		public function digg(url:String,title:String,window:String="_blank"):void
		{
			if(!url)return;
			navigateToURL(new URLRequest('http://digg.com/submit?url='+escape(url)+'&title='+escape(title)),window);
		}
		
		
		public function handleDigg(obj:Sprite,url:String,title:String,window:String="_blank"):void
		{
			if(!info['digg'])info['digg']=new Dictionary();
			info['digg'][obj]={url:url,window:window,title:title};
			obj.addEventListener(MouseEvent.CLICK,onDigg);
		}
		
		
		private function onDigg(e:*):void
		{
			var obj:* =e.currentTarget;
			var params:Object=info["digg"][obj];
			digg(params.url,params.title,params.window);
		}
		
		
		public function delicious(url:String,title:String,window:String="_blank"):void
		{
			if(!url)return;
			navigateToURL(new URLRequest('http://del.icio.us/loginName?url='+escape(url)+'&title='+escape(title)+'&v=4'),window);
		}
		
		
		public function handleDelicious(obj:Sprite,url:String,title:String,window:String="_blank"):void
		{
			if(!info['del'])info['del']=new Dictionary();
			info['del'][obj]={url:url,window:window,title:title};
			obj.addEventListener(MouseEvent.CLICK,onDelicious);
		}
		
		
		private function onDelicious(e:*):void
		{
			var obj:* =e.currentTarget;
			var params:Object=info["del"][obj];
			delicious(params.url,params.title,params.window);
		}
		
		
		public function facebook(url:String,title:String,window:String="_blank"):void
		{
			if(!url)return;
			navigateToURL(new URLRequest('http://www.facebook.com/share.php?u='+escape(url)+'&t='+escape(title)),window);
		}
		
		
		public function handleFacebook(obj:Sprite,url:String,title:String,window:String="_blank"):void
		{
			if(!info['face'])info['face']=new Dictionary();
			info['face'][obj]={url:url,window:window,title:title};
			obj.addEventListener(MouseEvent.CLICK,onFacebook);
		}
		
		
		private function onFacebook(e:*):void
		{
			var obj:* =e.currentTarget;
			var params:Object=info["face"][obj];
			facebook(params.url,params.title,params.window);
		}
		
		
		public function reddit(url:String,window:String="_blank"):void
		{
			navigateToURL(new URLRequest("http://www.reddit.com/submit?url="+escape(url)),window);
		}
		
		
		public function handleReddit(obj:Sprite,url:String,window:String="_blank"):void
		{
			if(!info['red'])info['red']=new Dictionary();
			info['red'][obj]={url:url,window:window};
			obj.addEventListener(MouseEvent.CLICK,onReddit);
		}
		
		
		private function onReddit(e:*):void
		{
			var obj:* =e.currentTarget;
			var params:Object=info["red"][obj];
			reddit(params.url,params.window);
		}
		
		
		public function furl(url:String,title:String,window:String="_blank"):void
		{
			if(!url)return;
			navigateToURL(new URLRequest('http://www.furl.net/storeIt.jsp?u='+escape(url)+'&keywords=&t='+escape(title)),window);
		}
		
		
		public function handleFurl(obj:Sprite,url:String,title:String,window:String="_blank"):void
		{
			if(!info['furl'])info['furl']=new Dictionary();
			info['furl'][obj]={url:url,window:window,title:title};
			obj.addEventListener(MouseEvent.CLICK,onFurl);
		}
		
		
		private function onFurl(e:*):void
		{
			var obj:* =e.currentTarget;
			var params:Object=info["furl"][obj];
			furl(params.url,params.title,params.window);
		}
		
		
		public static function winlive(url:String,window:String="_blank"):void
		{
			if(!url)return;
			navigateToURL(new URLRequest('https://favorites.live.com/quickadd.aspx?url='+escape(url)),window);
		}
		
		
		public function handleWinlive(obj:Sprite,url:String,window:String="_blank"):void
		{
			if(!info['win'])info['win']=new Dictionary();
			info['win'][obj]={url:url,window:window};
			obj.addEventListener(MouseEvent.CLICK,onWin);
		}
		
		
		private function onWin(e:*):void
		{
			var obj:* =e.currentTarget;
			var params:Object=info["win"][obj];
			winlive(params.url,params.window);
		}
		
		
		public function technorati(url:String,window:String="_blank"):void
		{
			if(!url)return;
			navigateToURL(new URLRequest('http://www.technorati.com/faves/loginName?add='+escape(url)),window);
		}
		
		
		public function mrwong(url:String,description:String,window:String="_blank"):void
		{
			if(!url)return;
			if(!description)return;
			navigateToURL(new URLRequest('http://www.mister-wong.com/index.php?action=addurl&bm_url='+escape(url)+'&bm_description='+escape(description)),window);
		}
		
		
		public function sphinn(url:String,window:String="_blank"):void
		{
			if(!url)return;
			navigateToURL(new URLRequest('http://sphinn.com/submit.php?url='+escape(url)),window);
		}
		
		
		public function twitter(url:String,window:String="_blank"):void
		{
			if(!url)return;
			navigateToURL(new URLRequest('http://twitter.com/home?status='+escape(url)),window);
		}
		
		
		public function handleTwitter(obj:Sprite,url:String,window:String="_blank"):void
		{
			if(!info['twitter'])info['twitter']=new Dictionary();
			info['twitter'][obj]={url:url,window:window};
			obj.addEventListener(MouseEvent.CLICK,onTwitter);
		}
		
		
		private function onTwitter(e:*):void
		{
			var obj:* =e.currentTarget;
			var params:Object=info["twitter"][obj];
			twitter(params.url,params.window);
		}
		
		
		public function ask(url:String,title:String,window:String="_blank"):void
		{
			if(!url)return;
			if(!title)return;
			navigateToURL(new URLRequest('http://myjeeves.ask.com/mysearch/BookmarkIt?v=1.2&t=webpages&url='+escape(url)+'&title='+escape(title)),window);
		}
		
		
		public function slashdot(url:String,window:String="_blank"):void
		{
			if(!url)return;
			navigateToURL(new URLRequest('http://slashdot.org/bookmark.pl?url='+escape(url)),window);
		}
		
		
		public function newsvine(url:String,title:String,window:String="_blank"):void
		{
			if(!url)return;
			if(!title)return;
			navigateToURL(new URLRequest('http://www.newsvine.com/_tools/seed&save?u='+escape(url)+'&h='+escape(title)),window);
		}
		
	}
}
class SingletonLock{}