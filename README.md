# Pet Simulator 99 Scripts
Scripts I made for PS99

## Auto Balloon
```
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
```
getgenv().autoChest = true

getgenv().autoChestConfig = {
    START_DELAY = 1, -- delay before starting
    SERVER_HOP = true, -- server hop after popping balloons
    CHEST_BREAK_DELAY = 2, -- delay before server hopping
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/fdvll/pet-simulator-99/main/autoChest.lua"))()
```
