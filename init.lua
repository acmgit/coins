--[[ 
*******************************************************
***                  coins                          ***
***                                                 ***
***            a mod for minetest                   ***
***                                                 ***
***                 by A.C.M.                       ***
***                                                 ***
*******************************************************
]]--

local MP = minetest.get_modpath(minetest.get_current_modname())
local S = minetest.get_translator(minetest.get_current_modname())

coins = {}

coins.ver = 1
coins.rev = 1
coins.copper = 0
coins.silver = 0  
coins.gold = 0
coins.silver_rate = 0 -- Number of coppercoins for 1 silver
coins.gold_rate = 0 -- Number of coppercoins for 1 gold
coins.copper_ingot = "default:copper_ingot"
coins.silver_ingot = "default:tin_ingot"
coins.gold_ingot = "default:gold_ingot"
coins.mints_rate = 5 -- Number of Coins from 1 Ingot
coins.modname = "coins"
coins.stack_max = 32768

-- Colors for the Messages
local green = '#00FF00'
local red = '#FF0000'
local orange = '#FF6700'

local storage = minetest.get_mod_storage()  -- initalize storage file of this mod. This can only happen here and should be always local
local cprint = minetest.chat_send_player
local coltext = core.colorize

minetest.register_privilege("coin_check", S("Player may mints new conins to or melts existing coins from the game."))


--[[
   *********************************************
   ***             Basic Functions           ***
   *********************************************
]]--

function coins.load()
    coins.copper = storage:get_int("copper")
    coins.silver = storage:get_int("silver")
    coins.gold = storage:get_int("gold")
    coins.silver_rate = storage:get_int("silver_rate")
    coins.gold_rate = storage:get_int("gold_rate")
    
end -- coins.load()

function coins.save()
    coins.calculate_rate()
    storage:set_int("copper",coins.copper)
    storage:set_int("silver",coins.silver)
    storage:set_int("gold",coins.gold)
    storage:set_int("silver_rate",coins.silver_rate)
    storage:set_int("gold_rate",coins.gold_rate)
    
end -- coins.save()

function coins.print_message(name, message)
    cprint(name, message)
    
end -- coins.print_message()

function coins.split(parameter)
        local cmd = {}
        for word in string.gmatch(parameter, "[%w%-%:%.2f]+") do
            table.insert(cmd, word)
            
        end -- for word
        
        return cmd
        
end -- function distancer.split

--[[
   *********************************************
   ***             coins Functions           ***
   *********************************************
]]--
    
