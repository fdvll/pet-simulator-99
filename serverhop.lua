local gameId = game.PlaceId

local function getServer()
    local servers = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. tostring(gameId) .. '/servers/Public?sortOrder=Asc&limit=100')).data
    local server = servers[Random.new():NextInteger(1, 100)]
    if server then
        return server
    else
        return getServer()
    end
end

while true do
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, getServer().id, game.Players.LocalPlayer)
    task.wait(10)
end
