# coins

Minetest-mod for an own financial system on your Server.

## Description:

The Admin of the Server manages the amount and typ of coins on your server. For this, he
can nominate his or her own treasurer. This people can add or remove coins on your server,
to hold the balance in your financal system.
There are three independent type of coins: copper, silver and gold. This kind of coins can
have their own amount of coins and is managed under the admin and his or her treasurer.

## Commands for all:

/coins_show

Shows for each kind of coin the amount on the server, NOT your own amount.

## Commands for Admins and treasurer:

Treasurer has the Privileg coin_check.

### /coins_add \<type\> \<value\>

Add's the \<value\> amount of \<type\> coins. Valid types are copper, silver or gold.
Example: 
/coins_add silver 5

Add's 5 Silvercoins to your server and in your inventory. After them you can spread in in your world.

## Depends:
default

### optional:
technic

## Licence:
LGPL 3.0