function coins.show(name, param)
    if((param == nil) or (param == "")) then
        param = "all"
        
    end -- if(param
    
    local mypara = {}
    mypara = coins.split(param)
    
    if((mypara[1] == "all")) then
        coins.show_coin(name)
        coins.print_message(name, "\n")
        coins.show_rate(name)
        
    elseif(mypara[1] == "coins") then
        coins.show_coin(name)
        
    elseif(mypara[1] == "rate") then
        coins.show_rate(name)
        
    elseif((mypara[1] == nil) or (mypara[1] == "")) then
        coins.print_message(name, coltext(red,S("Unknown or no Parameter.")))
        coins.print_message(name, coltext(red,S("Usage: ")) .. coltext(orange,"/coins_show <command>") ..  coltext(green, "."))
        
    end
    
end -- coins.show

function coins.show_coin(name)
    local copper = coins.copper
    local silver = coins.silver
    local gold = coins.gold
      
    coins.print_message(name, coltext(green,S("There are ")) .. coltext(orange,copper) .. coltext(green, S(" coppercoins in the game.")))
    coins.print_message(name, coltext(green,S("There are ")) .. coltext(orange,silver) .. coltext(green, S(" silvercoins in the game.")))
    coins.print_message(name, coltext(green,S("There are ")) .. coltext(orange,gold) .. coltext(green, S(" goldcoins in the game.")))
      
end --coins.show_coin

function coins.show_rate(name)
    
    if(coins.silver_rate < 0) then
        coins.print_message(name, coltext(green,S("The rate of silvercoins is ")) .. coltext(orange,S("fix")) .. coltext(green,"."))
        coins.print_message(name, coltext(green,S("The exchange-rate of ") .. coltext(orange, 1) .. coltext(green,S(" silvercoin is ")) .. coltext(orange,coins.silver_rate * -1) .. coltext(green,S(" coppercoins."))))
        
    elseif(coins.silver_rate >= 0) then
        coins.print_message(name, coltext(green,S("The rate of silvercoins is ")) .. coltext(orange,S("dynamic")) .. coltext(green,"."))
        coins.print_message(name, coltext(green,S("The exchange-rate of ") .. coltext(orange, 1) .. coltext(green,S(" silvercoin is ")) .. coltext(orange,coins.silver_rate) .. coltext(green,S(" coppercoins."))))
                
    end -- if(coins.silver_rate
    
    if(coins.gold_rate < 0) then
        coins.print_message(name, coltext(green,S("The rate of goldcoins is ")) .. coltext(orange,S("fix")) .. coltext(green,"."))
        coins.print_message(name, coltext(green,S("The exchange-rate of ") .. coltext(orange, 1) .. coltext(green,S(" goldcoin is ")) .. coltext(orange,coins.gold_rate * -1) .. coltext(green,S(" silvercoins."))))
        
    elseif(coins.gold_rate >= 0) then
        coins.print_message(name, coltext(green,S("The rate of goldcoins is ")) .. coltext(orange,S("dynamic")) .. coltext(green,"."))
        coins.print_message(name, coltext(green,S("The exchange-rate of ") .. coltext(orange, 1) .. coltext(green,S(" goldcoin is ")) .. coltext(orange,coins.gold_rate) .. coltext(green,S(" silvercoins."))))
                
    end -- if(coins.silver_rate
    
end

function coins.calculate_rate()
    if((coins.silver_rate >= 0) and (coins.silver > 0) and (coins.copper > coins.silver)) then
        coins.silver_rate = math.floor(coins.copper / coins.silver)
        
    end
        
    if((coins.gold_rate >= 0) and (coins.gold > 0) and (coins.silver > coins.gold)) then
        coins.gold_rate = math.floor(coins.silver / coins.gold)
        
    end -- if(coins.gold > 0
                    
end -- coins.calculate_rate()

function coins.set_rate(name, param)
    local myparam = {}
    
    if((param == nil) or (param == "")) then
        coins.print_message(name, coltext(green,S("Usage: /coins_rate ") .. coltext(orange, "<typ> <value>") .. coltext(green,".")))
        return
        
    end -- if(param == nil
    
    myparam = coins.split(string.lower(param))
    local typ = myparam[1]
    local value = tonumber(myparam[2]) or 0
    value = value * -1 -- convert it to fix or dynamic. > 0 = dynamic
    
    if((typ == "silver") and (value < 0)) then -- fix silverrate
        coins.silver_rate = value
        coins.print_message(name, coltext(green, S("Silverrate set fix to ")) .. coltext(orange, value * -1) .. coltext(green, "."))
        minetest.log("action", name .. " sets a fix rate for silver to " .. value * -1)
        
    elseif((typ == "silver") and (value >= 0)) then -- dynamic silverrate
        coins.silver_rate = 0
        coins.calculate_rate()
        coins.print_message(name, coltext(green, S("Silverrate set dynamic to ")) .. coltext(orange, coins.silver_rate) .. coltext(green,"."))
        minetest.log("action", name .. " sets a dynamic rate for silver to " .. coins.silver_rate)
        
    end -- if(typ == "silver"

    if((typ == "gold") and (value < 0)) then -- fix goldrate
        coins.gold_rate = value
        coins.print_message(name, coltext(green, S("Goldrate set fix to ") .. coltext(orange, value * -1)))
        minetest.log("action", name .. " sets a fix rate for gold to " .. value * -1)
        
    elseif((typ == "gold") and (value >= 0)) then -- dynamic goldrate
        coins.gold_rate = 0
        coins.calculate_rate()
        coins.print_message(name, coltext(green, S("Goldrate set dynamic to ")) .. coltext(orange, coins.gold_rate) .. coltext(green,"."))
        minetest.log("action", name .. " sets a dynamic rate for gold to " .. coins.gold_rate)
        
    end -- if(typ == "silver"
    
    coins.save()
    
end -- coins.set_rate()

function coins.ingot2coin(name, inventory, typ, coin_value)
    local ingot
    
    if(typ == "copper") then
            ingot = coins.copper_ingot
            if(inventory:contains_item("main", ingot .. " " .. coin_value)) then
                inventory:add_item("main", "coins:coin_" .. typ .. " " .. (coin_value * coins.mints_rate))
                inventory:remove_item("main",ingot .. " " .. coin_value)
                coins.copper = coins.copper + (coin_value * coins.mints_rate)
                minetest.log("action", name .. " mints " .. coin_value * coins.mints_rate .. " Coins of " .. typ .. ".")
                minetest.log("action", "Now are " .. coins.copper .. " " .. typ .. "coins in the Game.")
                coins.show(name, "coins")
                
            else
                coins.print_message(name, coltext(red,S("You've not enough ") .. ingot .. S(" in your inventory.")))
                                    
            end -- if(inventory:contains_item
            
    elseif(typ == "silver") then
            ingot = coins.silver_ingot
            if(inventory:contains_item("main", ingot .. " " .. coin_value)) then
                inventory:add_item("main", "coins:coin_" .. typ .. " " .. (coin_value * coins.mints_rate))
                inventory:remove_item("main",ingot .. " " .. coin_value)
                coins.silver = coins.silver + (coin_value * coins.mints_rate)
                minetest.log("action", name .. " mints " .. coin_value * coins.mints_rate .. " Coins of " .. typ .. ".")
                minetest.log("action", "Now are " .. coins.silver .. " " .. typ .. "coins in the Game.")
                coins.show(name, "coins")
              
            else
                coins.print_message(name, coltext(red,S("You've not enough ") .. ingot .. S(" in your inventory.")))
                                    
            end -- if(inventory:contains_item
            
    elseif(typ == "gold") then
            ingot = coins.gold_ingot
            if(inventory:contains_item("main", ingot .. " " .. coin_value)) then
                inventory:add_item("main", "coins:coin_" .. typ .. " " .. (coin_value * coins.mints_rate))
                inventory:remove_item("main",ingot .. " " .. coin_value)
                coins.gold = coins.gold + (coin_value * coins.mints_rate)
                minetest.log("action", name .. " mints " .. coin_value * coins.mints_rate .. " Coins of " .. typ .. ".")
                minetest.log("action", "Now are " .. coins.gold .. " " .. typ .. "coins in the Game.")
                coins.show(name, "coins")
              
            else
                coins.print_message(name, coltext(red,S("You've not enough ") .. ingot .. S(" in your inventory.")))
                                    
            end -- if(inventory:contains_item
                                   
    else
                                
        coins.print_message(name, coltext(red, ingot .. S(" is'nt a valid metal for coins.")))
                            
    end -- if(typ ==
    
end -- function ingot2coin
      
    
function coins.coin2ingot(name, inventory, typ, coin_value)
    
    local ingot
    local ingot_value = coin_value / coins.mints_rate
    coin_value = ingot_value * coins.mints_rate
    
    if(typ == "copper") then
            ingot = coins.copper_ingot
            if(inventory:contains_item("main", "coins:coin_copper " .. coin_value)) then
                inventory:add_item("main", ingot .. " " .. ingot_value)
                inventory:remove_item("main","coins:coin_copper " .. coin_value)
                coins.copper = coins.copper - coin_value
                minetest.log("action", name .. " melts " .. coin_value .. " Coins of " .. typ .. ".")
                minetest.log("action", "Now are " .. coins.copper .. " " .. typ .. "coins in the Game.")
              
            else
                coins.print_message(name, coltext(red,S("You've not enough ")) .. coltext(orange, "coins:coin_copper") .. coltext(red,S(" in your inventory.")))
                                    
            end -- if(inventory:contains_item
            
    elseif(typ == "silver") then
            ingot = coins.silver_ingot
            if(inventory:contains_item("main", "coins:coin_silver " .. coin_value)) then
                inventory:add_item("main", ingot .. " " .. ingot_value)
                inventory:remove_item("main","coins:coin_silver " .. coin_value)
                coins.silver = coins.silver - coin_value
                minetest.log("action", name .. " melts " .. coin_value .. " Coins of " .. typ .. ".")
                minetest.log("action", "Now are " .. coins.silver .. " " .. typ .. "coins in the Game.")
              
            else
                coins.print_message(name, coltext(red,S("You've not enough ")) .. coltext(orange, "coins:coin_silver") .. coltext(red,S(" in your inventory.")))
                                    
            end -- if(inventory:contains_item
            
    elseif(typ == "gold") then
            ingot = coins.gold_ingot
            if(inventory:contains_item("main", "coins:coin_gold " .. coin_value)) then
                inventory:add_item("main", ingot .. " " .. ingot_value)
                inventory:remove_item("main","coins:coin_gold " .. coin_value)
                coins.gold = coins.gold - coin_value
                minetest.log("action", name .. " melts " .. coin_value .. " Coins of " .. typ .. ".")
                minetest.log("action", "Now are " .. coins.gold .. " " .. typ .. "coins in the Game.")
              
            else
                coins.print_message(name, coltext(red,S("You've not enough ")) .. coltext(orange, "coins:coin_gold") .. coltext(red,S(" in your inventory.")))
                                    
            end -- if(inventory:contains_item
                                   
    else
                                
        coins.print_message(name, coltext(red, ingot .. S(" is'nt a valid metal for coins.")))
                            
    end -- if(typ ==

end -- coin2ingot()
                           
function coins.add(name, param)
    local mypara = {}
    if((param == nil) or (param == "")) then
        coins.print_message(name, coltext(green, S("Usage: /coins_mint ")) .. coltext(orange, "<typ> <value>"))
        return
    
    end --if(param

    mypara = coins.split(param)
    local coin_value = tonumber(mypara[2])
    local typ = string.lower(mypara[1]) or ""
    
    if((coin_value == nil) or (coin_value <= 0)) then 
        coins.print_message(name, coltext(red, S("No Coins added. Value was less or 0")))
        coins.print_message(name, coltext(green, S("Usage: /coins_mint ")) .. coltext(orange, "<typ> <value>"))
        return
        
    end -- if(coin_value
    
    if(typ == "copper" or typ == "silver" or typ == "gold") then
        local player = minetest.get_player_by_name(name)
        if(player ~= nil) then
            local pinv = player:get_inventory()
            if(pinv ~= nil) then
                if(pinv:room_for_item("main", "coins:coin_".. typ .. " " .. (coin_value * 5))) then
                    coins.ingot2coin(name, pinv, typ, coin_value)
                    coins.save()
                                                            
                else -- if(pinv:room_for_item()
                    coins.print_message(name, coltext(green, S("No Room for ") .. coltext(orange, coin_value) .. coltext(green, S(" Coppercoins in your Inventory."))))
                                    
                end -- if(pinv:room_for_item()
                                   
            else
                coins.print_message(name, coltext(red, S("No Inventory found.")))
                                
            end -- if(pinv ~= nil
                               
        end -- if(player ~= nil
            
    else
        coins.print_message(name, coltext(red, S("Only copper, silver or gold allowed.")))
        
    end -- if(typ == 
                               
end -- function coins.add()

function coins.set(name, param)
    local mypara = {}
    if((param == nil) or (param == "")) then
        coins.print_message(name, coltext(green, S("Usage: /coins_set ")) .. coltext(orange, "<typ> <value>"))
        return
    
    end --if(param

    mypara = coins.split(string.lower(param))
    local coin_value = tonumber(mypara[2])
    
    if(mypara[1] == "copper") then
        coins.copper = coin_value
        coins.print_message(name, coltext(green, S("Coppercoins set to ")) .. coltext(orange, coin_value) .. coltext(green, S(" Coins.")))
        minetest.log("action", name .. " sets Coppercoins to " .. coin_value .. " Coins.")
        coins.save()
        coins.show("all")
        
    elseif(mypara[1] == "silver") then
        coins.silver = coin_value
        coins.print_message(name, coltext(green, S("Silvercoins set to ")) .. coltext(orange, coin_value) .. coltext(green, S(" Coins.")))
        minetest.log("action", name .. " sets Silvercoins to " .. coin_value .. " Coins.")
        coins.save()
        coins.show("all")
        
    elseif(mypara[1] == "gold") then
        coins.gold = coin_value
        coins.print_message(name, coltext(green, S("Goldcoins set to ")) .. coltext(orange, coin_value) .. coltext(green, S(" Coins.")))
        minetest.log("action", name .. " sets Goldcoins to " .. coin_value .. " Coins.")
        coins.save()
        coins.show("all")
    
    else
        coins.print_message(name, coltext(red, S("Unknown typ of coins to set.")))
        
    end -- if(mypara[

end -- coins.set(
    
function coins.sub(name, param)
    local mypara = {}
    if((param == nil) or (param == "")) then
        coins.print_message(name, coltext(green, S("Usage: /coins_melt ")) .. coltext(orange, "<typ> <value>"))
        return
    
    end --if(param
    
    mypara = coins.split(string.lower(param))
    local coin_value = tonumber(mypara[2])
    local typ = mypara[1] or ""
    local ingot_value
    
    if((coin_value ~= nil) and (coin_value >= coins.mints_rate)) then
        ingot_value = coin_value / coins.mints_rate
        coin_value = ingot_value * coins.mints_rate
        ingot_value = math.floor(ingot_value)
        
    else        
        coins.print_message(name, coltext(red, S("No Ingots added. Value was less than 5")))
        coins.print_message(name, coltext(green, S("Usage: /coins_melt <typ> <value>")))
        
        return
        
    end -- if(coin_value
    
    local ingot
    
    if(typ == "copper") then
        ingot = coins.copper_ingot
        
    elseif(typ == "silver") then
        ingot = coins.silver_ingot
        
    elseif(typ == "gold") then
        ingot = coins.gold_ingot
        
    else
        coins.print_message(name, coltext(red, S("Only copper, silver or gold allowed.")))
        return
        
    end -- if(typ ==
        
    local player = minetest.get_player_by_name(name)
    if(player ~= nil) then
        local pinv = player:get_inventory()
        if(pinv ~= nil) then
            if(pinv:room_for_item("main", ingot .. " " .. ingot_value)) then
                coins.coin2ingot(name, pinv, typ, coin_value)
                coins.save()
                                                            
            else -- if(pinv:room_for_item()
                coins.print_message(name, coltext(green, S("No Room for ") .. coltext(orange, ingot_value) .. coltext(green, S(" Ingots in your Inventory."))))
                                    
            end -- if(pinv:room_for_item()
                                   
        else
            coins.print_message(name, coltext(red, S("No Inventory found.")))
                                
        end -- if(pinv ~= nil
                               
    end -- if(player ~= nil
                    
end -- function coins.sub()
    
--[[
   *********************************************
   ***             Chatcommands              ***
   *********************************************
]]--

minetest.register_chatcommand("coins_show", {
    param = "<command>",
	description = "\n<rate> | " .. S("Shows the rate of the coins.") .. "\n<coins> | " .. S("Shows the number of the coins.") .. "\n<all> | " .. S("Shows rate and number of coins."),
	func = function(name, param)
		coins.show(name, param)

	end,
})

minetest.register_chatcommand("coins_mint", {
    privs = {coin_check = true},
    params = "<typ>, <value>",
	description = S("Mints <value> <typ> of Ingots in coins to the game."),
	func = function(name, param)
		coins.add(name, param)

	end,
})

minetest.register_chatcommand("coins_melt", {
    privs = {coin_check = true},
    params = "<typ>, <value>",
	description = S("Melts <value> <typ> coins to Ingots and removes it from the game."),
	func = function(name, param)
		coins.sub(name, param)

	end,
})

minetest.register_chatcommand("coins_set", {
    privs = {coin_check = true},
    params = "copper <value>| silver <value>| gold <value>",
	description = "\n" .. S("copper <value> - Set's number of coppercoins.") .. "\n" .. S("silver <value> - Set's number of silvercoins.") .. "\n" .. S("gold <value> - Set's number of goldcoins."),
	func = function(name, param)
        coins.set(name, param)

	end,
})

minetest.register_chatcommand("coins_rate", {
    privs = {coin_check = true},
    params = "silver <rate>| gold <rate>",
	description = "\n" .. S("silver <rate> - Set's rate for silvercoins.") .. "\n" .. S("gold <rate> - Set's the rate for goldcoins."),
	func = function(name, param)
        coins.set_rate(name, param)

	end,
})

--[[
   *********************************************
   ***                Items                  ***
   *********************************************
]]--
    
minetest.register_craftitem("coins:coin_copper", {
    description = "Copper Coin",
    inventory_image = "coins_coin_copper.png",
    groups = {currency = 1, not_in_creative_inventory=1, not_in_craft_guide=1},
    stack_max = coins.stack_max,
--[[   
    on_drop = function(itemstack, dropper, pos)
            return
                                                     
    end
]]--
})
        
minetest.register_craftitem("coins:coin_silver", {
    description = "Silver Coin",
    inventory_image = "coins_coin_silver.png",
    groups = {currency = 1, not_in_creative_inventory=1, not_in_craft_guide=1},
    stack_max = coins.stack_max,
--[[                                                  
    on_drop = function(itemstack, dropper, pos)
            return
                                                     
    end
]]--                                            
})
    
minetest.register_craftitem("coins:coin_gold", {
	description = "Gold Coin",
	inventory_image = "coins_coin_gold.png",
	groups = {currency = 1, not_in_creative_inventory=1, not_in_craft_guide=1},
    stack_max = coins.stack_max,
--[[    
    on_drop = function(itemstack, dropper, pos)
            return
                                                     
    end
]]--
})

--[[
   *********************************************
   ***                Startcode here         ***
   *********************************************
]]--

coins.load()

if minetest.get_modpath("moreores") then
    coins.silver_ingot = "moreores:silver_ingot"
    
end

minetest.log("info", "[MOD] " .. coins.modname .. " Version " .. coins.ver .. "." .. coins.rev .. " loaded.")
