# Pet Simulator 99 Scripts
All scripts are made by me for free. Discord server: https://discord.gg/ettP4TjbAb
By using my scripts you agree that I am not responsible anything that happens to you or your account.

## Auto Balloon
```lua
getgenv().autoBalloon = true

getgenv().autoBalloonConfig = {
    START_DELAY = 1, -- delay before starting
    SERVER_HOP = true, -- server hop after popping balloons
    SERVER_HOP_DELAY = 0, -- delay before server hopping
    BALLOON_DELAY = 1, -- delay before popping next balloon (if there are multiple balloons in the server)
    GET_BALLOON_DELAY = 1 -- delay before getting balloons again if none are detected
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/fdvll/pet-simulator-99/main/autoBalloon.lua"))()
```

## Auto Chest
```lua
getgenv().autoChest = true

getgenv().autoChestConfig = {
    START_DELAY = 1, -- delay before starting
    SEND_PETS = false, -- send pets to break chests (if false, it shouldn't interfere with autofarm)
    SERVER_HOP = true, -- server hop after breaking all chests
    SERVER_HOP_DELAY = 1, -- delay in seconds before server hopping (set to 0 for no delay)
    CHEST_BREAK_DELAY = 2, -- delay before breaking next chest
    TIMER_SEARCH_DELAY = 0 -- if you are crashing or lagging, increase this value, otherwise leave it as is
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/fdvll/pet-simulator-99/main/autoChest.lua"))()
```


## Auto Balloon And Chest
```lua
getgenv().START_DELAY = 1 -- delay before starting
getgenv().SWITCH_DELAY = 2 -- delay before switching to autoChest
getgenv().SERVER_HOP_DELAY = 1 -- delay in seconds before server hopping

getgenv().autoBalloonConfig = {
    BALLOON_DELAY = 1, -- delay before popping next balloon (if there are multiple balloons in the server)
    GET_BALLOON_DELAY = 1 -- delay before getting balloons again if none are detected
}

getgenv().autoChestConfig = {
    CHEST_BREAK_DELAY = 2, -- delay before breaking next chest
    TIMER_SEARCH_DELAY = 1 -- if you are crashing or lagging, increase this value, otherwise leave it as is
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/fdvll/pet-simulator-99/main/autoBalloonAndChest.lua"))()
```
