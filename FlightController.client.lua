local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local TOGGLE_ACTION = "ToggleFlight"
local ASCEND_ACTION = "AscendFlight"
local DESCEND_ACTION = "DescendFlight"
local FLIGHT_SPEED = 56

local character
local humanoid
local rootPart
local attachment
local velocity
local flightEnabled = false
local ascendHeld = false
local descendHeld = false
local updateConnection
local savedAutoRotate = true

local function stopFlight()
	flightEnabled = false
	ascendHeld = false
	descendHeld = false

	if updateConnection then
		updateConnection:Disconnect()
		updateConnection = nil
	end
	if velocity then
		velocity:Destroy()
		velocity = nil
	end
	if attachment then
		attachment:Destroy()
		attachment = nil
	end
	if humanoid and humanoid.Parent then
		humanoid.AutoRotate = savedAutoRotate
		humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
	end
end

local function startFlight()
	if flightEnabled or not character or not humanoid or not rootPart or humanoid.Health <= 0 then
		return
	end

	flightEnabled = true
	savedAutoRotate = humanoid.AutoRotate
	humanoid.AutoRotate = false
	humanoid:ChangeState(Enum.HumanoidStateType.Physics)

	attachment = Instance.new("Attachment")
	attachment.Name = "FlightAttachment"
	attachment.Parent = rootPart

	velocity = Instance.new("LinearVelocity")
	velocity.Name = "FlightVelocity"
	velocity.Attachment0 = attachment
	velocity.RelativeTo = Enum.ActuatorRelativeTo.World
	velocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
	velocity.VectorVelocity = Vector3.zero
	velocity.MaxForce = math.huge
	velocity.Parent = rootPart

	updateConnection = RunService.Heartbeat:Connect(function()
		if not flightEnabled or not humanoid or humanoid.Health <= 0 or not rootPart.Parent then
			stopFlight()
			return
		end

		local move = humanoid.MoveDirection * FLIGHT_SPEED
		local vertical = (ascendHeld and FLIGHT_SPEED or 0) - (descendHeld and FLIGHT_SPEED or 0)
		velocity.VectorVelocity = Vector3.new(move.X, vertical, move.Z)
	end)
end

local function toggleFlight(_, inputState)
	if inputState ~= Enum.UserInputState.Begin then
		return Enum.ContextActionResult.Pass
	end
	if flightEnabled then
		stopFlight()
	else
		startFlight()
	end
	return Enum.ContextActionResult.Sink
end

local function setVertical(direction, _, inputState)
	local isDown = inputState == Enum.UserInputState.Begin
	if direction == "up" then
		ascendHeld = isDown
	else
		descendHeld = isDown
	end
	return Enum.ContextActionResult.Sink
end

local function onCharacterAdded(newCharacter)
	stopFlight()
	character = newCharacter
	humanoid = newCharacter:WaitForChild("Humanoid")
	rootPart = newCharacter:WaitForChild("HumanoidRootPart")
	humanoid.Died:Connect(stopFlight)
end

ContextActionService:BindAction(TOGGLE_ACTION, toggleFlight, true, Enum.KeyCode.F, Enum.KeyCode.ButtonY)
ContextActionService:SetTitle(TOGGLE_ACTION, "Fly")
ContextActionService:SetPosition(TOGGLE_ACTION, UDim2.new(0.78, 0, 0.55, 0))

ContextActionService:BindAction(ASCEND_ACTION, function(_, state)
	return setVertical("up", nil, state)
end, true, Enum.KeyCode.Space, Enum.KeyCode.ButtonA)
ContextActionService:SetTitle(ASCEND_ACTION, "Up")
ContextActionService:SetPosition(ASCEND_ACTION, UDim2.new(0.68, 0, 0.38, 0))

ContextActionService:BindAction(DESCEND_ACTION, function(_, state)
	return setVertical("down", nil, state)
end, true, Enum.KeyCode.LeftControl, Enum.KeyCode.ButtonB)
ContextActionService:SetTitle(DESCEND_ACTION, "Down")
ContextActionService:SetPosition(DESCEND_ACTION, UDim2.new(0.68, 0, 0.68, 0))

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then
	onCharacterAdded(player.Character)
end

script.Destroying:Connect(function()
	stopFlight()
	ContextActionService:UnbindAction(TOGGLE_ACTION)
	ContextActionService:UnbindAction(ASCEND_ACTION)
	ContextActionService:UnbindAction(DESCEND_ACTION)
end)
