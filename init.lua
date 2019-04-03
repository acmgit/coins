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

coins = {}

coins.ver = 1
coins.rev = 0
coins.copper = 0
coins.silver = 0  -- Number of coppercoins for 1 silver
coins.gold = 0     -- Number of silvercoins for 1 gold
coins.copper_ingot = "default:copper_ingot"
coins.silver_ingot = "default:tin_ingot"
coins.gold_ingot = "default:gold_ingot"

coins.modname = "coins"

-- Colors for the Messages
local log = 0
local green = '#00FF00'
local red = '#FF0000'
local orange = '#FF6700'
local none = 99

local storage = minetest.get_mod_storage()  -- initalize storage file of this mod. This can only happen here and should be always local
local cprint = minetest.chat_send_player
local coltext = core.colorize

minetest.register_privilege("coin_check", "Player may mints new conins to or melts existing coins from the game.")


--[[
   *********************************************
   ***             Basic Functions           ***
   *********************************************
]]--

function coins.load()
    coins.copper = storage:get_int("copper")
    coins.silver = storage:get_int("silver")
    coins.gold = storage:get_int("gold")
    
end -- coins.load()

function coins.save()
    storage:set_int("copper",coins.copper)
    storage:set_int("silver",coins.silver)
    storage:set_int("gold",coins.gold)
    
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
    
function coins.show(name)
    local copper = coins.copper
    local silver = coins.silver
    local gold = coins.gold
        
    coins.print_message(name, coltext(green,"There are ") .. coltext(orange,copper) .. coltext(green, " coppercoins in the game."))
    coins.print_message(name, coltext(green,"There are ") .. coltext(orange,silver) .. coltext(green, " silvercoins in the game."))
    coins.print_message(name, coltext(green,"There are ") .. coltext(orange,gold) .. coltext(green, " goldcoins in the game."))
    
end -- coins.show

