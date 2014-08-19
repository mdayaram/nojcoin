Nojcoin
=======

Created by [noj](http://www.noj.cc), with major contributions and
ideas from [Sean Jezewski](https://twitter.com/sjezewski), [Mateusz
Byczkowski](https://twitter.com/matahwoosh), [Hampton
Catlin](http://www.hamptoncatlin.com/), [Michael
Catlin](http://www.mjlcatlin.com/), [M. David Green](http://www.mdavidgreen.com/), Amit Joshi, Chris Neale, [J-kai Hsu](https://twitter.com/jkaih), [Tatyana Brown](http://www.tatyanabrown.com/),
[Stephanie Quan](https://twitter.com/skinnybones), and [Trisha
Quan](https://twitter.com/Trisha).

One nojcoin to rule them all.

## Todos
* Image, stick figure with head of twitter icon of current holder -- them holding the coin
* Implement coin properties described below.
* Randomly deny steals based on stealibility.
* Provide an option to steal from yourself, but tweet something shaming.
* Provide different narratives that are randomly chosen for successful and failed steals.
* Provide dashboard for several stats.
	* Counter of number of steals (unique and total)
	* Counter for number of trades (unique and total)
	* Current value of nojcoin
	* Counter on how many nojcoins are out there (only one)
* Mine action that just shows you animated gif of miner
* Rate limit trading somehow (after introducing trading...).
* Need a favicon, avatar for twitter account, and maybe a coin image?

## Properties of the NojCoin

The nojcoin has a couple of properties which change every time an action is performed on it.  The two properties of interested are its **stealability** and **value**.

**value**:  The coin should have a value associated to it that fluctuates with both time, steals, trades, and scarcity. These events can be loosely associated with a supply and demand economic model that can then be used to calculate the coins value.

**stealability**:  This is how easy/difficult it is to steal the coin.  This property is measured as a probability that a steal action will succeed at any given point in time.  This will be calculated by the volatility of the coin itself.  If the coin is transferring hands fairly often (that is, it is being stolen or traded frequently), then stealing it should be more probable.  If the coin has not transfered hands as frequently, then stealing it is less likely.

Here is a proposed property system that will hopefully keep the economies surrounding nojcoin to be sound.

Properties of the nojcoin

* If someone attempts to steal a nojcoin and fails.
	* It means demand is high.
	* Value increases 1x
	* Stealability increases 1x 
* If someone attempts to steal a nojcoin and succeeds.
	* It means demand is high and coin has exchanged hands.
	* Value decreases 2x
	* Stealability increases 2x
* If a trade successfully completes of the nojcoin.
	* Can't determine economic state.
	* Value is taken from the trade.
	* Stealability increases 2x
* If a day goes by with no activity
	* Value increases 10x
	* Stealibility decreases 10x


## Ideaspace
* Need a proper ledger for the nojcoin (centralized since there's only one)
	* Or maybe explain how this site functions as the ledger.

## Troubles
* Twitter doesn't like nojcoin, they blocked the account.
* Perhaps will have to change the paradigm, have users log in to their twitter and have them tweet on their account with a hashtag?
* After tweeting as them, nojcoin account can retweet those tweets to maintain an uptodate timeline.

### Your account has been suspended
This account, @nojcoin, was suspended for sending multiple unsolicited mentions to other users.

The mention and @reply features are intended to make communication between people on Twitter easier, and posting messages to several users in an unsolicited or egregious manner is considered an abuse of its use. Plus, it bothers other users! For more information about these features and proper use, [please visit our @Replies and Mentions help page](https://support.twitter.com/articles/14023).

You will need to change your behavior to continue using Twitter. Repeat violations of the [Twitter Rules](https://twitter.com/rules) may result in the permanent suspension of your account.

To continue using this account, please confirm below:

I confirm that I will discontinue abuse of the mention or reply feature, as well as any other behaviors that are prohibited by the [Twitter Rules](https://twitter.com/rules).
I understand that my account may be permanently suspended if I continue using Twitter in a way that violates the [Twitter Rules](https://twitter.com/rules).

