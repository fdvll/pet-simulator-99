local fruitsModule = require(game:GetService("ReplicatedStorage").Library.Client.FruitCmds)


local fruitIds = {}
local neededFruits = {}

for itemId, itemData in pairs(require(game:GetService("ReplicatedStorage").Library).Save.Get().Inventory.Fruit) do
    if itemData["id"] ~= "Candycane" then
        local fruitName = itemData["id"]
        fruitIds[fruitName] = itemId
        table.insert(neededFruits, fruitName)
    end
end

for fruitName, fruitData in pairs(fruitsModule.GetActiveFruits()) do
    if #fruitData < 20 then
        fruitsModule.Consume(fruitIds[fruitName], (20 - #fruitData))
    end
    for i = 1, #neededFruits do
        if neededFruits[i] == fruitName then
            table.remove(neededFruits, i)
        end
    end
    task.wait(0.15)
end

for _, fruit in neededFruits do
    fruitsModule.Consume(fruitIds[fruit], 20)
    task.wait(0.15)
end

require(game:GetService("ReplicatedStorage").Library.Client.Network).Fired("Fruits: Update"):Connect(function(data)
    task.wait(1)
    for fruitName, fruitData in pairs(data) do
        if #fruitData < 20 then
            fruitsModule.Consume(fruitIds[fruitName])
            task.wait(0.15)
        end
    end
end)
