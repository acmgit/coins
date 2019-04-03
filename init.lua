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

minetest.register_privilege("coin_check", "Player may add new or delete existing coins to the game.")


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

function coins.add(name, param)
    local mypara = {}
    mypara = coins.split(param)
    local value = mypara[2] or 0
    local typ = string.lower(mypara[1]) or ""
    
    if(value == 0) then 
        coins.print_message(name, coltext(red, "No Coins added. Value was 0"))
        return
        
    end -- if(value
    
    if(typ == "copper" or typ == "silver" or typ == "gold") then
        local player = minetest.get_player_by_name(name)
        if(player ~= nil) then
            local pinv = player:get_inventory()
            if(pinv ~= nil) then
                if(pinv:room_for_item("main", "coins:coin_".. typ .. " " .. value)) then
                    pinv:add_item("main", "coins:coin_" .. typ .. " " .. value)
                    coins.print_message(name, coltext(orange, value) .. coltext(green, " " .. mypara[1] .. " coins added."))
                    if(typ == "copper") then
                        coins.copper = coins.copper + value
                        
                    elseif(typ == "silver") then
                        coins.silver = coins.silver + value
                        
                    else
                        coins.gold = coins.gold + value
                        
                    end -- if(typ ==
                    
                    coins.save()
               
                else
                    coins.print_message(name, coltext(green, "No Room for " .. coltext(orange, value) .. coltext(green, " Coppercoins in your Inventory.")))
                                    
                end -- if(pinv:room_for_item()
                                   
            else
                coins.print_message(name, coltext(red, "No Inventory found."))
                                
            end -- if(pinv ~= nil
                               
        end -- if(player ~= nil
            
    else
        coins.print_message(name, coltext(red, "Only copper, silver or gold allowed."))
        
    end -- if(mypara[1]
                               
end -- function coins.add()
                               
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

minetest.register_chatcommand("coins_add", {
    privs = {coin_check = true},
    params = "<typ>, <value>",
	description = "Add <value> <typ> coins to the game.",
	func = function(name, param)
		coins.add(name, param)

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
    on_drop = function(itemstack, dropper, pos)
            return
                                                     
    end
})
        
minetest.register_craftitem("coins:coin_silver", {
    description = "Silver Coin",
    inventory_image = "coins_coin_silver.png",
    groups = {currency = 1, not_in_creative_inventory=1, not_in_craft_guide=1},
    on_drop = function(itemstack, dropper, pos)
            return
                                                     
    end
})
    
minetest.register_craftitem("coins:coin_gold", {
	description = "Gold Coin",
	inventory_image = "coins_coin_gold.png",
	groups = {currency = 1, not_in_creative_inventory=1, not_in_craft_guide=1},
    on_drop = function(itemstack, dropper, pos)
            return
                                                     
    end
})

--[[
   *********************************************
   ***                Final Code             ***
   *********************************************
]]--

coins.load()
print("[MOD] " .. coins.modname .. " successfully loaded.")
