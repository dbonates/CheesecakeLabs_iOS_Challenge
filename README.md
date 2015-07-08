#Cheesecake Labs
##iOS Developer Challenge App
 
The main goal of this challenge is to analyze the skills and knowledge the applicant presents
related to iOS programming and its latest trends, as well as his/her ability to write code, comments and meaningful git commits.
 
The applicant must develop an iOS app that fetches the JSON list of articles available through the endpoint http://www.ckl.io/challenge/ and present them in a list. Here are the MVP and extra tasks that will be evaluated.
 
####MVP
- Create a public repository on GitHub and add @vitchor and - @lucoceano;
	- `√ https://github.com/dbonates/CheesecakeLabs_iOS_Challenge`
- Create a UITableView with the articles (title, date, author and image);
	- `√ Done`
- Ability to visualize content (all provided info);
	- `√ Done`
- Ability to sort articles by any field (date, title, website, etc);
	- `√ Done`
- Ability to mark articles as read;
	- `√ Done. Using persistent store for this - NSKeyedArchiver/NSKeyedUnarchiver`
- Create a pull-request and assign it to @lucoceano.
 	- `√ Done`
 	
####Extras
- Use cool GitHub libraries to aid the development;
	- `√ Done. SwiftyJSON, Alamofire, AlamoImage, MZFormSheetPresentationController and Reveal-iOS-SDK for debug UI`
- Tablet-adaptive layout;
	- `√ Done`
- Persistent info;
	- `√ Done. NSKeyedArchiver/NSKeyedUnarchiver for read status for simple stuff example. (PS.: For a more robust solution I could go with CoreData using MagicalRecord framework as you can see on my other app repositories).`
- Images showing up both in the list and in the content viewer;
	- `√ Done`
- Design tweaks: animation, icons, etc;
	- `√ Done`
- Use a dependency manager;
	- `√ Done. Cocoapods :)`
 
####Evaluation criteria
- Technical capacity;
- Knowledge on the platform;
- Knowledge on the used tools;
- Code readability;
- Code reusability;
	- `I like to extract reusable code into Lib files and save it on a common place on harddrive to share with other projects. In this example I just put them on the Lib.swift file for sake of simplicity`
- Clarity on descriptive texts;
 