# coins

Minetest-mod for an own financial system on your Server.

## Description:

The Admin of the Server manages the amount and typ of coins on your server. For this, he
can nominate his or her own treasurer. This people can add or remove coins on your server,
to hold the balance in your financal system.
There are three independent type of coins: copper, silver and gold. This kind of coins can
have their own amount of coins and is managed under the admin and his or her treasurer.

## Commands for all:

### /coins_show

Shows for each kind of coin the amount on the server, NOT your own amount.

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

## Depends:
default

### optional:
moreores (for Silveringots, else it takes Tiningots from default)

## Licence:
LGPL 3.0