function coins.ingot2coin(name, inventory, typ, coin_value)
    local ingot
    
    if(typ == "copper") then
            ingot = coins.copper_ingot
            if(inventory:contains_item("main", ingot .. " " .. coin_value)) then
                inventory:add_item("main", "coins:coin_" .. typ .. " " .. (coin_value * 5))
                inventory:remove_item("main",ingot .. " " .. coin_value)
                coins.copper = coins.copper + (coin_value * 5)
                coins.show(name)
              
            else
                coins.print_message(name, coltext(red,"You've not enough " .. ingot .. " in your inventory."))
                                    
            end -- if(inventory:contains_item
            
    elseif(typ == "silver") then
            ingot = coins.silver_ingot
            if(inventory:contains_item("main", ingot .. " " .. coin_value)) then
                inventory:add_item("main", "coins:coin_" .. typ .. " " .. (coin_value * 5))
                inventory:remove_item("main",ingot .. " " .. coin_value)
                coins.silver = coins.silver + (coin_value * 5)
                coins.show(name)
              
            else
                coins.print_message(name, coltext(red,"You've not enough " .. ingot .. " in your inventory."))
                                    
            end -- if(inventory:contains_item
            
    elseif(typ == "gold") then
            ingot = coins.gold_ingot
            if(inventory:contains_item("main", ingot .. " " .. coin_value)) then
                inventory:add_item("main", "coins:coin_" .. typ .. " " .. (coin_value * 5))
                inventory:remove_item("main",ingot .. " " .. coin_value)
                coins.gold = coins.gold + (coin_value * 5)
                coins.show(name)
              
            else
                coins.print_message(name, coltext(red,"You've not enough " .. ingot .. " in your inventory."))
                                    
            end -- if(inventory:contains_item
                                   
    else
                                
        coins.print_message(name, coltext(red, ingot .. " is'nt a valid metal for coins."))
                            
    end -- if(typ ==
      
end -- function ingot2coin
      
    
function coins.coin2ingot(name, inventory, typ, coin_value)
    
    local ingot
    local ingot_value = coin_value / 5
    coin_value = ingot_value * 5
    
    if(typ == "copper") then
            ingot = coins.copper_ingot
            if(inventory:contains_item("main", "coins:coin_copper " .. coin_value)) then
                inventory:add_item("main", ingot .. " " .. ingot_value)
                inventory:remove_item("main","coins:coin_copper " .. coin_value)
                coins.copper = coins.copper - coin_value
                coins.show(name)
              
            else
                coins.print_message(name, coltext(red,"You've not enough coins:coin_copper in your inventory."))
                                    
            end -- if(inventory:contains_item
            
    elseif(typ == "silver") then
            ingot = coins.silver_ingot
            if(inventory:contains_item("main", "coins:coin_silver " .. coin_value)) then
                inventory:add_item("main", ingot .. " " .. ingot_value)
                inventory:remove_item("main","coins:coin_silver " .. coin_value)
                coins.silver = coins.silver - coin_value
                coins.show(name)
              
            else
                coins.print_message(name, coltext(red,"You've not enough coins:coin_silver in your inventory."))
                                    
            end -- if(inventory:contains_item
            
    elseif(typ == "gold") then
            ingot = coins.gold_ingot
            if(inventory:contains_item("main", "coins:coin_gold " .. coin_value)) then
                inventory:add_item("main", ingot .. " " .. ingot_value)
                inventory:remove_item("main","coins:coin_gold " .. coin_value)
                coins.gold = coins.gold - coin_value
                coins.show(name)
              
            else
                coins.print_message(name, coltext(red,"You've not enough coins:coin_gold in your inventory."))
                                    
            end -- if(inventory:contains_item
                                   
    else
                                
        coins.print_message(name, coltext(red, ingot .. " is'nt a valid metal for coins."))
                            
    end -- if(typ ==

end
                           
function coins.add(name, param)
    local mypara = {}
    mypara = coins.split(param)
    local coin_value = tonumber(mypara[2])
    local typ = string.lower(mypara[1]) or ""
    
    if((coin_value == nil) or (coin_value <= 0)) then 
        coins.print_message(name, coltext(red, "No Coins added. Value was less or 0"))
        coins.print_message(name, coltext(green, "Usage: coins_mint <typ> <value>"))
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
                    coins.print_message(name, coltext(green, "No Room for " .. coltext(orange, coin_value) .. coltext(green, " Coppercoins in your Inventory.")))
                                    
                end -- if(pinv:room_for_item()
                                   
            else
                coins.print_message(name, coltext(red, "No Inventory found."))
                                
            end -- if(pinv ~= nil
                               
        end -- if(player ~= nil
            
    else
        coins.print_message(name, coltext(red, "Only copper, silver or gold allowed."))
        
    end -- if(typ == 
                               
end -- function coins.add()

function coins.sub(name, param)
    local mypara = {}
    mypara = coins.split(param)
    local coin_value = tonumber(mypara[2])
    local typ = string.lower(mypara[1]) or ""
    local ingot_value
    
    if((coin_value ~= nil) and (coin_value >= 5)) then
        ingot_value = coin_value / 5
        coin_value = ingot_value * 5
        ingot_value = math.floor(ingot_value)
        
    else        
        coins.print_message(name, coltext(red, "No Ingots added. Value was less than 5"))
        coins.print_message(name, coltext(green, "Usage: coins_melt <typ> <value>"))
        
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
        coins.print_message(name, coltext(red, "Only copper, silver or gold allowed."))
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
                coins.print_message(name, coltext(green, "No Room for " .. coltext(orange, ingot_value) .. coltext(green, " Ingots in your Inventory.")))
                                    
            end -- if(pinv:room_for_item()
                                   
        else
            coins.print_message(name, coltext(red, "No Inventory found."))
                                
        end -- if(pinv ~= nil
                               
    end -- if(player ~= nil
                    
end -- function coins.sub()
    
--[[
   *********************************************
   ***             Chatcommands              ***
   *********************************************
]]--

minetest.register_chatcommand("coins_show", {
	description = "Shows the number of coins in the game.",
	func = function(name)
		coins.show(name)

	end,
})

minetest.register_chatcommand("coins_mint", {
    privs = {coin_check = true},
    params = "<typ>, <value>",
	description = "Mints <value> <typ> of Ingots in coins to the game.",
	func = function(name, param)
		coins.add(name, param)

	end,
})

minetest.register_chatcommand("coins_melt", {
    privs = {coin_check = true},
    params = "<typ>, <value>",
	description = "Melts <value> <typ> coins to Ingots and removes it from the game.",
	func = function(name, param)
		coins.sub(name, param)

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
