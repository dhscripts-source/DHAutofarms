getgenv().Enabled = true
getgenv().Dis = function()
	Enabled = false

	for i,v in pairs(workspace:GetDescendants()) do 
		if (v:IsA("Seat")) or (v:IsA("VehicleSeat")) then 
			v.Disabled = true
		end
	end
end

if (not game:IsLoaded()) then 
	game.Loaded:Wait()
	task.wait(2)
end

repeat task.wait(0.2) until (game:GetService("Players").LocalPlayer) and (game:GetService("Players").LocalPlayer.Character)

local Players = game:GetService("Players")
local Cashiers = workspace.Cashiers
local Player = Players.LocalPlayer

loadstring(game:HttpGet("https://github.com/applless/RandomScripts/raw/main/AntiAfk"))()
pcall(function()local a=game:GetService("ReplicatedStorage").MainEvent;local b={"CHECKER_1","TeleportDetect","OneMoreTime"}local c;c=hookmetamethod(game,"__namecall",function(...)local d={...}local self=d[1]local e=getnamecallmethod()local f=getcallingscript()if e=="FireServer"and self==a and table.find(b,d[2])then return end return c(...)end)end)

for i,v in pairs(workspace:GetDescendants()) do 
	if (v:IsA("Seat")) or (v:IsA("VehicleSeat")) then 
		v.Disabled = true
	end
end



local GetClosestPart = function(Table)
	local ClosestPart = nil

	for i,v in pairs(Table) do
		if (ClosestPart == nil) then
			ClosestPart = v
		else
			if ((Player.Character.HumanoidRootPart.Position - v.Position).Magnitude) < ((ClosestPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude) then
				ClosestPart = v
			end
		end
	end
	
	return ClosestPart
end

local CheckKOed = function()
	if (Player.Character.BodyEffects["K.O"].Value == true) then 
		Player.Character.Humanoid.Health = 0 

		for i,v in pairs(Player.Character:GetChildren()) do 
			if (v:IsA("BasePart")) then 
				v:Destroy()
			end
		end
	end
end

local GetCashier = function()
	local AvailableCashiers = {}
	for i,v in pairs(Cashiers:GetChildren()) do 
		if (v:FindFirstChild("Humanoid")) and (v.Humanoid.Health > 0) then 
			AvailableCashiers[#AvailableCashiers+1] = v.Open
		end
	end
	
	local ClosestPart = GetClosestPart(AvailableCashiers)
	
	if (ClosestPart) and (ClosestPart.Parent) then 
		return ClosestPart.Parent
	else 
		return nil
	end

end

local GetCashParts = function()
	local CashParts = {}
	for i,v in pairs(workspace.Ignored.Drop:GetChildren()) do 
		if (v.Name == "MoneyDrop") and ((Player.Character.HumanoidRootPart.Position - v.Position).Magnitude < 13) then 
			CashParts[#CashParts+1] = v
		end
	end
	
	return CashParts
end


task.spawn(function()
	while true and task.wait(0.33) do 
		if (Enabled == true) and (Player.Character) and (Player.Character:FindFirstChild("FULLY_LOADED_CHAR"))  then 
			local Cashier = nil
			repeat 
				Cashier = GetCashier()
				task.wait()
			until (Cashier ~= nil)

			
			repeat 
				if (Player.Backpack:FindFirstChild("Combat")) then 
					task.wait(0.77)
					pcall(function()
						Player.Backpack.Combat.Parent = Player.Character
					end)
					task.wait()
				end
				Player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
				Player.Character.HumanoidRootPart.CFrame = Cashier.Open.CFrame * CFrame.Angles(0, math.random(-180, 0), 0)
				
				if (Player.Character:FindFirstChild("Combat")) then 
					Player.Character.Combat:Activate()
					--Player.Character.Combat:Deactivate() Disabled because super punch is faster and more reliable on low fps.
				end

				
				task.wait()
			until (Cashier.Humanoid.Health <= 0) or (Player.Character.Humanoid.Health <= 0) or (Player.Character.BodyEffects["K.O"].Value == true) or (Enabled == false)
			
			pcall(CheckKOed)
			
			repeat 
				local CashParts = GetCashParts()
				
				Player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
				Player.Character.HumanoidRootPart.CFrame = Cashier.Open.CFrame + Vector3.new(0, 2, 0)
				
				for i,v in pairs(CashParts) do 
					if (v:FindFirstChild("ClickDetector")) then 
						fireclickdetector(v.ClickDetector)
					end
				end

				task.wait()
			until (#CashParts <= 0) or (Player.Character.Humanoid.Health <= 0) or (Player.Character.BodyEffects["K.O"].Value == true) or (Enabled == false)
			
			pcall(CheckKOed)
		end
	end
end)