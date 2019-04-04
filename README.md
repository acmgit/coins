# coins

Minetest-mod for an own financial system on your Server.

## Description:

The Admin of the Server manages the amount and typ of coins on your server. For this, he
can nominate his or her own treasurer. This people can add or remove coins on your server,
to hold the balance in your financal system.
There are three independent type of coins: copper, silver and gold. This kind of coins can
have their own amount of coins and is managed under the admin and his or her treasurer.

## Commands for all:

### /coins_show coins | rate | all

/coins_show coins
Shows for each kind of coin the amount on the server, NOT your own amount.

/coin_show rate
Shows you the exchange-rate of silver or goldcoins and gives you the information
if the rate is a fixed or dynamic rate.

/coin_show all
Executes first the command /coins_show coins and then /coins_show rate

## Commands for Admins and treasurer:

Treasurer has the Privileg coin_check.

### /coins_mint \<type\> \<value\>

Mints the \<value\> Ingots of \<type\> in coins. Valid types are copper, silver or gold.
1 Ingot gives 5 Coins.
You must have the type of Ingot in your Inventory.<br>
Example:<br>
/coins_mint silver 1<br>
<br>
Add's 5 Silvercoins to your server and in removes 1 Silveringot from your inventory. After them you can spread the coins in your world.

### /coins_melt \<type\> \<value\>

Melts your \<value\> 
Melts your \<value\> amount of \<type\> coins in \<type\> Ingots. Valid types are copper, silver or gold.
5 Coins melts down to 1 Ingot. You must have the Coins in your Inventory to melt down.<br>
Example:<br>
/coins_melt silver 5<br>
<br>
Add's 1 Silveringot in your Inventory and removes 5 Silvercoins from your Inventory and the Server.

### /coins_set \<typ\> \<value\>

Set's your amount of \<typ\> coins to the amount of the \<value\>.
Usefull if you have deleted some Coins without /coins_melt.
This affects dynamic exchange-rates.

### /coins_rate \<typ\> \<value\>

Set's the exchange-rate of \<typ\> coins to \<value\>.
Is the value more than 0, the exchange-rate is fix otherwise it's dynamic and depends on the amount of coins you have on the server.

## Depends:
default

### optional:
moreores (for silver-.ingots, else it takes tin-ingots from default)

## Licence:
LGPL 3.0

